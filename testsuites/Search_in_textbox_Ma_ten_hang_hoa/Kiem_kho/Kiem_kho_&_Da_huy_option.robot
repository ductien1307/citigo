*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../core/Hang_Hoa/kiemkho_list_page.robot

*** Variables ***
@{input_data_search}    6    k    K    s    SP0126    Khăn lụa giấy

*** Test Cases ***    Trang thai kho    Ma_sp                               Ten sp                      Input_Search
hh da can bang kho    [Template]        Kiem kho with Trang thai options
                      Đã hủy            SP0126                              Khăn lụa giấy Kleenex $x    @{input_data_search}

*** Keywords ***
Kiem kho with Trang thai options
    [Arguments]    ${input_trangthai}    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Timeout]
    Go to Kiem kho
    Sleep    2s
    #loop
    ${trangthai}    Format String    ${checkbox_trangthai_phieu}    ${input_trangthai}
    Click Element    ${trangthai}
    ${da_canbang}    Format String    ${checkbox_trangthai_phieu}    Đã cân bằng kho
    ${phieu_tam}    Format String    ${checkbox_trangthai_phieu}    Phiếu tạm
    Click Element    ${da_canbang}
    Click Element    ${phieu_tam}
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item unavailable in dropdownlist
    u
