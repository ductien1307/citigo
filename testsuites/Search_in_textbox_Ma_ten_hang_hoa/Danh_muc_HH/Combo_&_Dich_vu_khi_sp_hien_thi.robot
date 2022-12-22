*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Test Template     Check combo_dichvu searching in danh muc hh
Library           SeleniumLibrary
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot

*** Variables ***
@{input_data_search}    6    k    K    s    SP0126    Khăn lụa giấy

*** Test Cases ***    Loai HH             Tich diem             Ton kho               Nhom hàng               Trang thai              Ma_sp    Ten sp                  Input_Search
combo                 Combo - Đóng gói    Tất cả                Tất cả                B                       Hàng đang Kinh doanh    \        @{input_data_search}
                      Combo - Đóng gói    Tất cả                Tất cả                B                       Tất cả                  \        @{input_data_search}
                      Combo - Đóng gói    Tích điểm             Hết hàng trong kho    B                       Hàng đang Kinh doanh    \        @{input_data_search}
                      Combo - Đóng gói    Tích điểm             Hết hàng trong kho    B                       Tất cả                  \        @{input_data_search}

dich vu               Dịch vụ             Tất cả                B                     Hàng đang Kinh doanh    \                       \        @{input_data_search}
                      Dịch vụ             Tất cả                B                     Tất cả                  \                       \        @{input_data_search}
                      Dịch vụ             Hết hàng trong kho    B                     Hàng đang Kinh doanh    \                       \        @{input_data_search}
                      Dịch vụ             Hết hàng trong kho    B                     Tất cả                  \                       \        @{input_data_search}

*** Keywords ***
Check combo_dichvu searching in danh muc hh
    [Arguments]    ${loai_hh}    ${trangthai_kho}    ${tichdiem}    ${nhom_hang}    ${trang_thai}    ${input_ma_sp}
    ...    ${input_ten_sp}    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go To Danh Muc Hang Hoa
    Sleep    2s
    ${checkbox_loai_hh}    Format String    ${checkbox_loai_hh_variable}    ${loai_hh}
    Click Element    ${checkbox_loai_hh}
    ${checkbox_trangthai_kho}    Format String    ${checkbox_tonkho_variable}    ${trangthai_kho}
    Click Element    ${checkbox_trangthai_kho}
    ${checkbox_tichdiem}    Format String    ${checkbox_loc_theo_tichdiem}    ${tichdiem}
    Click Element    ${checkbox_tichdiem}
    ${select_nhomhang}    Format String    ${textcell_nhomhang}    ${nhom_hang}
    Click Element    ${select_nhomhang}
    ${checkbox_trangthai}    Format String    ${checkbox_trangthai_variable}    ${trang_thai}
    Click Element    ${checkbox_trangthai}
    sleep    1s
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
