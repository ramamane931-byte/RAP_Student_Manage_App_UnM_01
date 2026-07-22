@EndUserText.label: 'Abstract entity student UnM 3'
@Metadata.allowExtensions: true
define abstract entity ZAB_STUD_UNM_01
  //  with parameters parameter_name : parameter_type
{
  //// SHOWING A DEFAULT VALUE OF STUDENT 'STATUS' IN DROPDOWN BEFORE SELECTION
  ////  @UI.defaultValue:'X' // TO MAKE A DEFAULT VALUE
  //// 'ELEMENT_OF_REFERENCED_ENTITY' // WHATEVER THE VALUE ENTITY IS SHOWING SAME VALUE WILL BE DISPLAY ON THE DROPDOWN.
  @UI.defaultValue:#( 'ELEMENT_OF_REFERENCED_ENTITY: Status' )
  status         : abap_boolean;

  @UI.defaultValue:#( 'ELEMENT_OF_REFERENCED_ENTITY: Course' )
  course         : abap.char(60);

  @UI.defaultValue:#( 'ELEMENT_OF_REFERENCED_ENTITY: Courseduration' )
  courseduration : abap.numc(4);
}
