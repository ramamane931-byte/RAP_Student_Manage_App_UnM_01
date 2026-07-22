CLASS zcl_virtual_discount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_virtual_discount IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.


    DATA: lt_student_data TYPE STANDARD TABLE OF zc_root_stud_unm_01 WITH DEFAULT KEY.

    lt_student_data = CORRESPONDING #( it_original_data ).
    LOOP AT lt_student_data ASSIGNING FIELD-SYMBOL(<fs_student_data>).
      IF ( <fs_student_data>-InternDesgn EQ 'Analyst' ).
        <fs_student_data>-variablePay = <fs_student_data>-InternSalary + <fs_student_data>-InternBonus + 100.
      ELSE.
        <fs_student_data>-variablePay = <fs_student_data>-InternSalary + <fs_student_data>-InternBonus + 300.
      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_student_data ).


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    """ This method execute first before the method 'CALCULATE'

  ENDMETHOD.
ENDCLASS.
