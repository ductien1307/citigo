*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Giao dich/giaodich_nav.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot

*** Variables ***
@{input_data_search}    6    k    K    s    SP0126    Khăn lụa giấy Kleenex $x    0

*** Test Cases ***    Ma_sp         Ten sp                                 Input_Search
hh_thuong             [Template]    Check product searching in kiem kho
                      SP0126        Khăn lụa giấy Kleenex $x               @{input_data_search}

*** Keywords ***
Check product searching in kiem kho
    [Arguments]    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Timeout]
    Go to Dat hang
    Sleep    2s
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
