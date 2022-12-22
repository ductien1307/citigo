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
@{list_tt_1}      xanh    đỏ    tím

*** Test Cases ***    Mã hh         Tên           Nhóm       Giá vốn    Giá bán    Tồn kho    Thuộc tính      Giá trị TT
Thêm mới              [Tags]        EP
                      [Template]    ett1
                      [Documentation]   Thêm mới hàng có thuộc tính
                      HTT00001    GreenCross    Dịch vụ    80000      60000      2               MÀU           ${list_tt_1}

Cập nhật              [Tags]        EP
                      [Template]    ett2
                      [Documentation]   Cập nhật hàng có thuộc tính
                      HTT00002      GreenCross    Dịch vụ    80000      MÀU        ${list_tt_1}    Dầu gội       Dịch vụ         50000    10

Xóa                   [Tags]
                      [Template]    ett3
                      [Documentation]   Xóa hàng có thuộc tính
                      GreenCross    Dịch vụ    80000      60000      2               MÀU           ${list_tt_1}

*** Keywords ***
ett1
    [Arguments]    ${ma_hh}   ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${attr}
    ...    ${list_attr}
    ${list_pr_del}      Create List    ${ma_hh}   ${ma_hh}-1    ${ma_hh}-2
    Delete list product if list product is visible thr API       ${list_pr_del}
    Log    Step UI
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Input attributes in Them hang hoa form    ${attr}    ${list_attr}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Log    validate API
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa} - ${list_attr[0]}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    ${list_hang_thuoc_tinh_actual}   Assert count of attribute product and return list attribute product     ${ma_hh}    ${list_attr}
    Assert data in case create list attribute product    ${list_hang_thuoc_tinh_actual}   ${ten_hanghoa}   ${nhom_hang}    ${tonkho}    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}
    Delete list product if list product is visible thr API       ${list_hang_thuoc_tinh_actual}

ett2
    [Arguments]    ${ma_hh}   ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${attr}    ${list_attr}    ${ten_hanghoa_up}
    ...    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    ${list_pr_del}      Create List    ${ma_hh}   ${ma_hh}-1    ${ma_hh}-2
    Delete list product if list product is visible thr API       ${list_pr_del}
    Reload Page
    Go to Them moi Hang Hoa
    Input code, name, cost, category in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${giavon}    ${nhom_hang}
    Input attributes in Them hang hoa form    ${attr}    ${list_attr}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    #get sp thuoc tinh
    ${get_list_hh_thuoc_tinh}    Get product code from MasterProductId    ${ma_hh}
    ${list_hang_thuoc_tinh_actual}    Create List
    : FOR    ${item_hh}    IN ZIP    ${get_list_hh_thuoc_tinh}
    \    ${item_hh}    Replace sq blackets    ${item_hh}
    \    Append To List    ${list_hang_thuoc_tinh_actual}    ${item_hh}
    Log    ${list_hang_thuoc_tinh_actual}
    #
    Search product code    ${ma_hh}
    KV Click Element By Code    ${cell_mahang}    ${ma_hh}
    Wait Until Page Contains Element    ${button_capnhat_hh}    15s
    Wait Until Keyword Succeeds    3 times    3s    Access update product popup
    Input data in Them hang hoa form without cost    none    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    Click Element    ${button_luu}
    Update data success validation

    Log    validate API
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa_up} - ${list_attr[0]}    ${nhom_hang}
    ...    ${tonkho_up}    ${giavon}    ${giaban_up}
    ${list_hang_thuoc_tinh_actual}   Assert count of attribute product and return list attribute product      ${ma_hh}    ${list_attr}
    Assert data in case create list attribute product    ${list_hang_thuoc_tinh_actual}   ${ten_hanghoa}   ${nhom_hang}    0    ${giavon}    0
    Delete product thr API    ${ma_hh}
    Delete list product if list product is visible thr API       ${list_hang_thuoc_tinh_actual}

ett3
    [Arguments]    ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${attr}
    ...    ${list_attr}
    [Timeout]
    Go to Them moi Hang Hoa
    ${ma_hh}    Generate code automatically    HHT
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Input attributes in Them hang hoa form    ${attr}    ${list_attr}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Sleep    2s
    #get sp thuoc tinh
    ${get_list_hh_thuoc_tinh}    Get product code from MasterProductId    ${ma_hh}
    ${list_hang_thuoc_tinh_actual}    Create List
    : FOR    ${item_hh}    IN ZIP    ${get_list_hh_thuoc_tinh}
    \    ${item_hh}    Replace sq blackets    ${item_hh}
    \    Append To List    ${list_hang_thuoc_tinh_actual}    ${item_hh}
    Log    ${list_hang_thuoc_tinh_actual}
    #
    Search product code    ${ma_hh}
    KV Click Element By Code    ${cell_mahang}    ${ma_hh}
    Delete product
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
    Delete list product if list product is visible thr API       ${list_hang_thuoc_tinh_actual}
