*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Bang tinh luong and switch branch    Nhánh B
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../../core/Nhan_vien/bangtinhluong_list_action.robot
Resource          ../../../../core/API/api_bangtinhluong.robot
Resource          ../../../../core/API/api_nhanvien.robot
Resource          ../../../../core/API/api_chamcong.robot
Resource          ../../../../core/API/api_access.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/Share/computation.robot
Resource          ../../../../core/Share/toast_message.robot
Resource          ../../../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Library           DateTime

*** Variables ***
@{list_ca}        ca 1    ca 2
@{list_tong_gio_lv}    3    4
@{list_h_ve_som}    0    60
@{list_h_di_muon}    30    90
&{list_prs_num}    GHDV003=3    GHDV004=2
@{list_giamoi}    35000    60000

*** Test Cases ***
Hoa hồng 1 CN
    [Tags]      TS4
    [Template]    ethh1
    Nhánh B    NVtest26    user1    0986521456     45000    55000    0    Hoa hồng
    ...    ca 1    CTKH008    ${list_prs_num}    ${list_giamoi}    30000    100000    TK003

Hoa hồng nhiều CN
    [Tags]      TS4
    [Template]    ethh2
    Nhánh B    NVtest27    user2     0986547896     40000    50000    0    Hoa hồng
    ...    ca 1    CTKH008    ${list_prs_num}    ${list_giamoi}    30000    100000    TK003

Theo doanh thu
    [Tags]      TS4
    [Template]    ethh3
    Nhánh B    NVtest28    user3      0986597546    30000    70000    10000    VND
    ...    ca 1    CTKH008    ${list_prs_num}    ${list_giamoi}    30000    45000    TK003
    Nhánh B    NVtest29    user4    0986532546    40000    60000    10    % Doanh thu
    ...    ca 1    CTKH008    ${list_prs_num}    ${list_giamoi}    20000    45000    TK003

*** Keywords ***
ethh1
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_user}     ${input_sdt}    ${input_luong_theo_ca}    ${input_doanhthu}    ${input_giatri}
    ...    ${input_type}    ${input_ten_ca}    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}    ${input_thukhac}
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName    ${input_user}
    Run Keyword If    ${get_user_id}==0    Log    Ignore
    ...    ELSE    Delete user    ${get_user_id}
    Create new user    ${input_user}    ${input_user}    123    ${input_sdt}    Quản trị chi nhánh
    Add employee and set salary by shift and commission thr API    ${input_ma_nv}    ${input_ma_nv}    ${input_user}    ${input_branch}    ${input_luong_theo_ca}    ${input_doanhthu}
    ...    ${input_giatri}    ${input_type}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}    ${get_clocking_id}    ${get_timesheet_id}
    ${get_ma_hd}      Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code     ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}     ${input_user}    ${input_branch}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    #
    ${list_proudct}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}      Get Dictionary Values    ${dict_product_nums}
    ${list_value}    Get list commission value of list product by commission thr API    ${input_type}    ${list_proudct}
    ${doanhthuthuan}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${list_hoahong}    Create List
    : FOR    ${item_thanhtien}    ${item_giatri}    ${item_num}    IN ZIP    ${list_thanhtien_hh}    ${list_value}    ${list_nums}
    \    ${pbgg_sp}    Price after apllocate discount    ${result_gghd}    ${result_tongtienhang}    ${item_thanhtien}
    \    ${doanhthuthuan_sp}    Minus    ${item_thanhtien}    ${pbgg_sp}
    \    ${doanhthuthuan_sp}    Evaluate    round(${doanhthuthuan_sp},0)
    \    ${hoahong}    Run Keyword If    ${item_giatri}>1000    Multiplication      ${item_giatri}    ${item_num}
    \    ...    ELSE    Convert % discount to VND    ${item_giatri}    ${doanhthuthuan_sp}
    \    ${hoahong}    Evaluate    round(${hoahong},0)
    \    ${result_hoahong}    Set Variable If    ${doanhthuthuan}>${input_doanhthu}    ${hoahong}    0
    \    Append To List    ${list_hoahong}    ${result_hoahong}
    Log    ${list_hoahong}
    ${result_hoahong}    Sum values in list    ${list_hoahong}
    ${result_cantra}    Sum    ${input_luong_theo_ca}    ${result_hoahong}
    #
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}    ${get_luongchinh}    ${get_hoahong}    ${get_lamthem}    ${get_phucap}    ${get_giamtru}    ${get_datra}
    ...    ${get_cantra}    ${get_thuong}    Get pay sheet infor by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}    2
    Should Be Equal As Numbers    ${get_hoahong}    ${result_hoahong}
    Should Be Equal As Numbers    ${get_luongchinh}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_cantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}    0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ethh2
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_user}   ${input_sdt}    ${input_luong_theo_ca}    ${input_doanhthu}    ${input_giatri}
    ...    ${input_type}    ${input_ten_ca}    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}    ${input_thukhac}
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName    ${input_user}
    Run Keyword If    ${get_user_id}==0    Log    Ignore
    ...    ELSE    Delete user    ${get_user_id}
    Create new user    ${input_user}   ${input_user}    123    ${input_sdt}    Quản trị chi nhánh
    Add employee and set salary by shift and commission thr API    ${input_ma_nv}     ${input_ma_nv}    ${input_user}    ${input_branch}    ${input_luong_theo_ca}    ${input_doanhthu}
    ...    ${input_giatri}    ${input_type}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}    ${get_clocking_id}    ${get_timesheet_id}
    ${get_ma_hd}      Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code     ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}     ${input_user}    ${input_branch}
    ${get_ma_hd_cn}      Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code     ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}     ${input_user}    Nhánh A
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    #
    ${list_proudct}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}      Get Dictionary Values    ${dict_product_nums}
    ${list_value}    Get list commission value of list product by commission thr API    ${input_type}    ${list_proudct}
    ${doanhthuthuan}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${doanhthuthuan_all}      Multiplication    ${doanhthuthuan}    2
    ${list_hoahong}    Create List
    : FOR    ${item_thanhtien}    ${item_giatri}    ${item_num}    IN ZIP    ${list_thanhtien_hh}    ${list_value}    ${list_nums}
    \    ${pbgg_sp}    Price after apllocate discount    ${result_gghd}    ${result_tongtienhang}    ${item_thanhtien}
    \    ${doanhthuthuan_sp}    Minus    ${item_thanhtien}    ${pbgg_sp}
    \    ${doanhthuthuan_sp}    Evaluate    round(${doanhthuthuan_sp},0)
    \    ${hoahong}    Run Keyword If    ${item_giatri}>1000    Multiplication      ${item_giatri}    ${item_num}
    \    ...    ELSE    Convert % discount to VND    ${item_giatri}    ${doanhthuthuan_sp}
    \    ${hoahong}    Evaluate    round(${hoahong},0)
    \    ${result_hoahong}    Set Variable If    ${doanhthuthuan}>${input_doanhthu}    ${hoahong}    0
    \    Append To List    ${list_hoahong}    ${result_hoahong}
    Log    ${list_hoahong}
    ${result_hoahong}    Sum values in list    ${list_hoahong}
    ${result_hoahong}     Multiplication    ${result_hoahong}    2
    ${result_cantra}    Sum    ${input_luong_theo_ca}    ${result_hoahong}
    #
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}    ${get_luongchinh}    ${get_hoahong}    ${get_lamthem}    ${get_phucap}    ${get_giamtru}    ${get_datra}
    ...    ${get_cantra}    ${get_thuong}    Get pay sheet infor by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}    2
    Should Be Equal As Numbers    ${get_hoahong}    ${result_hoahong}
    Should Be Equal As Numbers    ${get_luongchinh}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_cantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}    0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ethh3
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_user}   ${input_sdt}    ${input_luong_theo_ca}    ${input_doanhthu}    ${input_giatri}
    ...    ${input_type}    ${input_ten_ca}    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}    ${input_thukhac}
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName    ${input_user}
    Run Keyword If    ${get_user_id}==0    Log    Ignore
    ...    ELSE    Delete user    ${get_user_id}
    Create new user    ${input_user}    ${input_user}    123    ${input_sdt}    Quản trị chi nhánh
    Add employee and set salary by shift and commission thr API    ${input_ma_nv}    ${input_ma_nv}    ${input_user}    ${input_branch}    ${input_luong_theo_ca}    ${input_doanhthu}
    ...    ${input_giatri}    ${input_type}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}    ${get_clocking_id}    ${get_timesheet_id}
    ${get_ma_hd}      Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code     ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}     ${input_user}    ${input_branch}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    #
    ${list_proudct}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}      Get Dictionary Values    ${dict_product_nums}
    ${list_value}    Get list commission value of list product by commission thr API    ${input_type}    ${list_proudct}
    ${doanhthuthuan}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${result_hoahong}    Run Keyword If    '${input_type}'=='VND'    Set Variable    ${input_giatri}    ELSE    Convert % discount to VND and round    ${doanhthuthuan}     ${input_giatri}
    ${result_hoahong}     Set Variable If    ${doanhthuthuan}>${input_doanhthu}    ${result_hoahong}    0
    ${result_cantra}    Sum    ${input_luong_theo_ca}    ${result_hoahong}
    #
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}    ${get_luongchinh}    ${get_hoahong}    ${get_lamthem}    ${get_phucap}    ${get_giamtru}    ${get_datra}
    ...    ${get_cantra}    ${get_thuong}    Get pay sheet infor by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}    2
    Should Be Equal As Numbers    ${get_hoahong}    ${result_hoahong}
    Should Be Equal As Numbers    ${get_luongchinh}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_cantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}    0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
