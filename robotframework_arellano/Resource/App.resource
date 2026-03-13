*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/loginpage.py
Variables    ../Variables/common.py
Library    ../Libraries/CommonLibrary.py

*** Variables ***    
${TEST_URL}    https://marmelab.com/react-admin-demo
@{sales_submenu}    Orders    Invoices    # "@" pag list tapos rekta ung items
@{catalog_submenu}    Posters    Categories
@{customers_submenu}    Customers    Segments
&{MENU}    Sales=${sales_submenu}    Catalog=${catalog_submenu}    Customers=${customers_submenu}
${USERS}

*** Keywords ***
Launch Browser
    [Arguments]    ${url}=${TEST_URL}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized");
    Wait Until Element Is Visible    ${login_txt_username}

Login User
    [Arguments]    ${username}=demo    ${password}=dem
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}   ${password}
    Capture Page Screenshot
    Click Button    ${login_btn_submit}
    Wait Until Element Is Visible    ${main_content}

Get Parent Menu
    [Arguments]    ${sub_menu}
    FOR    ${key}    IN    @{MENU.keys()}
        Return From Keyword If    "${sub_menu}" in ${MENU['${key}']}    //li[descendant::p[text()="${key}"]]
    END   

    RETURN    ${None}

Navigate
    [Arguments]    ${sub_menu}
    ${sub_menu_loc}    Set Variable    //a[descendant::p[text()="${sub_menu}"]]
    ${status}    Run Keyword And Return Status    Element Should Be Visible   ${sub_menu_loc}

    IF    not ${status}
        ${parent_menu}    Get Parent Menu    ${sub_menu}
        Click Element    ${parent_menu}
        Wait Until Element Is Visible    ${sub_menu_loc}
    END
    Click Element    ${sub_menu_loc}
    Wait Until Element Is Visible    //h6[//span[text()="${sub_menu}"]]
    Run Keyword If    "${sub_menu}"=="Customers"    
    ...    Sleep    2s

Dismiss Alert If Present
    Sleep    10s

Clean Text
    [Arguments]    ${text}
    IF    "\\n" in """${text}"""
        ${text}    Evaluate    """${text}""".replace("\\n","")[1:]
    END
    Return From Keyword    ${text}

Clear Then Input Text
    [Arguments]    ${locator}    ${text}
    Press Keys    ${locator}    CTRL+a    BACKSPACE
    Input Text    ${locator}    ${text}