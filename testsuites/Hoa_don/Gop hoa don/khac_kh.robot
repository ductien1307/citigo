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

*** Variables ***
&{list_product_num}        GHDCB003=4     GHDDV003=4      GHDI003=2     GHDT003=4.5   GHDU003=3.5
@{list_discount}           120000.5         3000           10            4000.5        75000
@{list_discount_type}      change          dis             dis            dis         change
&{list_product_num_1}      GHDCB004=3     GHDDV003=4       GHDI004=3     GHDT003=5     GHDUQD004=5
@{list_discount_1}         3000           3000            95000          5              95000
@{list_discount_type_1}    dis             dis            change         dis           change
                          #khác            giống           khác          cùng sp       khác

*** Test Cases ***
Gộp hóa đơn khác KH
      [Tags]      GHD
      [Template]    eghd9
      PVKH007      DT00001     ${list_product_num}     ${list_discount}      ${list_discount_type}     10           PVKH008      DT00002     ${list_product_num_1}     ${list_discount_1}      ${list_discount_type_1}     15000

*** Keywords ***
eghd9
      [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}     ${input_ma_kh_1}     ${input_ma_dtgh_1}     ${dict_product_nums_1}    ${list_change_1}    ${list_change_type_1}    ${input_gghd_1}
      Set Selenium Speed    0.1
      Log    tạo list sau gộp
      ${list_pr}      Get Dictionary Keys    ${dict_product_nums}
      ${list_num}     Get Dictionary Values    ${dict_product_nums}
      ${list_pr_1}      Get Dictionary Keys    ${dict_product_nums_1}
      ${list_num_1}     Get Dictionary Values    ${dict_product_nums_1}
      ${list_pr_af_ex}    Create List
      ${list_num_af_ex}    Create List
      ${list_change_af_ex}    Create List
      ${list_change_type_af_ex}    Create List
      :FOR      ${item_pr}      ${item_num}     ${item_change}      ${item_change_type}     ${item_pr_1}      ${item_num_1}     ${item_change_1}      ${item_change_type_1}     IN ZIP     ${list_pr}   ${list_num}   ${list_change}      ${list_change_type}       ${list_pr_1}   ${list_num_1}   ${list_change_1}      ${list_change_type_1}
      \     ${sum_num}      Sum    ${item_num}    ${item_num_1}
      \     Run Keyword If    '${item_pr}'=='${item_pr_1}' and '${item_change}'=='${item_change_1}' and '${item_change_type}'=='${item_change_type_1}'    Run Keywords    Append To List    ${list_pr_af_ex}    ${item_pr}    AND     Append To List    ${list_num_af_ex}    ${sum_num}    AND     Append To List    ${list_change_af_ex}    ${item_change}    AND     Append To List    ${list_change_type_af_ex}    ${item_change_type}
      \     ...   ELSE    Run Keywords    Append To List    ${list_pr_af_ex}    ${item_pr}    ${item_pr_1}   AND     Append To List    ${list_num_af_ex}    ${item_num}   ${item_num_1}     AND     Append To List    ${list_change_af_ex}    ${item_change}   ${item_change_1}   AND     Append To List    ${list_change_type_af_ex}    ${item_change_type}   ${item_change_type_1}
      Log    ${list_pr_af_ex}
      Log    ${list_num_af_ex}
      Log    ${list_change_af_ex}
      Log    ${list_change_type_af_ex}
      #
      Log    tính tồn kho af ex
      ${list_pr_assert_onhand}      Create List
      ${list_num_assert_onhand}     Create List
      :FOR      ${item_pr}      ${item_num}     ${item_pr_1}      ${item_num_1}     IN ZIP      ${list_pr}   ${list_num}    ${list_pr_1}   ${list_num_1}
      \     ${sum_num}      Sum    ${item_num}    ${item_num_1}
      \     Run Keyword If    '${item_pr}'=='${item_pr_1}'   Run Keywords    Append To List    ${list_pr_assert_onhand}    ${item_pr}    AND     Append To List    ${list_num_assert_onhand}    ${sum_num}
      \     ...   ELSE    Run Keywords    Append To List    ${list_pr_assert_onhand}    ${item_pr}    ${item_pr_1}   AND     Append To List    ${list_num_assert_onhand}    ${item_num}   ${item_num_1}
      Log    ${list_pr_assert_onhand}
      Log    ${list_num_assert_onhand}
      #
      Log    tính giảm giá hd 1
      ${result_khtt}   ${result_gghd}     Computation result customer paid - discount invoice incase changing price by product code    ${list_pr}  ${list_num}   ${list_change}    ${list_change_type}   ${input_gghd}   none
      #
      Log    tính giảm giá hd 2
      ${result_khtt_1}    ${result_gghd_1}    Computation result customer paid - discount invoice incase changing price by product code     ${list_pr_1}  ${list_num_1}   ${list_change_1}    ${list_change_type_1}   ${input_gghd_1}   none
      #
      Log    tính tổng tiền hàng, khách cần trả, gghd gộp
      ${list_giaban_af_ex}    ${list_result_ggsp_af_ex}    Computation list price and result discount incase changing price by product code    ${list_pr_af_ex}    ${list_change_af_ex}    ${list_change_type_af_ex}
      ${list_thanhtien_hh_af_ex}    Create List
      : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban_af_ex}    ${list_num_af_ex}
      \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
      \    Append To List    ${list_thanhtien_hh_af_ex}    ${result_item_thanhtien}
      Log    ${list_thanhtien_hh_af_ex}
      ${result_tongtienhang_af_ex}    Sum values in list    ${list_thanhtien_hh_af_ex}
      ${result_tongtienhang_af_ex}      Evaluate    round(${result_tongtienhang_af_ex},0)
      ${result_gghd_af_ex}    Sum    ${result_gghd}    ${result_gghd_1}
      ${result_khachcantra}    Minus    ${result_tongtienhang_af_ex}    ${result_gghd_af_ex}
      #
      Log    tính công nợ kh
      ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
      ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
      ${list_onhand_af_ex}   Get list of result onhand incase changing product price     ${list_pr_assert_onhand}      ${list_num_assert_onhand}
      ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${list_pr_assert_onhand}
      ${list_result_onhand_af_ex}     Create List
      :FOR    ${item_pr_type}     ${item_imei_status}     ${item_ohand}   ${item_num}     IN ZIP       ${get_list_product_type}   ${get_list_imei_status}    ${list_onhand_af_ex}   ${list_num_assert_onhand}
      \       ${onhand_imei}      Sum    ${item_ohand}   ${item_num}
      \       Run Keyword If    ${item_pr_type}==1 or ${item_pr_type}==3     Append To List    ${list_result_onhand_af_ex}    0     ELSE IF      '${item_imei_status}'=='True'      Append To List   ${list_result_onhand_af_ex}    ${onhand_imei}      ELSE    Append To List   ${list_result_onhand_af_ex}    ${item_ohand}
      Log     ${list_result_onhand_af_ex}
      #
      Log    tạo hóa đơn
      ${invoice_code}   Add new delivery invoice - no payment   ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
      ${invoice_code_1}   Add new delivery invoice - no payment       ${input_ma_kh_1}     ${input_ma_dtgh_1}     ${dict_product_nums_1}    ${list_change_1}    ${list_change_type_1}    ${input_gghd_1}
      Log    gộp hóa đơn
      Reload Page
      Search invoice code and select invoice    ${invoice_code}
      Search invoice code and select invoice    ${invoice_code_1}
      Combine invoice
      Wait Until Page Contains Element    ${toast_message}     60s
      ${get_msg}      Get Text      ${toast_message}
      Element Should Contain    ${toast_message}    được tạo thành công.
      ${get_ma_hd_gop}      Remove String    ${get_msg}    Hóa đơn      được tạo thành công.      ${SPACE}
      #
      Sleep    10s    wait for response to API
      ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
      ...    ${get_ma_hd_gop}
      Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_af_ex}
      Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
      Should Be Equal As Numbers    ${get_khach_tt}    0
      Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
      Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_gghd_af_ex}
      Should Be Equal As Strings    ${get_trangthai}    Đang xử lý
      Log        Assert values in product list and stock card
      Assert list of Onhand after execute      ${list_pr_assert_onhand}    ${list_result_onhand_af_ex}
      Log        assert values in Khach hang
      ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${get_ma_hd_gop}    0
      Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
      #
      Log    assert trạng thái hóa đơn đã hủy, ghi chú hóa đơn gọp
      ${message}    Set Variable          Hóa đơn ${get_ma_hd_gop} được tạo do gộp các hóa đơn ${invoice_code}, ${invoice_code_1}
      Assert infor invoice incase combine invoice    ${invoice_code}    ${invoice_code_1}    ${get_ma_hd_gop}     ${input_ma_dtgh}    ${message}
      Delete invoice by invoice code    ${get_ma_hd_gop}
