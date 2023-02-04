*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${base_url}     http://127.0.0.1:8000
${relative_uri_26}     /api/post_schedule
${relative_uri_27}     /api/released_schedules
${relative_uri_28}     /api/schedule_by_sub_id
${relative_uri_29}     ?id=
${schedule_param}         2
${relative_uri_30}      /api/update_scheduler_info/
${relative_uri_31}      /api/delete_schedule/

*** Test Cases ***
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






