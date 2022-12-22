*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot
Resource          ../../../core/Giao dich/giaodich_nav.robot

*** Variables ***
@{input_data_search}    S    s    0    4    SX004    pack1

*** Test Cases ***    Ma_sp         Ten sp                                 Input_Search
hh_thuong, dang kd, duoi ton, con hang trong kho
                      [Template]    Check product searching in kiem kho
                      SP0126        Khăn giấy lụa Kleenex                  @{input_data_search}

*** Keywords ***
Check product searching in kiem kho
    [Arguments]    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go To Tra Hang Nhap
    Sleep    2s
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
