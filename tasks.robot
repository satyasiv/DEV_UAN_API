*** Settings ***
Library   RPA.Browser.Selenium
# Library   SeleniumLibrary 
Library    Collections
Library    OperatingSystem
Library    String
Library    Process
Library    BuiltIn
Library    RPA.HTTP 
Library    RPA.JSON
Library    DateTime
Library    RPA.Email.ImapSmtp


*** Variables *** 
${username}          BUZZWORKS2012           
${password}          Bu$$2024Work$
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
${error}             ${EMPTY} 
${employee_id}       ${EMPTY}
#apis
${robot_path}        /home/buzzadmin/Documents/Django/project/tasks.robot
${aaa_str}                
${django_url}                 http://127.0.0.1:8000/
${insert_user_data}           ${django_url}output_data/          #user output
${current_index}     0
#mail
${EMAIL_SERVER}         smtp.gmail.com
${EMAIL_PORT}           587
${EMAIL_USERNAME}       lakshmi.l@buzzworks.com
${EMAIL_PASSWORD}       dypk xdvo wgcb pxrb
${EMAIL_SENDER}         ${EMAIL_USERNAME}
${TAGGED_EMAIL}         dodla.manasa@buzzworks.com
${SUBJECT}              Failed_User.

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
    Wait Until Element Is Visible    xpath://*[@id="btnCloseModal"]    timeout=30s     error= Unable to find Alert Popup..
Accept Popup
    Click Button    xpath://*[@id="btnCloseModal"]  
    Log    Opened EPFO login page   
Enter Username and Password
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
        ${employee_id}=   Set Variable     ${member_data['employee_id']}
        Log      ${employee_id}
        ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
        Wait Until Element Is Visible    //input[@id='memberName']   timeout=30s           error=memebername not found           #name
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
        Wait Until Element Is Visible    //input[@id='dob']        timeout=30s               error=dob not found
        Input Text        //input[@id='dob']     ${date_without_time}
        Sleep   2s

        ${date}    Set Variable     ${member_data['date_of_joining']}                                         #doj
        Wait Until Element Is Visible   //input[@id="doj"]                 timeout=30s    error=doj not found 
        Input Text    //input[@id="doj"]    ${date}
        Sleep    2s

        Wait Until Element Is Visible    //input[@id="wages"]             timeout=30s        error=wages not found         #Monthly EPF Wages as on Joining
        Input Text    //input[@id="wages"]      ${member_data['wages_as_on_joining']}

        ${Father's/Husband's Name}=    Set Variable     ${member_data['father_husband_name']}                  #husband/father
        Wait Until Element Is Visible     //input[@id="fatherHusbandName"]         timeout=30s        error=father/husband not found
        Input Text   //input[@id="fatherHusbandName"]     ${Father's/Husband's Name}

        ${Status}=    Create Dictionary    Single=UnMarried    None=UnMarried    UnMarried=UnMarried    Unmarried=UnMarried    Married=Married    married=Married
        ${marital_status}=    Set Variable         ${member_data['marital_status']}                          #martial status
        ${marital_status}=  Get From Dictionary    ${Status}    ${marital_status}
        ${first_letter}=    Get Substring    ${marital_status}    0    1
        ${uppercase_first_letter}=    Convert To Upper Case    ${first_letter}

        Wait Until Element Is Visible     //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']     timeout=30s    error=martialstatus not found
        Click Element    //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']
        Log     ${uppercase_first_letter}

        ${Relationship}=    Set Variable       ${member_data['relationship_with_member']}                      #relation
        ${first}=    Get Substring    ${Relationship}    0    1
        ${uppercase_first}=    Convert To Upper Case    ${first}
        Wait Until Element Is Visible    //select[@id="relation"]/option[@value='${uppercase_first}']        timeout=30s    error=relationship not found
        Click Element    //select[@id="relation"]/option[@value='${uppercase_first}']

        #KYC  DETAILS
        Wait Until Element Is Visible   //input[@id="chkDocTypeId_1"]       timeout=50s                error= checkbox not found
        Click Element       //input[@id="chkDocTypeId_1"]                              #checkbox
        Sleep    1s
        ${Document_number}=    Set Variable          ${member_data['aadhaar_number']} 
        Wait Until Element Is Visible     //*[@id="docNo1"]         timeout=30s              error= number_as_per adhaar not found            #aadhaar number
        Input Text     //*[@id="docNo1"]       ${Document_number}
        Sleep    5s
        ${Document_name}=  Set Variable       ${member_data['name_as_on_aadhaar']}                   #aadhaar name
        Wait Until Element Is Visible    //*[@id="nameOnDoc1"]     timeout=30s          error= name_as_per adhaar not found
        Input Text    //*[@id="nameOnDoc1"]     ${Document_name}
        Sleep   1s
        #TICKBUTTON
        Wait Until Element Is Visible      //*[@id="aadhaarConsentChkBox"]     timeout=120s      error=tickbox not found    #tickbutton
        Click Element     //*[@id="aadhaarConsentChkBox"]
        Sleep     1s
        Wait Until Element Is Visible       //*[@id="memreg2"]/input    timeout=120s      error=savebutton not found  #savebutton 
        Click Element       //*[@id="memreg2"]/input    
        Handle Alert
        Sleep    10s
        #error
        ${element_exists}    Run Keyword And Return Status    Element Should Be Visible     //div[@id="kycDetailsDiv"]/div/div[4]/div/div         timeout=200s
        ${error_text}=     Run Keyword If    ${element_exists}     Get Text    //div[@id="kycDetailsDiv"]/div/div[4]/div/div       
        Log    ${error_text}
        ${aadhaar} =     Set Variable     ${member_data['aadhaar_number']} 
        #take the uan num if present
        # : conditon 
        ${contains_colon}=    Run Keyword And Return Status    Should Contain   ${error_text}    :
        IF  '${contains_colon}' == 'True' 
            ${uan_num}=  Split String  ${error_text}  separator=:
            ${uan} =  Set Variable    ${uan_num}[1] 
            ${uan_clean}=    Replace String    ${uan}    .    ${EMPTY}
            ${uan_clean}    Replace String    ${uan_clean}    ${SPACE}    ${EMPTY}
            ${text}=    Set Variable      ${uan_num}[0]  
            yes button process     ${uuid}    ${uan_clean}      ${member_data}      ${START_TIME}    
        ELSE 
            ${aadhaar_number}=  Set Variable  ${aadhaar} 
            ${name} =      Set Variable      ${member_data['member_name']}
            ${uan_status}=  Set Variable   None
            ${uan_num}=    Set Variable    None 
            ${remarks}=    Set Variable     Errror:${error_text} 
            ${employee_id}=   Set Variable     ${member_data['employee_id']}
            ${entity_status}=   Set Variable   creation pending
            ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
            ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
            Log    Total seconds elapsed: ${SECONDS_ELAPSED}
            ${time}=   Set Variable     ${SECONDS_ELAPSED}
            Post User Data      ${aadhaar_number}     ${name}     ${uan_status}    ${uan_num}    ${remarks}   ${entity_status}   ${uuid}    ${time}    ${employee_id}
            Unselect Checkbox   //*[@id="chkDocTypeId_1"]  
            Wait Until Element Is Visible   //*[@id="chkDocTypeId_1"]       timeout=30s      error= unslelect check box not found
            Unselect Checkbox  //*[@id="chkDocTypeId_1"]
        END
    


send email
   [Arguments]    ${member_data} 
    Log    ${member_data} 
    ${email_body}=    Set Variable    Hi, NOTE:this is the failed user_data "${member_data}" due to the reason .
    # Send the email with the Excel file as attachment
    Authorize Smtp    ${EMAIL_USERNAME}    ${EMAIL_PASSWORD}    ${EMAIL_SERVER}    ${EMAIL_PORT}
    Send Message
    ...    ${EMAIL_SENDER}
    ...    ${TAGGED_EMAIL}
    ...    ${SUBJECT}
    ...    ${email_body}
    


yes button process
    [Arguments]    ${uuid}    ${uan_clean}      ${member_data}   ${START_TIME}      
    Log    ${uan_clean}
    Log     ${member_data}  
    Log     ${uuid} 
    Sleep    4s 
    ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
    Log       ${START_TIME}
    #yes button
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='Y']
    Wait Until Element Is Visible    ${locator}          timeout= 120s
    Execute JavaScript    document.getElementById('previousEmployementYes').click();

    ${uan_status}=    Run Keyword If    '${uan_clean}' != ''    Set Variable     Newly created     ELSE    Set Variable     Already exist

     #uan_num condition --->> 
    ${uan}=    Run Keyword If    '${uan_clean}' != ''    Set Variable    ${uan_clean}    ELSE    Set Variable     ${member_data['Universal_Account']} 
    Wait Until Element Is Visible    //input[@id="uan"]    timeout=80s
    Input Text    //input[@id="uan"]    ${uan}


    #dob
    ${date_without_time}=    Set Variable        ${member_data['date_of_birth']}                       
    Log    ${date_without_time} 
    Wait Until Element Is Visible   //input[@id="dobVerify"]               timeout=30s        
    Input Text         //input[@id="dobVerify"]     ${date_without_time}
    Sleep     2s
    #name
    ${Name}=      Set Variable        ${member_data['name_as_on_aadhaar']}                                   
    Wait Until Element Is Visible     //input[@id="nameVerify"]       timeout=30s                  
    Input Text    //input[@id="nameVerify"]    ${Name}
    #aadhar number
    ${AADHAAR}=   Set Variable         ${member_data['aadhaar_number']}                             
    Wait Until Element Is Visible  //input[@id="aadharVerify"]
    Input Text    //input[@id="aadharVerify"]   ${AADHAAR}
    Sleep     10s
    
    #TICK BUTTON
    Wait Until Element Is Visible    //input[@id="aadhaarConsentChkBox"]   timeout=30s       error=not found      #tickbox
    Click Element   //input[@id="aadhaarConsentChkBox"] 
    
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]    timeout=50s                error=not found       #verify button   
    Click Element     //input[@value="Verify"]
    Sleep  4s

    #geting the text 
    Wait Until Element Is Visible    //div[@role="alert"]        timeout=200s                error=not found    #text extraction 
    ${error_message}=    Get Text    //div[@role="alert"]
    ${error} =    Strip String     ${error_message} 
    Log   ${error} 
    Sleep  2s

    #condition
    Run Keyword If    '${error}' == 'Member name mismatch.'    Member name mismatch for no          
    ...    ELSE IF    '${error}' == 'Member name mismatch. Member DOB mismatch.'    Member name mismatch for no         
    ...    ELSE IF    '${error}' == 'Member DOB mismatch.'    Member name mismatch for no 
    ...    ELSE IF    '${error}' == 'Member details matched'   Member details matched for no     
    ...    ELSE     Log   ${error} 


    Sleep  2s
    # Check and input date of joining
    ${error_message}=    Run Keyword And Return Status    Element Should Be Visible     //div[@role="alert"]       timeout=30s
    ${error_data}=    Run Keyword If    ${error_message}   Get Text      //div[@role="alert"]  

    Sleep    2s
    #WHAT EVER CLOSE/OK
    ${close_button_visible}=    Run Keyword And Return Status    Element Should Be Visible    //div[@id="memDetailsModal"]//button[contains(text(),'Close')]    timeout=100s    
    ${ok_button_visible}=    Run Keyword And Return Status       Element Should Be Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
    Run Keyword If    ${close_button_visible}    Click Button     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
    Run Keyword If    ${ok_button_visible}    Click Button    //div[@id="memDetailsModal"]//button[contains(text(),'Ok')]
    Sleep    10s
  
    # Check and input date of joining
    ${doj_visible}=    Run Keyword And Return Status    Element Should Be Visible    //input[@id="doj"]    timeout=30s
    Run Keyword If    ${doj_visible}    Input Text    //input[@id="doj"]    ${member_data['date_of_joining']}

    # Check and input wages as on joining
    ${wages_visible}=    Run Keyword And Return Status    Element Should Be Visible    //input[@id="wages"]    timeout=30s
    Run Keyword If    ${wages_visible}    Input Text    //input[@id="wages"]    ${member_data['wages_as_on_joining']}

    # Check and click tick box
    ${tickbox_visible}=    Run Keyword And Return Status    Element Should Be Visible    //input[@id="aadhaarConsentChkBox"]    timeout=30s
    Run Keyword If    ${tickbox_visible}    Click Element    //input[@id="aadhaarConsentChkBox"]
    
    # Check and click verify button
    ${tickbox_visible}=    Run Keyword And Return Status    Element Should Be Visible    //input[@type="submit"]      timeout=50s
    Run Keyword If    ${tickbox_visible}    Click Element     //input[@type="submit"]   
    Sleep  12s

    #handle alerts
    ${alert_visible_1}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=30s
    Run Keyword If    '${alert_visible_1}' == 'True'    Log    First alert handled successfully
    Sleep    4s
    ${alert_visible_2}=    Run Keyword And Return Status    Alert Should Be Present    action=ACCEPT    timeout=30s
    Run Keyword If    '${alert_visible_2}' == 'True'    Log    Second alert handled successfully
  
    #no button
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='N']
    Wait Until Element Is Visible    ${locator}      timeout=30s
    Execute JavaScript    document.getElementById('previousEmployementNo').click();
    Sleep   10s
    
    Wait Until Element Is Visible   //*[@id="1"]/td[6]  timeout=30s
    ${verify_user}=    Get Text   //*[@id="1"]/td[6]
    Log    ${verify_user}
    #validation ===> dob
    ${date}=    Set Variable      ${verify_user} 
    ${result}=    Split String    ${date}    separator=-
    Log    ${result}
    ${day}=    Set Variable    ${result}[0]
    ${month}=    Set Variable    ${result}[1]
    ${year}=    Set Variable    ${result}[2]
    ${month_value}    Evaluate    {'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'}
    ${selected_month}    Set Variable    ${month_value['${month}']}
    Log    Selected month value is ${selected_month}
    ${date}=    Set Variable      ${day}/${selected_month}/${year}
    Log    ${date}  
    Log     ${member_data['date_of_birth']}   
    Sleep  5s


    #condition for remarks,entitystatus

    ${entity_status}=    Run Keyword If    '${date}' == '${member_data['date_of_birth']}'    Set Variable    approval pending     
    ...    ELSE   Set Variable    creation pending 
    Log    ${entity_status}
   
    ${remarks}=    Run Keyword If    '${date}' == '${member_data['date_of_birth']}'    Set Variable    success
    ...    ELSE IF    '${error_data}' != 'Member details matched'    Set Variable    Error:${error_data}
    ...    ELSE    Set Variable    Page is not loaded..
    Log    ${remarks}


    
    # ${uan_status}=    Run Keyword If    '${entity_status}' != 'creation pending'    Set Variable    None      ELSE    Set Variable      ${uan_exist}
    #push data to DB.
    ${aadhaar_number} =     Set Variable   ${member_data['aadhaar_number']} 
    ${name} =     Set Variable     ${member_data['name_as_on_aadhaar']}  
    ${uan_status}=    Set Variable     ${uan_status}       
    ${uan_num}=    Set Variable          ${uan}
    ${remarks}=    Set Variable          ${remarks}
    ${employee_id}=   Set Variable     ${member_data['employee_id']}
    Log    ${entity_status}  
    Log  ${START_TIME}
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}
    ${time} =     Set Variable    ${SECONDS_ELAPSED}
    Post User Data       ${aadhaar_number}     ${name}     ${uan_status}    ${uan_num}    ${remarks}   ${entity_status}   ${uuid}    ${time}      ${employee_id}
    [Return]   success





Member get error  
    #close button
    Wait Until Element Is Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Close')]    timeout=30s 
    Click Element     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
   

 Member details matched for no 
   Sleep   2s
    ${close_button_visible}=   Run Keyword And Return Status    Element Should Be Visible    //div[@id="memDetailsModal"]//button[contains(text(),'Close')]  timeout=30s      
    ${ok_button_visible}=    Run Keyword And Return Status    Element Should Be Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
    Run Keyword If    ${close_button_visible}    Click Button     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
    Run Keyword If    ${ok_button_visible}    Click Button    //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
    Set Test Variable    ${entity_status}    Approval pending
Member name mismatch for no 
    #extract data from table name$dob
    Wait Until Element Is Visible    //*[@id="memberRegistration"]//table/tbody/tr/td/pre     timeout=30s  
    ${mismatch_name}=    Get Text    //*[@id="memberRegistration"]//table/tbody/tr/td/pre
    Sleep   1s
    Wait Until Element Is Visible  //*[@id="memberRegistration"]/div/table/tbody/tr[2]/td[2]    timeout=30s  
    ${mismatch_dob}=    Get Text   //*[@id="memberRegistration"]/div/table/tbody/tr[2]/td[2]
    #close
    Wait Until Element Is Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Close')]    timeout=30s 
    Click Element     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
    #insert into the fields 
    Wait Until Element Is Visible    //input[@id="nameVerify"]    timeout=30s 
    Input Text    //input[@id="nameVerify"]    ${mismatch_name}
   
    Wait Until Element Is Visible    //input[@id="dobVerify"]    timeout=30s 
    Input Text    //input[@id="dobVerify"]    ${mismatch_dob}
    Sleep   1s
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]      timeout=60s                      #verify button   
    Click Element     //input[@value="Verify"]
    Sleep    8s
   

Post User Data            #database push data
    [Arguments]     ${aadhaar_number}     ${name}     ${uan_status}    ${uan_num}    ${remarks}   ${entity_status}   ${uuid}    ${time}   ${employee_id}
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${data}=    Create Dictionary    employee_id=${employee_id}     aadhaar_number=${aadhaar_number}    name=${name}   uan_status=${uan_status}    uan_num=${uan_num}    remarks=${remarks}     entity_status=${entity_status}    user_uuid=${uuid}    time=${time}
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log    ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    Sleep    5s
    




Handle Alert And Click Radio Button
    [Arguments]  ${locator}                        #(yes/no)radian button purpose 
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
    TRY
        Log    ${validated_data}   
        ${data_list}=    Evaluate    json.loads($validated_data)    json
        ${current_index}=    Get Length    ${data_list}
        ${total_index}=    Set Variable    ${current_index}
        ${all_member_data}=    Create List
        ${current_index}=    Set Variable    0
        FOR    ${member_data}    IN    @{data_list}
            Log       ${member_data}
            ${member_info}=    Create Dictionary      Member Name=${member_data['member_name']}    Gender=${member_data['gender']}    Father/Husband Name=${member_data['father_husband_name']}    Relationship with Member=${member_data['relationship_with_member']}    Nationality=${member_data['nationality']}    Marital Status=${member_data['marital_status']}    Aadhaar Number=${member_data['aadhaar_number']}    Name as on Aadhaar=${member_data['name_as_on_aadhaar']}     Date of Birth=${member_data['date_of_birth']}    Date of Joining=${member_data['date_of_joining']}    Universal_Account=${member_data['Universal_Account']}    wages_as_on_joining=${member_data['wages_as_on_joining']}
            Log     ${member_info}   
            ${uuid}=    Evaluate    str(uuid.uuid4())
            Log    Generated UUID:${uuid}
            ${condition}=    Run Keyword And Continue On Failure        Run Keyword If    '${member_data['Universal_Account']}' != 'None'   yes button process   ${uuid}    ${uan_clean}      ${member_data}   ${START_TIME}   ELSE    fill and submit form for every no_uan    ${member_data}    ${uuid} 
             
            ${employee_id}=   Set Variable     ${member_data['employee_id']}
            Log      ${employee_id}
        END
        Sleep    2s
    EXCEPT    message
        Log     ${member_data} 
    FINALLY
        Log     ${member_data}  
        send email        ${member_data}  
    END


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
  





