*** Settings ***
Suite Setup       Setup Test Suite    Before Test Inventory Transfer
Suite Teardown    After Test
Resource          ../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/API/api_chuyenhang.robot

*** Variables ***
&{ch_dict1}       PIB10020=7.6    QDC008=11    SIM001=3
&{ch_dict2}       PIB10021=7.6    QDC009=11    SIM002=3
&{ch_dict2_change_receive}    PIB10021=5    QDC009=6.5    SIM002=2


*** Test Cases ***    Dict SP&SL     CN Nhan             Thay doi SL nhan              Ghi chú
ChuyenHang_Hoanthanh
                      [Tags]         ECT      GOLIVE2
                      [Template]     etech_nor_finished
                      ${ch_dict1}    Nhánh A

Nhan 1 phan           [Tags]         ECT
                      [Template]     etech_nor_apart
                      ${ch_dict2}    Nhánh A            ${ch_dict2_change_receive}    chỉ nhận 1 phần

Chua nhan             [Tags]         ECT
                      [Template]     etech_nor_notfinish
                      ${ch_dict1}    Nhánh A

Khong nhan hang       [Tags]         ECT
                      [Template]     etech_nor_cancel
                      ${ch_dict2}    Nhánh A

*** Keyword ***
etech_nor_finished
    [Arguments]    ${list_dict}    ${input_branchname}
    [Documentation]    Chuyển hàng với 3 loại hàng hóa: hàng thường, imei, đơn vị tính. CN nhận nhận hết hàng
    ...    - Validate UI tồn kho của CN nhận và CN chuyển
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    ${list_pr}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${get_list_imei_status}    Get list imei status thr API    ${list_pr}
    ${list_imei}     Import list imei for list product    ${list_pr}    ${list_nums}    ${get_list_imei_status}
    Sleep    5s
    ${result_tong_gt_chuyen}     ${list_result_onhand_source}    ${list_result_onhand_target}      ${list_result_num_cb}   ${source_list_onhand_bf_trans}   ${target_list_onhand_bf_rev}     Get total, onhand af transfer finish     ${list_pr}
    ...   ${list_pr_cb}      ${list_nums}     ${input_branchname}
    #
    Log    Step UI
    Wait Until Keyword Succeeds    3 times    1s    Go To Inventory Transfer form
    Input inventory transfer code    ${ma_phieuchuyen}
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${lastest_num}    Input list products and nums to Inventory transfer form    ${list_pr}    ${list_nums}     ${input_branchname}    ${source_list_onhand_bf_trans}   ${target_list_onhand_bf_rev}     ${get_list_imei_status}    ${list_imei}
    Click Element    ${button_ch_hoanthanh}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Accept transferring proccess    ${ma_phieuchuyen}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    ##
    Log    validate tồn kho của chi nhánh chuyển và nhận
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_onhand_source}
    Assert list of Onhand after execute by branch     ${list_pr_cb}     ${list_result_onhand_target}    ${input_branchname}
    Assert transfer infor    ${ma_phieuchuyen}    ${lastest_num}     ${result_tong_gt_chuyen}    ${lastest_num}     ${result_tong_gt_chuyen}    Đã nhận
    Delete Transform code    ${ma_phieuchuyen}

etech_nor_apart
    [Arguments]    ${list_dict}    ${input_branchname}    ${list_changed_num}    ${input_note}
    [Documentation]    Chuyển hàng với 3 loại hàng hóa: hàng thường, imei, đơn vị tính. CN nhận nhận 1 phần
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    ${get_current_branch_name}    Get current branch name
    ${list_pr}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${list_num_changes}    Get Dictionary Values    ${list_changed_num}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${get_list_imei_status}    Get list imei status thr API    ${list_pr}
    #
    ${ma_phieuchuyen}   Add new basic transform frm API    ${get_current_branch_name}    ${input_branchname}    ${list_dict}
    Sleep    5s
    ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}    ${result_tong_sl_nhan}    ${result_tong_gt_nhan}   ${list_result_onhand_source}    ${list_result_onhand_target}       Get total, onhand af transfer a part     ${list_pr}
    ...   ${list_pr_cb}     ${list_nums}    ${list_num_changes}     ${input_branchname}
    #
    ${list_del_imei}   Get list imei del to transfer    ${imei_inlist}    ${list_num_changes}    ${get_list_imei_status}
    #
    Log    Step UI
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Accept transferring proccess with A part and adding note     ${ma_phieuchuyen}   ${list_pr}   ${list_num_changes}    ${list_del_imei}    ${get_list_imei_status}   ${input_note}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    ##
    Log    validate tồn kho của chi nhánh chuyển và nhận
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_onhand_source}
    Assert list of Onhand after execute by branch     ${list_pr_cb}     ${list_result_onhand_target}    ${input_branchname}
    Assert transfer infor    ${ma_phieuchuyen}    ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}    ${result_tong_sl_nhan}    ${result_tong_gt_nhan}     Đã nhận
    Delete Transform code    ${ma_phieuchuyen}


etech_nor_notfinish
    [Arguments]    ${list_dict}    ${input_branchname}
    [Documentation]    Chuyển hàng với 3 loại hàng hóa: hàng thường, imei, đơn vị tính. CN nhận chưa nhận hàng
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    ${get_current_branch_name}    Get current branch name
    ${list_pr}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    #
    ${ma_phieuchuyen}   Add new basic transform frm API    ${get_current_branch_name}    ${input_branchname}    ${list_dict}
    Sleep    5s
    ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}     ${list_result_onhand_source}    ${list_result_onhand_target}     Get total, onhand af transfer not finish      ${list_pr}
    ...   ${list_pr_cb}      ${list_nums}     ${input_branchname}
    #
    Log    Step UI
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Assert values Transfer form in Target branch    ${ma_phieuchuyen}    Đang chuyển    ${get_current_branch_name}    ${input_branchname}
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    ##
    Log    validate tồn kho của chi nhánh chuyển và nhận
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_onhand_source}
    Assert list of Onhand after execute by branch     ${list_pr_cb}     ${list_result_onhand_target}    ${input_branchname}
    Assert transfer infor    ${ma_phieuchuyen}    ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}   0    0   Đang chuyển
    Delete Transform code    ${ma_phieuchuyen}

etech_nor_cancel
    [Arguments]    ${list_dict}    ${input_branchname}
    [Documentation]    Chuyển hàng với 3 loại hàng hóa: hàng thường, imei, đơn vị tính. CN nhận hủy phiếu chuyển hàng
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    ${get_current_branch_name}    Get current branch name
    ${list_pr}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    #
    ${ma_phieuchuyen}   Add new basic transform frm API    ${get_current_branch_name}    ${input_branchname}    ${list_dict}
    Sleep    5s
    ${list_result_onhand_source}    ${list_result_onhand_target}    Get total, onhand af transfer cancel     ${list_pr}   ${list_pr_cb}   ${list_nums}    ${input_branchname}
    #
    Log    Step UI
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Cancel transferring proccess    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3x    0.5s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    ##
    Log    validate tồn kho của chi nhánh chuyển và nhận
    Assert list of Onhand after execute until succeed     ${list_pr_cb}      ${list_result_onhand_source}
    Assert list of Onhand after execute by branch     ${list_pr_cb}     ${list_result_onhand_target}    ${input_branchname}
