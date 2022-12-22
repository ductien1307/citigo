*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{invoice}    GHDDV010=2 	GHDT011=3     GHDT013=5
@{ggsp}          0            1000          0
@{option1}     Không tích điểm cho sản phẩm giảm giá    Không tích điểm cho hóa đơn giảm giá    Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng   Không tích điểm cho hóa đơn thanh toán bằng voucher
@{option2}     Không tích điểm cho sản phẩm giảm giá    Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng
@{option3}     Không tích điểm cho hóa đơn giảm giá

*** Test Cases ***    Tỷ lệ quy đổi      Options           Nhóm KH         KH          SP-SL         GGSP          GGHD     Điểm      Voucher    Giá trị
Tích điểm hd          [Tags]      TDKH
                      [Template]    etd1
                      [Documentation]   Tích điểm theo hàng hóa cới các loại option ở thiết lập tích điểm
                      10000             ${option1}       all             CTKH034     ${invoice}     ${ggsp}         0       0         VOUCHER003     20000
                      20000             ${option1}       all             CTKH034     ${invoice}     ${ggsp}         5000    10        none     none
                      15000             ${option2}       all             CTKH034     ${invoice}     ${ggsp}         0       0         none     none
                      10000             ${option3}       all             CTKH034     ${invoice}     ${ggsp}         0       0         none     none
                      10000             ${option1}       Thân thiết      PVKH004     ${invoice}     ${ggsp}         0       0         none     none
                      20000             ${option1}       Thân thiết      PVKH004     ${invoice}     ${ggsp}         5000    0         VOUCHER003     20000
                      15000             ${option2}       Thân thiết      PVKH004     ${invoice}     ${ggsp}         0       10        none     none
                      20000             ${option3}       Thân thiết      PVKH004     ${invoice}     ${ggsp}         5000    0         none     none

Tích điểm hàng hóa    [Tags]      TDKH
                      [Template]    etd2
                      [Documentation]   Tích điểm theo hóa đơn với các loại option ở thiết lập tích điểm
                      10000             ${option1}       all             CTKH033     ${invoice}     ${ggsp}         0       0         VOUCHER003     20000
                      20000             ${option1}       all             CTKH033     ${invoice}     ${ggsp}         5000    10        none     none
                      20000             ${option2}       all             CTKH033     ${invoice}     ${ggsp}         5000    0         none     20000
                      10000             ${option3}       all             CTKH033     ${invoice}     ${ggsp}         0       0         none     none
                      10000             ${option1}       Thân thiết      PVKH003     ${invoice}     ${ggsp}         0       0         none     none
                      20000             ${option1}       Thân thiết      PVKH003     ${invoice}     ${ggsp}         5000    0         VOUCHER003     20000
                      15000             ${option2}       Thân thiết      PVKH003     ${invoice}     ${ggsp}         0       10        none     none
                      20000             ${option3}       Thân thiết      PVKH003     ${invoice}     ${ggsp}         5000    0         none     none

*** Keywords ***
etd1
    [Arguments]     ${input_tyle_quydoi}   ${list_option}    ${input_nhom_kh}    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}     ${input_diem}      ${input_voucher_issue}     ${voucher_pub_value}
    Log    ${list_option}
    Adjust point of customer thr API    ${input_ma_kh}    ${input_diem}
    ${result_diem_bf}   Set Variable If      ${input_diem}==0     ${input_diem}   0
    Sleep    3s
    ${list_product}     Get Dictionary Keys     ${dict_product_nums}
    ${list_pr_point_status}    Get list product status point frm API    ${list_product}
    Setting reward point by invoice thr API    ${input_tyle_quydoi}   ${list_option}    ${input_nhom_kh}
    Sleep    3s
    ${invoice_code}   Run Keyword If    ${input_diem}!=0 and '${input_voucher_issue}'=='none'    Add new invoice incase discount with multi product - payment with point    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   ${input_diem}   ELSE IF   '${input_voucher_issue}'!='none'    Add new invoice incase discount with multi product - payment with voucher    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   ${input_voucher_issue}    ${voucher_pub_value}      ELSE     Add new invoice incase discount with multi product - no payment - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   none
    #
    Log    trả về có chọn Không tích điểm cho sản phẩm giảm giá ko
    ${is_ForDiscountProduct}     Run Keyword And Return Status     List Should Contain Value      ${list_option}    Không tích điểm cho sản phẩm giảm giá
    ${list_result_thanhtien_tichdiem}      Create List
    :FOR    ${item_pr}    ${item_ggsp}      ${item_thanhtien}    ${item_status}    IN ZIP    ${list_product}     ${list_ggsp_bf}    ${list_thanhtien_hh_bf}    ${list_pr_point_status}
    \   ${result_thanhtien_tichdiem}     Run Keyword If    '${is_ForDiscountProduct}'=='True' and ${item_ggsp}!=0    Set Variable   0    ELSE IF    '${item_status}'=='False'   Set Variable    0     ELSE    Set Variable    ${item_thanhtien}
    \   Append To List    ${list_result_thanhtien_tichdiem}    ${result_thanhtien_tichdiem}
    Log    ${list_result_thanhtien_tichdiem}
    ${result_tongtien_tichdiem}    Sum values in list    ${list_result_thanhtien_tichdiem}
    ${result_tongtien_tichdiem}   Minus    ${result_tongtien_tichdiem}    ${input_gghd}
    ${diem_hd}     Devision and round down    ${result_tongtien_tichdiem}    ${input_tyle_quydoi}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn giảm giá ko
    ${is_ForDiscountInvoice}     Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn giảm giá
    ${result_diem_hd}     Run Keyword If    '${is_ForDiscountInvoice}'=='True' and ${input_gghd}!=0    Set Variable    0    ELSE     Set Variable    ${diem_hd}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng ko
    ${is_ForInvoiceUsingRewardPoint}     Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng
    ${result_diem_hd}     Run Keyword If    '${is_ForInvoiceUsingRewardPoint}'=='True' and ${input_diem}!=0    Set Variable    0    ELSE     Set Variable    ${result_diem_hd}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn thanh toán bằng voucher ko
    ${is_ForInvoiceUsingVoucher}      Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn thanh toán bằng voucher
    ${result_diem_hd}     Run Keyword If    '${is_ForInvoiceUsingVoucher}'=='True' and '${input_voucher_issue}'!='none'    Set Variable    0    ELSE     Set Variable    ${result_diem_hd}
    #
    Log    tính tổng điểm
    ${result_tong_diem}     Sum    ${result_diem_bf}    ${result_diem_hd}
    Wait Until Keyword Succeeds    3x    5s    Assert reward point af ex    ${input_ma_kh}    ${result_tong_diem}
    Delete invoice by invoice code    ${invoice_code}

etd2
    [Arguments]     ${input_tyle_quydoi}   ${list_option}    ${input_nhom_kh}    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${input_diem}    ${input_voucher_issue}     ${voucher_pub_value}
    Log    ${list_option}
    Adjust point of customer thr API    ${input_ma_kh}    ${input_diem}
    ${result_diem_bf}   Set Variable If      ${input_diem}==0     ${input_diem}   0
    Sleep    3s
    ${list_product}     Get Dictionary Keys     ${dict_product_nums}
    ${list_nums}    Get Dictionary Values     ${dict_product_nums}
    ${list_pr_point}    Get list product reward point frm API    ${list_product}
    Setting reward point by product thr API    ${input_tyle_quydoi}   ${list_option}    ${input_nhom_kh}
    Sleep    3s
    ${invoice_code}   Run Keyword If    ${input_diem}!=0 and '${input_voucher_issue}'=='none'    Add new invoice incase discount with multi product - payment with point    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   ${input_diem}   ELSE IF   '${input_voucher_issue}'!='none'    Add new invoice incase discount with multi product - payment with voucher    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   ${input_voucher_issue}    ${voucher_pub_value}      ELSE     Add new invoice incase discount with multi product - no payment - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}   none
    #
    Log    trả về có chọn Không tích điểm cho sản phẩm giảm giá ko
    ${is_ForDiscountProduct}     Run Keyword And Return Status     List Should Contain Value      ${list_option}    Không tích điểm cho sản phẩm giảm giá
    ${list_result_tichdiem}      Create List
    :FOR    ${item_pr}    ${item_num}    ${item_ggsp}    ${item_point}    IN ZIP    ${list_product}    ${list_nums}    ${list_ggsp_bf}     ${list_pr_point}
    \   ${point_hh}     Run Keyword If    '${is_ForDiscountProduct}'=='True' and ${item_ggsp}!=0    Set Variable   0      ELSE    Set Variable    ${item_point}
    \   ${total_point_hh}     Multiplication    ${point_hh}    ${item_num}
    \   Append To List    ${list_result_tichdiem}    ${total_point_hh}
    Log    ${list_result_tichdiem}
    ${diem_hd}    Sum values in list    ${list_result_tichdiem}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn giảm giá ko
    ${is_ForDiscountInvoice}     Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn giảm giá
    ${result_diem_hd}     Run Keyword If    '${is_ForDiscountInvoice}'=='True' and ${input_gghd}!=0    Set Variable    0    ELSE     Set Variable    ${diem_hd}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng ko
    ${is_ForInvoiceUsingRewardPoint}     Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng
    ${result_diem_hd}     Run Keyword If    '${is_ForInvoiceUsingRewardPoint}'=='True' and ${input_diem}!=0    Set Variable    0    ELSE     Set Variable    ${result_diem_hd}
    #
    Log    trả về có chọn Không tích điểm cho hóa đơn thanh toán bằng voucher ko
    ${is_ForInvoiceUsingVoucher}      Run Keyword And Return Status     List Should Contain Value    ${list_option}   Không tích điểm cho hóa đơn thanh toán bằng voucher
    ${result_diem_hd}     Run Keyword If    '${is_ForInvoiceUsingVoucher}'=='True' and '${input_voucher_issue}'!='none'    Set Variable    0    ELSE     Set Variable    ${result_diem_hd}
    #
    ${result_tong_diem}     Sum    ${result_diem_bf}    ${result_diem_hd}
    Wait Until Keyword Succeeds    3x    5s    Assert reward point af ex    ${input_ma_kh}    ${result_tong_diem}
    Delete invoice by invoice code    ${invoice_code}
