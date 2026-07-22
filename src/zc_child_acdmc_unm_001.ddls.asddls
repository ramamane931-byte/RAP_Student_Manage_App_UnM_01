@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection stud acadmic 3'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CHILD_ACDMC_UNM_001
  as projection on ZI_CHILD_ACDMC_UNM_001
{
      @UI.identification: [{ position: 10 , label: 'Academic UUID' }]
      @UI.lineItem: [{ position: 10 , label: 'Academic UUID' }]
  key Id,

      @UI.identification: [{ position: 11 , label: 'Academic UUID' }]
      @UI.lineItem: [{ position: 11 , label: 'Academic UUID' }]
  key Id1,

      @UI.identification: [{ position: 20 , label: 'Course' }]
      @UI.lineItem: [{ position: 20 , label: 'Course' }]
      Course,

      @UI.identification: [{ position: 30 , label: 'Course Description' }]
      @UI.lineItem: [{ position: 30 , label: 'Course Description' }]
      Course_desc,

      /* Associations */
      //     _course,
      //      _semester,
      //      _semres,
      _student : redirected to parent ZC_ROOT_STUD_UNM_01
}
