*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary

*** Variables ***
${base_url}     http://127.0.0.1:8000
# for student
${relative_uri_tc1}     /api/student_register
${relative_uri_tc2}     /api/all_registered_students
${relative_uri_tc3}     /api/find/student
${query_param_tc3}      ?id=
${relative_uri_tc4}     /api/update_student_info/
${relative_uri_tc5}     /api/partially/update/student_info/
${relative_uri_tc6}     /api/delete_student/
${param}    2

# for Instructor
${relative_tc7}=    /api/instructor_regis
${relative_tc8}=    /api/all/registered/instructors
${relative_tc9}=    /api/find/instructor
${relative_tc10}=    ?id=
${ins_param}=    2
${relative_tc11}=    /api/update_instructor_info/
${relative_tc12}=    /api/partially/update/instructor_info/
${relative_tc13}=    /api/delete_instructor/


# for courses
${relative_uri_14}     /api/assign_course
${relative_uri_15}     /api/available_courses
${relative_uri_16}     /api/specific_course
${relative_uri_17}      ?id=
${course_param}         2
${relative_uri_18}      /api/update_course_details/
${relative_uri_19}      /api/delete_course/


# for subjects
${relative_uri_20}     /api/assign_subject
${relative_uri_21}     /api/available_subjects
${relative_uri_22}     /api/totalSubjects_by_cid
${relative_uri_23}     ?course_id=
${subj_param}         2
${relative_uri_24}      /api/update_subject_info/
${relative_uri_25}      /api/delete_subject/


# for class schedules
${relative_uri_26}     /api/post_schedule
${relative_uri_27}     /api/released_schedules
${relative_uri_28}     /api/schedule_by_sub_id
${relative_uri_29}     ?id=
${schedule_param}         1
${relative_uri_30}      /api/update_scheduler_info/
${relative_uri_31}      /api/delete_schedule/


*** Test Cases ***
TC1: Register a new student using valid credentials (POST)
    Create Session    mysession     ${base_url}
    &{body}=   Create Dictionary   f_name=Faysal   l_name=Sarder   gender=male     age=24       mobile_no=01797651089      email=faysal001@gmail.com   password=12Abc#12
    &{header}=    Create Dictionary    Content-Type=application/json
    ${response}=   POST On Session    mysession   ${relative_uri_tc1}     json=${body}      headers=${header}

    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #  Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${contentType}=   Get From Dictionary   ${response.headers}   Content-Type
    Should Contain    ${contentType}    application/json
    ${res_body}=    Convert To String    ${response.content}
    Should Contain      ${res_body}    Registration successfully
    Should Contain      ${res_body}    Faysal


    ${student_email}=     Get Value From Json     ${response.json()}   ["student information"].email
    ${emailFromList}=   Get From List    ${student_email}   0
    Should Be Equal    ${emailFromList}     faysal001@gmail.com


TC2: View the list of registered students along with their details (GET)
    Create Session    mysession     ${base_url}
    ${response}=    GET On Session    mysession    ${relative_uri_tc2}

    # Prints
    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${contentType}=   Get From Dictionary   ${response.headers}   Content-Type
    Should Be Equal    ${contentType}    application/json
    ${res_body}=    Convert To String    ${response.content}
    Should Contain      ${res_body}    List of all students.
    Should Contain      ${res_body}    Faysal      Sarder


    ${student_mobileNum}=     Get Value From Json     ${response.json()}   $.List[1].mobile_no
    ${mobileNumFromList}=   Get From List    ${student_mobileNum}   0
    Should Be Equal    ${mobileNumFromList}     01797651089

#    ${json_object}=    To Json    ${response.content}
#    ${student_mobileNum}=  Get Value From Json    ${json_object}       $.List[0].mobile_no
#    ${user_Nm}=  Convert To List     ${student_mobileNum}
#    List Should Contain Value    ${user_Nm}    01534012340


TC3: Return the detail's of a student by student id (GET)
    Create Session    mysession     ${base_url}
    ${response}=    GET On Session    mysession    ${relative_uri_tc3}${query_param_tc3}${param}

    # Prints
    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${header_elements}=   Get From Dictionary   ${response.headers}   Content-Type      X-Powered-By
    Should Be Equal    ${header_elements}    application/json       PHP/8.2.0

    ${mobile_number}=       Get Value From Json     ${response.json()}  ["Student details"][0].mobile_no    ["Student details"][0].l_name
    ${mobileNumr_fromList}=     Get From List    ${mobile_number}     0
    Should Be Equal    ${mobileNumr_fromList}   01797651089     Faysal      true

TC4: Update student information by student id (PUT)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary       f_name=Faysal   l_name=Ahmed   gender=male     age=24       mobile_no=01521493889      email=ahmed123@gmail.com   password=12aBc#12
    &{headers}=     Create Dictionary    Content-Type=application/json      Cache-Control=no-cache, private
    ${response}=    PUT On Session    mySession     ${relative_uri_tc4}${param}     json=&{body}    headers=&{headers}

    #  Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${contentType}=   Get From Dictionary   ${response.headers}   Content-Type
    Should Be Equal    ${contentType}    application/json
    ${res_body}=    Convert To String    ${response.content}
    Should Contain      ${res_body}    Student info. has been updated successfully


TC5: Update specific information of a student by student id using patch method (PATCH)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary       f_name=Faysal   l_name=Sarder   age=23
    &{headers}=     Create Dictionary    Content-Type=application/json      Cache-Control=no-cache, private
    ${response}=    PATCH On Session    mySession     ${relative_uri_tc5}${param}     json=&{body}    headers=&{headers}

    #  Validations
    Should Be Equal As Strings    ${response.status_code}   202
    ${contentType}=   Get From Dictionary   ${response.headers}   Content-Type
    Should Be Equal    ${contentType}    application/json
    ${resp_body}=    Convert To String    ${response.content}
    ${response_body}=  Convert To String     ${resp_body}
    Should Contain     ${response_body}    Student info. has been updated successfully
    Should Contain     ${response_body}     true


TC6: Delete a particular student anlong with activities by student id (DELETE)
    Create Session    my_session     ${base_url}
    ${response}=    DELETE On Session   my_session  ${relative_uri_tc6}${param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Host    Connection
    Should Be Equal     ${header_elements}      127.0.0.1:8000      close

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   Student id - ${param} has been deleted successfully.


TC7: Assign a new Instructor with valid credentials (POST REQUEST METHOD)
    Create Session    mySession     ${base_url}
    &{payload}=    Create Dictionary    insf_name=Nabil    insl_name=Islam     ins_gender=male      ins_age=29     ins_mobile_no=01731231456       ins_email=nabil@gmail.com       ins_password=123123123
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    mySession    ${relative_tc7}     json=${payload}       headers=${contentType}

    # print the status code, header elements and response payloads
    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}


    # Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${ins_mobileNo}=   Get Value From Json    ${response.json()}   ["instructor information"].ins_mobile_no
    ${capture_mblNo}=   Get From List    ${ins_mobileNo}    0
    Should Be Equal    ${capture_mblNo}     01731231456

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Assigned Instructor successfully


# Automation Test Cases for Instructor API
TC8: Views of all registered Instructors along with their details (GET REQUEST METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession     ${relative_tc8}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    ${sts_code}=   Convert To String    ${resp.status_code}
    Should Be Equal    ${sts_code}   200

    ${inst_email}=   Get Value From Json     ${resp.json()}     $.List[1].ins_email
    ${ins_emailAddr}=   Get From List    ${inst_email}  0
    Should Be Equal    ${ins_emailAddr}     nabil@gmail.com

    ${header}=  Get From Dictionary    ${resp.headers}  Host
    ${xPowerBy}=  Get From Dictionary    ${resp.headers}   X-Powered-By
    Should Be Equal As Strings       ${header}        127.0.0.1:8000
    Should Be Equal    ${xPowerBy}      PHP/8.2.0


TC9: Return the detail's of an Instructor by instructor id (GET REQUEST METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession     ${relative_tc9}${relative_tc10}${ins_param}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    Should Be Equal As Strings    ${resp.status_code}   200
    ${contentType}=     Get From Dictionary    ${resp.headers}       Content-Type
    Should Be Equal As Strings    ${contentType}    application/json

    ${body_elements}=    To Json    ${resp.content}
    ${message}=   Get Value From Json    ${body_elements}     $.Message
    ${capt_message}=    Convert To List    ${message}
    List Should Contain Value     ${capt_message}     Successful. Instructor ID: ${ins_param}.


TC10: Update Instructor information by Instructor id (PUT REQUEST METHOD)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary    insf_name=Nabil    insl_name=Islam     ins_gender=male      ins_age=30     ins_mobile_no=01731231466       ins_email=nabilkkhan@gmail.com      ins_password=123123
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    mySession    ${relative_tc11}${ins_param}     json=${body}       headers=${contentType}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Instructor Info. has been updated successfully


TC11: Update specific records of an Instructor by Instructor id using patch method (PATCH REQUEST METHOD)
    Create Session    mySession     ${base_url}
    &{request_payload}=    Create Dictionary    insf_name=Tarique    insl_name=Nabil      ins_age=32
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    PATCH On Session    mySession    ${relative_tc12}${ins_param}     json=${request_payload}       headers=${contentType}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   202
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Instructor info. has been updated partially.
    Should Contain    ${message}    ${ins_param}


TC12: Delete Instructors by their id (DELETE REQUEST METHOD)
    Create Session    my_session     ${base_url}
    ${response}=    DELETE On Session   my_session  ${relative_tc13}${ins_param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Host    Connection
    Should Be Equal     ${header_elements}      127.0.0.1:8000      close

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   Instrutor -${ins_param} info. has been deleted successfully.


# Automation Test Cases for Course API
TC13: Offer courses (POST HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    course_name=API Testing Course 01      course_hours=8 Hours    dept=CSE
    ${header}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session     mysession    ${relative_uri_14}      json=${body}    headers=${header}


    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

     # Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${courseName}=   Get Value From Json    ${response.json()}   $["course information"].course_name
    ${capture_courseNm}=   Get From List    ${courseName}    0
    Should Be Equal    ${capture_courseNm}     API Testing Course 01

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      ${capture_courseNm} course has been assigned successful.


TC14: View the available offered courses (GET REQUEST METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession     ${relative_uri_15}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    ${sts_code}=   Convert To String    ${resp.status_code}
    Should Be Equal    ${sts_code}   200

    ${courseNm}=   Get Value From Json     ${resp.json()}     $[1].course_name
    ${course_name}=   Get From List    ${courseNm}  0
    Should Be Equal    ${course_name}     API Testing Course 01

    ${header}=  Get From Dictionary    ${resp.headers}  Host
    ${contentType}=  Get From Dictionary    ${resp.headers}   Content-Type
    Should Be Equal As Strings       ${header}        127.0.0.1:8000
    Should Be Equal    ${contentType}      application/json


TC18: Assign subjects to a particular course (POST HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    sub_name=Robot Framework      course_id=${course_param}                        #--------------------------------
    ${header}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session     mysession    ${relative_uri_20}      json=${body}    headers=${header}


    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

     # Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${subjName}=   Get Value From Json    ${response.json()}   $["Subject information"].sub_name
    ${capture_subjectNm}=   Get From List    ${subjName}    0
    Should Be Equal    ${capture_subjectNm}     Robot Framework

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Subject ${capture_subjectNm} has been assigned successful.

    ${courseName}=   Get Value From Json    ${response.json()}   $["Course information"].course_name
    ${capture_courseNm}=   Get From List    ${courseName}    0
    Should Be Equal    ${capture_courseNm}     API Testing Course 01



TC15: Search course & return the detail's course by id (GET HTTP METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession    ${relative_uri_16}${relative_uri_17}${course_param}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    Should Be Equal As Strings    ${resp.status_code}   200
    ${contentType}=     Get From Dictionary    ${resp.headers}       Content-Type
    Should Be Equal As Strings    ${contentType}    application/json

    ${courseName}=   Get Value From Json    ${resp.json()}   $["Course Details"][0].course_name
    ${capture_courseNm}=   Get From List    ${courseName}    0
    Should Be Equal    ${capture_courseNm}     API Testing Course 01

#    ${subName}=   Get Value From Json    ${resp.json()}   $["Subject offers under course"].1.sub_name
#    ${capture_subjectNm}=   Get From List    ${subName}    1
#    Should Be Equal    ${capture_subjectNm}     Robot Framework                  #----------------------------------------------------------------

TC16: Update the existing course after course offer (POST HTTP REQUEST)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary    course_name=API Testing Autmation 01      course_hours=10 Hours    dept=CSE
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    mySession    ${relative_uri_18}${course_param}     json=${body}       headers=${contentType}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Course details updated successfully
    Should Contain     ${message}       ${course_param}


TC17: Delete courses by their id (DELETE HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${response}=    DELETE On Session   mysession   ${relative_uri_19}${course_param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Host
    Should Be Equal     ${header_elements}      127.0.0.1:8000

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   Course - ${course_param} details has been deleted successfully.






# Automation Test Cases for Subjects API
TC18: Assign subjects to a particular course (POST HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    sub_name=Robot Framework      course_id=1                          #--------------------------------
    ${header}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session     mysession    ${relative_uri_20}      json=${body}    headers=${header}


    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

     # Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${subjName}=   Get Value From Json    ${response.json()}   $["Subject information"].sub_name
    ${capture_subjectNm}=   Get From List    ${subjName}    0
    Should Be Equal    ${capture_subjectNm}     Robot Framework

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Subject ${capture_subjectNm} has been assigned successful.

    ${courseName}=   Get Value From Json    ${response.json()}   $["Course information"].course_name
    ${capture_courseNm}=   Get From List    ${courseName}    0
    Should Be Equal    ${capture_courseNm}     SQA Course 01


TC19: View all offered subjects (GET REQUEST METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession     ${relative_uri_21}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    ${sts_code}=   Convert To String    ${resp.status_code}
    Should Be Equal    ${sts_code}   200

    ${subjNm}=   Get Value From Json     ${resp.json()}     $[1].sub_name
    ${subject_name}=   Get From List    ${subjNm}  0
    Should Be Equal    ${subject_name}     Robot Framework

    ${c_id}=   Get Value From Json     ${resp.json()}     $[1].course_id
    ${cour_id}=   Get From List    ${c_id}  0
    Should Be Equal As Strings    ${cour_id}     1

    ${contentType}=  Get From Dictionary    ${resp.headers}   Content-Type
    Should Be Equal    ${contentType}      application/json



TC20: Find number of offered subjects under a particular course and returns the associated details of subjects by course id (GET HTTP METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession    ${relative_uri_22}${relative_uri_23}1

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    Should Be Equal As Strings    ${resp.status_code}   200
    ${contentType}=     Get From Dictionary    ${resp.headers}       Content-Type
    Should Be Equal As Strings    ${contentType}    application/json

    ${message}=   Convert To String    ${resp.content}
    Should Contain Any      ${message}      Offered subjects under course id: 1

    ${courseid}=   Get Value From Json    ${resp.json()}   $["Search results"][0].course_id
    ${capture_courseID}=   Get From List    ${courseid}    0
    Should Be Equal As Strings   ${capture_courseID}     1                       #---------------------------------------

    ${subName}=   Get Value From Json    ${resp.json()}   $["Search results"][0].sub_name
    ${capture_subjectNm}=   Get From List    ${subName}    0
    Should Be Equal    ${capture_subjectNm}     REST Assured

TC21: Update the subject information (PUT HTTP REQUEST)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary    sub_name=API Testing with postman      course_id=1         #--------------------------------
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    mySession    ${relative_uri_24}${subj_param}     json=${body}       headers=${contentType}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Successfully Updated.
    Should Contain     ${message}       ${subj_param}


TC22: Delete subjects by their id (DELETE HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${response}=    DELETE On Session   mysession   ${relative_uri_25}3

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Content-Type
    Should Be Equal     ${header_elements}      application/json

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   3 nd Subject has been deleted successfully.




# Automation Test Cases for class schedule API
TC23: Post class schedule along with associated details (POST HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    course_id=1       ins_id=1     sub_id=1    stu_id=1      day=Sunday      time_start=2023-02-04 03:42:00    time_end=2023-02-04 05:00:00
    ${header}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session     mysession    ${relative_uri_26}      json=${body}    headers=${header}


    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

     # Validations
    Should Be Equal As Strings    ${response.status_code}   201
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${s_day}=   Get Value From Json    ${response.json()}   $["Schedules information"].day
    ${capture_s_day}=   Get From List    ${s_day}    0
    Should Be Equal    ${capture_s_day}     Sunday



TC24: View all releases schedule and returns course, registered students and Instructor info (GET REQUEST METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession     ${relative_uri_27}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    ${sts_code}=   Convert To String    ${resp.status_code}
    Should Be Equal    ${sts_code}   200

    ${day}=   Get Value From Json     ${resp.json()}     $[0].day
    ${capt_day}=   Get From List    ${day}  0
    Should Be Equal    ${capt_day}     Sunday

    ${c_id}=   Get Value From Json     ${resp.json()}     $[0].course_id
    ${cour_id}=   Get From List    ${c_id}  0
    Should Be Equal As Strings    ${cour_id}     1              #-----------------------------

    ${contentType}=  Get From Dictionary    ${resp.headers}   Content-Type
    Should Be Equal As Strings      ${contentType}      application/json



TC25: Fetch schedule info by subject id (GET HTTP METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession    ${relative_uri_28}${relative_uri_29}${schedule_param}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    Should Be Equal As Strings    ${resp.status_code}   200
    ${contentType}=     Get From Dictionary    ${resp.headers}       Content-Type
    Should Be Equal As Strings    ${contentType}    application/json

    ${message}=   Convert To String    ${resp.content}
    Should Contain Any      ${message}      information of schedule id-${schedule_param}.

    ${courseNM}=   Get Value From Json    ${resp.json()}   $["Course information"]["Course details"].course_name
    ${capture_courseNm}=   Get From List    ${courseNM}    0
    Should Be Equal As Strings   ${capture_courseNm}     SQA Course 01

    ${day}=   Get Value From Json    ${resp.json()}     $["Schduler information"].day
    ${capture_day}=   Get From List    ${day}    0
    Should Be Equal    ${capture_day}     Sunday

    ${subjectNM}=   Get Value From Json    ${resp.json()}   $["Course information"]["Subject details"].sub_name
    ${capture_subNm}=   Get From List    ${subjectNM}    0
    Should Be Equal As Strings   ${capture_subNm}     REST Assured

    ${ins_name}=   Get Value From Json    ${resp.json()}   $["Course information"]["Instructor details"][0].insf_name
    ${capture_ins_nm}=   Get From List    ${ins_name}    0
    Should Be Equal As Strings   ${capture_ins_nm}     Tanvir

TC26: Update information of class schedule (PUT HTTP REQUEST)
    Create Session    mySession     ${base_url}
    &{body}=    Create Dictionary    course_id=1    ins_id=1     sub_id=1    stu_id=1      day=Friday      time_start=2023-02-06 02:00:02   time_end=2023-02-06 04:00:03
    &{contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    mySession    ${relative_uri_30}${schedule_param}     json=${body}       headers=${contentType}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${cont_type}=   Get From Dictionary     ${response.headers}     Content-Type
    Should Be Equal    ${cont_type}     application/json

    ${message}=   Convert To String    ${response.content}
    Should Contain Any      ${message}      Schedule ${schedule_param} updated successfully.


TC27: Cancel class schedule by schedule id (DELETE HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${response}=    DELETE On Session   mysession   ${relative_uri_31}${schedule_param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Content-Type
    Should Be Equal     ${header_elements}      application/json

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   Scheduler ${schedule_param} information has been deleted successfully.






