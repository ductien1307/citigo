*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/API/api_nhanvien.robot
Resource         ../../../core/API/api_chamcong.robot
Library          DateTime

*** Variables ***

*** Test Cases ***
Update branch 1       [Documentation]     Cập nhật trường ngày làm việc của chi nhánh  từ làm việc sang ngày nghỉ - nv chưa chấm công - có hủy lịch làm việc
                      [Tags]      TL      TSF
                      [Template]    ecn1
                      0917534679       1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo        9:00      10:00      NVCN001

Update branch 2       [Documentation]     Cập nhật trường ngày làm việc của chi nhánh  từ làm việc sang ngày nghỉ - nv chưa chấm côn - không hủy lịch lamv việc
                      [Tags]      TL      TSR
                      [Template]    ecn2
                      0917666789    1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo        9:00      10:00         NVCN002

Update branch 3       [Documentation]     Cập nhật trường ngày làm việc của chi nhánh  từ làm việc sang ngày nghỉ - nv đã chấm công - có hủy lịch làm việc
                      [Tags]      TL       TSR
                      [Template]    ecn3
                      0917776789       1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo        9:00      10:00      NVCN003

Update branch 4       [Documentation]     Cập nhật trường ngày làm việc của chi nhánh  từ làm việc sang ngày nghỉ - nv đã chấm côn - không hủy lịch lamv việc
                      [Tags]      TL       TSR
                      [Template]    ecn4
                      0917588789       1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo        9:00      10:00      NVCN004

*** Keywords ***
ecn1
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}       ${input_gio_bd}     ${input_gio_kt}    ${ma_nv}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_branch}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    ${input_ten_ca}     Generate Random String    5    [UPPER][NUMBERS]
    Create new branch    ${input_branch}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Delete employee if it exists thr API    ${ma_nv}
    Sleep    3s
    Add employee thr API    ${ma_nv}    Linh    ${input_branch}
    Add new shift    ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${ma_nv}
    Sleep    2s
    ${get_clocking_status_bf}     Get clocking status thr API      ${input_branch}
    Should Be Equal As Strings    ${get_clocking_status_bf}    1
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_branch}
    ${get_day}       Get Current Date      result_format=%A
    ${ngay_nghi}      Run Keyword If    '${get_day}'=='Monday'    Set Variable    T2     ELSE IF    '${get_day}'=='Tuesday'    Set Variable    T3      ELSE IF    '${get_day}'=='Wednesday'    Set Variable    T4      ELSE IF    '${get_day}'=='Thursday'    Set Variable    T5    ELSE IF    '${get_day}'=='Friday'    Set Variable    T6        ELSE IF    '${get_day}'=='Saturday'    Set Variable    T7      ELSE      Set Variable    CN
    ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${ngay_nghi}
    Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Wait Until Page Contains Element    ${button_co_huy_lich_lv}    30s
    Click Element     ${button_co_huy_lich_lv}
    ${get_cur_day}       Get Current Date
    ${ngay_ap_dung}       Subtract Time From Date   ${get_cur_day}    2 day        result_format=%d%m%Y
    ${ngay_ap_dung}   Convert To String    ${ngay_ap_dung}
    Input data      ${textbox_apdung_tungay}      ${ngay_ap_dung}
    Click Element       ${button_dongy_thaydoi}
    #Run Keyword If    '${URL}'=='https://fnb.kiotviet.vn'   Log    Ignore     ELSE    Branch message create validation
    ${get_branch_id}    Wait Until Keyword Succeeds    3x    3s    Assert get branch id succeed    ${input_branch}
    Sleep    2s
    ${get_clocking_status_af}     Get clocking status thr API      ${input_branch}
    Should Be Equal As Strings    ${get_clocking_status_af}    0
    Delete Branch    ${get_branch_id}

ecn2
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}       ${input_gio_bd}     ${input_gio_kt}    ${ma_nv}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_branch}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    ${input_ten_ca}     Generate Random String    5    [UPPER][NUMBERS]
    Create new branch    ${input_branch}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Delete employee if it exists thr API    ${ma_nv}
    Sleep    3s
    Add employee thr API    ${ma_nv}    Linh    ${input_branch}
    Add new shift    ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${ma_nv}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_branch}
    ${get_day}       Get Current Date      result_format=%A
    ${ngay_nghi}      Run Keyword If    '${get_day}'=='Monday'    Set Variable    T2     ELSE IF    '${get_day}'=='Tuesday'    Set Variable    T3      ELSE IF    '${get_day}'=='Wednesday'    Set Variable    T4      ELSE IF    '${get_day}'=='Thursday'    Set Variable    T5    ELSE IF    '${get_day}'=='Friday'    Set Variable    T6        ELSE IF    '${get_day}'=='Saturday'    Set Variable    T7      ELSE      Set Variable    CN
    ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${ngay_nghi}
    Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Wait Until Page Contains Element    ${button_co_huy_lich_lv}    30s
    ${get_cur_day}       Get Current Date
    ${ngay_ap_dung}       Subtract Time From Date   ${get_cur_day}    2 day        result_format=%d%m%Y
    ${ngay_ap_dung}   Convert To String    ${ngay_ap_dung}
    Input data      ${textbox_apdung_tungay}      ${ngay_ap_dung}
    Click Element       ${button_dongy_thaydoi}
    #Run Keyword If    '${URL}'=='https://fnb.kiotviet.vn'   Log    Ignore     ELSE    Branch message create validation
    ${get_branch_id}    Wait Until Keyword Succeeds    3x    3s    Assert get branch id succeed    ${input_branch}
    Sleep    2s
    ${get_clocking_status_af}     Get clocking status thr API      ${input_branch}
    Should Be Equal As Strings       ${get_clocking_status_af}    1
    Delete Branch    ${get_branch_id}

ecn3
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}       ${input_gio_bd}     ${input_gio_kt}      ${ma_nv}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_branch}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    ${input_ten_ca}     Generate Random String    5    [UPPER][NUMBERS]
    Create new branch    ${input_branch}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Delete employee if it exists thr API    ${ma_nv}
    Sleep    3s
    Add employee thr API    ${ma_nv}    Linh    ${input_branch}
    Add new shift    ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${ma_nv}
    Update not timekeeping to timekeeping thr API     ${input_branch}     ${input_ten_ca}    ${ma_nv}      ${get_clocking_id}   ${get_timesheet_id}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_branch}
    ${get_day}       Get Current Date      result_format=%A
    ${ngay_nghi}      Run Keyword If    '${get_day}'=='Monday'    Set Variable    T2     ELSE IF    '${get_day}'=='Tuesday'    Set Variable    T3      ELSE IF    '${get_day}'=='Wednesday'    Set Variable    T4      ELSE IF    '${get_day}'=='Thursday'    Set Variable    T5    ELSE IF    '${get_day}'=='Friday'    Set Variable    T6        ELSE IF    '${get_day}'=='Saturday'    Set Variable    T7      ELSE      Set Variable    CN
    ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${ngay_nghi}
    Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Wait Until Page Contains Element    ${button_co_huy_lich_lv}    30s
    Click Element     ${button_co_huy_lich_lv}
    ${get_cur_day}       Get Current Date
    ${ngay_ap_dung}       Subtract Time From Date   ${get_cur_day}    2 day        result_format=%d%m%Y
    ${ngay_ap_dung}   Convert To String    ${ngay_ap_dung}
    Input data      ${textbox_apdung_tungay}      ${ngay_ap_dung}
    Click Element       ${button_dongy_thaydoi}
    #Run Keyword If    '${URL}'=='https://fnb.kiotviet.vn'   Log    Ignore     ELSE    Branch message create validation
    ${get_branch_id}    Wait Until Keyword Succeeds    3x    3s    Assert get branch id succeed    ${input_branch}
    Sleep    2s
    ${get_clocking_status_af}     Get clocking status thr API      ${input_branch}
    Should Be Equal As Strings    ${get_clocking_status_af}    3
    Delete Branch    ${get_branch_id}

ecn4
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}       ${input_gio_bd}     ${input_gio_kt}      ${ma_nv}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_branch}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    ${input_ten_ca}     Generate Random String    5    [UPPER][NUMBERS]
    Create new branch    ${input_branch}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Delete employee if it exists thr API    ${ma_nv}
    Sleep    3s
    Add employee thr API    ${ma_nv}    Linh    ${input_branch}
    Add new shift    ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${ma_nv}
    Update not timekeeping to timekeeping thr API     ${input_branch}     ${input_ten_ca}    ${ma_nv}        ${get_clocking_id}   ${get_timesheet_id}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_branch}
    ${get_day}       Get Current Date      result_format=%A
    ${ngay_nghi}      Run Keyword If    '${get_day}'=='Monday'    Set Variable    T2     ELSE IF    '${get_day}'=='Tuesday'    Set Variable    T3      ELSE IF    '${get_day}'=='Wednesday'    Set Variable    T4      ELSE IF    '${get_day}'=='Thursday'    Set Variable    T5    ELSE IF    '${get_day}'=='Friday'    Set Variable    T6        ELSE IF    '${get_day}'=='Saturday'    Set Variable    T7      ELSE      Set Variable    CN
    ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${ngay_nghi}
    Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Wait Until Page Contains Element    ${button_co_huy_lich_lv}    30s
    ${get_cur_day}       Get Current Date
    ${ngay_ap_dung}       Subtract Time From Date   ${get_cur_day}    2 day        result_format=%d%m%Y
    ${ngay_ap_dung}   Convert To String    ${ngay_ap_dung}
    Input data      ${textbox_apdung_tungay}      ${ngay_ap_dung}
    Click Element       ${button_dongy_thaydoi}
    #Run Keyword If    '${URL}'=='https://fnb.kiotviet.vn'   Log    Ignore     ELSE    Branch message create validation
    ${get_branch_id}    Wait Until Keyword Succeeds    3x    3s    Assert get branch id succeed    ${input_branch}
    Sleep    2s
    ${get_clocking_status_af}     Get clocking status thr API      ${input_branch}
    Should Be Equal As Strings       ${get_clocking_status_af}    3
    Delete Branch    ${get_branch_id}
