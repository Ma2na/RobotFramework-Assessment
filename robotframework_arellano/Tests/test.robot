*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/Customers.resource

Suite Setup    Suite Init
Suite Teardown    Capture Page Screenshot

*** Test Cases ***
TEST-1
    [Documentation]    User Should Be Able To Add A Customer
    Add A Customer    ${USERS}
    
TEST-2
    [Documentation]    Update Existing Customers
    Update A Customer    ${USERS}

TEST-3
    [Documentation]    Log Table Data
    Get Customer Details

TEST-4
    [Documentation]    Analyze User Spending
    Analyze User Spending

*** Keywords ***
Suite Init
    Launch Browser
    Login User
    ${users}    Get Users
    Set Suite Variable    ${USERS}    ${users}


