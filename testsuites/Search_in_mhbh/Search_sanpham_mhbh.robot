*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Test Template     Check product searching
Library           SeleniumLibrary
Resource          ../../core/Ban_Hang/banhang_action.robot
Resource          ../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../core/share/computation.robot
Resource          ../../core/Ban Hang page menu.robot
Resource          ../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/Search/Search_san_pham/dropdown_in_mhbh.robot
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/API/get_data_from_rest_api_9k1.robot
Library           String

*** Test Cases ***    Ma_sp     Thay doi SL    Ten sp                      Search
Hien thi dropdownlist
                      SP0126    \              Khăn lụa giấy Kleenex $x    K

*** Keywords ***
Check product searching
    [Arguments]    ${input_ma_sp}    ${change_soluong}    ${input_ten_sp}    ${input_keyword_search}
    [Documentation]    *hh thường*
    ...
    ...    checkbox: hàng hóa thường,
    ...    tồn kho: tất cả
    ...    nhóm hàng: chứa sản phẩm
    ...    Ngừng kinh doanh
    [Timeout]
    Go to Ban Hang from Menu page
    ${get_ton}    ${get_dat}    ${get_giaban}    Get Ton Dat Gia ban    ${input_ma_sp}
    Input Text    ${textbox_bh_search_ma_sp}    ${input_keyword_search}
    Sleep    2s
    ${input_textcell_tensp}    Format String    ${textcell_ten_sp}    ${input_ten_sp}
    ${get_textcell_tensp}    Get Text    ${input_textcell_tensp}
    Element Should Be Visible    ${input_textcell_tensp}
    Should Be Equal As Strings    ${get_textcell_tensp}    ${input_ten_sp}
    ${get_ton_insearchlist}    Get Ton    ${input_ten_sp}
    Should Be Equal As Numbers    ${get_ton_insearchlist}    ${get_ton}
    ${get_dat_insearchlist}    Get Dat    ${input_ten_sp}
    Should Be Equal As Numbers    ${get_dat_insearchlist}    ${get_dat}
    ${get_gia_insearchlist}    Get Gia Ban    ${input_ten_sp}
    Should Be Equal As Numbers    ${get_gia_insearchlist}    ${get_giaban}
