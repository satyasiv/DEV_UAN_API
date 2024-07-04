
*** Settings ***
Library   RPA.Browser.Selenium
Library    Collections
Library    OperatingSystem
Library    String
Library    Process
Library    BuiltIn
Library    RPA.HTTP 
Library    RPA.JSON
Library    DateTime
Library    DatabaseLibrary
Library    RPA.Email.ImapSmtp

*** Variables *** 
${username}          ${EMPTY}          
${password}          ${EMPTY}   
${aadhaar_number}    ${EMPTY}    
${uan_status}        ${EMPTY}
${uan_num}           ${EMPTY}
${remarks}           ${EMPTY}
${user_uuid}         ${EMPTY}
${created_by}        ${EMPTY}
${time}              ${EMPTY}
${validated_data}    ${EMPTY}
${entity_status}     ${EMPTY}
${uan_clean}         ${EMPTY}    
${START_TIME}        ${EMPTY}  
${error_data}        ${EMPTY} 
${error}            ${EMPTY} 
${robot_path}        /home/buzzadmin/Documents/Django/project/tasks.robot
${aaa_str}                
${django_url}                 http://127.0.0.1:8000/
${insert_user_data}           ${django_url}output_data/          #user output
${current_index}     0
${BASE_URL}                    http://localhost:8000


#email
${EMAIL_USERNAME}   your_username@example.com
${EMAIL_PASSWORD}   your_password
${EMAIL_SERVER}     smtp.example.com
${EMAIL_PORT}       587
${EMAIL_SENDER}     sender@example.com
${TAGGED_EMAIL}     recipient@example.com
${SUBJECT}          Error Notification

#db
${DB_TYPE}    psycopg2
${DB_NAME}    uan_individual
${DB_USER}    postgres
${DB_PASS}    flexydial
${DB_HOST}    127.0.0.1
${DB_PORT}    5432


*** Keywords ***
Click Element When Visible
    [Arguments]    ${PreLocator}      ${Elementtype}    ${PostLocator}
    Wait Until Element Is Visible     ${PreLocator}   timeout=120s    error=${Elementtype} not visible within 2m
    Click Element     ${PreLocator}
    Wait Until Element Is Visible    ${PostLocator}    timeout=30s    error= unable to navigate to next page
    Log    Successfully Clicked on     ${Elementtype}
Open EPF India Website
    Open Browser   https://www.epfindia.gov.in/site_en/index.php#      Chrome     options=add_experimental_option("detach", True) 
    # ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method    ${options}    add_argument    headless
    # Open Browser    https://www.epfindia.gov.in/site_en/index.php#    Chrome    options=${options}
    Wait Until Element Is Visible    xpath://*[@id="ecr_panel_1"]    timeout=30s     error=Unbale to launch EPF website..    
Click ECR/Returns/Payment Button
    Click Element        xpath://*[@id="ecr_panel_1"]
    Switch Window        EPFO: Home     timeout=30s
    Maximize Browser Window
    Wait Until Element Is Visible   //button[@id="btnCloseModal"]     timeout=30s     error= Unable to find Alert Popup..
Accept Popup
    Click Button   //button[@id="btnCloseModal"]  
    Log    Opened EPFO login page   
Enter Username and Password
    Connect To Database    ${DB_TYPE}    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    ${query_result}=    Query    SELECT e_username, e_password FROM bot_credentials
    Log    ${query_result}
    ${credentials}=  Set Variable   ${query_result}[0]
    ${username} =   Set Variable  ${credentials}[0]
    ${password} =   Set Variable  ${credentials}[1]
    Log    ${password}
    Wait Until Element Is Visible   xpath://input[@id="username1"]     timeout=30s     error=Unable to find username input
    Input Text    xpath://input[@id="username1"]     ${username}       
    Input Text    xpath://input[@id="password"]     ${password}                
    Log    Entered username and password   
Click Signin Button
    Wait Until Element Is Visible     //button[@value="Submit"]  timeout=30s
    Click Button        //button[@value="Submit"]
    Sleep    2s
click register individual
    Wait Until Element Is Visible     //*[contains(@class, 'dropdown-toggle') and contains(text(), 'Member')]     timeout=30s
    Click Element   //*[contains(@class, 'dropdown-toggle') and contains(text(), 'Member')]   
    Wait Until Element Is Visible    //ul[@class='dropdown-menu m1']//a[text()='REGISTER-INDIVIDUAL']    timeout=30s  
    Click Element   //ul[@class='dropdown-menu m1']//a[text()='REGISTER-INDIVIDUAL']         
    

fill and submit form for every no_uan 
        [Arguments]           ${member_data}     ${uuid}     
        Sleep    2s
        ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
        Wait Until Element Is Visible    //input[@id='memberName']   timeout=30s           error=not found             #name
        Input Text    //input[@id='memberName']      ${member_data['member_name']}
        Run Keyword If    '${member_data['gender']}' == 'F' and '${member_data['marital_status']}' == 'Married'
        ...   Click Element    //select[@id="salutation"]/option[text()="Mrs."]
        ...  ELSE IF    '${member_data['gender']}' == 'F' and '${member_data['marital_status']}' == 'Unmarried'  
        ...    Click Element    //select[@id="salutation"]/option[text()="Ms."]
        ...  ELSE
        ...    Click Element    //select[@id="salutation"]/option[text()="Mr."]
        
        ${gender}=    Set Variable    ${member_data['gender']} 
        ${uppercase}=    Convert To Upper Case    ${gender} 
        ${uppercase}=    Get Substring   ${gender}   0    1
        Wait Until Element Is Visible    //input[@type='radio'][@value='${uppercase}']    timeout=30s                     #gender
        Execute JavaScript    document.querySelector("input[type='radio'][value='${uppercase}']").click()

        ${date_without_time}    Set Variable     ${member_data['date_of_birth']}                           #dob
        Log    ${date_without_time} 
        Wait Until Element Is Visible    //input[@id='dob']        timeout=30s               error=not found
        Input Text        //input[@id='dob']     ${date_without_time}
        Sleep   2s

        ${date}    Set Variable     ${member_data['date_of_joining']}                                         #doj
        Wait Until Element Is Visible   //input[@id="doj"]                 timeout=30s    error=not found 
        Input Text    //input[@id="doj"]    ${date}
        Sleep    6s

        Wait Until Element Is Visible    //input[@id="wages"]             timeout=30s        error=not found         #Monthly EPF Wages as on Joining
        Input Text    //input[@id="wages"]      ${member_data['wages_as_on_joining']}

        ${Father's/Husband's Name}=    Set Variable     ${member_data['father_husband_name']}                  #husband/father
        Wait Until Element Is Visible     //input[@id="fatherHusbandName"]         timeout=30s        error=not found
        Input Text   //input[@id="fatherHusbandName"]     ${Father's/Husband's Name}

        ${Status}=    Create Dictionary    Single=UnMarried    None=UnMarried    UnMarried=UnMarried    Unmarried=UnMarried    Married=Married    married=Married
        ${marital_status}=    Set Variable         ${member_data['marital_status']}                          #martial status
        ${marital_status}=  Get From Dictionary    ${Status}    ${marital_status}
        ${first_letter}=    Get Substring    ${marital_status}    0    1
        ${uppercase_first_letter}=    Convert To Upper Case    ${first_letter}


        Wait Until Element Is Visible     //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']     timeout=30s
        Click Element    //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']
        Log     ${uppercase_first_letter}

        ${Relationship}=    Set Variable       ${member_data['relationship_with_member']}                      #relation
        ${first}=    Get Substring    ${Relationship}    0    1
        ${uppercase_first}=    Convert To Upper Case    ${first}
        Wait Until Element Is Visible    //select[@id="relation"]/option[@value='${uppercase_first}']        timeout=30s
        Click Element    //select[@id="relation"]/option[@value='${uppercase_first}']

        #KYC  DETAILS
        Wait Until Element Is Visible   //input[@id="chkDocTypeId_1"]       timeout=50s
        Click Element       //input[@id="chkDocTypeId_1"]                              #checkbox
        Sleep    1s
        ${Document_number}=    Set Variable          ${member_data['aadhaar_number']} 
        Wait Until Element Is Visible     //input[@id="docNo1"]         timeout=30s                        #aadhaar number
        Input Text     //input[@id="docNo1"]       ${Document_number}
        ${Document_name}=  Set Variable       ${member_data['name_as_on_aadhaar']}                   #aadhaar name
        Wait Until Element Is Visible    //input[@id="nameOnDoc1"]     timeout=30s  
        Input Text    //input[@id="nameOnDoc1"]      ${Document_name}
        Sleep   1s
        #TICKBUTTON
        Wait Until Element Is Visible      //input[@id="aadhaarConsentChkBox"]     timeout=120s       #tickbutton
        Click Element     //input[@id="aadhaarConsentChkBox"] 
        Sleep     1s
        Wait Until Element Is Visible       //div[@id="memreg2"]/input[@type="submit"]   timeout=200s       #savebutton
        Click Element      //div[@id="memreg2"]/input[@type="submit"]  
        # Sleep    10s
        #handle alerts
        ${alert_visible_1}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=120s
        Run Keyword If    '${alert_visible_1}' == 'True'    Log    First alert handled successfully
        Sleep    2s
        ${alert_visible_2}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=30s
        Run Keyword If    '${alert_visible_2}' == 'True'    Log    Second alert handled successfully
        Sleep    2s
        #error
        ${element_exists}    Run Keyword And Return Status    Element Should Be Visible     //div[@id="kycDetailsDiv"]/div/div[4]/div/div         timeout=200s
        ${error_text}=     Run Keyword If    ${element_exists}     Get Text    //div[@id="kycDetailsDiv"]/div/div[4]/div/div       
        Log    ${error_text}
        #take the uan num if present
        # : conditon 
        ${contains_colon}=    Run Keyword And Return Status    Should Contain   ${error_text}    :
        IF  '${contains_colon}' == 'True' 
            ${uan_num}=  Split String  ${error_text}  separator=:
            ${uan} =  Set Variable    ${uan_num}[1] 
            ${uan_clean}=    Replace String    ${uan}    .    ${EMPTY}
            ${uan_clean}    Replace String    ${uan_clean}    ${SPACE}    ${EMPTY}
            ${text}=    Set Variable      ${uan_num}[0]  
            yes button process      ${uuid}    ${uan_clean}      ${member_data}   ${START_TIME}     
        ELSE IF    '${error_text}' == 'None'
            ${uan}=    Set Variable    None 
            ${error_text}=    Set Variable     Updated but not reflecting in the table
            ${entity_status}=   Set Variable  approval pending
             ${uan_status} =    Set Variable    Newly added
            Log   ${START_TIME}
            Post User Data    ${uan_status}    ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}
        ELSE 
            ${uan}=    Set Variable    None 
            ${uan_status} =    Set Variable    None
            Log    ${error_text}
            ${entity_status}=   Set Variable   creation pending
            Log     ${START_TIME}
            ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
            ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
            Log    Total seconds elapsed: ${SECONDS_ELAPSED}
            ${time}=   Set Variable     ${SECONDS_ELAPSED}
            ${employee_id}=    Set Variable     ${member_data['employee_id']} 
            ${aadhaar_number}=    Set Variable    ${member_data['aadhaar_number']} 
            ${name} =     Set Variable    ${member_data['member_name']}
            ${uan_num} =    Set Variable   ${uan}
            ${remarks}=    Set Variable  Error:${error_text}
            ${data}=    Create Dictionary    employee_id=${employee_id}     aadhaar_number=${aadhaar_number}    name=${name}   uan_status=${uan_status}    uan_num=${uan_num}    remarks=${remarks}     entity_status=${entity_status}    user_uuid=${uuid}    time=${time}
            RPA.HTTP.Create Session    UserSession   ${BASE_URL} 
            Log    ${data}
            ${headers}=    Create Dictionary    Content-Type=application/json
            Log    ${headers}
            ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
            Log    ${response}
            Sleep    5s





            Post User Data    ${uan_status}    ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}      
            #unselect the button 
            Wait Until Element Is Visible   //*[@id="chkDocTypeId_1"]       timeout=30s      error= unslelect check box
            Unselect Checkbox  //*[@id="chkDocTypeId_1"]
        END
        Sleep    1s

yes button process
    [Arguments]    ${uuid}    ${uan_clean}      ${member_data}   ${START_TIME}      
    Log    ${uan_clean}
    Log     ${member_data}  
    Log     ${uuid} 
    Sleep    2s 
    ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
    Log       ${START_TIME}
    #yes button
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='Y']
    Wait Until Element Is Visible    ${locator}          timeout= 120s
    Execute JavaScript    document.getElementById('previousEmployementYes').click();
    Sleep    5s

    ${uan_status}=    Run Keyword If    '${uan_clean}' != ''    Set Variable     Newly created     ELSE    Set Variable     Already exist
    Wait Until Element Is Visible  //input[@id="uan"]    timeout=30s
    
     #uan_num condition --->> 
    ${uan}=    Run Keyword If    '${uan_clean}' != ''    Set Variable    ${uan_clean}    ELSE    Set Variable     ${member_data['Universal_Account']} 
    Wait Until Element Is Visible    //input[@id="uan"]    timeout=80s
    ${uan_enter}=    Input Text    //input[@id="uan"]     ${uan}

    #dob
    ${date_without_time}=    Set Variable        ${member_data['date_of_birth']}                       
    Log    ${date_without_time} 
    Wait Until Element Is Visible   //input[@id="dobVerify"]               timeout=30s        
    Input Text         //input[@id="dobVerify"]       ${date_without_time} 
    Sleep     2s
    #name
    ${Name}=      Set Variable        ${member_data['name_as_on_aadhaar']}                                   
    Wait Until Element Is Visible     //input[@id="nameVerify"]       timeout=30s                  
    Input Text    //input[@id="nameVerify"]    ${Name}
    #aadhar number
    ${AADHAAR}=   Set Variable         ${member_data['aadhaar_number']}                             
    Wait Until Element Is Visible  //input[@id="aadharVerify"]
    Input Text    //input[@id="aadharVerify"]     ${AADHAAR}
    # Sleep     10s
    ${value}=    Get Value    //input[@id="uan"]
    Run Keyword If    '${value}' == ''     ${uan_enter}
    ...    ELSE    Log    Input field is not empty
    
    #TICK BUTTON
    Wait Until Element Is Visible    //input[@id="aadhaarConsentChkBox"]   timeout=30s       error=not found      #tickbox
    Click Element   //input[@id="aadhaarConsentChkBox"] 
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]    timeout=300s                error=not found       #verify button   
    Click Element     //input[@value="Verify"]
    Sleep    20s
    #geting the text 
    Wait Until Element Is Visible    //div[@role="alert"]        timeout=400s               
    ${error_message}=    Get Text    //div[@role="alert"]
    ${error} =    Strip String     ${error_message} 
    Log   ${error} 
    Sleep  2s
    IF    '${error}' == 'Member name mismatch.' 
        Member name mismatch for no    ${error}    ${member_data}    ${uuid}    ${uan}      ${START_TIME}  ${uan_status} 
    ELSE IF  '${error}' == 'Member name mismatch. Member DOB mismatch.'   
        Member name mismatch for no      ${error}    ${member_data}   ${uuid}    ${uan}     ${START_TIME}  ${uan_status} 
    ELSE IF      '${error}' == 'Member DOB mismatch.' 
        Member name mismatch for no       ${error}    ${member_data}    ${uuid}    ${uan}    ${START_TIME}  ${uan_status} 
    ELSE IF   '${error}' == 'Member details matched'
        Member details matched for no     ${error}    ${member_data}    ${uuid}    ${uan}     ${START_TIME}  ${uan_status} 
    ELSE
       ${error_text}=  Set Variable   ${error} 
    END
    [Return]    ${uan}    ${error_text}
    Post User Data   ${uan_status}    ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}   




Member name mismatch for no    
    [Arguments]    ${error}    ${member_data}     ${uuid}    ${uan}      ${START_TIME}     ${uan_status} 
    #extract data from table name$dob
    Wait Until Element Is Visible    //*[@id="memberRegistration"]//table/tbody/tr/td/pre     timeout=30s  
    ${mismatch_name}=    Get Text    //*[@id="memberRegistration"]//table/tbody/tr/td/pre
    Sleep   1s
    Wait Until Element Is Visible  //*[@id="memberRegistration"]/div/table/tbody/tr[2]/td[2]    timeout=30s  
    ${mismatch_dob}=    Get Text   //*[@id="memberRegistration"]/div/table/tbody/tr[2]/td[2]
    #close
    Wait Until Element Is Visible  //button[contains(text(),'Close')]      timeout=30s 
    Click Element   //button[contains(text(),'Close')] 

    #insert into the fields 
    Wait Until Element Is Visible    //input[@id="nameVerify"]    timeout=30s 
    Input Text    //input[@id="nameVerify"]    ${mismatch_name}
   
    Wait Until Element Is Visible    //input[@id="dobVerify"]    timeout=30s 
    Input Text    //input[@id="dobVerify"]    ${mismatch_dob}
    Sleep   1s
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]      timeout=60s                      #verify button   
    Click Element     //input[@value="Verify"]
    Sleep    10s
    ${error_message}=    Get Text    //div[@role="alert"]
    ${error_text} =    Strip String     ${error_message} 
    Log    ${error_text}
    ${close_button_visible}=    Run Keyword And Return Status    Element Should Be Visible    //button[contains(text(),'Close')]    timeout=100s    
    ${ok_button_visible}=    Run Keyword And Return Status       Element Should Be Visible  //button[contains(text(),'Ok')] 
    Run Keyword If    ${close_button_visible}    Click Button     //button[contains(text(),'Close')] 
    Run Keyword If    ${ok_button_visible}    Click Button   //button[contains(text(),'Ok')] 
    IF    '${error_text}' == 'Member details matched' 
        member data match    ${member_data}   ${uuid}    ${uan}   ${START_TIME}    ${uan_status} 
    ELSE
        Log   ${error_text} 
    END
    [Return]      ${error_text}
    Post User Data   ${uan_status}   ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}

Member details matched for no   
    [Arguments]      ${error}    ${member_data}   ${uuid}    ${uan}     ${START_TIME}   ${uan_status} 
    Log    ${error} 
    Log      ${member_data} 
    Sleep   3s
    Wait Until Element Is Visible   //button[contains(text(),'Ok')]    timeout=200s
    Click Button   //button[contains(text(),'Ok')] 
    Sleep    1s
    IF   '${error}' == 'Member details matched' 
        member data match   ${member_data}   ${uuid}    ${uan}     ${START_TIME}    ${uan_status} 
    ELSE
        ${error_text}=    Set Variable    ${error}
    END
    [Return]    ${error_text}  
    Post User Data   ${uan_status}    ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}

member data match        
    [Arguments]    ${member_data}   ${uuid}    ${uan}    ${START_TIME}    ${uan_status} 
    Log   ${member_data}  
    Sleep    3s
    #doj
    Wait Until Element Is Visible      //input[@id="doj"]     timeout=80s
    Input Text    //input[@id="doj"]      ${member_data['date_of_joining']} 
    # Check and input wages as on joining
    Wait Until Element Is Visible    //input[@id="wages"]    timeout=80s
    Input Text    //input[@id="wages"]       ${member_data['wages_as_on_joining']}
    Sleep    1s
    # Check and click verify button
    ${tickbox_visible}=    Run Keyword And Return Status    Element Should Be Visible    //input[@type="submit"]      timeout=50s
    Run Keyword If    ${tickbox_visible}    Click Element     //input[@type="submit"]   
    Sleep    20s
    #handle alerts
    ${alert_visible_1}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=30s
    Run Keyword If    '${alert_visible_1}' == 'True'    Log    First alert handled successfully
    Sleep    4s
    ${alert_visible_2}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=30s
    Run Keyword If    '${alert_visible_2}' == 'True'    Log    Second alert handled successfully
    Sleep    30s
    #get if it visible 
    ${already_active}=    Run Keyword And Return Status    Element Should Be Visible      //*[@id="error"]   timeout=30s
    ${already_active}=    Run Keyword If    ${already_active}   Get Text     //*[@id="error"]
    Log     ${already_active}
    IF    '${already_active}' != 'None'
       ${already_active} =    Strip String      ${already_active}
    ELSE
       Log    ${already_active}
    END
    ${error_text}=    Set Variable     ${already_active}
    [Return]        ${error_text}  
    Post User Data     ${uan_status}    ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}


Post User Data            #database push data
    [Arguments]    ${uan_status}   ${uuid}    ${uan}    ${error_text}    ${member_data}    ${START_TIME}
    Log    ${START_TIME}
    Log     ${uuid}
    Log    ${uan}  
    Log    ${error_text} 
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}
    ${time}=   Set Variable     ${SECONDS_ELAPSED}
    ${employee_id}=    Set Variable     ${member_data['employee_id']} 
    ${aadhaar_number}=    Set Variable    ${member_data['aadhaar_number']} 
    ${name} =     Set Variable    ${member_data['member_name']}
    ${uan_num} =    Set Variable   ${uan}
    IF    '${error_text}' == 'None'
        ${remarks}=    Set Variable   sucess
    ELSE
        ${remarks}=    Set Variable  Error:${error_text}
    END
    ${entity_status}=   Set Variable  approval pending
    ${data}=    Create Dictionary    employee_id=${employee_id}     aadhaar_number=${aadhaar_number}    name=${name}   uan_status=${uan_status}    uan_num=${uan_num}    remarks=${remarks}     entity_status=${entity_status}    user_uuid=${uuid}    time=${time}
    RPA.HTTP.Create Session    UserSession   ${BASE_URL} 
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log    ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    Sleep    5s

Handle Alert And Click Radio Button
    [Arguments]    ${locator}                        #(yes/no)radian button purpose 
    Run Keyword And Ignore Error    Handle Alert
    Wait Until Element Is Visible    ${locator}    timeout=30s
    Click Element    ${locator}    
Calculate Time Difference
    [Arguments]    ${end_time}    ${start_time}
    ${start_seconds}=    Convert Time To Seconds    ${start_time}
    ${end_seconds}=    Convert Time To Seconds    ${end_time}
    ${difference}=    Evaluate    ${end_seconds} - ${start_seconds}
    [Return]    ${difference}
Convert Time To Seconds
    [Arguments]    ${time}
    ${time_parts}=    Split String    ${time}    separator=:
    ${hours}=    Convert To Integer    ${time_parts[0]}
    ${minutes}=    Convert To Integer    ${time_parts[1]}
    ${seconds}=    Convert To Integer    ${time_parts[2]}
    ${total_seconds}=    Evaluate    ${hours}*3600 + ${minutes}*60 + ${seconds}
    [Return]    ${total_seconds}

Extract All Member Data 
    [Arguments]     ${validated_data}   ${uan_clean}   ${START_TIME}
        Log    ${validated_data}   
        ${data_list}=    Evaluate    json.loads($validated_data)    json
        ${current_index}=    Get Length    ${data_list}
        ${total_index}=    Set Variable    ${current_index}
        ${all_member_data}=    Create List
        ${current_index}=    Set Variable    0
        FOR    ${member_data}    IN    @{data_list}
            TRY
                Log       ${member_data}
                ${member_info}=    Create Dictionary      Member Name=${member_data['member_name']}    Gender=${member_data['gender']}    Father/Husband Name=${member_data['father_husband_name']}    Relationship with Member=${member_data['relationship_with_member']}    Nationality=${member_data['nationality']}    Marital Status=${member_data['marital_status']}    Aadhaar Number=${member_data['aadhaar_number']}    Name as on Aadhaar=${member_data['name_as_on_aadhaar']}     Date of Birth=${member_data['date_of_birth']}    Date of Joining=${member_data['date_of_joining']}    Universal_Account=${member_data['Universal_Account']}    wages_as_on_joining=${member_data['wages_as_on_joining']}
                Log     ${member_info}   
                ${uuid}=    Evaluate    str(uuid.uuid4())
                Log    Generated UUID:${uuid}
                ${condition}=    Run Keyword And Continue On Failure        Run Keyword If    '${member_data['Universal_Account']}' != 'None'   yes button process   ${uuid}    ${uan_clean}      ${member_data}   ${START_TIME}   ELSE    fill and submit form for every no_uan    ${member_data}    ${uuid} 
                ${employee_id}=   Set Variable     ${member_data['employee_id']}
                Log      ${employee_id}
            EXCEPT    message
                Log     ${member_data} 
            FINALLY
                Log     ${member_data}  
                # send email        ${member_data}    ${remarks}  
            END     
        END
        Sleep    2s
    

send email
   [Arguments]    ${member_data}    ${remarks}  
    Log    ${member_data} 
    ${email_body}=    Set Variable    Hi, NOTE:this is the failed user_data "${member_data}" due to the reason of this   ${remarks}.
    # Send the email with the Excel file as attachment
    Authorize Smtp    ${EMAIL_USERNAME}    ${EMAIL_PASSWORD}    ${EMAIL_SERVER}    ${EMAIL_PORT}
    Send Message
    ...    ${EMAIL_SENDER}
    ...    ${TAGGED_EMAIL}
    ...    ${SUBJECT}
    ...    ${email_body}
    

*** Test Cases ***  
Automate EPFO Webpage
    Open EPF India Website
    Click ECR/Returns/Payment Button
    Accept Popup
    Enter Username and Password
    Click Signin Button
    click register individual
data 
   Extract All Member Data    ${validated_data}    ${uan_clean}   ${START_TIME}  
  
    
