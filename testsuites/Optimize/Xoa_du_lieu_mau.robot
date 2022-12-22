*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Dang Ky Shop Moi    ${remote}
Test Teardown     After Test
Library           String
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/Dang_ky_moi/dangkymoi_action.robot
Resource          ../../config/envi.robot
Resource          ../../core/Thiet_lap/thiet_lap_nav.robot

*** Test Cases ***      Tên ngành hàng    Họ tên      Sđt              Account     Password    Phường xã           Địa chỉ     Mã SP
Xoa du lieu mau            [Tags]            OPT
                      [Template]    del_dulieumau
                      Tạp hóa         autotest       0987654321        admin         123      Quận Hoàng Mai      Hà Nội      SP000023


*** Keyword ***
del_dulieumau
    [Arguments]    ${input_nganh_hang}    ${input_ho_ten}    ${input_sdt}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}    ${input_ma_sp}
    ${get_ten_cuahang}    Generate Random String    10    [NUMBERS][LOWER]
    Click Element JS    ${button_dky_dung_thu_mien_phi}
    ${button_nganh_hang}    Format String    ${button_nganh_hang}    ${input_nganh_hang}
    Wait Until Page Contains Element    ${button_nganh_hang}    30s
    Click Element JS    ${button_nganh_hang}
    Input informations in popup Tao tai khoan KiotViet    ${input_ho_ten}    ${input_sdt}    ${get_ten_cuahang}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}
    ${xp_ten_gh}    Format String    ${cell_diachi_gh}    ${get_ten_cuahang}
    Wait Until Page Contains Element    ${xp_ten_gh}    3 mins
    Click Element    ${button_bat_dau_kd}
    Wait Until Keyword Succeeds    3 times    2s    Close popups if visible    ${button_dong_popup}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${input_ten_dangnhap}    ${input_matkhau}
    Wait Until Page Contains Element    ${checkbox_taodulieumau}    1 min
    Click Element JS    ${checkbox_taodulieumau}
    Wait Until Page Contains Element    ${button_hoanthanh_taodulieumau}    1 min
    Click Element JS    ${button_hoanthanh_taodulieumau}
    Sleep    15s
    Wait Until Page Contains Element    ${button_thietlap}    1 min
    Click Element JS    ${button_thietlap}
    Wait Until Element Is Visible    ${button_xoadulieu_dungthu}
    Click Element    ${button_xoadulieu_dungthu}
    Wait Until Element Is Visible    ${button_dongy_xoadulieu_dungthu}
    Click Element JS    ${button_dongy_xoadulieu_dungthu}
    ${get_id_product}   Get product id thr API    ${input_ma_sp}
    Should Be Equal As Numbers    ${get_id_product}    0
