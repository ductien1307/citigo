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
@{dict_pr}      XT0001
@{dict_num}      5

*** Test Cases ***    SP thường
Hoan thanh            [Tags]               TCG
                      [Template]           Tao phieu xuat huy
                      [Documentation]   Tạo phiếu xuất hủy với 3 loại hh (hàng thường, đơn vị tính, imei) > check thẻ kho
                      ${dict_pr}    ${dict_num}

*** Keywords ***
Tao phieu xuat huy
    [Arguments]    ${list_pr}   ${list_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}     Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr}    ${list_num}
    ${ma_phieu}    Generate code automatically    XH

    Given Create damage documentation
    When Input damage number    ${ma_phieu}
    And Input product ${list_pr} and number ${list_num}
    Then Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    When Click complete
    Then Damage doc message success validation    ${ma_phieu}
    And Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}    2
    And Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_ton_cb_af_ex}

    Delete damage documentation thr API    ${ma_phieu}

Create damage documentation
    KV Click Element    ${button_taophieu_xh}

Input damage number
    [Arguments]     ${ma_phieu}
    KV Input data   ${textbox_xh_nhap_maphieu}    ${ma_phieu}

Click complete
    Click Element     ${button_xh_hoanthanh}

Input product ${list_pr} and number ${list_num}
    : FOR    ${item_pr}    ${item_num}       IN ZIP    ${list_pr}    ${list_num}
    \    Input product - num in XH form    ${item_pr}    ${item_num}
