*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/sanxuat_list_page.robot

*** Variables ***
@{input_data_search}    S    x    4    0    SXHH04    Thuốc lá mix 5*

*** Test Cases ***    Ma_sp         Ten sp                              Input_Search
hh_thuong, dang kd, duoi ton, con hang trong kho
                      [Template]    Check product searching San xuat
                      SXHH04        Thuốc lá mix 5*                     @{input_data_search}

*** Keywords ***
Check product searching San xuat
    [Arguments]    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go To San Xuat
    Sleep    2s
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
