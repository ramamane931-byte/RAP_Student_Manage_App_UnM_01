@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view stud hdr 01'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ROOT_STUD_UNM_01 
as select from ztbl_stud_unm_01
  association to one ZI_STUD_GENDER                 as _gender on $projection.Gender = _gender.Value
  composition [0..*] of ZI_CHILD_ACDMC_UNM_001  as _academicres
  composition [0..*] of ZI_CHILD_ATTACH_UNM_001 as _Attaching ////Attachment data
  //  composition [0..*] of zi_child_stud_reprt_um_01 as _report    ////Student Report data
{
  key id                  as Id, /// STUDENT_UUID
      studentid           as Studentid, // STUDENT ID
      firstname           as Firstname,
      lastname            as Lastname,
      age                 as Age,
      course              as Course,
      courseduration      as Courseduration,
      status              as Status,
      gender              as Gender,
      dob                 as Dob,

      intern_desgn        as InternDesgn,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      intern_salary       as InternSalary,
      currency_code       as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      intern_bonus        as InternBonus,

      ////SOM: Student Report Changes
      attachment          as Attachment,
      mimetype            as Mimetype,
      filename            as Filename,
      file_status         as FileStatus,
      template_status     as TemplateStatus,

      // to give color coding to file status
      case file_status
        when 'File Selected'     then 2     -- 'open'       | 2: yellow colour
        when 'Excel Uploaded'    then 3     -- 'accepted'   | 3: green colour
        when 'File not Selected' then 1     -- 'rejected'   | 1: red colour
        else 0                              -- 'nothing'    | 0: unknown
      end                 as Criticality,

      case template_status
        when 'Present' then 3
        when 'Absent'  then 1
        else 0
      end                 as TemplateCriticality,
      ////EOM: Student Report Changes

      @Semantics.systemDateTime.lastChangedAt: true // ETag field changes identified with this annotation
      lastchangedat       as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true // ETag field changes identified with this annotation
      locallastchangedat  as Locallastchangedat,

      _gender,
      _gender.Description as Genderdesc,

      //ASSOCIATIONS//
      _academicres, ///Student Academic data
      _Attaching ///Attachment data
      //      _report
}
