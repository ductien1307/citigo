*** Settings ***
Suite Setup       Setup Test Suite    Before Test Xuat Huy
Suite Teardown     After Test
Resource          ../../../core/API/api_xuathuy.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/xuat_huy_add_action.robot
Resource          ../../../core/Hang_Hoa/sanxuat_list_action.robot
Library           SeleniumLibrary
Library           Collections
Resource          ../../../core/Giao_dich/xuat_huy_list_action.robot

*** Variables ***
&{dict_tao}       NHP006=4    NHP007=6    NQD01=11
&{dict_sua}       NHP006=9    NHP007=0    NQD01=7      LD12=3    QD27=4

*** Test Cases ***    Tạo mới        Cập nhật
Cap nhat              [Tags]         EXL    
                      [Template]     etxi_capnhat
                      [Documentation]   Cập nhật phiếu xuất hủy với hàng lodate > check thẻ kho
                      ${dict_tao}    ${dict_sua}

*** Keywords ***
etxi_capnhat
    [Arguments]    ${dict_create}    ${dict_update}
    ${list_pr}    Get Dictionary Keys    ${dict_create}
    ${list_pr_update}    Get Dictionary Keys    ${dict_update}
    ${list_num_update}    Get Dictionary Values    ${dict_update}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr_update}
    ${get_list_lodate_status}    Get list lodate status thr API    ${list_pr_update}
    ${list_tenlo}    Import lot name for products by list all type product    ${list_pr_update}    ${list_num_update}   ${get_list_lodate_status}
    Sleep    10s
    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_ton_cb_af_ex}    ${list_actual_num_cb}     Get total - result onhand af damage    ${list_pr_cb}
    ...    ${list_pr_update}    ${list_num_update}
    ${ma_phieu}    Add new damage documentation with multi product    ${dict_create}

    Log    step UI
    Reload Page
    Search damage code and click open    ${ma_phieu}
    Edit lodate product detail in XH form   ${list_pr}    ${list_pr_update}    ${list_num_update}    ${get_list_lodate_status}   ${list_tenlo}
    Validate Tong gia tri huy in XH form    ${result_tong_gt_huy}
    Click Element     ${button_xh_hoanthanh}
    Damage doc message success validation    ${ma_phieu}
    #
    Log    validate API
    Assert damage documentation infor until susseed     ${ma_phieu}    ${result_tong_sl_huy}    ${result_tong_gt_huy}   2
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_ton_cb_af_ex}
    Delete damage documentation thr API    ${ma_phieu}
