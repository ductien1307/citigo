*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Bang tinh luong and switch branch    Nhánh A
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../../core/Nhan_vien/bangtinhluong_list_action.robot
Resource          ../../../../core/API/api_bangtinhluong.robot
Resource          ../../../../core/API/api_nhanvien.robot
Resource          ../../../../core/API/api_chamcong.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_access.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/Share/computation.robot
Resource          ../../../../core/Share/toast_message.robot
Resource          ../../../../prepare/Hang_hoa/Sources/thietlap.robot
Library           Collections
Library           DateTime

*** Variables ***
&{list_prs_num}    GHDV003=3
@{list_giamoi}    35000



*** Test Cases ***
Basic               [Tags]    TS4
                    [Template]              ebtd01
                    Nhánh A   NVtest11    55000    ca 1      70000

Basic               [Tags]    TS4
                    [Template]              ebtd02
                    Nhánh A    NVtest12    hoang.le    40000    50000    0    Hoa hồng
                    ...    ca 1    CTKH008    ${list_prs_num}    ${list_giamoi}    30000    100000

Basic               [Tags]    TS4
                    [Template]              ebtd03
                    Nhánh A    NVtest13    55000    ca 1      Hàng tuần

*** Keywords ***
ebtd01
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}   ${input_luong_theo_ca_up}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    #
    Update employee and salary by shift thr API     ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca_up}    200    300     Tùy chọn
    Click element    ${button_chotluong}
    Wait Until Page Contains Element      ${button_dongy_thaydoi_bangluong}     20s
    Click element     ${button_dongy_thaydoi_bangluong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_datra}    ${get_cantra}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_cantra}     ${input_luong_theo_ca_up}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebtd02
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_user}    ${input_luong_theo_ca}    ${input_doanhthu}    ${input_giatri}
    ...    ${input_type}    ${input_ten_ca}    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}
    ${list_proudct}     Get Dictionary Keys    ${dict_product_nums}
    ${input_product}      Get From List     ${list_proudct}    0
    Setting commission value for all product for commission thr API      ${input_type}      ${input_product}      50000     VND    false
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName    ${input_user}
    Run Keyword If    ${get_user_id}==0    Log    Ignore
    ...    ELSE    Delete user    ${get_user_id}
    Create new user    Hoàng Lê    ${input_user}    123    0354965574    Quản trị chi nhánh
    Add employee and set salary by shift and commission thr API    ${input_ma_nv}    Hoa    ${input_user}    ${input_branch}    ${input_luong_theo_ca}    ${input_doanhthu}
    ...    ${input_giatri}    ${input_type}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}    ${get_clocking_id}    ${get_timesheet_id}
    ${get_ma_hd}    Add new invoice incase newprice with multi prouduct - payment by user    ${input_ma_kh}    ${input_user}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    none    ${input_khtt}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Setting commission value for all product for commission thr API      ${input_type}      ${input_product}      10     %    false
    Click element    ${button_chotluong}
    Wait Until Page Contains Element      ${button_dongy_thaydoi_bangluong}     20s
    Click element     ${button_dongy_thaydoi_bangluong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
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

ebtd03
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}   ${ky_han_traluong}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    #
    Update employee and salary by shift thr API     ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300     ${ky_han_traluong}
    Click element    ${button_chotluong}
    Wait Until Page Contains Element      ${button_dongy_thaydoi_bangluong}     20s
    Click element     ${button_dongy_thaydoi_bangluong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    Should Be Equal As Numbers    ${get_ma_phieu_luong}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
