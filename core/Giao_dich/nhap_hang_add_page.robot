*** Variables ***
${textbox_nh_search_hh}    //*[@id='productSearchInput']
${textbox_nh_soluong}    //td[contains(@class, 'cell-qty-numb')]//input
${textbox_nh_gia}    //tr[1]//td[contains(@class, 'cell-price') or contains(@class, 'cell-total') ]//input[contains(@class, 'txtR')]
${nh_cell_first_product_code}    //tr[1]//td[@class='cell-code']
${nh_item_indropdown_search}    //ul//li//div[contains(@class, 'ovh')]//p[contains(text(),'{0}')]
${cell_nh_thanhtien}    //tr[1]//div[contains(@class, 'qtyBox')]//input[contains(@class, 'cell-total')]
${cell_nh_giamgia}    //*[@id='itmDiscount0']
${button_nh_giamgiasp_vnd}    //*[@id='productPrice']//kv-toggle//a[contains(text(), 'VND')]
${button_nh_giamgiasp_vnd%}    //*[@id='productPrice']//kv-toggle//a[contains(text(), '%')]
${textbox_nh_giamgia_sp}    //*[@id='productPrice']//*[@id='priceInput']
${text_nhaphang_ui}    //*[contains(@class, 'header-page-inline')]//h1[(text()= 'Nhập hàng')]
${element_phieu_nhap_hang}    //*[contains(@class, 'headerContent columnViewTwo')]//span[text()='Phiếu nhập hàng']
#Right information import
${textbox_nh_ncc}    //*[@id='idSupplierSearchTerm']
${button_nh_hoanthanh}    //a[@ng-click="saveData(true)"]
${label_nh_hh}    Mã hàng hóa
${textbox_nh_tien_tra_ncc}    //*[@id='payGetCustomer']
${cell_tong_tien_hang}    //div[contains(@class,'kv2BoxTop')]//div[contains(@class, 'form-group') and ./label[text()='Tổng tiền hàng ']]//div[contains(@class, 'form-wrap')]
${row_product}    HH number
${textbox_nh_ma_phieunhap}    //div[contains(@class, 'kv2BoxTop')]//div[contains(@class, 'form-wrapper')]//label[contains(text(), 'Mã phiếu nhập')]/..//input[contains(@class, 'codeAuto')]
${cell_nh_giamgia_hd}    //*[@id='idDiscountOnOrder']
${button_nh_gg_hd__vnd}    //*[@id="discountOnOrder"]//kv-toggle//a[contains(text(), 'VND')]
${button_nh_gg_hd_%}    //*[@id="discountOnOrder"]//kv-toggle//a[contains(text(), '%')]
${textbox_nh_giamgia_hd}    //*[@id='discountOnOrder']//*[@id='idDiscountValue']
${textbox_nhap_serial}    //tags-input[@placeholder='Nhập số Serial/Imei']//input
${cell_nhacungcap}    //div[@class='output-complete']//li[1]
${cell_nh_tinh_vao_cong_no}    //label[contains(text(),"Tính vào công nợ")]//..//div
${cell_nh_lastest_number}    //span[@class='qty ng-binding']
${button_nh_giamgia_sp}    //*[@kv-popup-anchor="productPrice"]
${textbox_nh_dongia_sp}    //input[@ng-change="ChangePrice(dataItem)"]
${textbox_nh_gghd_%}    //input[@ng-show="DiscountType == discountTypes.percent"]
${cell_nh_unit}    //span[span[@class='slcUnit']]
${item_unit_nh_inlist}    //span[@class='slcUnit']//select//option[contains(text(),'{0}')]    # ten dvt
${textbox_nh_nhap_lo}    //input[@placeholder="Nhập lô, hạn sử dụng"]
${item_nh_lo_in_dropdown}    //em[contains(text(),'{0}')]    #0: ten lo
${button_nh_them_lo_hsd}    //li[contains(text(),'Thêm mới lô, hạn sử dụng')]
${textbox_nh_tenlo}    //input[@ng-model="product.BatchName"]
${textbox_nh_hansudung}    //input[@k-ng-model="product.ExpireDate"]
${button_nh_xong_popup_themlo}    //a[@ng-click="SaveBatchexpire()"]
${button_nh_luutam}    //a[@ng-enter="saveData(false)"]
${cell_supplier_charge_value}    //a[@ng-enter="showExpensesOther(0)"]
${cell_other_charge_value}    //a[@ng-enter="showExpensesOther(1)"]
${checkbox_all_expense}    //input[@ng-change="checkAllExpensesOthers()"]/..
${button_close_popup_cpnh}      //div[contains(@class,'window-expensesOtherInput')]//span[@role='presentation'][normalize-space()='Close']
${textbox_nh_muc_chi_moi}    //input[@ng-change="expensesOtherValueChanged()"]
${cell_nh_chi_phi_nhap_theo_macp}    //a[@id='idExpensesOther{0}']    #0: ma chi phi nhap
${button_nh_cpnh_vnd}    //kv-toggle[@ng-model="formData.ExpensesOtherValueType"]//a[text()='VND']
${button_nh_cpnh_%}    //kv-toggle[@ng-model="formData.ExpensesOtherValueType"]//a[text()='%']
${checkbox_nh_cpnh}    //td[text()='{0}']//..//td[@class="cell-check"]//span    #0 : ma chi phi nh
${textbox_nh_nhap_serial}    //tr[td[span[contains(text(),'{0}')]]]/following-sibling::tr[1]//input
${button_nh_dongy_hoanthanh_dhn}    //button[contains(@class,'btn-confirm')]
${button_nh_boqua_hoanthanh_dhn}    //div[span[contains(text(),'Hoàn thành')]]//..//div//button[contains(@class,'btn-cancel')]
###
${button_nh_optional_display}        //a[@id='toogleActionButton']//i
${toggle_nh_add_row}        //span[@id='toggleMultiLine']
##Popup Lo date
${textbox_nh_soluong_lo}          //input[@ng-model="product.Quantity"]
#
${textbox_nh_soluong_any_pr}      //td[span[text()='{0}']]//..//td[contains(@class,'cell-qty-numb')]//input
${textbox_nh_dongia_any_pr}       //td[span[text()='{0}']]//..//td[contains(@class,'cell-total')]//input
${button_nh_giamgia_any_pr}     //td[span[text()='{0}']]//..//td[contains(@class,'cell-total')]//button
${button_nh_luu}        //a[@ng-enter="saveData(true)"]
${button_nh_dongy_capnhat}      //button[contains(@class,"btn-confirm")]
${button_nh_dongy_capnhat_info}      //button[contains(@class,"btn-confirm kv2Btn")]
${button_nh_remove_ncc}      //a[@id='idRemoveSupplier']
#nhieu dong
${button_nh_giamgia_pr_in_row}     //button[@id='itmDiscount1_{0}']
${textbox_nh_dongia_pr_in_row}    //td[div[button[@id='itmDiscount1_{0}']]]//..//td[@class="txtR cell-total"]//input
${textbox_nh_soluong_pr_in_row}     //td[div[button[@id='itmDiscount1_{0}']]]//..//td[contains(@class,"cell-qty-numb")]//input
${textbox_nh_nhapimei_in_row}      //tr[td[div[button[@id='itmDiscount1_{0}']]]]//..//tr//tags-input//input
${button_nh_add_row_by_pr}          //td[div[button[@id='itmDiscount1_{0}']]]//..//td[@class="cell-adddel"]//i
