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
Resource          ../../core/api/api_sanxuat.robot

*** Variables ***
&{dict_prs}       NHP020=3    NHP021=6
@{list_num_up}    7    5

*** Test Cases ***    Ma HH         HH TP1    HH TP2
Thêm mới              [Tags]        EP
                      [Template]    esx1
                      [Documentation]   Thêm mới hàng sản xuất
                      SXAT0001      oremere       800000    5            Đồ ăn vặt      ${dict_prs}

Cập nhật              [Tags]        EP
                      [Template]    esx2
                      [Documentation]   Cập nhật hàng sản xuất
                      SXAT0002      oremere       800000    Đồ ăn vặt    ${dict_prs}       cde            Dịch vụ    4555    ${list_num_up}

Xóa                   [Tags]
                      [Template]    esx3
                      [Documentation]   Xóa hàng sản xuất
                      SXAT0004      oremere       800000    5            Đồ ăn vặt      ${dict_prs}

*** Keyword ***
esx1
    [Arguments]    ${ma_hh}   ${ten_hh}    ${giaban}    ${ton}    ${nhom_hang}    ${dict_tp}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    ${list_prs}    Get Dictionary Keys    ${dict_tp}
    ${list_num}    Get Dictionary Values    ${dict_tp}
    Input data in Them hang hoa form without cost    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${ton}
    KV Click Element    ${tab_thanhphan_in_add_hh_page}
    ${total_giavon}    ${total_giaban}    Input list component product    ${list_prs}    ${list_num}
    Assert total cost and sating price    ${total_giavon}    ${total_giaban}
    Click Element    ${button_luu}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hh}    ${nhom_hang}
    ...    ${ton}    ${total_giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

esx2
    [Arguments]    ${ma_hh}   ${ten_hh}    ${giaban}    ${nhom_hang}    ${dict_tp}     ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${giaban_up}    ${list_num_tp_up}
    ${list_prs}    Get Dictionary Keys    ${dict_tp}
    ${list_num}    Get Dictionary Values    ${dict_tp}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product manufacturing    ${ma_hh}   ${ten_hh}    ${nhom_hang}    ${giaban}    0    ${list_prs[0]}    ${list_num[0]}    ${list_prs[1]}    ${list_num[1]}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost and onhand    none    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Click Element    ${tab_thanhphan_in_add_hh_page}
    ${total_giavon_up}    ${total_giaban_up}    Input list amount component product    ${list_prs}    ${list_num_tp_up}
    Wait Until Keyword Succeeds    3 times    1s    Assert total cost and sating price    ${total_giavon_up}    ${total_giaban_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    0    0    ${giaban_up}
    Delete product thr API    ${ma_hh}

esx3
    [Arguments]    ${ma_hh}   ${ten_hh}    ${giaban}    ${ton}    ${nhom_hang}    ${dict_tp}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product manufacturing    ${ma_hh}   ${ten_hh}    ${nhom_hang}    ${giaban}    0    ${list_prs[0]}    ${list_num[0]}    ${list_prs[1]}    ${list_num[1]}
    Search product code    ${ma_hh}
    Delete product
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
