@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Attachment UM 001'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_CHILD_ATTACH_UNM_001
  as projection on ZI_CHILD_ATTACH_UNM_001 as Attaching
{
       @Search.defaultSearchElement: true
       @UI.identification: [{ position: 10 , label: 'Attachment UUID' }]
       @UI.lineItem: [{ position: 10 , label: 'Attachment UUID' }]
  key  Id,

       @Search.defaultSearchElement: true
       @UI.identification: [{ position: 20 , label: 'Attachment ID' }]
       @UI.lineItem: [{ position: 20 , label: 'Attachment ID' }]
  key  Attach_Id,
       Comments,

       @UI.identification: [{ position: 30 , label: 'Attachment' }]
       @UI.lineItem: [{ position: 30 , label: 'Attachment' }]
       //  contentDispositionPreference: #ATTACHMENT //// THIS ANNOTATION ALLOWED TO DOWNLOAD ATTACHED FILE
       //  contentDispositionPreference: #INLINE //// THIS ANNOTATION ALLOWED TO OPEN FILE IN A BROWSER
       //  acceptableMimeTypes: [ 'application/pdf' ] //// THIS ANNOTATION ALLOWED ONLY '.pdf' FILE FORMAT ATTACHMENTS
       @Semantics.largeObject:{ mimeType: 'Mimetype',
                                fileName: 'Filename',
             contentDispositionPreference: #ATTACHMENT,
             acceptableMimeTypes: [ 'text/plain', 'application/pdf' ]
       }
       Attachment,

       @Semantics.mimeType: true
       Mimetype,

       @UI.identification: [{ position: 40 , label: 'Filename' }]
       @UI.lineItem: [{ position: 40 , label: 'Filename' }]
       Filename,
       lastchangedat,

       /* Associations */
       _student : redirected to parent ZC_ROOT_STUD_UNM_01
}
