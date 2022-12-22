*** Settings ***
Library           SeleniumLibrary
Resource          search_invoice_info_page.robot

*** Keywords ***
Search product in invoice manager form
    [Arguments]    ${input_list_product}
    Wait Until Keyword Succeeds    3 times    5s    Click Element    ${icon_search_advance}
    :FOR    ${item_product}   IN  @{input_list_product}
    \     KV Input Text    ${textbox_search_product_invoice}     ${item_product}
    #\     ${xpath_cell_item_af_search}    Format String    ${cell_item_product_af_search}     ${item_product}
    #\     Wait Until Keyword Succeeds    3 times    5s    Click Element    ${xpath_cell_item_af_search}
    #Wait Until Keyword Succeeds    3 times    5s    Click Element    ${list_search_invoice_info}
    Wait Until Keyword Succeeds    3 times    5s    Click Element    ${button_search_info}

Click tìm kiếm
    Execute JavaScript    document.evaluate("${btn_tim_kiem}",document.body,null,9,null).singleNodeValue.click();
    Sleep    2s

Click enter
    [Arguments]    ${elm}
    Press Key   ${elm}      \\13
    Sleep    3s

Validate invoice code after search
    [Arguments]    ${input_invoice_code}
    Wait Until Page Contains    ${input_invoice_code}

Validate multi invoice code after search
    [Arguments]    ${input_list_invoice}
    :FOR    ${item_invoice}   IN    @{input_list_invoice}
    \     Validate invoice code after search    ${item_invoice}

Validate invoice search
    [Arguments]    ${input_list_invoice}
    ${count_list}   Get Length    ${input_list_invoice}
    Run Keyword If    ${count_list} > 1    Validate multi invoice code after search    ${input_list_invoice}    ELSE    Validate invoice code after search    ${input_list_invoice}

Chọn tìm kiếm sản phẩm
    Click Element    ${search_option}
    Sleep    2s

Nhập mã hàng hoặc tên hàng vào ô tìm kiếm
    [Arguments]    ${ma_hang}
    Wait Until Page Contains Element    ${textbox_search_product_invoice}
    Input Text    ${textbox_search_product_invoice}    ${ma_hang}
    Sleep   2s

Check kết quả hiển thị đúng mã sản phẩm
    [Arguments]    ${ma_tim_kiem}
    ${length}    Get Length    ${ma_tim_kiem}
    Wait Until Page Contains Element    ${list_box}
    Sleep    2s
    ${count}    Get Element Count  ${list_ma_san_pham}
    ${names}    Create List
    :FOR    ${i}    IN RANGE    1     ${count}+1
    \    ${name}=    Get Text    ${list_ma_san_pham}[${i}]
    \    Append To List    ${names}    ${name}
    :FOR    ${item}    IN     @{names}
    \    ${str}    Get Substring    ${item}    0      ${length}
    \    Should Be Equal As Strings    ${str}    ${ma_tim_kiem}

Check kết quả hiển thị đúng tên sản phẩm
    [Arguments]    ${ten_tim_kiem}
    ${length}    Get Length    ${ten_tim_kiem}
    Wait Until Page Contains Element    ${list_box}
    Sleep    2s
    ${count}    Get Element Count  ${list_ten_san_pham}
    ${names}    Create List
    :FOR    ${i}    IN RANGE    1     ${count}+1
    \    ${name}=    Get Text    ${list_ten_san_pham}[${i}]
    \    Append To List    ${names}    ${name}
    :FOR    ${item}    IN     @{names}
    \    ${str}    Get Substring    ${item}    0      ${length}
    \    Should Be Equal As Strings    ${str}    ${ten_tim_kiem}

Check giá trị hoá đơn trả về
    [Arguments]    ${expexted_list_hoa_don}    ${expected_list_tien_hang}
    ${count}    Get Element Count    ${ma_hoa_don}
    ${actual_result}    Create List
    ${invoice_sumary_total}    Get Text    ${tong_tien_hang}[1]
    ${invoice_sumary_discount}    Get Text    ${tong_giam_gia}[1]
    ${invoice_sumary_after_discount}    Get Text    ${tong_sau_giam}[1]
    ${invoice_sumary_total_payment}    Get Text    ${tong_payment}[1]
    :FOR    ${i}    IN RANGE    1     ${count}+1
    \    ${code}=    Get Text    ${ma_hoa_don}[${i}]
    \    Append To List    ${actual_result}    ${code}
    Reverse List    ${actual_result}
    log    ${actual_result}
    log    ${expexted_list_hoa_don}
    Sleep    2s
    Lists Should Be Equal    ${actual_result}    ${expexted_list_hoa_don}
    Log    ${invoice_sumary_total}
    Should Be Equal As Strings   ${invoice_sumary_total}     @{expected_list_tien_hang}[0]
    Should Be Equal As Strings   ${invoice_sumary_discount}     @{expected_list_tien_hang}[1]
    Should Be Equal As Strings   ${invoice_sumary_after_discount}     @{expected_list_tien_hang}[2]

Chọn sản phẩm gợi ý
    Click Element    ${list_ma_san_pham}[1]
    Sleep   1s

Click outside
    Click Element    ${page_title}
    Sleep    1s

Chọn filter date
    [Arguments]    ${name}
    Click Element   ${time_filter}
    Sleep    1s
    Click Element    (//a[text()='${name}'])[1]

Nhập chi nhánh
    [Arguments]    ${name}
    ${count}    Get Element Count    //li/span[text()='${name}']
    Run Keyword If    ${count} == 0    Click Element    ${ten_chi_nhanh}
    Run Keyword If    ${count} == 0    Click Element    (//ul[@class='k-list k-reset']/li[text()='${name}'])[2]

Chọn trạng thái hoàn thành
    ${count}    Get Element Count    ${hoan_thanh_rdb_checked}
    Run Keyword If    ${count} == 0   Click Element    ${hoan_thanh_rdb}

Chọn trạng thái chờ xử lý
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    ${count}    Get Element Count    ${cho_xu_ly_rdo_checked}
    Run Keyword If    ${count} == 0   Click Element    ${cho_xu_ly_rdo}

Chọn trạng thái kênh trực tiếp
    Execute JavaScript    window.scrollTo(0, 600)
    Click Element    ${input_kenh_ban}
    Sleep    2s
    CLick Element    ${kenh_ban}

Nhập nhiểu mã hàng hoặc tên hàng vào ô tìm kiếm
    [Arguments]    ${list_hang}
    :FOR    ${item}    IN     @{list_hang}
    \    Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${item}
    \    Sleep    2s
    \    Chọn sản phẩm gợi ý

Check thông báo lỗi hiển thị
    [Arguments]    ${error}
    Page Should Contain Element    //*[text()='${error}']

Check hệ thống không gợi ý mã sản phẩm
    ${count}    Get Element Count    ${list_ma_san_pham}
    Should Be Equal As Numbers    ${count}    0
