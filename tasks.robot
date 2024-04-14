*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    OperatingSystem
Library    String
Library    Process
Library    RPA.Desktop
Library    RPA.Robocorp.WorkItems
Library    RPA.Robocorp.Storage 
Library    RPA.Excel.Files
Library    Telnet
Library    XML
Library    RPA.Database
Library    RPA.JSON
Library    RPA.FileSystem
Library    BuiltIn
Library    RequestsLibrary   
Library      RPA.HTTP 

#Library    /home/buzzadmin/Documents/Django/project/app/views.py


*** Variables *** 
${username}          BUZZWORKS2012           
${password}          Bu$$2024Work$
${aadhaar_number}    ${EMPTY}    
${uan_status}        ${EMPTY}
${uan_num}           ${EMPTY}
${remarks}           ${EMPTY}
${user_uuid}         ${EMPTY}
${created_by}        ${EMPTY}
${robot_path}        /home/buzzadmin/Documents/Django/project/tasks.robot
${aaa_str}                
${django_url}             http://127.0.0.1:8000/
${insert_user_data}   ${django_url}api/insert_user_data/
${username}    admin
${password}    flexydial

*** Keywords ***
Click Element When Visible
    [Arguments]    ${PreLocator}      ${Elementtype}    ${PostLocator}
    Wait Until Element Is Visible     ${PreLocator}   timeout=120s    error=${Elementtype} not visible within 2m
    Click Element     ${PreLocator}
    Wait Until Element Is Visible    ${PostLocator}    timeout=30s    error= unable to navigate to next page
    Log    Successfully Clicked on     ${Elementtype}
Open EPF India Website
    Open Browser    https://www.epfindia.gov.in/site_en/index.php#      Chrome     options=add_experimental_option("detach", True) 
    # ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method    ${options}    add_argument    headless
    # Open Browser    https://www.epfindia.gov.in/site_en/index.php#    Chrome    options=${options}
    Wait Until Element Is Visible    xpath://*[@id="ecr_panel_1"]    timeout=30s     error=Unbale to launch EPF website..    
Click ECR/Returns/Payment Button
    Click Element        xpath://*[@id="ecr_panel_1"]
    Switch Window        EPFO: Home     timeout=30s
    Maximize Browser Window
    Wait Until Element Is Visible    xpath://*[@id="btnCloseModal"]    timeout=30s     error= Unable to find Alert Popup..
Accept Popup
    Click Button    xpath://*[@id="btnCloseModal"]  
    Log    Opened EPFO login page   
Enter Username and Password
    Wait Until Element Is Visible   xpath://*[@id="username"]    timeout=30s     error=Unable to find username input
    Input Text    xpath://*[@id="username"]     ${username}       
    Input Text    xpath://*[@id="password"]     ${password}                
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
    [Arguments]        ${data}
    ${initial}=    Set Variable          ${data['Mr/Mrs']}                                      #initial
    Wait Until Element Is Visible    //select[@id="salutation"]/option[text()="${initial}"]     timeout=30s     error=not found
    Click Element    //select[@id="salutation"]/option[text()="${initial}"]

    Wait Until Element Is Visible    //input[@id='memberName']   timeout=30s           error=not found             #name
    Input Text    //input[@id='memberName']      ${data['Member Name']} 

    ${gender}=    Set Variable     ${data['Gender']} 
    ${uppercase}=    Convert To Upper Case    ${gender} 
    Wait Until Element Is Visible    //input[@type='radio'][@value='${uppercase}']    timeout=30s                     #gender
    Execute JavaScript    document.querySelector("input[type='radio'][value='${uppercase}']").click()

    ${date_without_time}    Set Variable     ${data['Date of Birth']}                         #dob
    Log    ${date_without_time} 
    # ${date_without_time}    Evaluate    datetime.datetime.strptime('${date_without_time}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date_without_time} 
    Wait Until Element Is Visible    //input[@id='dob']        timeout=30s               error=not found
    Input Text        //input[@id='dob']     ${date_without_time}
    Sleep   2s

     ${date}    Set Variable    ${data['Date of Joining']}                                          #doj
    # ${date}    Evaluate    datetime.datetime.strptime('${date}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Wait Until Element Is Visible   //input[@id="doj"]                 timeout=30s
    Input Text    //input[@id="doj"]    ${date}
    Sleep    1s

    Wait Until Element Is Visible    //input[@id="wages"]             timeout=30s        error=not found         #Monthly EPF Wages as on Joining
    Input Text    //input[@id="wages"]      ${data['Wages as on Joining']}  

    ${Father's/Husband's Name}=    Set Variable      ${data['Father/Husband Name']}                  #husband/father
    Wait Until Element Is Visible     //input[@id="fatherHusbandName"]         timeout=30s        error=not found
    Input Text   //input[@id="fatherHusbandName"]     ${Father's/Husband's Name}

    ${marital_status}=    Set Variable          ${data['Marital Status']}                           #martial status
    ${first_letter}=    Get Substring    ${marital_status}    0    1
    ${uppercase_first_letter}=    Convert To Upper Case    ${first_letter}
    Wait Until Element Is Visible     //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']     timeout=30s
    Click Element    //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']
    Log     ${uppercase_first_letter}

    ${Relationship}=    Set Variable        ${data['Relationship with the Member']}                      #relation
    ${first}=    Get Substring    ${Relationship}    0    1
    ${uppercase_first}=    Convert To Upper Case    ${first}
    Wait Until Element Is Visible    //select[@id="relation"]/option[@value='${uppercase_first}']        timeout=30s
    Click Element    //select[@id="relation"]/option[@value='${uppercase_first}']
   

    #KYC  DETAILS
    Wait Until Element Is Visible   //*[@id="chkDocTypeId_1"]       timeout=30s
    Unselect Checkbox  //*[@id="chkDocTypeId_1"]
    Click Element    //*[@id="chkDocTypeId_1"]                                  #checkbox
    Sleep    1s
    ${Document_number}=    Set Variable           ${data['AADHAAR Number']}  
    Wait Until Element Is Visible     //*[@id="docNo1"]         timeout=30s                        #aadhaar number
    Input Text     //*[@id="docNo1"]       ${Document_number}
    ${Document_name}=  Set Variable        ${data['Name as on AADHAAR']}                   #aadhaar name
    Wait Until Element Is Visible    //*[@id="nameOnDoc1"]     timeout=30s  
    Input Text    //*[@id="nameOnDoc1"]     ${Document_name}
    Sleep   1s

    #TICKBUTTON
    Wait Until Element Is Visible      //*[@id="aadhaarConsentChkBox"]     timeout=30s       #tickbutton
    Click Element     //*[@id="aadhaarConsentChkBox"]
    Sleep     1s
    Wait Until Element Is Visible   //*[@id="memreg2"]/input     timeout=30s                    #save button    
    Click Element     //*[@id="memreg2"]/input
    Handle Alert
    Sleep  5s   
    # Exit if element is not visible
    ${element_exists}    Run Keyword And Return Status    Element Should Be Visible     xpath=//div[@class='error']         timeout=200s
    ${error_text}=     Run Keyword If    ${element_exists}     Get Text    xpath=//div[@class='error']        
    Log    ${error_text}
    ${aadhaar} =     Set Variable      ${data['AADHAAR Number']} 
    # : conditon 
    ${contains_colon}=    Run Keyword And Return Status    Should Contain   ${error_text}    :
    IF  '${contains_colon}' == 'True' 
        ${uan_num}=  Split String  ${error_text}  separator=:
        ${uan} =  Set Variable    ${uan_num}[1] 
        ${uan_clean}=    Replace String    ${uan}    .    ${EMPTY}
        ${text}=    Set Variable      ${uan_num}[0]   
        ${aadhaar_number}=  Set Variable    ${aadhaar} 
        ${uan_status}=  Set Variable   Newly Added
        ${uan_num}=    Set Variable     ${uan_clean}
        ${remarks}=    Set Variable   ${text}
    ELSE  
        ${aadhaar_number}=  Set Variable  ${aadhaar}   
        ${uan_status}=  Set Variable   Newly Added
        ${uan_num}=    Set Variable    None 
        ${remarks}=    Set Variable     ${error_text}    
    END
    ${data}=    Split To Key Value Pairs    ${aaa_str}
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${user_uuid}=    Get From Dictionary    ${data}    user_uuid
    ${created_by}=    Get From Dictionary    ${data}    created_by
    Log    User UUID: ${user_uuid}
    Log    Created By: ${created_by}
    ${data}=    Create Dictionary   aadhaar_number=${aadhaar_number}    uan_status=${uan_status}    uan_num=${uan_num}    remarks=${remarks}    user_uuid=${user_uuid}    created_by=${created_by}
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log     ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    # Should Be Equal As Strings    ${response.status_code}    201
    # Log    Response content: ${response.content}

Handle Alert And Click Radio Button
    [Arguments]  ${locator}                        #radian button purpose
    Run Keyword And Ignore Error    Handle Alert
    Wait Until Element Is Visible    ${locator}    timeout=30s
    Click Element    ${locator}

fill and submit form for every uan is_present
    [Arguments]           ${data}          
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='Y']
    Wait Until Element Is Visible    ${locator}          timeout= 120s
    Execute JavaScript    document.getElementById('previousEmployementYes').click();

    ${uan_number}=       Set Variable      ${data['Universal Account']}                    #uan                   
    Wait Until Element Is Visible    //input[@id="uan"]    timeout=80s
    Input Text    //input[@id="uan"]    ${uan_number}

    ${date_without_time}=    Set Variable       ${data['Date of Birth']}                       #dob
    Log    ${date_without_time} 
    # ${date_without_time}    Evaluate    datetime.datetime.strptime('${date_without_time}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date_without_time} 
    Wait Until Element Is Visible   //input[@id="dobVerify"]               timeout=30s        
    Input Text         //input[@id="dobVerify"]     ${date_without_time}

    ${Name}=      Set Variable        ${data['Name as on AADHAAR']}                         #name as aadhar            
    Wait Until Element Is Visible     //input[@id="nameVerify"]       timeout=30s                  
    Input Text    //input[@id="nameVerify"]    ${Name}
    
    ${AADHAAR}=   Set Variable         ${data['AADHAAR Number']}                              #aadhar number
    Wait Until Element Is Visible  //input[@id="aadharVerify"]
    Input Text    //input[@id="aadharVerify"]   ${AADHAAR}
    
    
    #TICK BUTTON
    Wait Until Element Is Visible    //input[@id="aadhaarConsentChkBox"]   timeout=30s       error=not found      #tickbox
    Click Element   //input[@id="aadhaarConsentChkBox"] 
    
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]    timeout=30s                error=not found       #verify button   
    Click Element     //input[@value="Verify"]

    Wait Until Element Is Visible    //div[@role="alert"]        timeout=200s                error=not found    #text extraction 
    ${error_message}=    Get Text    xpath=//div[@role="alert"]
    Log     ${error_message} 
    ${error} =    Strip String     ${error_message} 
    Log   ${error} 
    Sleep  2s

    #memeber name mismatch
    IF   '${error}' == 'Member name mismatch.'	
        Wait Until Element Is Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Close')]    timeout=30s 
        Click Element     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 

        Wait Until Element Is Visible    //*[@id="memberRegistration"]//table/tbody/tr/td/pre     timeout=30s  
        ${mismatch_condition}=    Get Text    //*[@id="memberRegistration"]//table/tbody/tr/td/pre

        Wait Until Element Is Visible    //input[@id="nameVerify"]    timeout=30s 
        Input Text    //input[@id="nameVerify"]    ${mismatch_condition}
        
        #verify
        Wait Until Element Is Visible   //input[@value="Verify"]      timeout=60s                      #verify button   
        Click Element     //input[@value="Verify"]
        Sleep    6s

        ${close_button_visible}=    Run Keyword And Return Status    Element Should Be Visible    //div[@id="memDetailsModal"]//button[contains(text(),'Close')]   
        ${ok_button_visible}=    Run Keyword And Return Status       Element Should Be Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
        Run Keyword If    ${close_button_visible}    Click Button     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
        Run Keyword If    ${ok_button_visible}    Click Button    //div[@id="memDetailsModal"]//button[contains(text(),'Ok')]
        Wait Until Element Is Visible    //div[@role="alert"]        timeout=200s                error=not found    #text extraction 
        ${message}=    Get Text    xpath=//div[@role="alert"]
        Log    ${message}
        ${aadhaar_number} =     Set Variable    ${data['AADHAAR Number']}
        ${uan_status} =  Set Variable       Already Exist 
        ${uan_num}=    Set Variable     ${data['Universal Account']}
        ${remarks}=     Set Variable       ${message}    
    ELSE
        ${close_button_visible}=    Run Keyword And Return Status    Element Should Be Visible    //div[@id="memDetailsModal"]//button[contains(text(),'Close')]   
        ${ok_button_visible}=    Run Keyword And Return Status    Element Should Be Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
        Run Keyword If    ${close_button_visible}    Click Button     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
        Run Keyword If    ${ok_button_visible}    Click Button    //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 

        ${aadhaar} =     Set Variable      ${data['AADHAAR Number']} 
        ${uan_present}=       Set Variable      ${data['Universal Account']}                    #uan  
        ${aadhaar_number}=  Set Variable  ${aadhaar}   
        ${uan_status} =  Set Variable     Already Exist  
        ${uan_num} =     Set Variable     ${data['Universal Account']}
        ${remarks}=     Set Variable       ${error_message}
        
    END 
    ${data}=    Split To Key Value Pairs    ${aaa_str}
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${user_uuid}=    Get From Dictionary    ${data}    user_uuid
    ${created_by}=    Get From Dictionary    ${data}    created_by
    Log    User UUID: ${user_uuid}
    Log    Created By: ${created_by}
    ${data}=    Create Dictionary   aadhaar_number=${aadhaar_number}    uan_status=${uan_status}    uan_num=${uan_num}    remarks=${remarks}    user_uuid=${user_uuid}    created_by=${created_by}
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log     ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    # Should Be Equal As Strings    ${response.status_code}    200
    # Log    Response content: ${response.content}
    Wait Until Element Is Visible     ${locator}          timeout=30s
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='N']
    Execute JavaScript    document.getElementById('previousEmployementNo').click();
        
    
# Handle Unauthorized Error
#     [Arguments]    ${response}
#     Run Keyword If    ${response.status_code} == 401    Log    Unauthorized access: Username or password is incorrect
#     Run Keyword If    ${response.status_code} != 401    Log    Unexpected error occurred: ${response.status_code} - ${response.content}
   
Split To Key Value Pairs
    [Arguments]    ${input_string}
    ${pairs}=    Split String    ${input_string}    ,    # split ,
    ${result}=    Create Dictionary                       #  empty dictionary 
    FOR    ${pair}    IN    @{pairs}                            # Looping
        ${key}    ${value}=    Split String    ${pair}    :    # Split
        Set To Dictionary    ${result}    ${key.strip()}    ${value.strip()}    # Adding key-value ---->dict
    END
    [Return]    ${result}

*** Test Cases ***
Automate EPFO Webpage
    Open EPF India Website
    Click ECR/Returns/Payment Button
    Accept Popup
    Enter Username and Password
    Click Signin Button
    click register individual

Check Universal Account And Fill Data
    ${data}=    Split To Key Value Pairs    ${aaa_str}
    Log    ${data}
    Log    ${data['Universal Account']}
    Run Keyword If    '${data['Universal Account']}' != 'nan'   fill and submit form for every uan is_present   ${data}     ELSE     fill and submit form for every no_uan     ${data} 







   