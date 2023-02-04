*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${base_url}=    http://127.0.0.1:8000
${relative_tc7}=    /api/instructor_regis
${relative_tc8}=    /api/all/registered/instructors
${relative_tc9}=    /api/find/instructor
${relative_tc10}=    ?id=
${ins_param}=    4
${relative_tc11}=    /api/update_instructor_info/
${relative_tc12}=    /api/partially/update/instructor_info/
${relative_tc13}=    /api/delete_instructor/


*** Test Cases ***
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




