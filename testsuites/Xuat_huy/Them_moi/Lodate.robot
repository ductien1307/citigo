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
&{pr_nums_thuong}    LD02=3.9    QD23=5

*** Test Cases ***    SP
Hoan thanh            [Tags]               EXL
                      [Template]           etxl_finished
                      [Documentation]   Tạo phiếu phiếu xuất hủy với hàng lodate > check thẻ kho
                      ${pr_nums_thuong}

Luu tam               [Tags]               EXL
                      [Template]           etxl_draft
                      [Documentation]   Tạo phiếu tạm phiếu xuất hủy với hàng lodate > check thẻ kho
                      ${pr_nums_thuong}

*** Keywords ***
etxl_finished
    [Arguments]    ${dict_pr_num}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${list_tenlo}    Import lot name for products by generating randomly    ${list_pr}    ${list_num}
    Sleep    10s
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}     Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr}    ${list_num}
    #
    Log    step UI
    KV Click Element    ${button_taophieu_xh}
    ${ma_phieu}    Generate code automatically    XH
    KV Input Text   ${textbox_xh_nhap_maphieu}    ${ma_phieu}
    Input list product and lot name to XH form    ${list_pr}    ${list_num}    ${list_tenlo}
    Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    Click Element     ${button_xh_hoanthanh}
    Damage doc message success validation    ${ma_phieu}
    #
    Log    validate API
    Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}    2
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_ton_cb_af_ex}
    Delete damage documentation thr API    ${ma_phieu}

etxl_draft
    [Arguments]    ${dict_pr_num}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${list_tenlo}    Import lot name for products by generating randomly    ${list_pr}    ${list_num}
    Sleep    10s
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}     Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr}    ${list_num}
    ${get_list_cost_bf_af}    ${get_list_onhand_thuong_bf}    Get list cost - onhand frm API    ${list_pr_cb}
    #
    Log    step UI
    KV Click Element    ${button_taophieu_xh}
    ${ma_phieu}    Generate code automatically    XH
    KV Input Text   ${textbox_xh_nhap_maphieu}    ${ma_phieu}
    Input list product and lot name to XH form    ${list_pr}    ${list_num}    ${list_tenlo}
    Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    Click Element     ${button_xh_luutam}
    Damage doc message success validation    ${ma_phieu}
    #
    Log    validate API
    Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}    1
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${get_list_onhand_thuong_bf}
    Delete damage documentation thr API    ${ma_phieu}
