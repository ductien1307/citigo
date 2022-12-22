*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot

*** Variables ***
@{input_data_search}    6    k    K    s    SP0126    Khăn lụa giấy

*** Test Cases ***    Ma_sp         Ten sp                                 Input_Search
hh da co trong phieu kiem kho
                      [Template]    Check product searching in kiem kho
                      SP0126        Khăn lụa giấy Kleenex $x               @{input_data_search}

*** Keywords ***
Check product searching in kiem kho
    [Arguments]    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go to Kiem kho
    Sleep    2s
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
