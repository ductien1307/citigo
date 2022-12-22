*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa don
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Giao_dich/hoa_don_giao_hang_action.robot
Resource          ../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Giao_Van/giao_hang_nav.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Ban_Hang_page_menu.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/API/api_hanghoa.robot
Resource          ../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_product_num}        GHDDV002=3
@{list_discount}           145000
@{list_discount_type}      change
&{list_product_num_1}      GHDDV004=3
@{list_discount_1}         3000
@{list_discount_type_1}    dis
&{list_product_num_2}      GHDDV006=3

*** Test Cases ***
Gộp đơn hoàn thành
      [Tags]    GHD
      [Template]    eghd2
      CRPKH017      DT00008     ${list_product_num}     ${list_discount}      ${list_discount_type}     10           CRPKH018       ${list_product_num_2}

Gộp đơn giao thành công
      [Tags]    GHD
      [Template]    eghd3
      CRPKH017      DT00008     ${list_product_num}     ${list_discount}      ${list_discount_type}     10           CRPKH018      DT00008     ${list_product_num_1}     ${list_discount_1}      ${list_discount_type_1}     20

Gộp đơn từ phiếu đặt hàng
      [Tags]    GHD
      [Template]    eghd8
      CRPKH017     	GHDDV006        3       10000

*** Keywords ***
eghd2
      [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}     ${input_ma_kh_1}      ${dict_product_nums_1}
      Set Selenium Speed    0.1
      #
      Log    tạo hóa đơn
      ${invoice_code}   Add new delivery invoice - no payment   ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
      ${invoice_code_1}   Add new invoice no payment frm API    ${input_ma_kh_1}     ${dict_product_nums_1}
      Log    gộp hóa đơn
      Reload Page
      Search invoice code and select invoice    ${invoice_code}
      Search invoice code and select invoice    ${invoice_code_1}
      Click Element     ${button_gop_hoa_don}
      Wait Until Page Contains Element    ${toast_message}     60s
      ${get_msg}      Get Text      ${toast_message}
      Element Should Contain    ${toast_message}      ${invoice_code_1}: Tính năng Gộp phiếu chỉ áp dụng cho đơn ở trạng thái Đang xử lý.
      Delete invoice by invoice code    ${invoice_code}
      Delete invoice by invoice code    ${invoice_code_1}

eghd3
      [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}     ${input_ma_kh_1}     ${input_ma_dtgh_1}     ${dict_product_nums_1}    ${list_change_1}    ${list_change_type_1}    ${input_gghd_1}
      Set Selenium Speed    0.1
      #
      Log    tạo hóa đơn
      ${invoice_code}   Add new delivery invoice - no payment   ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
      ${invoice_code_1}   Add new delivery invoice - no payment       ${input_ma_kh_1}     ${input_ma_dtgh_1}     ${dict_product_nums_1}    ${list_change_1}    ${list_change_type_1}    ${input_gghd_1}
      Log    chuyển trạng thái giao thành công
      Reload Page
      Update delivery status by invoice code    ${invoice_code}    Giao thành công
      Reload Page
      Log    gộp hóa đơn
      Search invoice code and select invoice    ${invoice_code}
      Search invoice code and select invoice    ${invoice_code_1}
      Click Element     ${button_gop_hoa_don}
      Wait Until Page Contains Element    ${toast_message}     60s
      ${get_msg}      Get Text      ${toast_message}
      Element Should Contain    ${toast_message}   Hệ thống không hỗ trợ gộp hóa đơn ${invoice_code} có trạng thái giao hàng là Giao thành công.
      Delete invoice by invoice code    ${invoice_code}
      Delete invoice by invoice code    ${invoice_code_1}

eghd8
      [Arguments]   ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
      Set Selenium Speed    0.1
      #
      Log    tạo đơn đặt hàng
      ${order_code}     Add new order frm API    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
      ${input_sl_hd}      Minus    ${input_soluong}    1
      ${invoice_code}     Add new delivery invoice from order code thr API    ${order_code}    ${input_ma_kh}    ${input_ma_hang}    ${input_sl_hd}
      ${order_code_1}     Add new order frm API    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
      ${invoice_code_1}     Add new delivery invoice from order code thr API    ${order_code_1}    ${input_ma_kh}    ${input_ma_hang}    ${input_sl_hd}
      Reload Page
      Log    gộp hóa đơn
      Search invoice code and select invoice    ${invoice_code}
      Search invoice code and select invoice    ${invoice_code_1}
      Click Element     ${button_gop_hoa_don}
      Wait Until Page Contains Element    ${toast_message}     60s
      ${get_msg}      Get Text      ${toast_message}
      Element Should Contain    ${toast_message}   Hệ thống không hỗ trợ gộp hóa đơn ${invoice_code} do phiếu đặt hàng liên quan ${order_code} có trạng thái khác hoàn thành.
      Delete invoice by invoice code    ${invoice_code}
      Delete invoice by invoice code    ${invoice_code_1}
