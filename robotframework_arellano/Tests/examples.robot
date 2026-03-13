*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${var_1}    ${5}

*** Test Cases ***
TEST-00001
    [Documentation]    Test Descriptions
    Open Browser    https://www.google.com    chrome
    Sleep    5s

    ${var_1}    Set Variable    ${16}
    ${var_2}    Set Variable    8

    # Addition
    ${ans}    Evaluate    ${var_1}+${var_2}
    Log To Console    Addition
    Log To Console    ${ans}
    Log To Console    ${var_1+${var_2}}    # pwede wala nang ${} ung var 1 kasi na typecast na nung nilagay sa loob ng ${} sa *** Variables***
    # you could also do this if result would not be needed any further

    # ${sum}    Evaluate    ${var1}+${var2}
    # Log    ${sum}
    # Log To Console    \nlog to console output:${sum}
    

    # ${var_3}    Set Variable    ${var_1}+${var2}   # dahil "Set Var" tinreat nya as string and not as expression kaya "5+3"
    # Log    ${var_3}
    # ${concat}    Evaluate    "${var_1}"+"${var_2}"    #concat = "53" kasi concat ng string
    # Log    ${concat}

    # Subtraction
    ${ans}    Evaluate    ${var_1}-${var_2}
    Log To Console    Subtraction
    Log To Console    ${ans}
    Log To Console    ${var_1-${var_2}} 

    # Multiplication
    ${ans}    Evaluate    ${var_1}*${var_2}
    Log To Console    Multiplication
    Log To Console    ${ans}
    Log To Console    ${var_1*${var_2}} 

    # Division
    ${ans}    Evaluate    ${var_1}/${var_2}
    Log To Console    Division
    Log To Console    ${ans}
    Log To Console    ${var_1/${var_2}} 

Test-00002
    [Documentation]    String Concatenation
    ${var_1}    Set Variable    ${16}
    ${var_2}    Set Variable    8
    ${var_3}    Set Variable    ABC
    ${var_4}    Set Variable    ABCZXC

    # ${result}    Evaluate    "${var_1}" + " " + "${var_2}"
    ${result}    Set Variable    ${var_1} ${SPACE}${var_2}     # para may space ng hindi nag coconcat, pero 1 space max lng
                                                              # ${SPACE} if need more than 1 space
    Log To Console    ${result}

Test-00003
    [Documentation]    List Examples
    ${list_1}    Set Variable    ['value_1', 'value_2']    # MALI
    ${list_1}    Create List    value_1    value_2    value_3
    Log To Console    ${list_1[0]}
    Log To Console    ${list_1}[0]    # pwede rin
    Append To List    ${list_1}    value_4    # pag mag add sa list
    Log To Console    ${list_1}

Test-00004
    [Documentation]    Dictionary Examples
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2    # "=" pag key value pair
    Log To Console    ${dict_1}
    Log To Console    ${dict_1['key_1']}
    Set To Dictionary    ${dict_1}    key_3=value_3    key_4=value_4    # pag mag add sa dictionary
    Log To Console    ${dict_1}

Test-00005
    [Documentation]    For Loop Examples
    ${list_1}    Create List    value_1    value_2    value_3
    FOR    ${element}    IN    @{list_1}
        Log To Console    ${element}
    END
    # or directly
    FOR    ${element}    IN    value_1    value_2    value_3
        Log To Console    ${element}
    END

    # for i in range(0,10,2)
    FOR    ${i}    IN RANGE    0    10    2
        Log To Console    ${i}
    END

    # pwede rin gamitin pag magttraverse ng list
    ${len}    Get Length    ${list_1}

    FOR    ${i}    IN RANGE    0    ${len}
        Log To Console    ${list_1[${i}]}
    END

    # enumerate, nagrereturn index at current element
    FOR    ${index}    ${element}    IN ENUMERATE    @{list_1}
        Log To Console    ${index+1}. ${element}
    END

    Log To Console    \nFOR loop for dictionary
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2    key_3=value_3    key_4=value_4
    FOR    ${key}    IN    @{dict_1.keys()}     # .keys() or .values()
        Log To Console    ${dict_1["${key}"]}    # or ganito para maaccess ung values, need string si "key"
    END

    #Nested For Loop
    # FOR    ${i}    IN    1    2    3
    FOR    ${i}    IN RANGE    1    4
        FOR    ${j}    IN    A    B    C            
            Log To Console    ${i}:${j}
        END
    END
    
Test-00006
    [Documentation]    Assertation
    ${ans}    Evaluate    1+1
    # Should Be Equal    ${ans}    2    # error kasi need "${2}"" or "Should Be Equal As Integers"
    Should Be Equal As Integers    ${ans}    2
    # Should Be Equal As Strings    ${ans}    2    # pwede rin to
    
Test-00007
    [Documentation]    IF STATEMENTS

    ${ans}    Evaluate    1+1
    IF    ${ans}!=3
        Fail    Failed    # ito ung malolog sa console pag nag fail
    END

Test-00008
    Open Browser    https://www.google.com    chrome
    Sleep    5s

Test-00009
    ${num}    Evaluate    random.randint(1, 100)    random
    ${remainder}    Evaluate    ${num} % 2

    IF    ${remainder} == 0
        Pass Execution    PASS: ${num} is an even number
    ELSE
        Fail    FAIL: ${num} is an odd number
    END
    
    
    

*** Keywords ***
Log Console
    [Arguments]    ${text}    ${level}=INFO
    Log    ${text}
    Log To Console    \n${text}    lvel-${level}