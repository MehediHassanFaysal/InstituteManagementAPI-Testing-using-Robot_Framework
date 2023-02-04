*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${base_url}     http://127.0.0.1:8000
${relative_uri_14}     /api/assign_course
${relative_uri_15}     /api/available_courses

${relative_uri_16}     /api/specific_course
${relative_uri_17}      ?id=
${course_param}         2

${relative_uri_18}      /api/update_course_details/
${relative_uri_19}      /api/delete_course/


*** Test Cases ***
TC13: Offer courses (POST HTTP REQUEST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    course_name=API Testing Course 03      course_hours=8 Hours    dept=CSE
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
    Should Be Equal    ${capture_courseNm}     API Testing Course 03

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

    ${courseNm}=   Get Value From Json     ${resp.json()}     $[3].course_name
    ${course_name}=   Get From List    ${courseNm}  0
    Should Be Equal    ${course_name}     API Testing Course 03

    ${header}=  Get From Dictionary    ${resp.headers}  Host
    ${contentType}=  Get From Dictionary    ${resp.headers}   Content-Type
    Should Be Equal As Strings       ${header}        127.0.0.1:8000
    Should Be Equal    ${contentType}      application/json



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
    Should Be Equal    ${capture_courseNm}     Web Dev Course 1

    ${subName}=   Get Value From Json    ${resp.json()}   $["Subject offers under course"][0].sub_name
    ${capture_subjectNm}=   Get From List    ${subName}    0
    Should Be Equal    ${capture_subjectNm}     html 5

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

