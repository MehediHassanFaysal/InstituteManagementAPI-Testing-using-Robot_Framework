*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${base_url}     http://127.0.0.1:8000
${relative_uri_20}     /api/assign_subject
${relative_uri_21}     /api/available_subjects
${relative_uri_22}     /api/totalSubjects_by_cid
${relative_uri_23}     ?course_id=
${subj_param}         3
${relative_uri_24}      /api/update_subject_info/
${relative_uri_25}      /api/delete_subject/


*** Test Cases ***
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
    Should Be Equal    ${capture_courseNm}     API Testing Autmation 01


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

    ${subjNm}=   Get Value From Json     ${resp.json()}     $[0].sub_name
    ${subject_name}=   Get From List    ${subjNm}  0
    Should Be Equal    ${subject_name}     html 5

    ${c_id}=   Get Value From Json     ${resp.json()}     $[0].course_id
    ${cour_id}=   Get From List    ${c_id}  0
    Should Be Equal As Strings    ${cour_id}     ${subj_param}

    ${contentType}=  Get From Dictionary    ${resp.headers}   Content-Type
    Should Be Equal    ${contentType}      application/json



TC20: Find number of offered subjects under a particular course and returns the associated details of subjects by course id (GET HTTP METHOD)
    Create Session    mysession     ${base_url}
    ${resp}=    GET On Session    mysession    ${relative_uri_22}${relative_uri_23}${subj_param}

    # print the status code, header elements and response payloads
    Log To Console    ${resp.status_code}
    Log To Console    ${resp.headers}
    Log To Console    ${resp.content}

    # Validations
    Should Be Equal As Strings    ${resp.status_code}   200
    ${contentType}=     Get From Dictionary    ${resp.headers}       Content-Type
    Should Be Equal As Strings    ${contentType}    application/json

    ${message}=   Convert To String    ${resp.content}
    Should Contain Any      ${message}      Offered subjects under course id: ${subj_param}

    ${courseid}=   Get Value From Json    ${resp.json()}   $["Search results"][0].course_id
    ${capture_courseID}=   Get From List    ${courseid}    0
    Should Be Equal As Strings   ${capture_courseID}     1                       #---------------------------------------

    ${subName}=   Get Value From Json    ${resp.json()}   $["Search results"][0].sub_name
    ${capture_subjectNm}=   Get From List    ${subName}    0
    Should Be Equal    ${capture_subjectNm}     html 5

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
    ${response}=    DELETE On Session   mysession   ${relative_uri_25}${subj_param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200

    ${header_elements}=     Get From Dictionary    ${response.headers}      Content-Type
    Should Be Equal     ${header_elements}      application/json

    ${message}=       Get Value From Json     ${response.json()}  $.Message
    ${get_message}=     Get From List    ${message}     0
    Should Be Equal    ${get_message}   ${subj_param} nd Subject has been deleted successfully.





