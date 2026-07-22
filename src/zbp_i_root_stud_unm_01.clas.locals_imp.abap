CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Student RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Student.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Student.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Student.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Student.

    METHODS read FOR READ
      IMPORTING keys FOR READ Student RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Student.

    METHODS rba_Academicres FOR READ
      IMPORTING keys_rba FOR READ Student\_Academicres FULL result_requested RESULT result LINK association_links.

    METHODS rba_Attaching FOR READ
      IMPORTING keys_rba FOR READ Student\_Attaching FULL result_requested RESULT result LINK association_links.

    METHODS cba_Academicres FOR MODIFY
      IMPORTING entities_cba FOR CREATE Student\_Academicres.

    METHODS earlynumbering_cba_Academicres FOR NUMBERING
      IMPORTING entities FOR CREATE Student\_Academicres.

    METHODS cba_Attaching FOR MODIFY
      IMPORTING entities_cba FOR CREATE Student\_Attaching.

    METHODS earlynumbering_cba_Attaching FOR NUMBERING
      IMPORTING entities FOR CREATE Student\_Attaching.

    METHODS copyData FOR MODIFY
      IMPORTING keys FOR ACTION Student~copyData.

    METHODS createInstance FOR MODIFY
      IMPORTING keys FOR ACTION Student~createInstance.

    METHODS multistatusUpdate FOR MODIFY
      IMPORTING keys FOR ACTION Student~multistatusUpdate RESULT result.

    METHODS setAdmitted FOR MODIFY
      IMPORTING keys FOR ACTION Student~setAdmitted RESULT result.

    METHODS updateStudentStatus FOR MODIFY
      IMPORTING keys FOR ACTION Student~updateStudentStatus RESULT result.

    METHODS calculateAge FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Student~calculateAge.

    METHODS changeSalary FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Student~changeSalary.

    METHODS updateCourseDuration FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Student~updateCourseDuration.

    METHODS validate_course FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~validate_course.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~validate_fields.

    METHODS is_update_granted RETURNING VALUE(update_granted) TYPE abap_bool.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_features.

    ""Custom Action - Change State, BUTTON: 'setAdmitted'

    READ ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_submitted)
    FAILED failed.

    ""Button 'setAdmitted' enable only if field STATUS value is 'No', else if 'Yes' then remains disable.
    result = VALUE #( FOR ls_student_submitted IN lt_student_submitted
                      LET lv_status = COND #( WHEN ls_student_submitted-Status = abap_true
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled )

                                                       IN ( %tky = ls_student_submitted-%tky
                                                            %action-setAdmitted = lv_status )
                      ).

**** Make 'EDIT' button disable if value of the field STATUS is 'NO'.
*    DATA(ls_student_submitted_2) = lt_student_submitted[ 1 ].
*    APPEND VALUE #(
*       %tky = ls_student_submitted_2-%tky
*       %action-Edit         = COND #( WHEN ls_student_submitted_2-Status = abap_false
*                                                        THEN if_abap_behv=>fc-o-disabled
*                                                        ELSE if_abap_behv=>fc-o-enabled )
*     ) TO result.

  ENDMETHOD.

  METHOD get_instance_authorizations. ""authorization master ( instance )
    ""This method will Authorized /  Unauthorized separate instance base on certain conditions.

    DATA: update_requested TYPE abap_bool,
          update_grtanted  TYPE abap_bool.

    READ ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
      ENTITY Student
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_stud_auth)
      FAILED failed.

    CHECK lt_stud_auth IS NOT INITIAL.
    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
                                    requested_authorizations-%action-Edit = if_abap_behv=>mk-on THEN
                                    abap_true ELSE abap_false ).

*    LOOP AT lt_stud_auth ASSIGNING FIELD-SYMBOL(<lfs_stud_auth>).
*      IF <lfs_stud_auth>-Status = abap_false. ""Base on value of the Field 'STATUS' instance will be authorized to update a record.
*        IF update_requested = abap_true.
**          update_grtanted = is_update_granted( status = <lfs_stud_auth>-Status ).
*          update_grtanted = is_update_granted( ).
*          IF update_grtanted = abap_false.
*            APPEND VALUE #(  %tky = <lfs_stud_auth>-%tky ) TO failed-student.
*            APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                            %msg = new_message_with_text(
*                                severity = if_abap_behv_message=>severity-error
*                                text = 'No Authorization to update status!!!'
*                            )
*            ) TO reported-student.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.

    "" authorization master ( global )
    "" This method will Authorized / Unauthorized all the instances at once.

*   This will disable the EDIT button base on the variable 'UPDATE_GRANTED' value TRUE OR FALSE.
*    IF requested_authorizations-%update = if_abap_behv=>mk-on OR
*        requested_authorizations-%action-Edit   = if_abap_behv=>mk-on.
**
***     Check method IS_UPDATE_ALLOWED (Authorization simulation Check method)
*      IF is_update_granted( ) = abap_true.
**
***       update result with EDIT Allowed
*        result-%update = if_abap_behv=>auth-allowed.
*        result-%action-Edit = if_abap_behv=>auth-allowed.
**
*      ELSE.
**
***       update result with EDIT Not Allowed
*        result-%update = if_abap_behv=>auth-unauthorized.
*        result-%action-Edit = if_abap_behv=>auth-unauthorized.
*
*      ENDIF.
*    ENDIF.

  ENDMETHOD.

  METHOD is_update_granted.

    " This simulates missing authorization for canceled (status = X) travels.
*    update_granted =  abap_true. "" 'ABAP_TRUE' will enable the button 'EDIT'. User able to perform edit/update operation.
    ""***NOTE: This line of code not ALLOWED in a Production system.
    update_granted =  abap_false. "" 'ABAP_FALSE' will disable the button 'EDIT'. User unable to perform edit/update operation.


    " Authorization check for the update operation
*    AUTHORITY-CHECK OBJECT 'ZAUTHSTUD2' " Your authorization object
*      ID 'ZAUTH_STUS' FIELD status
*      ID 'ACTVT' FIELD '02'. " '02' indicates update operation
*
*    IF sy-subrc EQ 0.
*      update_granted = abap_true.
*    ELSE.
*      update_granted = abap_false.
*    ENDIF.

  ENDMETHOD.

  METHOD create.
    zcl_api_stud_unm_01=>get_instance(  )->create_student(
           EXPORTING
             entities = entities
           CHANGING
             mapped   = mapped
             failed   = failed
             reported = reported
         ).
  ENDMETHOD.

  METHOD earlynumbering_create.
    ""Method 'earlynumbering_create' implimentation is mandatory to CREATE record after clicked on
    ""the button CREATE. To avoid 'RUNTIME SHORT_DUMP ERROR'.
    zcl_api_stud_unm_01=>get_instance(  )->earlynumbering_create_student(
    EXPORTING
      entities = entities
    CHANGING
      mapped   = mapped
      failed   = failed
      reported = reported
  ).
  ENDMETHOD.

  METHOD update.
    zcl_api_stud_unm_01=>get_instance(  )->update_student(
          EXPORTING
            entities =  entities
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported
        ).
  ENDMETHOD.

  METHOD delete.
    zcl_api_stud_unm_01=>get_instance(  )->delete_student(
       EXPORTING
         keys     = keys
       CHANGING
         mapped   = mapped
         failed   = failed
         reported = reported
     ).
  ENDMETHOD.

  METHOD read.
    zcl_api_stud_unm_01=>get_instance(  )->read_student(
        EXPORTING
          keys     = keys
        CHANGING
          result   = result
          failed   = failed
          reported = reported
      ).
  ENDMETHOD.

  METHOD lock.
    ""Pessimistic Concurrency Control
*    ""CREATING INSTANCE FOR LOCK OBJECT 'EZLOCKSTUDENT_3'
*    ""IF A SAME RECORD MULTIPLE USERS TRYING TO EDIT THEN IT WILL THROW AN ERROR TO OTHER USERS EXCEPT THE USER
*    ""WHO FIRST OPEN THE SAME RECORD.
*    TRY.
*        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZLOCKSTUDENT_3' ).
*      CATCH cx_abap_lock_failure INTO DATA(excp).
*        RAISE SHORTDUMP excp.
*    ENDTRY.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_student>).
*
*      TRY.
*          lock->enqueue(
*            it_parameter  = VALUE #( ( name = 'ID' value  = REF #( <fs_student>-Id ) ) )
*          ).
*        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
*
*          APPEND VALUE #(
*                          Id = keys[ 1 ]-Id
*                           %msg = new_message_with_text(
*                                   severity = if_abap_behv_message=>severity-error
*                                    text     = 'Record is locked by-' && || && foreign_lock->user_name
*                                  )
*                                  ) TO reported-student.
*
*          APPEND VALUE #(
*                            Id = keys[ 1 ]-Id  )
*                            TO failed-student.
*
*        CATCH cx_abap_lock_failure INTO DATA(ls_excp).
*          RAISE SHORTDUMP ls_excp.
*      ENDTRY.
*    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Academicres.
  ENDMETHOD.

  METHOD rba_Attaching.
  ENDMETHOD.

  METHOD cba_Academicres.
    zcl_api_stud_unm_01=>get_instance(  )->cba_academicres(
        EXPORTING
          entities_cba = entities_cba
        CHANGING
          mapped       = mapped
          failed       = failed
          reported     = reported
      ).
  ENDMETHOD.

  METHOD earlynumbering_cba_Academicres.
    zcl_api_stud_unm_01=>get_instance(  )->earlynumbering_cba_academicres(
         EXPORTING
           entities = entities
         CHANGING
           mapped   = mapped
           failed   = failed
           reported = reported
       ).
  ENDMETHOD.

  METHOD cba_Attaching."""ATTACHMENT DATA
    zcl_api_stud_unm_01=>get_instance(  )->cba_attaching(
      EXPORTING
        entities_cba = entities_cba
      CHANGING
        mapped       = mapped
        failed       = failed
        reported     = reported
    ).
  ENDMETHOD.

  METHOD earlynumbering_cba_Attaching."""ATTACHMENT DATA
    zcl_api_stud_unm_01=>get_instance(  )->earlynumbering_cba_attaching(
    EXPORTING
      entities = entities
    CHANGING
      mapped   = mapped
      failed   = failed
      reported = reported
  ).
  ENDMETHOD.

  METHOD copyData.

    ""Instance Based Factory action
    DATA: lt_student_Data TYPE TABLE FOR CREATE zi_root_stud_unm_01.

    READ ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_copy)
    FAILED failed.

    LOOP AT lt_student_copy ASSIGNING FIELD-SYMBOL(<fs_student_copy>).

      APPEND VALUE #( %cid = keys[ KEY entity %key = <fs_student_copy>-%key ]-%cid
                      %is_draft = keys[ KEY entity %key = <fs_student_copy>-%key ]-%param-%is_draft
                      %data = CORRESPONDING #( <fs_student_copy> EXCEPT id )
                     ) TO lt_student_data ASSIGNING FIELD-SYMBOL(<fs_newstudent>).

    ENDLOOP.

    ""CREATED BO INSTANCE BY COPY.
    MODIFY ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    CREATE FIELDS ( firstname lastname age course courseduration status gender dob )
    WITH lt_student_data
    MAPPED DATA(mapped_created).

    mapped-student = mapped_created-student.

  ENDMETHOD.

  METHOD createInstance.

    ""Static Factory Action

    MODIFY ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    CREATE FROM VALUE #( FOR <instance> IN keys (
                          %cid = <instance>-%cid
                          age = 31
                          Course = 'DA'
                          Courseduration = 9
                          Filename = 'ABC'
                          Lastname = 'XYZ'
                          Dob = sy-datum

    ""  'mk-on'  = default value set
    ""  'mk-off' = default value does not set
                          %control = VALUE #( age = if_abap_behv=>mk-on
                                              course = if_abap_behv=>mk-on
                                              Courseduration = if_abap_behv=>mk-off ""
                                              firstname = if_abap_behv=>mk-on
                                              Lastname = if_abap_behv=>mk-off ""
                                              Dob = if_abap_behv=>mk-on
                                               )
                          ) )
                          MAPPED mapped
                          FAILED failed
                          REPORTED reported.

  ENDMETHOD.

  METHOD multistatusUpdate.

    """invocationGrouping = #CHANGE_SET
*    READ ENTITIES OF zi_root_stud_unm_01
*    IN LOCAL MODE
*    ENTITY Student
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_student_multi)
*    FAILED failed.
*
*    SORT lt_student_multi BY Status DESCENDING.
*    LOOP AT lt_student_multi ASSIGNING FIELD-SYMBOL(<fs_student_multi>).
*      <fs_student_multi>-Status = abap_true.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zi_root_stud_unm_01
*    IN LOCAL MODE
*    ENTITY Student
*    UPDATE FIELDS ( Status ) WITH CORRESPONDING #( lt_student_multi ).

    """invocationGrouping = #ISOLATED
    READ ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_multi_2)
    FAILED failed.

    SORT lt_student_multi_2 BY Status DESCENDING.
    LOOP AT lt_student_multi_2 ASSIGNING FIELD-SYMBOL(<fs_student_multi_2>).
      IF  <fs_student_multi_2>-Age < 30.
        APPEND VALUE #( %tky = <fs_student_multi_2>-%tky ) TO failed-student.
        APPEND VALUE #( %tky = <fs_student_multi_2>-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = <fs_student_multi_2>-Firstname && ' has age less than 25Yrs, Status cannot update.'
                               ) ) TO reported-student.
      ELSE.
        <fs_student_multi_2>-Status = abap_true.
      ENDIF.
    ENDLOOP.

    IF failed-student IS INITIAL.
      SORT lt_student_multi_2 BY Status DESCENDING.
      MODIFY ENTITIES OF zi_root_stud_unm_01
      IN LOCAL MODE
      ENTITY Student
      UPDATE FIELDS ( Status ) WITH CORRESPONDING #( lt_student_multi_2 ).
    ENDIF.

  ENDMETHOD.

  METHOD setAdmitted.
    ""THIS METHOD IS USED TO UPDATE A VALUE OF THE FIELD 'STATUS' TO 'YES'.
    ""AND BUTTON 'setAdmitted' ONLY ENABLE IF THE STATUS = 'NO'.
    MODIFY ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    UPDATE
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )
    FAILED failed
    REPORTED reported.

    ""GET THE RESPONSE OF THE UPDATED RECORD:
    READ ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_studentdata).

    result = VALUE #( FOR ls_stundentdata IN lt_studentdata
        ( %tky = ls_stundentdata-%tky %param = ls_stundentdata ) ).
  ENDMETHOD.

  METHOD updateStudentStatus.
    ""ABSTRACT ENTITY METHOD ""POPUP WINDOW APPEAR TO UPDATE STATUS
    ""THIS METHOD WILL UPDATE A VALUE OF THE FIELD 'STATUS' ONCE CLICKED ON THE BUTTON 'UPDATE STATUS'
    ""WITHOUT EDITING A RECORD

    DATA(lt_keys) = keys.

    READ ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status Course Courseduration ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_cs).

    DATA(lv_new_status) = lt_keys[ 1 ]-%param-status.
    DATA(lv_new_course) = lt_keys[ 1 ]-%param-course.
    DATA(lv_new_coursedurtn) = lt_keys[ 1 ]-%param-courseduration.

    MODIFY ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    UPDATE FIELDS ( Status Course Courseduration )
    WITH VALUE #(
                 ( %tky = lt_student_cs[ 1 ]-%tky Status = lv_new_status
                   Course = lv_new_course
                   Courseduration = lv_new_coursedurtn )
               ).

    READ ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student).

    result = VALUE #( FOR <lfs_student> IN lt_student
                      ( %tky = <lfs_student>-%tky
                        %param = <lfs_student> )
                     ).
  ENDMETHOD.

  METHOD calculateAge.""Calculate student 'Age' base on 'DOB'
    DATA: lv_sysdate TYPE sy-datum.

    lv_sysdate = sy-datum. ""Mapping the Current System date.
    READ ENTITIES OF zi_root_stud_unm_01
        IN LOCAL MODE
        ENTITY Student
        FIELDS ( Dob ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_student_age).
    IF  lt_student_age IS NOT INITIAL.
      LOOP AT lt_student_age ASSIGNING FIELD-SYMBOL(<lt_student_age>).

        DATA(lv_age) = lv_sysdate(4) - <lt_student_age>-Dob(4).

        " Adjust if birthday not yet occurred this year
        IF lv_sysdate+4(4) < <lt_student_age>-Dob+4(4).
          lv_age = lv_age - 1.
        ENDIF.

        MODIFY ENTITIES OF zi_root_stud_unm_01 IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( age )
        WITH VALUE #(
                        ( %tky = <lt_student_age>-%tky
                          age = lv_age )
                      ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD changeSalary.

    READ ENTITIES OF zi_root_stud_unm_01
        IN LOCAL MODE
        ENTITY Student
        FIELDS ( InternDesgn ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_student_salary).

    IF  lt_student_salary IS NOT INITIAL.
      LOOP AT lt_student_salary ASSIGNING FIELD-SYMBOL(<fs_student_salary>).
        IF <fs_student_salary>-InternDesgn EQ 'Analyst'.
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( InternSalary )
          WITH VALUE #(
                          ( %tky = <fs_student_salary>-%tky InternSalary = 1000 )
                        ).
        ELSEIF <fs_student_salary>-InternDesgn EQ 'Senior Analyst'.
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( InternSalary )
          WITH VALUE #(
                          ( %tky = <fs_student_salary>-%tky InternSalary = 1500 )
                        ).
        ELSE.
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( InternSalary )
          WITH VALUE #(
                          ( %tky = <fs_student_salary>-%tky InternSalary = 2000 )
                          ).
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD updateCourseDuration.""""FIELD 'Courseduration' get updated once selected FIELD 'Course' value
    READ ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    FIELDS ( Course ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_tmp).
    IF  lt_student_tmp IS NOT INITIAL.
      LOOP AT lt_student_tmp ASSIGNING FIELD-SYMBOL(<lt_student_tmp>).
        IF <lt_student_tmp>-Course EQ 'CS'.
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( Courseduration )
          WITH VALUE #(
                          ( %tky = <lt_student_tmp>-%tky Courseduration = 9 )
                        ).
        ELSEIF <lt_student_tmp>-Course EQ 'MC'.
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( Courseduration )
          WITH VALUE #(
                          ( %tky = <lt_student_tmp>-%tky Courseduration = 6 )
                        ).
        ELSE. ""Course EQ 'NT'
          MODIFY ENTITIES OF zi_root_stud_unm_01
          IN LOCAL MODE
          ENTITY Student
          UPDATE FIELDS ( Courseduration )
          WITH VALUE #(
                          ( %tky = <lt_student_tmp>-%tky Courseduration = 12 )
                          ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD validate_course.

    READ ENTITIES OF zi_root_stud_unm_01
         IN LOCAL MODE
         ENTITY Student
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_student_tmp)
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

    IF lt_student_tmp[] IS NOT INITIAL.
      READ TABLE lt_student_tmp ASSIGNING FIELD-SYMBOL(<lfs_student_tmp>) INDEX 1.
      IF <lfs_student_tmp> IS ASSIGNED.

        """DUPLICATE ERROR MESSAGES RESOLVED BY THESE LINES CODE:
        """Property '%state_area' help to display error messages on hit 'ENTER' button.
        reported-student = VALUE #(
                        ( %tky = <lfs_student_tmp>-%tky  %state_area = 'VALIDATE_COURSE' )
                       ).

        """VALIDATING MANDATORY FIELDS:
        IF ( <lfs_student_tmp>-Course IS INITIAL ).
          failed-student = VALUE #( ( %tky = <lfs_student_tmp>-%tky ) ).

          IF <lfs_student_tmp>-Course IS INITIAL.
            reported-student = VALUE #( BASE reported-student ( """BASE reported-student // IS USED TO APPEND ALL THE ERROR MSGs
                                          %tky = <lfs_student_tmp>-%tky
                                          %state_area = 'VALIDATE_COURSE' "" %state_area PROPERTY HELP HIGHLIGHT ERROR MSG ON THE SCREEN
                                          %element-course = if_abap_behv=>mk-on
                                          %msg = new_message(   id = 'SY'
                                                                number = '002'
                                                                severity = if_abap_behv_message=>severity-error
                                                                v1 = 'Please enter Course value'
                                                              )
                                           ) ).
          ENDIF.

*          IF <lfs_student_tmp>-Gender IS INITIAL.
*            reported-student = VALUE #( BASE reported-student ( """BASE reported-student // IS USED TO APPEND ALL THE ERROR MSGs
*                                          %tky = <lfs_student_tmp>-%tky
*                                          %state_area = 'VALIDATE_GENDER' "" %state_area PROPERTY HELP HIGHLIGHT ERROR MSG ON THE SCREEN
*                                          %element-gender = if_abap_behv=>mk-on
*                                          %msg = new_message(
*                                                                id = 'SY'
*                                                                number = '002'
*                                                                severity = if_abap_behv_message=>severity-error
*
*                                                                v1 = 'Gender is required'
*                                                              )
*                                           ) ).
*          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD validate_fields.
    ""VALIDATE MANDATORY FIELDS IN THE OBJECT PAGE (FIELDS WITH RED STAR SYMBOL)
    ""MANDATORY FIELDS, THOSE FIELDS SHOULD NOT BE BLANK

    READ ENTITIES OF zi_root_stud_unm_01
    IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student_tmp)
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

    IF lt_student_tmp[] IS NOT INITIAL.
      READ TABLE lt_student_tmp ASSIGNING FIELD-SYMBOL(<lfs_student_tmp>) INDEX 1.
      IF <lfs_student_tmp> IS ASSIGNED.

        """DUPLICATE ERROR MESSAGES RESOLVED BY THESE LINES CODE:
        """Property '%state_area' help to display error messages on hit 'ENTER' button.
        reported-student = VALUE #(
                        ( %tky = <lfs_student_tmp>-%tky  %state_area = 'VALIDATE_FIRSTNAME' )
                        ( %tky = <lfs_student_tmp>-%tky  %state_area = 'VALIDATE_LASTNAME' )
                        ( %tky = <lfs_student_tmp>-%tky  %state_area = 'VALIDATE_AGE' )
                        ( %tky = <lfs_student_tmp>-%tky  %state_area = 'VALIDATE_GENDER' )
                       ).

        """VALIDATING MANDATORY FIELDS:
        IF ( <lfs_student_tmp>-Firstname IS INITIAL OR <lfs_student_tmp>-Lastname IS INITIAL
             OR <lfs_student_tmp>-Age IS INITIAL OR <lfs_student_tmp>-Gender IS INITIAL ).
          failed-student = VALUE #( ( %tky = <lfs_student_tmp>-%tky ) ).

          IF <lfs_student_tmp>-Firstname IS INITIAL.
            reported-student = VALUE #( BASE reported-student ( """BASE reported-student // IS USED TO APPEND ALL THE ERROR MSGs
                                          %tky = <lfs_student_tmp>-%tky
                                          %state_area = 'VALIDATE_FIRSTNAME' "" %state_area PROPERTY HELP HIGHLIGHT ERROR MSG ON THE SCREEN
                                          %element-firstname = if_abap_behv=>mk-on
                                          %msg = new_message(
                                                                id = 'SY'
                                                                number = '002'
                                                                severity = if_abap_behv_message=>severity-error

                                                                v1 = 'Firstname is required'
                                                              )
                                           ) ).
          ENDIF.

          IF <lfs_student_tmp>-Lastname IS INITIAL.
            reported-student = VALUE #( BASE reported-student (
                                          %tky = <lfs_student_tmp>-%tky
                                          %state_area = 'VALIDATE_LASTNAME'
                                          %element-lastname = if_abap_behv=>mk-on
                                          %msg = new_message(
                                                                id = 'SY'
                                                                number = '002'
                                                                severity = if_abap_behv_message=>severity-error
                                                                v1 = 'Lastname is required'
                                                              )
                                           ) ).
          ENDIF.

          IF <lfs_student_tmp>-Age IS INITIAL.
            reported-student = VALUE #( BASE reported-student (
                                          %tky = <lfs_student_tmp>-%tky
                                          %state_area = 'VALIDATE_AGE'
                                          %element-Age = if_abap_behv=>mk-on
                                          %msg = new_message(
                                                                id = 'SY'
                                                                number = '002'
                                                                severity = if_abap_behv_message=>severity-error
                                                                v1 = 'Age is required'
                                                              )
                                           ) ).
          ENDIF.

          IF <lfs_student_tmp>-Gender IS INITIAL.
            reported-student = VALUE #( BASE reported-student ( """BASE reported-student // IS USED TO APPEND ALL THE ERROR MSGs
                                          %tky = <lfs_student_tmp>-%tky
                                          %state_area = 'VALIDATE_GENDER' "" %state_area PROPERTY HELP HIGHLIGHT ERROR MSG ON THE SCREEN
                                          %element-gender = if_abap_behv=>mk-on
                                          %msg = new_message(
                                                                id = 'SY'
                                                                number = '002'
                                                                severity = if_abap_behv_message=>severity-error

                                                                v1 = 'Gender is required'
                                                              )
                                           ) ).
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Academicresult DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Academicresult.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Academicresult.

    METHODS read FOR READ
      IMPORTING keys FOR READ Academicresult RESULT result.

    METHODS rba_Student FOR READ
      IMPORTING keys_rba FOR READ Academicresult\_Student FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Academicresult IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    zcl_api_stud_unm_01=>get_instance(  )->delete_academicres(
         EXPORTING
           keys     = keys
         CHANGING
           mapped   = mapped
           failed   = failed
           reported = reported
       ).
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Student.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Attaching DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Attaching.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Attaching.

    METHODS read FOR READ
      IMPORTING keys FOR READ Attaching RESULT result.

    METHODS rba_Student FOR READ
      IMPORTING keys_rba FOR READ Attaching\_Student FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Attaching IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    zcl_api_stud_unm_01=>get_instance(  )->delete_attachment(
    EXPORTING
      keys     = keys
    CHANGING
      mapped   = mapped
      failed   = failed
      reported = reported
  ).
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Student.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_ROOT_STUD_UNM_01 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_ROOT_STUD_UNM_01 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save. """USE THIS METHOD TO PUT A VALIDATION
    ""IMP: This method will execute validation process after click on the second object page 'CREATE' or 'SAVE' button.
    ""and accordingly framework will throw an error message.
    DATA: gt_student_tmp   TYPE STANDARD TABLE OF ztbl_stud_unm_01.
    gt_student_tmp = zcl_api_stud_unm_01=>get_instance( )->gt_student.

    IF gt_student_tmp IS NOT INITIAL.
      READ TABLE gt_student_tmp ASSIGNING FIELD-SYMBOL(<lfs_student_tmp>) INDEX 1.
      IF <lfs_student_tmp> IS ASSIGNED.

        IF <lfs_student_tmp>-age < 18. ""Checking validation for AGE
          APPEND VALUE #( id = <lfs_student_tmp>-id ) TO failed-student.
          APPEND VALUE #( id = <lfs_student_tmp>-id
                          %msg = new_message_with_text(
                                      severity = if_abap_behv_message=>severity-error
                                      text = 'Age should be greater than or equal to 18' )
                           ) TO reported-student.
        ENDIF.

*        IF <lfs_student_tmp>-status EQ abap_false. ""Checking validation for STATUS
*          APPEND VALUE #( id = <lfs_student_tmp>-id ) TO failed-student.
*          APPEND VALUE #( id = <lfs_student_tmp>-id
*                          %msg = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text = 'Status should be Active' )
*                           ) TO reported-student.
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    zcl_api_stud_unm_01=>get_instance(  )->save(
        CHANGING
          reported = reported
      ).
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
