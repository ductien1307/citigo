*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/sanxuat_list_page.robot
Resource          ../../../core/share/Tim_kiem_in_mhql/thoi_gian.robot
Resource          ../../../core/share/Tim_kiem_in_mhql/chi_nhanh.robot
Resource          ../../../core/share/Tim_kiem_in_mhql/text_search.robot

*** Variables ***
@{input_data_search}    S    x    4    0    SXHH04    Thuốc lá mix 5*

*** Test Cases ***    Tim theo       Text search                                                          Chi nhanh      Thoi gian     Ma_sp     Ten sp             Input_Search
Avaiable in dropdownlist
                      [Template]     Check item in dropdown when changing chi nhanh and toan thoi gian
                      Mã sản xuất    CODE4987                                                             CN Yết Kiêu    7 ngày qua    SXHH04    Thuốc lá mix 5*    @{input_data_search}
                      Ghi chú        đóng gói                                                             CN Yết Kiêu    7 ngày qua    SXHH04    Thuốc lá mix 5*    @{input_data_search}

*** Keywords ***
Check item in dropdown when changing chi nhanh and toan thoi gian
    [Arguments]    ${input_tim_theo}    ${input_textsearch}    ${input_chinhanh}    ${input_thoigian}    ${input_ma_sp}    ${input_ten_sp}
    ...    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go To San Xuat
    Sleep    2s
    Select and input data to textsearch    ${input_tim_theo}    ${input_textsearch}
    Select Branch    ${input_chinhanh}
    Select Thoi gian    ${input_thoigian}
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
