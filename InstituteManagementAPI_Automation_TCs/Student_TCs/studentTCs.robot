*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary

*** Variables ***
${base_url}     http://127.0.0.1:8000
${relative_uri_tc1}     /api/student_register
${relative_uri_tc2}     /api/all_registered_students
${relative_uri_tc3}     /api/find/student
${query_param_tc3}      ?id=
${relative_uri_tc4}     /api/update_student_info/
${relative_uri_tc5}     /api/partially/update/student_info/
${relative_uri_tc6}     /api/delete_student/
${param}    1

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


    ${student_mobileNum}=     Get Value From Json     ${response.json()}   $.List[0].mobile_no
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


TC6: Delete a particular student along with activities by student id (DELETE)
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

