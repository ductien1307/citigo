*** Settings ***
Suite Setup       Setup Test Suite    Before Test Ban Hang
Suite Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/API/api_trahang.robot

*** Variables ***

*** Test Cases ***
Sao chép hóa đơn      [Tags]        #TLG
                      [Template]      xmbg4
                      [Documentation]    1. Hóa đơn có bảng giá đã xóa
                      ...    2. Click Sao chép hóa đơn
                      ...    > Hóa đơn sao chép trên MHBH hiện bảng giá chung
                      PVKH006         HH0042         5         50000

Tạo hóa đơn khi đã xóa bảng giá
                      [Tags]        TLG
                      [Template]      xmbg5
                      [Documentation]     1. Chọn sp và bảng giá A trên MHBH
                      ...   2. Xóa bảng giá A
                      ...   3. Quay lại MHBH thanh toán
                      ...   > chi tiết hóa đơn hiển thị bảng giá có thêm hâu tố DEL
                      PVKH006         TP017        3

Xóa BG > F5 MHBH
                      [Tags]        TLG
                      [Template]      xmbg6
                      [Documentation]     1. Chọn Bảng giá A trên MHBH
                      ...   2. Xóa bảng giá A
                      ...   3. F5 MHBH
                      ...   > Bảng giá load lại thành Bảng giá chung
                      TP017        4

Xử lý đặt hàng        [Tags]        TLG3
                      [Template]      xmbg7
                      [Documentation]     1. Tạo đơn đặt hàng vói bảng giá A
                      ...   2. Xóa bảng giá A
                      ...   3. Xử lý đơn đặt hàng > click Tạo hóa đơn
                      ...   > Bảng giá trên hóa đơn là Bảng giá chung
                      PVKH006         TP017        4         50000

*** Keywords ***
xmbg4
    [Arguments]    ${input_ma_kh}    ${input_product}      ${input_soluong}      ${input_khtt}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    ${invoice_code}     Add new invoice with price book frm API    ${input_ma_kh}     ${input_banggia}    ${input_product}      ${input_soluong}      ${input_khtt}
    Delete price book thr API   ${input_banggia}
    Wait Until Keyword Succeeds    3 times    5s    Go to Hoa don
    Search invoice code    ${invoice_code}
    Wait Until Page Contains Element    ${button_hd_sao_chep}     1 min
    Click Element    ${button_hd_sao_chep}
    ${url_bh}       Set Variable        ${URL}/sale/#/
    Wait Until Keyword Succeeds    10x    3s        Select Window   url=${url_bh}
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print preview page
    ${text_tab_sc}    Set Variable       Copy_${invoice_code}
    ${tab_saochep}      Format String    //span[text()='{0}']    ${text_tab_sc}
    Wait Until Page Contains Element      ${tab_saochep}      1 min
    Wait Until Page Contains Element    ${button_bh_thanhtoan}    1 min
    Wait Until Keyword Succeeds    3x    3s   Assert Ten bang gia in MHBH    Bảng giá chung
    Delete invoice by invoice code    ${invoice_code}

xmbg5
    [Arguments]    ${input_ma_kh}    ${input_product}      ${input_soluong}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    Reload Page
    Select Bang gia    ${input_banggia}
    Delete price book thr API    ${input_banggia}
    Input product-num in BH form    ${input_product}    ${input_soluong}    ${input_soluong}
    Input Khach Hang    ${input_ma_kh}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Wait Until Keyword Succeeds    3 times    2s    Assert price book in invoice detail    ${invoice_code}    ${input_banggia}{DEL}
    Delete invoice by invoice code    ${invoice_code}

xmbg6
    [Arguments]      ${input_product}      ${input_soluong}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    Reload Page
    Wait Until Keyword Succeeds    3 times    2s    Select Bang gia    ${input_banggia}
    Delete price book thr API    ${input_banggia}
    Input product-num in BH form    ${input_product}    ${input_soluong}    ${input_soluong}
    Reload Page
    Wait Until Keyword Succeeds    3x    3s   Assert Ten bang gia in MHBH    Bảng giá chung

xmbg7
    [Arguments]    ${input_ma_kh}    ${input_product}      ${input_soluong}      ${input_khtt}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    ${order_code}     Add new order with price book frm API       ${input_ma_kh}     ${input_banggia}    ${input_product}      ${input_soluong}      ${input_khtt}
    Delete price book thr API   ${input_banggia}
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3x    3s   Assert Ten bang gia in MHBH    Bảng giá chung
    Delete order frm Order code    ${order_code}
