@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection root view std 3'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_ROOT_STUD_UNM_01
  provider contract transactional_query
  as projection on ZI_ROOT_STUD_UNM_01
{

          @Search.defaultSearchElement: true
  key     Id,
          @Search.defaultSearchElement: true
          Studentid,
          @Search.defaultSearchElement: true
          Firstname,
          Lastname,
          Age,
          Course,
          Courseduration,
          Status,
          Gender,
          Genderdesc,
          Dob,
          InternDesgn,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          InternSalary,
          CurrencyCode,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          InternBonus,

          Lastchangedat,
          Locallastchangedat, //ETag field changes

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRTUAL_DISCOUNT'
          @EndUserText.label: 'Intern Variable Pay'
  virtual variablePay : abap.int4,

          //    /* Associations */
          _gender,
          _academicres : redirected to composition child ZC_CHILD_ACDMC_UNM_001, // Academic data
          _Attaching   : redirected to composition child ZC_CHILD_ATTACH_UNM_001 // Attachment data

}
