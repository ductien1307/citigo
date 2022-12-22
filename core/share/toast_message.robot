*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${toast_message}        //div[contains(@class, 'toast-message')]
${cell_product_name}    //div[contains(@class, 'row-product')]//div[contains(@class, 'cell-name not-units')]//h4
${toast_message_fnb}    //div[contains(@class, 'toast')]//span[contains(@class, 'toast-message')]
${toast_message_error}  //div[contains(@class, 'toast')]//div[contains(@class, 'toast toast-error')]

*** Keywords ***
Invoice message success validation
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${toast_message}    2 min
    Comment    ${var_success}    Set Variable    Hóa đơn được cập nhật thành công
    Comment    ${var_offline}    Set Variable    Không có kết nối internet. Giao dịch được lưu offline
    Comment    @{text_msg}    Create List    ${var_success}    ${var_offline}
    Comment    ${msg}    Get Text    ${toast_message}
    Comment    Pass Execution If    '${msg}'=='${var_offline}'    Close All Browsers
    Wait Until Element Is Visible    ${toast_message}    2 min
    Wait Until Element Contains    ${toast_message}    Hóa đơn được cập nhật thành công    2 min
    [Teardown]

Invoice message unsuccess validation
    [Timeout]    15 seconds
    #${get_text_productname}    Get Text    ${cell_product_name}
    #get_text_productname}=    Format String    ${SPACE}    ${get_text_productname}
    Element Should Contain    ${toast_message}    Không đủ số lượng tồn kho cho sản phẩm    #${get_text_productname}

Order message success validation
    [Timeout]    2 minutes
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Thông tin đơn hàng được cập nhật thành công

Return message success validation
    [Timeout]    2 minutes
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Trả hàng được cập nhật thành công

Update data success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Cập nhật dữ liệu thành công

Promo message success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Lưu chương trình khuyến mại thành công!

Pnh message success validation
    [Timeout]    15 seconds
    Wait Until Element Is Visible    ${toast_message}

Invoice message unsuccess for serial product validation
    [Timeout]    15 seconds
    #${get_text_productname}    Get Text    ${cell_product_name}
    #get_text_productname}=    Format String    ${SPACE}    ${get_text_productname}
    Element Should Contain    ${toast_message}    không tồn tại trong hệ thống, đã bán, không thuộc chi nhánh hiện tại hoặc nằm trong giao dịch offline chưa được đồng bộ. Bạn hãy đồng bộ các giao dịch offline.    #${get_text_productname}

Product exchange message success validation
    [Timeout]    20 seconds
    Wait Until Element Is Visible    ${toast_message}
    Element Should Contain    ${toast_message}    Trả hàng được cập nhật thành công

Update invoice success validation
    [Arguments]    ${input_ma_hd}
    [Timeout]    15 seconds
    Wait Until Element Is Visible    ${toast_message}
    ${toast_message_full}    Format String    Hóa đơn {0} được cập nhật thành công    ${input_ma_hd}
    Element Should Contain    ${toast_message}    ${toast_message_full}

Toast flex message validation
    [Arguments]    ${input_text_msg}
    [Timeout]
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    ${input_text_msg}
    Wait Until Page Does Not Contain Element    ${toast_message}    2 min

Purchase receipt message success validation
    [Arguments]    ${input_ma_pn}
    Wait Until Element Is Visible    ${toast_message}    2 min
    ${toast_message_full}    Format String    Phiếu nhập hàng {0} được cập nhật thành công    ${input_ma_pn}
    Element Should Contain    ${toast_message}    ${toast_message_full}

Product create success validation
    [Timeout]    1 minute
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}    Hàng hóa đã được tạo thành công

Delete product success validation
    [Arguments]    ${masp}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa hàng hóa: {0} thành công    ${masp}
    Element Should Contain    ${toast_message}    ${msg}

Delete unit product success validation
    [Arguments]    ${masp}
    Wait Until Page Contains Element    ${toast_message}    30s
    ${msg}    Format String    Xóa hàng hóa {0} và các đơn vị tính liên quan thành công    ${masp}
    Element Should Contain    ${toast_message}    ${msg}

Delete data success validation
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Xóa dữ liệu thành công

Damage doc message success validation
    [Arguments]    ${input_ma_phieu}
    Wait Until Element Is Visible    ${toast_message}    2 min
    ${toast_message_full}    Format String    Phiếu xuất hủy {0} được cập nhật thành công    ${input_ma_phieu}
    Element Should Contain    ${toast_message}    ${toast_message_full}

Purchase order message success validation
    [Arguments]    ${input_ma_phieu}
    Wait Until Element Is Visible    ${toast_message}    2 min
    ${toast_message_full}    Format String    Phiếu đặt hàng nhập {0} được cập nhật thành công    ${input_ma_phieu}
    Element Should Contain    ${toast_message}    ${toast_message_full}

Purchase receipt message update validation
    [Arguments]    ${input_ma_pn}
    Wait Until Element Is Visible    ${toast_message}    2 min
    ${toast_message_full}    Format String    Phiếu nhập hàng {0} được cập nhật thành công    ${input_ma_pn}
    Element Should Contain    ${toast_message}    ${toast_message_full}

Branch message create validation
    [Arguments]
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}    Cập nhật chi nhánh thành công

Delete pricebook message success validation
    [Arguments]    ${bang_gia}
    Wait Until Page Contains Element    ${toast_message}    2 min
    ${text}    Format String    Xóa bảng giá {0} thành công    ${bang_gia}
    Element Should Contain    ${toast_message}    ${text}

Delete promotion message succest validation
    [Arguments]    ${input_ma_promo}
    Wait Until Page Contains Element    ${toast_message}    2 min
    ${text}    Format String    Xóa chương trình khuyến mại: {0} thành công    ${input_ma_promo}
    Element Should Contain    ${toast_message}    ${text}

Expenses other message success validation
    [Timeout]    2 minutes
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Thông tin chi phí nhập hàng được cập nhật thành công

Invoice fnb message success validation
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${toast_message_fnb}    1 min
    Wait Until Element Contains    ${toast_message_fnb}    Giao dịch được cập nhật thành công    1 min

Delete order message success validation
    [Timeout]    2 minutes
    [Arguments]   ${ma_phieu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    ${text_msg}   Format String    Hủy phiếu đặt hàng: {0} thành công    ${ma_phieu}
    Wait Until Element Contains    ${toast_message}    ${text_msg}

Invoice update message success validation
    [Timeout]   2 minutes
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    ${text_msg}      Format String    Hóa đơn {0} được cập nhật thành công    ${ma_phieu}
    Wait Until Element Contains    ${toast_message}    ${text_msg}

Invoice delete message success validation
    [Timeout]   2 minutes
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    ${text_msg}      Format String    Hủy hóa đơn: {0} thành công    ${ma_phieu}
    Wait Until Element Contains    ${toast_message}    ${text_msg}

Return delete message success validation
    [Timeout]   2 minutes
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    ${text_msg}      Format String    Hủy trả hàng: {0} thành công    ${ma_phieu}
    Wait Until Element Contains    ${toast_message}    ${text_msg}

Create data message success validation
    [Timeout]   2 minutes
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Khởi tạo dữ liệu mẫu thành công      2 mins

Return update message success validation
    [Timeout]   2 minutes
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    ${text_msg}      Format String    Trả hàng {0} được cập nhật thành công    ${ma_phieu}
    Wait Until Element Contains    ${toast_message}    ${text_msg}

Medicine create success validation
    [Timeout]    1 minute
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}    Thuốc đã được tạo thành công

Delete medicine success validation
    [Arguments]    ${masp}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa thuốc: {0} thành công    ${masp}
    Element Should Contain    ${toast_message}    ${msg}

Create employee success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Thêm mới nhân viên thành công

Update employee success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Cập nhật nhân viên thành công

Delete employee success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Xóa nhân viên thành công

Create pay sheet success validation
    [Arguments]     ${ma_bang_luong}
    Wait Until Page Contains Element    ${toast_message}      20s
    ${text}     Format String    Chốt bảng lương {0} thành công      ${ma_bang_luong}
    Element Should Contain    ${toast_message}    ${text}

Create shift success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Thêm mới ca làm việc thành công

Create time sheet success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Thêm mới lịch làm việc thành công

Update clocking success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Cập nhật chi tiết ca làm việc thành công

Update multi clocking success validation
    [Arguments]     ${total_ca_lamviec}
    Wait Until Page Contains Element    ${toast_message}      20s
    ${text_msg}   Format String    Chấm công thành công cho {0} Chi tiết làm việc    ${total_ca_lamviec}
    Element Should Contain    ${toast_message}    ${text_msg}

Create commission success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Thêm mới bảng hoa hồng thành công

Update commission success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}      Cập nhật bảng hoa hồng thành công

Delete commission success validation
    [Arguments]     ${input_banghoahong}
    Wait Until Page Contains Element    ${toast_message}      20s
    ${text_msg}   Format String    Xóa bảng hoa hồng {0} thành công    ${input_banghoahong}
    Element Should Contain    ${toast_message}    ${text_msg}

Update pay sheet success validation
    [Arguments]     ${ten_bang_luong}
    Wait Until Page Contains Element    ${toast_message}      20s
    ${text}     Format String    Tạo mới bảng lương {0} thành công      ${ten_bang_luong}
    Element Should Contain    ${toast_message}    ${text}

Create payment success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Tạo phiếu thanh toán thành công

Purchase return message success validation
    [Arguments]     ${input_ma_phieu}
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Phiếu trả hàng nhập ${input_ma_phieu} được cập nhật thành công

Voucher message success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Lưu đợt phát hành thành công!

Message publish voucher code success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Lưu voucher thành công

Message delete voucher success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Xóa đợt phát hành voucher thành công

Message delete transaction success validation
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Xóa dữ liệu thành công

Update order success validation
    [Arguments]    ${input_ma_dh}
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Phiếu đặt hàng ${input_ma_dh} được cập nhật thành công

Message combine order with multiple branches
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Không gộp phiếu đặt hàng thành công do các phiếu đặt hàng khác chi nhánh.

Message combine order with payment and other customers
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Không gộp phiếu thành công do các phiếu đặt hàng khác khách hàng và đã phát sinh thanh toán.

Message combine with shipping order
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Tính năng Gộp phiếu chỉ áp dụng cho đơn ở trạng thái Phiếu tạm hoặc Đã xác nhận.

Create customer message success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Thông tin khách hàng được cập nhật thành công

Message update customer in MHBH
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Cập nhật thông tin thành công

Message delete customer success
    [Arguments]    ${input_ten_kh}
    [Timeout]    15 seconds
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Xóa khách hàng ${input_ten_kh} thành công

Message mapping product success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}      Liên kết hàng thành công

Surcharge create success validation
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}     Thông tin thu khác cập nhật thành công

Retailer create success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Retailer has been created successfully

Retailer update success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Retailer updated successfully

Transfer message success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}     Cập nhật phiếu chuyển hàng thành công

Promotion create message success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Lưu chương trình khuyến mại thành công!

Create delivery message success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Thông tin đối tác giao hàng được cập nhật thành công

Create supplier message success validation
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Thông tin nhà cung cấp được cập nhật thành công

Message delete customers successful
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}    Xóa thành công danh sách khách hàng đã chọn
