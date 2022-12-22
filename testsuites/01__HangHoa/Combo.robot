*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown     After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/api/api_hanghoa.robot

*** Variables ***
&{dict_prs}       NHP029=3    NHP030=6
@{list_num_up}    7    4

*** Test Cases ***
Thêm mới              [Tags]        GOLIVE2                     EP      EPT
                      [Template]    ecb1
                      [Documentation]   Thêm mới hàng combo
                      CBAT0001      oremere       800000        Đồ ăn vặt      ${dict_prs}
                      #CBAT0002      oremere       800000        Đồ ăn vặt      ${dict_prs}

Cập nhật              [Tags]        EP
                      [Template]    ecb2
                      [Documentation]   Cập nhật hàng combo
                      CBAT0003      Kẹo dẻo ABC      800000       Đồ ăn vặt      ${dict_prs}      Bánh oreo    Dịch vụ    4555    ${list_num_up}

Xóa                   [Tags]
                      [Template]    ecb3
                      [Documentation]   Xóa hàng combo
                      CBAT0005      Bim bim       Dịch vụ                     50000          NHP026         6            NHP027     3

*** Keyword ***
ecb1
    [Arguments]    ${ma_hh}     ${ten_hh}    ${giaban}    ${nhom_hang}    ${dict_tp}
    Delete product if product is visible thr API      ${ma_hh}
    ${list_prs}    Get Dictionary Keys    ${dict_tp}
    ${list_num}    Get Dictionary Values    ${dict_tp}
    Reload Page
    Go to Them moi Combo
    Input data to Thongtin    ${ma_hh}    ${ten_hh}    ${giaban}    ${nhom_hang}
    KV Click Element    ${tab_thanhphan_in_add_hh_page}
    ${total_giavon}    ${total_giaban}    Input list component product    ${list_prs}     ${list_num}
    Wait Until Keyword Succeeds    3 times    3s    Assert total cost and sating price    ${total_giavon}    ${total_giaban}
    Click Element    ${button_luu}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hh}    ${nhom_hang}
    ...    0    ${total_giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

ecb2
    [Arguments]    ${ma_hh}     ${ten_hh}    ${giaban}    ${nhom_hang}    ${dict_tp}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${giaban_up}    ${list_num_tp_up}
    ${list_prs}    Get Dictionary Keys    ${dict_tp}
    ${list_num}    Get Dictionary Values    ${dict_tp}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add combo    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${list_prs[0]}    ${list_num[0]}   ${list_prs[1]}    ${list_num[1]}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost and onhand    none    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Click Element    ${tab_thanhphan_in_add_hh_page}
    ${total_giavon_up}    ${total_giaban_up}    Input list amount component product    ${list_prs}    ${list_num_tp_up}
    Assert total cost and sating price    ${total_giavon_up}    ${total_giaban_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s   Assert data in case create product    ${ma_hh}    ${ten_hanghoa_up}    ${nhom_hang_up}    0    ${total_giavon_up}    ${giaban_up}
    Delete product thr API    ${ma_hh}

ecb3
    [Arguments]    ${ma_hh}   ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${pr1}    ${num1}    ${pr2}
    ...    ${num2}
    Delete product if product is visible thr API       ${ma_hh}
    Reload Page
    Add combo    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${pr1}    ${num1}    ${pr2}    ${num2}
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
