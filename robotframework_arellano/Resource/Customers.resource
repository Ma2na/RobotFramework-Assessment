*** Settings ***
Resource    ../Resource/App.resource
Library    SeleniumLibrary
Variables    ../Variables/customers.py
Library    ../Libraries/CommonLibrary.py
Library    Collections

*** Keywords ***

Open Create Modal
    Click Element   //a[text()="Create"]
    Wait Until Element Is Visible    //h6[descendant::span[text()="Create Customer"]]

Add A Customer
    [Arguments]    ${users}
    FOR    ${i}    IN RANGE    0    5
        ${user}    Set Variable    ${users}[${i}]
        Navigate    Customers
        Open Create Modal

        Input Text    ${cust_txt_first_name}    ${user['first_name']}
        Input Text    ${cust_txt_last_name}    ${user['last_name']}
        Input Text    ${cust_txt_email}    ${user['email']}

        # Input Text    ${cust_txt_birthday}    ${user['birthday']}
        Set React Date Input    ${cust_txt_birthday}    ${user['birthday']}
        
        Input Text    ${cust_txt_address}    ${user['address']['street']} ${user["address"]['suite']}
        Input Text    ${cust_txt_city}    ${user['address']['city']}
        Input Text    ${cust_txt_stateAbbr}    ${user['address']['stateAbbr']}
        Input Text    ${cust_txt_zipcode}    ${user['address']['zipcode']}
        Input Text    ${cust_txt_password}    ${user['password']}
        Input Text    ${cust_txt_confirm_password}    ${user['password']}
        Click Element   ${customers_btn_save}
        # setTimeout(() => { debugger; }, 1);
        Wait Until Element Is Visible    //div[text()="Customer created"]
        Verify If Customer Is Added In The Table    ${user}
        Verify Customer Identity Details   ${user}
    END

Format Birthday
    [Arguments]    ${date}
    ${formatted}    Evaluate    "/".join("${date}".split("-")[1:]+["${date}".split("-")[0]])
    RETURN    ${formatted}

Verify If Customer Is Added In The Table
    [Arguments]    ${user}
    ${user_row}    Get Customer Row    ${user}
    Should Not Be Equal As Strings    None    ${user_row}

Verify Customer Identity Details
    [Arguments]    ${user}
    # Navigate    Customers
    ${user_row}    Get Customer Row    ${user}
    Wait Until Element Is Visible    ((//tbody//tr)[${user_row}]//td)[2]        #(//tbody//tr)[1]//td[contains(@class,"column-last_name")]
    Click Element    ((//tbody//tr)[${user_row}]//td)[2]
    Wait Until Element Is Visible    ${cust_txt_first_name}

    ### TO SHORTEN
    ${locators}    Create List    
    ...    ${cust_txt_first_name}    ${cust_txt_last_name}    ${cust_txt_email}    
    ...    ${cust_txt_birthday}    ${cust_txt_address}    ${cust_txt_city}    
    ...    ${cust_txt_stateAbbr}    ${cust_txt_zipcode}    ${cust_txt_password}    
    ...    ${cust_txt_confirm_password}

    ${expected_values}     Create List    
    ...    ${user['first_name']}    ${user['last_name']}    ${user['email']}    
    ...    ${user['birthday']}    ${user['address']['street']} ${user["address"]['suite']}    
    ...    ${user['address']['city']}    ${user['address']['stateAbbr']}    
    ...    ${user['address']['zipcode']}    ${user['password']}    ${user['password']}

    FOR    ${i}    ${locator}    IN ENUMERATE    @{locators}
        Mouse Over    ${locator}    # para kita ano ung cinocompare
        ${value_text}    Get Value    ${locator}
        IF    '${locator}'=='${cust_txt_birthday}'
            ${value_text}    Format Birthday    ${value_text}
        END
        Should Be Equal As Strings    ${expected_values[${i}]}    ${value_text}
    END
    
Get Customer Row
    [Arguments]    ${user}
    Navigate    Customers
    ${web_elems}    Get WebElements    //tbody//tr    # Get WebElements == pag pinasahan xpath, kukunin nya lahat ng rows as list
    FOR    ${i}    ${elem}    IN ENUMERATE   @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        Return From Keyword If    "${user["first_name"]} ${user["last_name"]}"=="${name}"    ${i+1}
    END

Get Customer Details
    Navigate    Customers
    # ${table_headers}    Create List    Name    Last Seen    Orders    Total spent    Latest purchase    News    Segments
    ${web_elems}    Get WebElements    //tbody//tr    
    FOR    ${i}    ${elem}    IN ENUMERATE   @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        ${last_seen}    Get Text    ((//tbody//tr)[${i+1}]//td)[3]
        ${orders}    Get Text    ((//tbody//tr)[${i+1}]//td)[4]
        ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
        ${latest_purchase}    Get Text    ((//tbody//tr)[${i+1}]//td)[6]
        ${news}    Get Element Attribute    ((//tbody//tr)[${i+1}]//td)[7]//*[name()="svg"]    aria-label        
        ${segments}    Get WebElements    ((//tbody//tr)[${i+1}]//td)[8]//span

        Log To Console    \n====== USER ${i+1} ======
        Log to Console    Name: ${name}
        Log to Console    Last Seen: ${last_seen}
        Log to Console    Orders: ${orders}
        Log to Console    Total spent: ${total_spent}
        IF    "${latest_purchase}" != ''
            Log to Console    Latest purchase: ${latest_purchase}
        END
        Log to Console    News: ${news}
        IF    ${segments}
            ${segment_list}    Create List
            FOR    ${segment}    IN    @{segments}
                ${item}    Get Text    ${segment}
                ${segment_list}    Evaluate    ${segment_list}+['${item}']
            END
            ${comma_segment_list}    Evaluate    ", ".join(@{segment_list})
            Log to Console    Segments: ${comma_segment_list}
            Log To Console    \n
        END
    END

    RETURN    None

Analyze User Spending
    Navigate    Customers
    ${ctr}    Set Variable    1
    ${final_total}    Set Variable    0.00
    ${web_elems}    Get WebElements    //tbody//tr
    Log To Console    \n
    
    FOR    ${i}    ${elem}    IN ENUMERATE   @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}

        ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
        
        IF    "${total_spent}" != "$0.00"
            Log To Console    ${ctr}. ${name}: ${total_spent}
            ${ctr}    Evaluate    ${ctr} + ${1}
            ${float_total}    Evaluate    float('${total_spent}'.replace('$', '').replace(',', ''))
            ${final_total}    Evaluate    ${final_total}+${float_total}  
        END
        
    END

    ${formatted_total}    Evaluate    f"{${final_total}:,.2f}"
    Log To Console    \n==========================================
    Log To Console    Total Customer Spending: $${formatted_total}
    Log To Console    ==========================================

    IF    ${final_total} < 3500
        Fail    FAIL: Total spending ($${formatted_total}) is below minimum threshold ($3,500)
    ELSE
        Pass Execution    PASS: Total spending ($${formatted_total}) meets minimum threshold ($3,500)
    END
    
Update A Customer
    [Arguments]    ${users}
    ${customer_count}    Get Length    ${users}
    FOR    ${i}    IN RANGE    ${customer_count}-${5}    ${customer_count}
        ${user}    Set Variable    ${users}[${i}]
        
        Navigate    Customers
        Wait Until Element Is Visible    ((//tbody//tr)[${user["id"]}]//td)[2]        #(//tbody//tr)[1]//td[contains(@class,"column-last_name")]
        Click Element    ((//tbody//tr)[${user["id"]}]//td)[2]
        Wait Until Element Is Visible    ${cust_txt_first_name}

        ### TO SHORTEN
        ${locators}    Create List    
        ...    ${cust_txt_first_name}    ${cust_txt_last_name}    ${cust_txt_email}    
        ...    ${cust_txt_birthday}    ${cust_txt_address}    ${cust_txt_city}    
        ...    ${cust_txt_stateAbbr}    ${cust_txt_zipcode}    ${cust_txt_password}    
        ...    ${cust_txt_confirm_password}

        ${expected_values}     Create List    
        ...    ${user['first_name']}    ${user['last_name']}    ${user['email']}    
        ...    ${user['birthday']}    ${user['address']['street']} ${user["address"]['suite']}    
        ...    ${user['address']['city']}    ${user['address']['stateAbbr']}    
        ...    ${user['address']['zipcode']}    ${user['password']}    ${user['password']}

        FOR    ${i}    ${locator}    IN ENUMERATE    @{locators}
            Mouse Over    ${locator}   
            IF    '${locator}'=='${cust_txt_birthday}'
                Set React Date Input    ${locator}    ${expected_values[${i}]}
            ELSE
                Clear Then Input Text    ${locator}    ${expected_values[${i}]}
            END
        END

        Click Element   ${customers_btn_save}
        # setTimeout(() => { debugger; }, 1);
        Wait Until Element Is Visible    //div[text()="Customer updated"]
        Verify If Customer Is Added In The Table    ${user}
        Verify Customer Identity Details   ${user}
    END


    

    
