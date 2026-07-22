CLASS zcl_api_stud_unm_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      tt_create_student     TYPE TABLE FOR CREATE zi_root_stud_unm_01\\Student,
      tt_mapped_early       TYPE RESPONSE FOR MAPPED EARLY zi_root_stud_unm_01,
      tt_reported_early     TYPE RESPONSE FOR REPORTED EARLY zi_root_stud_unm_01,
      tt_failed_early       TYPE RESPONSE FOR FAILED EARLY zi_root_stud_unm_01,
      tt_reported_late      TYPE RESPONSE FOR REPORTED LATE zi_root_stud_unm_01,
      tt_read_keys          TYPE TABLE FOR READ IMPORT zi_root_stud_unm_01\\Student,
      tt_read_result        TYPE TABLE FOR READ RESULT zi_root_stud_unm_01\\Student,
      tt_update_student     TYPE TABLE FOR UPDATE zi_root_stud_unm_01\\Student,
      tt_delete_student     TYPE TABLE FOR DELETE zi_root_stud_unm_01\\Student,
      tt_create_academicres TYPE TABLE FOR CREATE zi_root_stud_unm_01\\Student\_academicres,
      tt_delete_academicres TYPE TABLE FOR DELETE zi_root_stud_unm_01\\AcademicResult,
      tt_create_attaching   TYPE TABLE FOR CREATE zi_root_stud_unm_01\\student\_Attaching,
      tt_delete_attaching   TYPE TABLE FOR DELETE zi_root_stud_unm_01\\Attaching,
      tt_lock_student       TYPE TABLE FOR KEY OF zi_root_stud_unm_01\\student.

    DATA: gt_student   TYPE STANDARD TABLE OF ztbl_stud_unm_01. """Now this GT_Student made as global variable.
    "" For the implementation of the CHECK_BEFORE_SAVE method.

    ""CREATE COSTRUCTOR FOR THE CLASS
    CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_api_stud_unm_01.

    METHODS:

      earlynumbering_create_student
        IMPORTING entities TYPE tt_create_student
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      create_student
        IMPORTING entities TYPE tt_create_student
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      read_student
        IMPORTING keys     TYPE tt_read_keys
        CHANGING  result   TYPE tt_read_result
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      update_student
        IMPORTING entities TYPE tt_update_student
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      delete_student
        IMPORTING keys     TYPE tt_delete_student
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

****SOM-ACADEMIC RESULT DATA
      earlynumbering_cba_academicres
        IMPORTING entities TYPE tt_create_academicres
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      cba_academicres
        IMPORTING entities_cba TYPE tt_create_academicres
        CHANGING  mapped       TYPE tt_mapped_early
                  failed       TYPE tt_failed_early
                  reported     TYPE tt_reported_early,

      delete_academicres
        IMPORTING keys     TYPE tt_delete_academicres
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,
****EOM-ACADEMIC RESULT DATA

****SOM-ATTACHMENT DATA
      earlynumbering_cba_attaching
        IMPORTING entities TYPE tt_create_attaching
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      cba_attaching
        IMPORTING entities_cba TYPE tt_create_attaching
        CHANGING  mapped       TYPE tt_mapped_early
                  failed       TYPE tt_failed_early
                  reported     TYPE tt_reported_early,

      delete_attachment
        IMPORTING keys     TYPE tt_delete_attaching
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,
****EOM-ATTACHMENT DATA

      save
        CHANGING reported TYPE tt_reported_late.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA : mo_instance      TYPE REF TO zcl_api_stud_unm_01,
                 gt_academres     TYPE STANDARD TABLE OF ztbl_acdmc_um_01,
                 gs_mapped        TYPE tt_mapped_early,
                 gr_academicres_d TYPE RANGE OF  sysuuid_x16,
                 gt_attachment    TYPE STANDARD TABLE OF ztbl_attc_unm_01,
                 gr_student_d     TYPE RANGE OF  sysuuid_x16,
                 gr_attachment_d  TYPE RANGE OF  sysuuid_x16.

    METHODS:
      get_next_id RETURNING VALUE(rv_id) TYPE   sysuuid_x16,
      get_next_student_id RETURNING VALUE(rv_student_id) TYPE zde_num12_01.

ENDCLASS.



CLASS zcl_api_stud_unm_01 IMPLEMENTATION.

  METHOD get_instance.  ""The method read instantiates the buffer and calls the method
    ""Method 'get_instance' implementation is mandatory to CREATE record after clicked on
    ""the button CREATE. To avoid 'RUNTIME SHORT_DUMP ERROR'.
    mo_instance = ro_instance = COND #( WHEN mo_instance IS BOUND
                                             THEN mo_instance
                                             ELSE NEW #(  ) ).
  ENDMETHOD.

  METHOD earlynumbering_create_student. ""CREATE STUDENT UUID

    ""Method 'earlynumbering_create_student' implementation is mandatory to CREATE record after clicked on
    ""the button CREATE. To avoid 'RUNTIME SHORT_DUMP ERROR'.
    ""Before click on the button 'SAVE' this method will triggered, that is at the interaction phase.
    ""IMP: This method will triggered as soon as you click on the the button 'CREATE' on the main object page.
    DATA(ls_mapped) = gs_mapped.
**    DATA(lv_new_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    DATA(lv_new_id) = get_next_id( ).

    READ TABLE gt_student ASSIGNING FIELD-SYMBOL(<fs_student>) INDEX 1.
    IF <fs_student> IS ASSIGNED.
      <fs_student>-id = lv_new_id.
      UNASSIGN  <fs_student>.
    ENDIF.

    ""NEED TO SHOW THE KEY FIELD VALUE ON FRONTEND AS WELL BEFORE SAVED.
    mapped-student = VALUE #(
       FOR ls_entity IN entities WHERE ( id IS INITIAL )
       (
       %cid      = ls_entity-%cid ""FRAMEWORK'S CID WILL GET GENERATE TEMPORARY ID HERE FOR EG: '%SADL_CID_1'
       %is_draft = ls_entity-%is_draft ""FOR EG: '01'
       id        = lv_new_id ""NEWLY GENERATED STUDENT UUID
       )
    ).

  ENDMETHOD.


  METHOD get_next_id. ""CREATE STUDENT UUID
    ""Method 'get_next_id' implimentation is mandatory to CREATE record after clicked on
    ""the button CREATE. To avoid 'RUNTIME SHORT_DUMP ERROR'.
    TRY.
        rv_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_next_student_id. """CREATE STUDENT ID

    SELECT MAX( studentid ) FROM ztbl_stud_unm_01 INTO @DATA(lv_max_student_id).
    rv_student_id = lv_max_student_id + 1.

  ENDMETHOD.


  METHOD create_student. ""CREATE STUDENT ID

    ""THIS METHOD WILL GENERATE NEXT CONSICATIVE STUDENT ID
    ""IMP: This method will triggered only when you click on second 'CREATE' button from second object page.
    ""Button 'SAVE' appear only when you edit the already created/existing record.
    ""While 'SAVING' this method will not triggered.
    gt_student = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    ""USING OLD SYNTAX:
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
*
*      IF gt_student[] IS NOT INITIAL.
*        gt_student[ 1 ]-studentid = get_next_student_id( ).
*        GET TIME STAMP FIELD DATA(lv_ts). """GETTING CURRENT TIMESTAMP
*        gt_student[ 1 ]-lastchangedat = lv_ts.
*        gt_student[ 1 ]-locallastchangedat = lv_ts.
*
*        mapped-student = VALUE #(
*           (
*           %cid = <fs_entity>-%cid
*           %key = <fs_entity>-%key
*           %is_draft = <fs_entity>-%is_draft
*           )
*        ).
*      ENDIF.
*
*    ENDLOOP.

    ""USING NEW SYNTAX:
    IF  gt_student[] IS NOT INITIAL.
      gt_student[ 1 ]-studentid = get_next_student_id( ).

      GET TIME STAMP FIELD DATA(lv_ts). """GETTING CURRENT TIMESTAMP
      gt_student[ 1 ]-lastchangedat = lv_ts. "" 'lv_ts' is ETAG FIELD WHICH HOLDS A CURRENT TIMESTAMP
      gt_student[ 1 ]-locallastchangedat = lv_ts.
    ENDIF.

    mapped = VALUE #(
            student = VALUE #(
                   FOR ls_entity IN entities (
                          %cid = ls_entity-%cid
                          %key = ls_entity-%key
                          %is_draft = ls_entity-%is_draft
                    )
                 )
             ).

  ENDMETHOD.

  METHOD save. ""SAVE STUDENT, ACADEMIC & ATTACHMENTS DETAILS
    ""IMP: This method will triggered after click on the button 'EDIT' or 'SAVE' a record.
    IF gt_student[] IS NOT INITIAL. "" AND  gt_student[ 1 ]-student_id IS NOT INITIAL.
      MODIFY ztbl_stud_unm_01 FROM TABLE @gt_student[]. ""STUDENT DATA SAVE HERE
    ENDIF.

    IF gt_academres[] IS NOT INITIAL. "" AND  gt_academres[ 1 ]-course IS NOT INITIAL.
      MODIFY ztbl_acdmc_um_01 FROM TABLE @gt_academres[]. ""ACADEMIC RESULT DATA SAVE HERE
    ENDIF.

    IF gt_attachment[] IS NOT INITIAL. "" AND  gt_academres[ 1 ]-course IS NOT INITIAL.
      MODIFY ztbl_attc_unm_01 FROM TABLE @gt_attachment[]. ""ATTACHMENT DATA SAVE HERE
    ENDIF.

    IF gr_student_d[] IS NOT INITIAL.
      DELETE FROM ztbl_stud_unm_01 WHERE id IN @gr_student_d. ""STUDENT DATA DELETE HERE
    ENDIF.

    IF gr_academicres_d[] IS NOT INITIAL.
      DELETE FROM ztbl_acdmc_um_01 WHERE id IN @gr_academicres_d. ""ACADEMIC RESULT DATA DELETE HERE
    ENDIF.

    IF gr_attachment_d[] IS NOT INITIAL.
      DELETE FROM ztbl_attc_unm_01 WHERE attach_id IN @gr_attachment_d. ""ATTACHMENT DATA DELETE HERE
    ENDIF.

  ENDMETHOD.


  METHOD delete_student. ""DELETE STUDENT UUID
    DATA lt_student TYPE TABLE OF ztbl_stud_unm_01.

    lt_student = CORRESPONDING #( keys MAPPING FROM ENTITY ).

    gr_student_d = VALUE #(
           FOR ls_student IN lt_student (
           sign = 'I'
           option = 'EQ'
           low   = ls_student-id ""STUDENT UUID
           )
    ).
  ENDMETHOD.


  METHOD read_student. """READ STUDENT DATA ONCE CLICKED ON THE BUTTON: 'EDIT'
    ""THIS METHOD WILL TRIGGERED BEFORE UPDATE THE RECORD, ONCE CLICKED ON THE BUTTON 'EDIT'
    SELECT * FROM ztbl_stud_unm_01 FOR ALL ENTRIES IN @keys
            WHERE id = @keys-Id
            INTO TABLE @DATA(lt_student_result).

    result = CORRESPONDING #( lt_student_result MAPPING TO ENTITY ).
  ENDMETHOD.


  METHOD update_student. ""UPDATE STUDENT DETAILS
    ""After finished record 'EDIT' then click on button 'SAVE' this method will triggered.
    DATA lt_student_update TYPE STANDARD TABLE OF ztbl_stud_unm_01.

    ""WHICH FIELDS HAS BEEN UPDATED BY THE USER, THIS CONTROL STRUCTURE HELP US TO IDENTIFY
    ""THOSE FIELDS IN THE UPDATE QUERY OR IN THE UPDATE METHOD.
    ""FOR EG: IF USER HAS CHANGED THE FIELD 'STATUS', OR 'COURSE', OR 'COURSEDURATION' THEN THESE FIELDS WILL HAVE A VALUE
    ""AS 'X'. THE FIELDS WHICH ARE NOT CHANGED THOSE WILL HAVE A BLANK VALUE; BUT CURRENT ENTITIES VALUE WILL SAVED.
    DATA lt_student_updatex TYPE STANDARD TABLE OF zcs_stud_unm_01. ""CONTROL STRUCTURE

    lt_student_update = CORRESPONDING #( entities MAPPING FROM ENTITY ). ""READ THE RECORD WITH THE 'ID' FIELD TO SHOW ON THE FRONTEND.
    lt_student_updateX = CORRESPONDING #( entities MAPPING FROM ENTITY USING CONTROL ).

    IF NOT lt_student_update[] IS INITIAL.
      ""READING OLD VALUES
      SELECT * FROM ztbl_stud_unm_01 FOR ALL ENTRIES IN @lt_student_update
             WHERE id = @lt_student_update-Id
             INTO TABLE @DATA(lt_student_update_old).
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_ts_2). """GETTING CURRENT TIMESTAMP ""ETAG FIELD
    gt_student = VALUE #(
             FOR x = 1 WHILE x <= lines(  lt_student_update )
       LET
              ls_control_flag = VALUE #( lt_student_updatex[ x ] OPTIONAL  )
              ls_student_new = VALUE #( lt_student_update[ x ] OPTIONAL  )
              ls_student_old = VALUE #( lt_student_update_old[ id = ls_student_new-id ] OPTIONAL )

       IN
       ( ""USING CONTROL STR TO IDENTIFY WHICH VALUE IS OLD OR NEW.
         id = ls_student_old-id
         locallastchangedat = lv_ts_2
         lastchangedat = lv_ts_2
         age = COND #( WHEN ls_control_flag-age IS NOT  INITIAL
                                     THEN ls_student_new-age
                                     ELSE ls_student_old-age )

         course = COND #( WHEN ls_control_flag-course IS NOT  INITIAL
                                     THEN ls_student_new-course
                                     ELSE ls_student_old-course )

         courseduration = COND #( WHEN ls_control_flag-courseduration IS NOT  INITIAL
                                     THEN ls_student_new-courseduration
                                     ELSE ls_student_old-courseduration )

         studentid = COND #( WHEN ls_control_flag-studentid IS NOT  INITIAL
                                     THEN ls_student_new-studentid
                                     ELSE ls_student_old-studentid )

         dob = COND #( WHEN ls_control_flag-dob IS NOT  INITIAL
                                     THEN ls_student_new-dob
                                     ELSE ls_student_old-dob )

         firstname = COND #( WHEN ls_control_flag-firstname IS NOT  INITIAL
                                     THEN ls_student_new-firstname
                                     ELSE ls_student_old-firstname )

         gender = COND #( WHEN ls_control_flag-gender IS NOT  INITIAL
                                     THEN ls_student_new-gender
                                     ELSE ls_student_old-gender )

         lastname = COND #( WHEN ls_control_flag-lastname IS NOT  INITIAL
                                     THEN ls_student_new-lastname
                                     ELSE ls_student_old-lastname )

         status = COND #( WHEN ls_control_flag-status IS NOT  INITIAL
                                     THEN ls_student_new-status
                                     ELSE ls_student_old-status )

         intern_desgn = COND #( WHEN ls_control_flag-interndesgn IS NOT  INITIAL
                                     THEN ls_student_new-intern_desgn
                                     ELSE ls_student_old-intern_desgn )

         intern_salary = COND #( WHEN ls_control_flag-internsalary IS NOT  INITIAL
                                     THEN ls_student_new-intern_salary
                                     ELSE ls_student_old-intern_salary )

         intern_bonus = COND #( WHEN ls_control_flag-internbonus IS NOT  INITIAL
                                     THEN ls_student_new-intern_bonus
                                     ELSE ls_student_old-intern_bonus )

       )
    ).
  ENDMETHOD.


  METHOD earlynumbering_cba_academicres. ""CREATE BY ASSOCIATION TO GENERATE ACADEMIC UUID AND MAKE REST OF THE ACADEMIC DATA FIELDS READY FOR INPUTS.
    ""JUST ACADEMIC UUID WILL GET GENERATED, BUT NOT SAVE A RECORD.
    ""CREATED BY ASSOCIATION STUDENT
    DATA(lv_new_academic_id) = get_next_id( ). ""NEW ACADEMIC UUID WILL GET GENERATE HERE

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>). ""ENTITIES WILL HAVE A STUDENT DATA
      LOOP AT <fs_entity>-%target ASSIGNING FIELD-SYMBOL(<fs_academic>).
        mapped-academicresult = VALUE #( (
            %cid      =  <fs_academic>-%cid ""FRAMEWORK'S CID WILL GET GENERATE HERE FOR EG: '%SADL_CID_1'
            %is_draft = <fs_academic>-%is_draft ""FOR EG: '01'
            %key      = <fs_academic>-%key
            Id1       = lv_new_academic_id ""NEWLY GENERATED ACADEMIC UUID
            )
         ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD cba_academicres.""CREATE BY ASSOCIATION DATA, SAVE ENTERED ASSOCIATION DATA BASE ON STUDENT UUID

    gt_academres = VALUE #(
        FOR ls_entity_cba IN entities_cba
         FOR ls_academic IN ls_entity_cba-%target ""%TARGET WILL CONTAINS CHILD ASSOCIATION DATA
         LET
              ls_rap_academic = CORRESPONDING ztbl_acdmc_um_01( ls_academic MAPPING FROM ENTITY )
        IN (
              ls_rap_academic
            )
      ).

    mapped = VALUE #(
        academicresult = VALUE #(
           FOR i = 1 WHILE i <= lines(  entities_cba )
           LET lt_academic = VALUE #( entities_cba[ i ]-%target OPTIONAL )
            IN  FOR j = 1 WHILE j <= lines( lt_academic )
                  LET ls_cur_academic = VALUE #(  lt_academic[ j ] OPTIONAL )

                  IN (
                  %cid = ls_cur_academic-%cid
                  %key = ls_cur_academic-%key
                  Id = ls_cur_academic-Id
                  )
          )
        ).
  ENDMETHOD.


  METHOD delete_academicres. """"DELETE ACADEMIC RESULT DATA
    DATA: lt_academicres TYPE TABLE OF ztbl_acdmc_um_01.

    lt_academicres = CORRESPONDING #( keys MAPPING FROM ENTITY ).

    gr_academicres_d = VALUE #(
           FOR ls_academicres IN lt_academicres (
           sign = 'I'
           option = 'EQ'
           low   = ls_academicres-id ""ACADEMIC RESULT UUID
           )
    ).
  ENDMETHOD.

  METHOD earlynumbering_cba_attaching. """"SOM-ATTACHMENT DATA
    DATA(lv_new_attachmnt_id) = get_next_id( ). ""NEW ATTACHMENT UUID WILL GET GENERATE HERE
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>). ""ENTITIES WILL HAVE A ATTACHMENT DATA
      LOOP AT <fs_entity>-%target ASSIGNING FIELD-SYMBOL(<fs_attachmnt>).
        mapped-attaching = VALUE #( (
            %cid         =  <fs_attachmnt>-%cid ""FRAMEWORK'S CID WILL GET GENERATE HERE FOR EG: '%SADL_CID_1'
            %is_draft    = <fs_attachmnt>-%is_draft ""FOR EG: '01'
            %key         = <fs_attachmnt>-%key
            Attach_Id    = lv_new_attachmnt_id ""NEWLY GENERATED ATTACHMENT UUID
            )
         ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD. """"EOM-ATTACHMENT DATA


  METHOD cba_attaching. """"SOM-ATTACHMENT DATA
    """"CREATE BY ASSOCIATION DATA, SAVE ENTERED ASSOCIATION DATA BASE ON STUDENT UUID FOR ATTACHMENT DETAILS
    gt_attachment = VALUE #(
       FOR ls_entity_cba IN entities_cba
        FOR ls_attachmnt IN ls_entity_cba-%target ""%TARGET WILL CONTAINS CHILD ASSOCIATION DATA
        LET
             ls_rap_attachment = CORRESPONDING ztbl_attc_unm_01( ls_attachmnt MAPPING FROM ENTITY )
       IN (
             ls_rap_attachment
           )
         ).

    mapped = VALUE #(
        attaching = VALUE #(
           FOR i = 1 WHILE i <= lines(  entities_cba )
           LET lt_attachmnt = VALUE #( entities_cba[ i ]-%target OPTIONAL )
            IN  FOR j = 1 WHILE j <= lines( lt_attachmnt )
                  LET ls_cur_attachmnt = VALUE #(  lt_attachmnt[ j ] OPTIONAL )

                  IN (
                  %cid      = ls_cur_attachmnt-%cid
                  %key      = ls_cur_attachmnt-%key
                  Id        = ls_cur_attachmnt-Id
                  )
          )
        ).
  ENDMETHOD. """"EOM-ATTACHMENT DATA


  METHOD delete_attachment. """"DELETE ATTACHMENT DATA
    DATA lt_attachment TYPE TABLE OF ztbl_attc_unm_01.

    lt_attachment = CORRESPONDING #( keys MAPPING FROM ENTITY ).

    gr_attachment_d = VALUE #(
           FOR ls_attachment IN lt_attachment (
           sign = 'I'
           option = 'EQ'
           low   = ls_attachment-attach_id ""ATTACHMENT UUID
           )
    ).
  ENDMETHOD. """"EOM-ATTACHMENT DATA

ENDCLASS.
