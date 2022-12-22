*** Variables ***
${icon_search_advance}    //button[@id="idDropdownBtnSearch"]//i[contains(@class,"fa-caret-down")]
${textbox_search_product_invoice}   //div[@ng-show="isSuggestProductForSearchInvoice"]//input
${cell_item_product_af_search}    //p[text()="{0}"]   #mã hh
${list_search_invoice_info}    //div[@id="idDropdownMenuSearch"]
${button_search_info}   //div[contains(@class,'kv-window-footer')]//button
${cell_item_invoice_af_search}    //span[text()='{0}']  #mã HĐ
${search_option}    //i[@class='fas fa-caret-down']
${product_code_input}    //input[@ng-model='filterProductCode']
${list_box}    //ul[@id='suggestProductSearch_listbox']
${list_ma_san_pham}    (//div[@class='ovh']/p[2])
${list_ten_san_pham}    (//p[@class='txtB'])
${btn_tim_kiem}    //button[@ng-click='quickSearch()']
${ma_hoa_don}    (//tr[@role='row']/td[4]/span[string-length(text()) > 0])
${tong_tien_hang}     (//td[@class='cell-total txtR invoiceSummarySubTotal'])
${tong_giam_gia}     (//td[@class='cell-total txtR invoiceSummaryDiscount'])
${tong_sau_giam}     (//td[@class='cell-total-final txtR invoiceSummaryTotalAfterDiscount'])
${tong_payment}     (//td[@class='cell-total txtR invoiceSummaryTotalPayment'])
${page_title}    (//input[@placeholder='Theo mã hóa đơn'])[2]
${time_filter}    (//label[@id='reportsortDateTimeLbl'])[1]
${ten_chi_nhanh}    (//div[@class='k-multiselect-wrap k-floatwrap']/input)[1]
${hoan_thanh_rdb}    //label[text()="Hoàn thành"]/preceding-sibling::a
${hoan_thanh_rdb_checked}    //label[text()="Hoàn thành"]/preceding-sibling::a[@class='checked']
${cho_xu_ly_rdo}    //label[text()="Chờ xử lý"]/preceding-sibling::a
${cho_xu_ly_rdo_checked}    //label[text()="Chờ xử lý"]/preceding-sibling::a[@class='checked']
${kenh_ban}    //span[@class='hasButton']/span[@class='fa fas fa-walking']
${input_kenh_ban}    //ul[@id='SaleChannel_taglist']/following-sibling::input
