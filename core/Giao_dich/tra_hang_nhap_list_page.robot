*** Variables ***
${textbox_search_trahangnhap}    //*[@id='productSearchInput']
${textbox_soluong_tra}    //tr[contains(@class, 'tr-odd productMaster')]//div[contains(@class, 'qtyBox')]//input[contains(@class, 'isQuantity')]
${cell_gia_tralai}    //*[@id='itmDiscount0']
${dropdown_product_code_display}       //div[contains(@class,'ovh')]//p[contains(text(),'{0}')]       # product code
${cell_product_code_display_thn}      //tr//td[contains(@class, 'cell-code')]//label[contains(text(),'{0}')]
${textbox_quantity_thn}        //tr//td[contains(@class, 'cell-code')]//label[contains(text(),'{0}')]//..//..//input[contains(@class,'isQuantity')]         # Product Code
${cell_lastest_number_thn}      //div[@class='form-group']//span[contains(@class, 'qty')]
${textbox_input_serial_num_thn}       //input[@placeholder='Nhập số Serial/Imei']
${textbox_input_imei_by_productcode}        //tr//td[contains(@class, 'cell-code')]//label[contains(text(),'{0}')]//..//..//..//input[@placeholder='Nhập số Serial/Imei']
${dropdown_item_imei_display_thn}       //ul//li//em[contains(text(),'{0}')]         # imei number
${tag_imei_thn}         //ng-include//span[contains(text(),'{0}')]          #imei number  or lot number
${button_changeprice_thn}       //button[@id='itmDiscount0']
${button_changeprice_by_productcode_thn}        //td[label[contains(text(),'{0}')]]//..//td[contains(@class,'cell-price txtR')]//button         # product code
${textbox_newprice_thn}        //kv-popup[@id='puchaseReturnItemDiscount']//label[contains(text(), 'Giá mới')]//..//input[contains(@class,'iptPriceNew')]
${textbox_discount_thn}       //kv-popup[@id='puchaseReturnItemDiscount']//label[contains(text(), 'Giảm giá')]//..//input[contains(@class,'discountValue')][2]
${textbox_discount_percentage_thn}       //kv-popup[@id='puchaseReturnItemDiscount']//label[contains(text(), 'Giảm giá')]//..//input[contains(@class,'discountValue')][1]
${button_discount_percentage_thn}        //div[@class='kv2Pop pop popArrow arrow-left']//a[contains(@class, 'btn-toggle')][contains(text(),'%')]
${button_discount_vnd_thn}        //div[@class='kv2Pop pop popArrow arrow-left']//a[contains(@class, 'btn-toggle')][contains(text(),'VND')]
${button_purchase_return_discount}        //button[@id='idCartDiscount']
${button_purchase_return_discount_ratio}          //kv-toggle[@ng-model="DiscountType"]//a[text()='%']
${textbox_purchase_return_discount_from_purchase_form}        //div[@class='kv2Pop pop popArrow arrow-left']//input[contains(@class, 'iptPriceNew')]
${textbox_purchase_return_discount}       //input[@ng-show="DiscountType != discountTypes.percent"]
${textbox_purchase_return_ratio_discount}       //input[@ng-show="DiscountType == discountTypes.percent"]
${textbox_input_supplier}        //input[@id='idSupplierSearchTerm']
${cell_nhacungcap_thn}        //div[@class="output-complete"]//li[1]
${item_supplier_name_in_dropdown}       //ul//li//span[contains(text(),'{0}')]
${cell_supplier_name_finished}       //a[@id='idEditSupplier']
${textbox_paid_for_supplier}        //input[@id='payGetCustomer']
${button_finish_thn}        //a[@ng-click="saveData(true)"]
${cell_add_to_debt}        //div[@class='form-group payAccount']/div
${textbox_purchase_return_code}        //input[@placeholder='Mã phiếu tự động']
#tra hang nhap list page
${button_tra_hang_nhap}     //a[@ng-show="rights.canAdd"]
#chi phi hoan tra
${button_chiphi_nhap_hoanlai}      //a[@ng-click="showExpensesOther(0)"]
${checkbox_ma_chihphi_hoanlai}    //td[text()='{0}']//..//label//span     #0:ma chi phi
${cell_chiphi_nhap_hoanlai}     //a[@ng-click="showExpensesOther(0)"]
${cell_chiphi_nhap_hoanlai_theo_ma}     //a[@id='idExpensesOther{0}']
${textbox_thn_muc_chi_moi}      //input[@ng-change="expensesOtherValueChanged()"]
${toggle_chi_phi_thn_%}    //kv-toggle[@ng-model='formData.ExpensesOtherValueType']//a[normalize-space()='%']
${toggle_chi_phi_thn_VND}    //kv-toggle[@ng-model='formData.ExpensesOtherValueType']//a[normalize-space()='VND']
${button_close_popup_chiphi_nhap_hoanlai}   //div[@kendo-window="expensesOtherWindow"]//..//div//span[contains(text(),'Close')]
#
${button_dongy_phanbo_gianhap}      //div[contains(@style,'transform: scale(1)')]//button[@ng-enter="onConfirm()"]
${button_ko_dongy_phanbo_gianhap}     //div[contains(@style,'transform: scale(1)')]//button[@ng-enter="onCancel()"]
#
${textbox_thn_giamgia_moi}        //input[@ng-change="cart.updateValue(true)"]
#nhieudong
${textbox_thn_soluong_in_row}     //td[@id='iq-{0}_{1}']//div//input
${button_thn_giatralai_in_row}      //td[@id='iq-{0}_{1}']//..//td[@class="cell-price txtR"]//button
${button_thn_them_dong}     //td[@id='iq-{0}_0']//..//td[@class="cell-adddel txtR"]//i
${textbox_thn_imei_in_row}      //td[@id='iq-{0}_{1}']//..//td//tags-input//input
${cell_thn_imei_in_row}     //td[@id='ti-{0}_{1}']
#
${textbox_thn_search_ma_phieu}      //div[@class='header-filter-search']/div[@class='input-group']/input
${button_thn_luu}     //a[i[@class='fas fa-save']]
${button_thn_sao_chep}      //a[i[@class='fa fa-clone']]
${button_thn_huy_bo}      //a[@ng-show="hasVoid"]
${button_thn_dongy_huybo}     //button[@class='btn-confirm btn btn-success']
#lodate
${item_lot_dropdownlist}    //ul[@class='suggestion-list']//li//span//em[text()='{0}']
${textbox_input_lot}    //input[@placeholder='Nhập lô, hạn sử dụng']
${dropdown_lot_display_thn}     //div[@ng-if="suggestionList.visible"]//li[1]       #lô đầu tiên trong danh sách suggestion
${textbox_sl_lo_thn}     //input[@ng-model="product.Quantity"]          #textbox số lượng trả của lô trong popup được bật lên
${button_save_lot_popup}    //a[@ng-click='SaveBatchExpire()']
