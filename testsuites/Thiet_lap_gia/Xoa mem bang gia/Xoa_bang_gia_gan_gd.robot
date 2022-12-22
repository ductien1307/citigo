*** Settings ***
Suite Setup       Setup Test Suite    Before Test Thiet lap gia
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
&{list_product_nums_TH05}    TP018=2
&{list_product_nums_DTH05}    TP019=6
@{list_giamoi}    200000


*** Test Cases ***
Hóa đơn               [Tags]      TLG
                      [Template]      xmbg1
                      [Documentation]   Xóa bảng giá đã có hóa đơn > Bảng giá trên hóa đơn thêm hậu tố DEL
                      PVKH006         TP017        5         50000

Đặt hàng              [Documentation]      Đang có bug trên live (ko hiển thị hậu tố DEL)


Đổi trả hàng          [Tags]      TLG
                      [Template]      xmbg2
                      [Documentation]   Xóa bảng giá đã có đơn đổi trả hàng > Bảng giá trên hóa đơn và phiếu trả thêm hậu tố DEL
                      PVKH006       ${list_product_nums_TH05}    ${list_product_nums_DTH05}    ${list_giamoi}           15              0       all

Xóa bg có bg phụ thuộc
                      [Tags]      TLG
                      [Template]      xmbg3
                      [Documentation]   Xóa bảng giá có bảng giá phụ thuộc > Bảng giá phụ thuộc ko thay đổi giá bán của các sp trong bảng giá
                      @{EMPTY}

*** Keywords ***
xmbg1
    [Arguments]    ${input_ma_kh}    ${input_product}      ${input_soluong}      ${input_khtt}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    ${invoice_code}     Add new invoice with price book frm API    ${input_ma_kh}     ${input_banggia}    ${input_product}      ${input_soluong}      ${input_khtt}
    Reload Page
    Select Bang gia for Bang gia    ${input_banggia}
    Delete price book thr UI    ${input_banggia}
    Assert price book is not avaiable thr API    ${input_banggia}
    ${get_ten_banggia}      Get price book in invoice detail    ${invoice_code}
    ${banggia_exp}      Set Variable    ${input_banggia}{DEL}
    Should Be Equal As Strings    ${get_ten_banggia}    ${banggia_exp}
    Click Element    ${button_banhang_on_quanly}
    Sleep    10s
    KV Click Element JS    ${dropdownlist_banggia}
    KV Input Text    ${textbox_banggia}    ${input_banggia}
    ${item_banggia}    Format String    ${item_banggia_in_dropdow}    ${input_banggia}
    Element Should Not Be Visible        ${item_banggia}

xmbg2
    [Arguments]       ${input_ma_kh}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_newprice}
    ...    ${input_phi_th}    ${input_ggdth}    ${input_khtt}
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    ${return_code}     Add new exchange with price book     ${input_banggia}    ${input_ma_kh}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_newprice}
    ...    ${input_phi_th}    ${input_ggdth}    ${input_khtt}
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    Reload Page
    Go To    ${URL}#/PriceBook
    Select Bang gia for Bang gia    ${input_banggia}
    Delete price book thr UI    ${input_banggia}
    Assert price book is not avaiable thr API    ${input_banggia}
    ${get_ten_banggia_hd}      Get price book in invoice detail    ${get_additional_invoice_code}
    ${get_ten_banggia_th}      Get price book in return detail   ${return_code}
    Should Be Equal As Strings    ${get_ten_banggia_hd}     ${input_banggia}{DEL}
    Should Be Equal As Strings    ${get_ten_banggia_th}     ${input_banggia}{DEL}

xmbg3
    [Arguments]
    ${input_banggia}      Generate code automatically    BGH
    Add new price book and add all category - discount %    ${input_banggia}    15
    ${input_banggia_phuthuoc}      Generate code automatically    BGH
    Add new price book had parent    ${input_banggia_phuthuoc}    ${input_banggia}    20
    Add all category into price book thr API    ${input_banggia_phuthuoc}
    ${get_gia_ban_bf}    Get price of product in price book thr API     ${input_banggia_phuthuoc}    NHP033
    Reload Page
    Go To    ${URL}#/PriceBook
    Select Bang gia for Bang gia    ${input_banggia}
    Click Element    ${button_chinhsua_banggia}
    KV Click Element    ${button_xoa_bang_gia}
    KV Click Element    ${button_dongy_xoa_bianggia}
    KV Click Element    ${button_dongy_xoa_banggia_all_cn}
    Delete pricebook message success validation    ${input_banggia}
    Reload Page
    Select Bang gia for Bang gia    ${input_banggia_phuthuoc}
    Wait Until Keyword Succeeds    3 times    3s    Search product in pricebook    NHP033
    KV Click Element By Code    ${textbox_bg_giamoi}     NHP033
    Wait Until Page Contains Element        ${dropdownlist_popup_chon_bang_gia}     30s
    ${get_gia_ban_af}    Get price of product in price book thr API     ${input_banggia_phuthuoc}    NHP033
    Should Be Equal    ${get_gia_ban_bf}    ${get_gia_ban_af}
