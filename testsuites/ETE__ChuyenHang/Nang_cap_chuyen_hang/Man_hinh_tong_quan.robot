*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/Tong_quan/tongquan_page.robot
Resource          ../../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/API/api_chuyenhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot

*** Variables ***
&{ch_dict3}       HHCH02=5

*** Test Cases ***    Dict SP&SL     CN nhan        User name 2       Password 2
Noti Tong quan             [Tags]     NCCH
                      [Template]     noti
                      ${ch_dict3}    Nhánh A        mai.ht            123

Hyper link user             [Tags]
                      [Template]     hyperlink
                      ${ch_dict3}    Nhánh A

*** Keyword ***
noti
    [Arguments]    ${list_dict}    ${input_branchname}    ${input_username1}     ${input_password1}
    [Timeout]    10 minutes
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${list_prs}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${get_list_cost}    ${get_onhand}      Get list cost - onhand frm API    ${list_prs}
    ${list_thanhtien}     Create List
    :FOR      ${cost}     ${nums}      IN ZIP    ${get_list_cost}     ${list_nums}
    \       ${result_thanhtien}   Multiplication with price round 2    ${cost}     ${nums}
    \       Append To List    ${list_thanhtien}    ${result_thanhtien}
    ${tongtienhang}     Sum values in list    ${list_thanhtien}
    ${tongtienhang}     Replace floating point    ${tongtienhang}
    ${ma_phieuchuyen}    ${list_result_transferring_onhand}    ${list_result_received_onhand}   Add new transform frm API    ${get_current_branch_name}    ${input_branchname}
    ...    ${list_dict}
    Delete Transform code    ${ma_phieuchuyen}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    3 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    3 s    Login    ${USER_NAME}     ${PASSWORD}
    ## validate tong quan
    ${get_name}   Get name of user    ${USER_NAME}
    ${text_giatri}     Format String      với giá trị {0}    ${tongtienhang}
    ${cell_text_username}     Format String      ${cell_text_username}    Transfers    ${ma_phieuchuyen}
    ${cell_text_active}     Format String      ${cell_text_active}    Transfers
    ${cell_text_huy}     Format String      ${cell_text_huy_giaodich}    Transfers   ${ma_phieuchuyen}
    ${cell_text_giatri}     Format String      ${cell_text_giatri}    Transfers    ${ma_phieuchuyen}
    ### get text frm UI
    ${get_text_user_tranfer}    Get Text      ${cell_text_username}
    ${get_text_active_tranfer}    Get Text      ${cell_text_active}
    ${get_text_chuyenhang}    Get Text      ${cell_text_huy}
    ${get_text_giatri}    Get Text      ${cell_text_giatri}
    ${get_text_giatri}    Replace String    ${get_text_giatri}      ,       ${EMPTY}
    Should Be Equal As Strings    ${get_text_user_tranfer}    ${get_name}
    Should Be Equal As Strings    ${get_text_active_tranfer}    vừa
    Should Be Equal As Strings    ${get_text_chuyenhang}    hủy phiếu chuyển hàng
    Should Be Equal As Strings    ${get_text_giatri}    ${text_giatri}
    ### validate other user
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    3 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    3 s    Login    ${input_username1}     ${input_password1}
    ${cell_text_username}     Format String      ${cell_text_username}    Transfers    ${ma_phieuchuyen}
    ${cell_text_active}     Format String      ${cell_text_active}    Transfers
    ${cell_text_huy}     Format String      ${cell_text_huy_giaodich}    Transfers   ${ma_phieuchuyen}
    ${cell_text_giatri}     Format String      ${cell_text_giatri}    Transfers    ${ma_phieuchuyen}
    ${get_text_user_tranfer}    Get Text      ${cell_text_username}
    ${get_text_active_tranfer}    Get Text      ${cell_text_active}
    ${get_text_chuyenhang}    Get Text      ${cell_text_huy}
    Should Be Equal As Strings    ${get_text_user_tranfer}    ${get_name}
    Should Be Equal As Strings    ${get_text_active_tranfer}    vừa
    Should Be Equal As Strings    ${get_text_chuyenhang}    hủy phiếu chuyển hàng

hyperlink
    [Arguments]    ${list_dict}    ${input_branchname}    ${input_username}     ${input_password}
    [Timeout]    10 minutes
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${list_prs}    Get Dictionary Keys    ${list_dict}
    ${list_nums}    Get Dictionary Values    ${list_dict}
    ${get_list_cost}    ${get_onhand}      Get list cost - onhand frm API    ${list_prs}
    ${list_thanhtien}     Create List
    :FOR      ${cost}     ${nums}      IN ZIP    ${get_list_cost}     ${list_nums}
    \       ${result_thanhtien}   Multiplication with price round 2    ${cost}     ${nums}
    \       Append To List    ${list_thanhtien}    ${result_thanhtien}
    ${tongtienhang}     Sum values in list    ${list_thanhtien}
    ${tongtienhang}     Replace floating point    ${tongtienhang}
    ${ma_phieuchuyen}    ${list_result_transferring_onhand}    ${list_result_received_onhand}   Add new transform with other user   ${get_current_branch_name}    ${input_branchname}
    ...    ${list_dict}   ${input_username}     ${input_password}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    3 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    3 s    Login    ${input_username}     ${input_password}
    ## validate tong quan
    ${cell_text_username}     Format String      ${cell_text_username}    Transfers    ${ma_phieuchuyen}
    Wait Until Element Is Visible     ${cell_text_username}
    Click Element JS     ${cell_text_username}
