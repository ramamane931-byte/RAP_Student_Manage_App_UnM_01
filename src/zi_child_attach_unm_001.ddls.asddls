@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity for Attachment UM 001'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CHILD_ATTACH_UNM_001
  as select from ztbl_attc_unm_01
  association to parent ZI_ROOT_STUD_UNM_01 as _student on $projection.Id = _student.Id
{
  key id            as Id, ///STUDENT UUID
  key attach_id     as Attach_Id, ///ATTACHMENT UUID
      @EndUserText.label: 'Comments'
      comments      as Comments,

      @Semantics.largeObject:{
      mimeType: 'Mimetype',
      fileName: 'Filename',
      //      contentDispositionPreference: #INLINE, //// THIS ANNOTATION ALLOWED TO DOWNLOAD ATTACHED FILE
            contentDispositionPreference: #ATTACHMENT, //// THIS ANNOTATION ALLOWED TO DOWNLOAD ATTACHED FILE
      //// THIS ANNOTATION ALLOWED ONLY '.pdf' FILE FORMAT ATTACHMENTS
            acceptableMimeTypes: [ 'application/pdf', 'text/plain', 'image/jpeg', 'image/png',
            'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]
      }
      attachment    as Attachment,
      @EndUserText.label: 'File Type'
      mimetype      as Mimetype,
      @EndUserText.label: 'File Name'
      filename      as Filename,
      lastchangedat as lastchangedat,

      //      _student.Lastchangedat as LastChangedat,
      _student

}
