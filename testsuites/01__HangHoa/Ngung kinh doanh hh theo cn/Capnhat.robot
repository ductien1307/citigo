*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown    After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***    Mã hh            Tên           Nhóm
Ngung kd tren toan ht        [Tags]       EP1     
                      [Template]       enkd1
                      [Documentation]   Ngừng kinh doanh hh trên toàn hệ thống > kiểm tra tab thành phần ko được hiện hàng hóa
                      HTKDAT0001         ABC       Dịch vụ

Ngung kd theo CN             [Tags]       EP1
                      [Template]       enkd2
                      [Documentation]   Ngừng kinh doanh hh theo CN > sang CN khác > kiểm tra tab thành phần vẫn hiện được hàng hóa
                      HTKDAT0002         CDE       Dịch vụ

Cho phep kd lai            [Tags]         EP1
                      [Template]       enkd3
                      [Documentation]   Cho phép kinh doanh lại hàng hóa
                      HTKDAT0003         CDE       Dịch vụ

*** Keywords ***
enkd1
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API       ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Search product code    ${ma_hh}
    Set Ngung Kinh Doanh all branch
    Assert active product by branch    Chi nhánh trung tâm   ${ma_hh}    False
    Go to Them moi Combo
    KV Click Element    ${tab_thanhphan_in_add_hh_page}
    KV Input text    ${textbox_hanghoa_thanhphan}    ${ma_hh}
    Sleep    3s
    Wait Until Page Contains Element     //div[@class="autoNotFound"]    30 s
    Element Should Contain    //div[@class="autoNotFound"]    Không tìm thấy kết quả nào phù hợp
    Delete product thr API    ${ma_hh}

enkd2
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Search product code    ${ma_hh}
    Set Ngung Kinh Doanh by Branch    Nhánh A
    Assert active product by branch    Nhánh A    ${ma_hh}    False
    Go to Them moi Combo
    KV Click Element    ${tab_thanhphan_in_add_hh_page}
    Wait Until Element Is Visible    ${textbox_hanghoa_thanhphan}     20s
    ${cell_tp_masp}    Format String    //td[text()='{0}']    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_hanghoa_thanhphan}    ${ma_hh}    ${cell_sanpham}
    ...    ${cell_tp_masp}
    Delete product thr API    ${ma_hh}
    Reload Page

enkd3
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API   ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Set inactive for poduct thr API     ${ma_hh}
    Reload Page
    Click Element    ${checkbox_filter_hang_ngung_kd}
    Search product code    ${ma_hh}
    KV Click Element     ${button_cho_phep_kd}
    KV CLick element     ${button_dongy_ngung_kd}
    Assert active product by branch    Chi nhánh trung tâm    ${ma_hh}     True
    Delete product thr API    ${ma_hh}
