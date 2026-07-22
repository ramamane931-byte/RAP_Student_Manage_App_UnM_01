@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity for Stud Academc M 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CHILD_ACDMC_UNM_001
  as select from ztbl_acdmc_um_01
  association to parent ZI_ROOT_STUD_UNM_01 as _student on $projection.Id = _student.Id
  association to ZI_STUD_COURSE             as _course  on $projection.Course = _course.Value
{
  key id                  as Id, ///STUDENT UUID
  key id1                 as Id1, ///ACADEMIC UUID
      course              as Course,

      _course,
      _course.Description as Course_desc,

      //ASSOCIATIONS//
      _student
}
