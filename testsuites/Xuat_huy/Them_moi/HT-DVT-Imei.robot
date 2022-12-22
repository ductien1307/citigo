*** Settings ***
Suite Setup       Setup Test Suite    Before Test Xuat Huy
Suite Teardown     After Test
Resource          ../../../core/API/api_xuathuy.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/xuat_huy_add_action.robot
Resource          ../../../core/Giao_dich/xuat_huy_list_action.robot
Library           SeleniumLibrary
Library           Collections

*** Variables ***
&{dict_pr}      XDVT03=6.5    XQD05=9     XT0001=5    XS0001=3

*** Test Cases ***    SP thường
Hoan thanh            [Tags]               EX     
                      [Template]           etxtu_finished
                      [Documentation]   Tạo phiếu xuất hủy với 3 loại hh (hàng thường, đơn vị tính, imei) > check thẻ kho
                      ${dict_pr}

Luu tam               [Tags]               EX
                      [Template]           etetu_draft
                      [Documentation]   Tạo phiếu tạm xuất hủy với 3 loại hh (hàng thường, đơn vị tính, imei) > check thẻ kho
                      ${dict_pr}

*** Keywords ***
etxtu_finished
    [Arguments]    ${dict_pr_num}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${get_list_imei_status}    Get list imei status thr API    ${list_pr}
    ${list_imei}     Import list imei for list product    ${list_pr}    ${list_num}    ${get_list_imei_status}
    Sleep    10s
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}     Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr}    ${list_num}
    #
    Log    step UI
    KV Click Element    ${button_taophieu_xh}
    ${ma_phieu}    Generate code automatically    XH
    KV Input data   ${textbox_xh_nhap_maphieu}    ${ma_phieu}
    Input list product - num in XH form      ${list_pr}    ${list_num}     ${get_list_imei_status}    ${list_imei}
    Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    Click Element     ${button_xh_hoanthanh}
    Damage doc message success validation    ${ma_phieu}
    #
    Log    validate API
    Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}    2
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_ton_cb_af_ex}
    Delete damage documentation thr API    ${ma_phieu}

etetu_draft
    [Arguments]    ${dict_pr_num}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${get_list_imei_status}    Get list imei status thr API    ${list_pr}
    ${list_imei}     Import list imei for list product    ${list_pr}    ${list_num}    ${get_list_imei_status}
    Sleep    10s
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}    Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr}    ${list_num}
    ${get_list_cost_bf_af}    ${get_list_onhand_thuong_bf}    Get list cost - onhand frm API    ${list_pr_cb}
    #
    Log    Step UI
    KV Click Element    ${button_taophieu_xh}
    ${ma_phieu}    Generate code automatically    XH
    KV Input Text    ${textbox_xh_nhap_maphieu}    ${ma_phieu}
    Input list product - num in XH form    ${list_pr}    ${list_num}    ${get_list_imei_status}    ${list_imei}
    Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    Click Element     ${button_xh_luutam}
    Damage doc message success validation    ${ma_phieu}
    #
    Log    validate API
    Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}    1
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${get_list_onhand_thuong_bf}
    Delete damage documentation thr API    ${ma_phieu}
