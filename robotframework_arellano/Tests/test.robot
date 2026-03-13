*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/Customers.resource

Suite Setup    Suite Init
Suite Teardown    Capture Page Screenshot

*** Test Cases ***
TEST-1
    [Documentation]    User Should Be Able To Add A Customer
    FOR    ${i}    IN RANGE    0    5
        Add A Customer    ${USERS[${i}]}
        Verify If Customer Is Added In The Table    ${USERS[${i}]}
        Verify Customer Identity Details   ${USERS[${i}]}
    END
    
TEST-2
    [Documentation]    Update Existing Customers
    ${customer_count}    Get Length    ${USERS}
    FOR    ${i}    IN RANGE    ${customer_count}-${5}    ${customer_count}
        Update A Customer    ${USERS[${i}]}
        Verify If Customer Is Added In The Table    ${USERS[${i}]}
        Verify Customer Identity Details   ${USERS[${i}]}
    END

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


