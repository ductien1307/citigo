*** Settings ***
Library           SeleniumLibrary
Library           Collections
Resource          banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../share/imei.robot
Resource          ../API/api_phieu_nhap_hang.robot
Resource          ../API/api_dathang.robot

*** Variables ***
### menu bar MHBH
${tab_suachua}    //div[contains(@class,'kv-tabs')]//ul//li//a[@class="tabBut_3 tabbut_new"]
${button_menubar}    //li[contains(@class, 'menu-bar')]//i[@class='fa fa-bars']
${cell_xuly_dathang}    //a[i[@class='fa fa-recycle fa-fw']]//span//span
${cell_tuychon_hienthi}    //a[i[@class='fa fa-eye-slash fa-fw']]//span//span
${cell_dangxuat}    //span[text() = 'Đăng xuất']
${cell_quanly}    //span[text() = 'Quản lý']
${button_dong_bo}     //i[@class='fa fa-sync-alt']
${icon_kenh_ban_truc_tiep}   //i[@title='Kênh bán: Bán trực tiếp']
${cell_xem_bc_cuoingay}      //a[i[@class='fa fa-align-left fa-fw']]//span//span
${cell_xuly_yeucau_suachua}      //a[i[@class='fas fa-file-export fa-fw']]//span//span
${cell_import}     //a[i[@class='fa fa-upload fa-fw']]//span//span
${button_close}   //span[text()='Close']
${cell_return}     //a[i[@class='fa fa-reply-all fa-fw']]//span//span
###
${button_them_kh}     //button[@id='addCustomer']
${button_them_dtgh}     //div[@id='searchPartnerForm']//div//i[@class='far fa-plus']
${tab_hoadon}     //div[contains(@class,'kv-tabs')]//ul//li//a[text()='Hóa đơn']
${textbox_bh_search_ma_sp}    //input[@id='productSearchInput']
${textbox_bh_soluongban}    //div[contains(@class, 'row-product')]//input[contains(@class, 'form-control')]
${cell_bh_rednumber}    //div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-change-price')]//div[contains(@class, 'popup-anchor')]/span/span
${cell_bh_ma_sp}    //div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-code')]
${cell_bh_thanhtien}    //div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][{0}]//div[contains(@class, 'cell-price')]
${item_search_product_indropdow}    //div[@class='search-product-info']//span[text()='{0}']
${cell_bh_gia}    //button[@kv-popup-anchor='productPrice']
${cell_item_input_imei}    //tags-input[@placeholder='Nhập số Serial/Imei']
${tag_single_imei_mhbh}    //ti-tag-item//span[contains(text(),'{0}')]    #imei
${button_xoa_multi_hh}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//div[contains(@class, 'cell-action')]//a    #ma hh
${textbox_multi_soluong}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//div[contains(@class, 'cell-quatity')]//input[@type= 'text']    #ma hh
${texbox_imei_search_multi_product}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//input[@placeholder='Nhập số Serial/Imei']    #ma hh
${cell_imei_multi_product}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//tags-input[@placeholder='Nhập số Serial/Imei']    #ma hh
${cell_each_imei}    //tags-input//ul//li//span[text()='{0}']    #imei
# doi tra hang
${cell_dth_sanpham}    //cart-refund-products-component//div[contains(@class, 'output-complete')]//li[1]
${cell_dth_ma_sanpham}    //cart-refund-products-component//div[contains(@class, 'product-cart')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-code')]
${textbox_dth_nhap_serial}    //cart-refund-products-component//input[@placeholder='Nhập số Serial/Imei']
${item_dth_imei_in_dropdown}    //cart-refund-products-component//em[contains(text(),'{0}')]    #input imei
${cell_dth_imei_multi_product}    //cart-refund-products-component//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//tags-input[@placeholder='Nhập số Serial/Imei']
##
${cell_lastest_number}    //payment-invoice-component//span[@class='badge']    #ô tổng số lượng sp trong hóa đơn
${textbox_bh_search_khachhang}    //*[@id='customerSearchInput']
${cell_auto_complete_customer}    //div[@class='customer-search-autocomplete']//a[@ng-click='vm.openEditForm()']//span[contains(text(),'{0}')]
${thongtin_khachhang}    //a[@id='infoCustomer']
${button_xoa_khach_hang}    //button[@id='deleteCustomer']
##
${cell_surcharge_value}    //a[@id='btnSurcharge']
${checkbox_surcharge_by_surchargecode}    //tr//td[text()='{0}']//..//label    #ma thu khac
${cell_bh_tongtienhang}    //payment-invoice-component//div[contains(text(), 'Tổng tiền hàng')]/../div[contains(@class, 'form-output')]
${cell_bh_khachcantra}    //payment-invoice-component//div[contains(@class, 'form-group') and ./label[strong[span[contains(text(), 'Khách cần trả')]]]]//div[contains(@class, 'form-output')]
${cell_tienthua_trakhach}    //payment-invoice-component//div[span[contains(text(), 'Tiền thừa trả khách')]]//../div[contains(@class,'form-output')]
${textbox_bh_khachtt}    //*[@id='payingAmtInvoice']
${button_bh_khachtt_hd}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group')]//button[@title='Khách thanh toán']//i[@style=""]
${button_bh_thanhtoan}    //*[@id='saveTransaction']
###
${textbox_bh_thanhtoan_multipayments}    //div[contains(@class, 'k-widget k-window payment-invoice')]//*[@id='txtCurrentAmount']
${cell_warning_sl}    //div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-warning')]
${element_bh_nhap_serial}    //tags-input[@placeholder='Nhập số Serial/Imei']//ul[@class='tag-list']
${button_hd_themmoi}    //div[contains(@class, 'content-tab')]//ul/li//a[@ng-click='vm.newPane()']
###serial
${item_serial_in_list}    //ul//li[{0}]//ng-include//span
${item_serial_in_dropdown}    //em[contains(text(),'{0}')]
${textbox_nhap_serial}    //input[@placeholder='Nhập số Serial/Imei']
${cell_bh_unit}    //div[contains(@class, 'row-product')]//div[contains(@class, 'cell-units')]//select[@id='unit']    #####unit
${item_unit_in_list}    //div[contains(@class, 'k-animation')]//div[contains(@class, 'k-list-scroller')]//li[contains(@class, 'k-item')][text()='{0}']
${cell_nguoiban}    //div[@id ='salesman1']//span[contains(@class, 'k-input')]
${checkbox_delivery}    //label[@id='deliveryCheckbox']
${cell_serial_imei}    //div[contains(@class, 'autocomplete')]//li[contains(@class,'suggestion-item')]//span[text()='{0}']    #ma imei
${cell_khachhang}    //div[@class='output-complete']//li[1]
${cell_sanpham}    //div[contains(@class, 'output-complete')]//li[1]
${textbox_khtt_order}    //input[@id='payingAmtOrder']
${textbox_search_order }    //input[@id='searchOrderCode']
${button_chon_order}    //order-list-form-component//tbody//tr//td[span[text()= '{0}']]//..//a[span[contains(text(), 'Chọn')]]    #ma dat hang
${button_delete_kh}    //div[contains(@class, 'customer-search-autocomplete')]//button[contains(@class, 'delete')]
${textbox_search_bangia}    //div[contains(@class, 'animation-container')]//input[contains(@class, 'textbox')]
${cell_banggia}    //div[contains(@class, 'list-scroller')]//ul//li//span[text()='{0}']    # ten bang gia
${textbox_search_imei}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//div[contains(@class, 'cells-serial')]//input[@placeholder = 'Nhập số Serial/Imei']    # ma san pham, multi product
${textbox_hoantratamung}    //input[@id='payingDepositReturn']
${cell_unit_name}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[contains(@class, 'cell-units')]//span//span[contains(@class, 'k-input')]
${dropdownlist_banggia}      //div[@class='wrap-actions']//pricebook-component//span[@class='k-input']//span
${textbox_banggia}      //div[@id='pricebook-list']//input[@class='k-textbox']
${item_banggia_in_dropdow}      //span[contains(text(),'{0}')]
##promo
${button_promo}    //payment-invoice-component//div[contains(text(),'Tổng tiền hàng') or contains(text(),'Sub-total')]//cart-promotions-component//button
${checkbox_promo_by_promoname}    //tr//div[contains(text(),'{0}')]//..//..//label    #name
${button_apply_promo}    //button[contains(text(),'Áp dụng')]
${icon_promo_sale}    //payment-invoice-component//div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label[contains(text(), 'Giảm giá')]]//span[@class='badge km']
${textbox_timhangtang}    //tr[td[div[contains(text(), '{0}')]]]//input[@placeholder='Tìm hàng tặng']    #ten chuong trinh KM
${item_giveaway_product_inlist}    //p[contains(text(),'{0}')]    #ma sp
${button_apply_in_select_giveaway_list}    //product-selection-component//button[@class='btn btn-success'][contains(text(),'Áp dụng')]
${cell_num_in_promo_screen}    //div[@class='row-product']//h4[@title= '{0}']//..//..//input    #ma sp
${icon_promo_sale_in_pro_compo}    //cart-gift-products-component[@cart-approved-promotion='$root.activeCart.ApprovedPromotions']//cart-promotions-component//button[@class='promotion-icon']
${button_promo_icon_on_row_product}    //i[@class='fa fa-gift']
${icon_activated_promo_on_row_product}    //i[@class='mask mask-gift']
${textbox_timhangkhuyenmai}    //input[@placeholder='Tìm sản phẩm khuyến mại']
${cell_result_timhangkhuyenmai}    //ul[@id='infScroll']
${textbox_search_product_select_promoproduct}    //input[@id='search_product_selection']
##gộp promotion
${button_multi_promo_icon_on_row_product}    //h4//i[@class='fa fa-gift']
## banggia
${select_hanghoa_in_bangia}    //div[@id='idProductCatTreeAll']//i[@class='fa fa-long-arrow-right']
${textbox_giamoi_in_banggia}    //section[contains(@class, 'mainWrap ')]//table//tr[1]//td[contains(@class, 'txtR ')]//input[@type ='text']
${icon_giamgia}    //kv-popup[@id='calcPriceItem']//i[contains(@class, 'minus')]
${textbox_giamgia_in_bangia}    //kv-popup[@id='calcPriceItem']//input[@type ='text']
${checkbox_giamgia}    //kv-popup[@id='calcPriceItem']//div[contains(@class, 'prettycheckbox')]//a
${button_ok}      //kv-popup[@id='calcPriceItem']//a[contains(text(), 'OK')]
#menu bars release voucher
${item_menu_release_voucher}    //a[i[@class='mask mask-voucher']]//span//span
${textbox_search_voucher_code}    //input[@placeholder='Nhập mã voucher và ấn Enter']
${radio_button_voucher_giveawaytype}    //label[@class='radio-inline']//span[contains(text(),'Tặng')]//..//..//input
${radio_button_voucher_saletype}    //label[@class='radio-inline']//span[contains(text(),'Bán')]//..//..//input
${button_save_form_release_voucher}    //div[@class='k-footer']//i[@class='fa fa-save']
##select payment type
${button_card}    //payment-invoice-component//i[@class='fa fa-credit-card']
${button_voucher_otherpaymentmethod_popup}    //multiple-payments-form-component//button[contains(@ng-click, 'vm.useVoucher()')]
${button_card_otherpaymentmethod_popup}    //multiple-payments-form-component//button[contains(@ng-click, 'paymentMethods.card')]
${button_transfer_otherpaymentmethod_popup}    //multiple-payments-form-component//button[contains(@ng-click, 'paymentMethods.transfer')]
${button_cash_otherpaymentmethod_popup}    //multiple-payments-form-component//button[contains(@ng-click, 'paymentMethods.cash')]
${textbox_voucher_code_otherpaymentmethod_popup}    //div[@class='form-wraper form-label-100']//input[@type='text']
${vouchercode_for_validation_otherpaymentmethod_popup}    //div[@class='k-widget k-window payment-invoice']//span[@class='voucher-code']
${button_apply_voucher_code_otherpaymentmethod}    //voucher-code-component//button[contains(text(),'Áp dụng')]
${button_finish_otherpaymentmethod_popup}    //multiple-payments-form-component//button[contains(text(),'Xong')]
${textbox_sotien_otherpaymentmethod_popup}    //div[@class='form-wraper form-label-280']//input[@type='text']
${button_cash_otherpaymentmethod_popup}    //div[@class='payment-btn']//span[text()='Tiền mặt']//..//..//button
${textbox_giaban_otherpaymentmethod_popup}    //div[@class='form-group']//label[span[text()='Giá bán']]//..//..//input[@type='text']
${arrow_dropdown_group_received}    //div[@class='col-md-7 form-label-150']//div//span[@class='k-icon k-i-arrow-s'][contains(text(),'select')]
${item_dropdown_group_received}    //div[@id='partnerTypes-list']//div[@class='k-list-scroller']//li[contains(text(),'{0}')]
${textbox_af_selectedgroup}    //span[@class='k-input'][contains(text(),'{0}')]
${textbox_customer_otherpaymentmethod_popup}    //input[@id='partnerSearchInput']
${button_confirm_notinput_data}    //div[@data-role='draggable']//div[p[contains(text(), 'Bạn chưa nhập Tên người mua')]]//..//..//button[contains(text(), 'Đồng ý')]
${button_confirm_create_receivedform}    //div[@data-role='draggable']//div[p[contains(text(), 'Hệ thống sẽ tạo ra phiếu thu')]]//..//..//button[contains(text(), 'Đồng ý')]
###Lodate
${textbox_nhap_lo}    //input[@placeholder='Nhập lô']
${cell_item_input_lo}    //tags-input[@placeholder='Nhập lô']
${item_lo_in_dropdown}    //div[contains(text(),'{0}')]
${textbox_nhap_lo_any_pr}     //div[div[div[text()='{0}']]]//..//div//input[@placeholder="Nhập lô"]
## nhieu dong
${button_add_row_infirstline}    //div[contains(@class,'row-product')]//div[text()='{0}']/..//..//div[contains(@class,'cell-action')]//i    #ma hh
${textbox_soluong_multirow}    //div[contains(@class,'row-list')]//input[@id='extraInput_{0}_0']    #id product
${icon_item_macdinh_khtt}    //div[@kendo-window='myKendoWindow']//div[contains(@class,'form-group') and ./label[text()='Mặc định khách thanh toán ']]//span[contains(@class,'toogle')]
${toggle_item_themdong}    //div[@kendo-window='myKendoWindow']//div[contains(@class,'form-group') and ./label[text()='Thêm dòng ']]//span[contains(@class,'toogle')]
${button_tuychon_hienthi_dongy}    //div[contains(@class,'k-footer')]//button[text()=' Đồng ý']
${button_tuychon_hienthi_boqua}    //div[contains(@class,'k-footer')]//button[text()=' Bỏ qua']
${textbox_search_imei_multirow}    //cart-item-duplication-component//div[contains(@class, 'has-serial')][{0}]//div[contains(@class, 'row-product')]//input[@placeholder='Nhập số Serial/Imei']    # thứ tự dòng imei 1 - 2- 3....
${cell_item_imei_multirow}    //cart-item-duplication-component//div[contains(@class, 'has-serial')][{0}]//div[contains(@class, 'row-product')]//tags-input[@placeholder='Nhập số Serial/Imei']    # thứ tự dòng imei 1 - 2- 3....
${button_tang_soluong}    //div[div[text()='{0}']]//..//div//button[@class='btn-icon up']
${button_giam_soluong}    //div[div[text()='{0}']]//..//div//button[@class='btn-icon down']
${icon_warning}    //div[div[text()='{0}']]//..//div[@class='cell-warning']//button
${button_luudonkhachle_dongy}    //div[span[text()='Lưu đơn hàng']]//..//div//div//button[contains(@class,'btn-confirm')]
${textbox_quantity_by_line}    //input[@id="extraInput_{0}_{1}"]    #0: id sp, #1: thu tu dong
${button_baseprice_by_line}    //div[input[@id="extraInput_{0}_{1}"]]//..//div[@class="cell-change-price"]//button    #0: id sp, #1: dong
${textbox_row_nhap_imei}    //div[input[@id="extraInput_{0}_0"]]//..//div[contains(@class,'cells-serial')]//input    #0: id sp
${cell_imei_multirow}    //div[input[@id="extraInput_{0}_0"]]//..//div[contains(@class,'cells-serial')]//tags-input    #0: id sp
${textbox_input_imei_by_line}    //div[div[input[@id='extraInput_{0}_{1}']]]//input[@placeholder='Nhập số Serial/Imei']    #0: id sp, #1: dong
##popup Luu don Hang
${button_saveinvoice_confirmation}    //div[@class='k-widget k-window k-window-danger']//button[contains(text(), 'Đồng ý')]
${cell_giaban_in_suggetion}    //p[span[text()='{0}']]//span[@class='priceValue']
${cell_giaban_in_toolbar}    //div[span[contains(text(),'{0}')]]//..//div//span[@class='product-price']    #0: ten sp
${toggle_filter_product}    //i[contains(@class,'mask-filterproducts')]
${textbox_bh_tknhomhang}    //input[@placeholder='Tìm kiếm nhóm hàng']
${checkbox_bh_nhomhang}    //span[span[span[text()='{0}']]]//..//span//label
${button_filter_xong}    //div[@class='float-nav left']//a[@class='btn btn-success']
${label_xoa_nhom_hang}    //a[@ng-click="vm.clearFilter()"]
${button_group_prs}    //i[contains(@class,'mask-ungroup')]
${button_dongy_dong_hoadon}    //button[contains(@class,'btn-confirm')]
${button_dong_tab_hoadon}    //i[contains(@class,'mask-delete')]
${cell_surcharge_doitra_value}    //a[@id='btnSurchargeRefund']
##pop up tinh cong no khach hang
${button_tinhvaocongno}   //div[@ng-show='$root.activeCart.CustomerId && ($root.activeCart.PayingAmount - $root.activeCart.BalanceDue) > 0.000001']//span[contains(text(),'Tính vào công nợ')]    ## thanh toan du
${checkbox_thanhtoan_in_popuptienthua}    //payment-allocation-component//span[text()='Thanh toán hóa đơn nợ']
${invoice_code_in_popuptienthua}    //table//td[contains(@class,'cell-code')]//span
${invoice_payment_in_popuptienthua}   //div[contains(@class,'col-md-offset')]//span[text()='Tổng thanh toán hóa đơn:']//..//..//strong
${button_dongy_in_popuptienthua}   //div[contains(@class,'k-footer')]//button[contains(@class,'btn btn-success')]
##phieu thu MHBH
${cell_lapphieuthu}     //a[i[@class='far fa-file-alt fa-fw']]//span//span
${textbox_searchcustomer_phieuthu_mhbh}     //input[@placeholder='Tìm khách hàng']
${cell_item_khachhang_phieuthu_mhbh}   //div[contains(@class,'output-complete')]//span[text()='Mã: {0}']    #ma khach hang
${textbox_thutukhach}     //input[@id='amount']
${button_taophieuthu}   //button[@ng-click='vm.doSubmit()']
##switch chi nhanh
${icon_select_branch_in_mhbh}    //li[@class='switch-branch']//span[text()='select']
${cell_item_branch}   //div[contains(@class,'k-list-scroller')]//li[span[text()='{0}']]   #ten chi nhánh
${label_branch_in_mhbh}   //div[contains(@class,'branch-dropdown')]//div[contains(@class,'k-list-scroller')]//li//span[contains(@class,'k-state-default active')]
## get text unit product in MHBH
${text_unit_product}    //div[contains(@class,'cell-units')]//select//option[{0}]   #thứ tự option tương ứng unit hiển thị 1,2...
${text_unit_product_dth}    //div[contains(@class,'k-animation-container')][2]//div//ul[@unselectable='on']//li
#
${button_ds_phimtat}      //i[@class="fa fa-exclamation"]
${label_exx}      //a[contains(text(),'502')]
#Yeu cua sua chua
${cell_sc_ma_sp}      //label[@class='form-label control-label width-auto']
#popup xu li dat hang
${kiemtra_hienthi}    //span[contains(text(),'Hiển thị')]
${textbox_xldh_kh}    //input[@ng-model="vm.customerNameFilter"]
${cell_ma_don_dat_hang}     //td[@class='cell-code']//span[@ng-bind='dataItem.Code'][contains(text(),'{0}')]
#popup tra hang
${textbox_return_kh}    //input[@ng-model='vm.customerSearchText']
${cell_ma_hd}    //span[contains(text(),'{0}')]
#popup lap phieu thu
${textbox_lpt_kh}    //input[@id='receiptCustomerSearch']
${cell_sdt_kh}    //output[@id='customer-phone']
#popup them moi khach hang
${textbox_ma_kh}    //input[@ng-model='vm.customer.Code']
${textbox_ten_kh}    //input[@id='customerName']
${textbox_sdt_kh}    //input[@ng-model='vm.customer.ContactNumber']
${textbox_diachi_kh}    //textarea[@ng-model='vm.entity.Address']
${button_luu_kh}    //span[contains(text(),'Lưu (F9)')]
${textbox_email_popup_themmoiKH}    //input[@ng-model='vm.customer.Email']
#popup them moi hang hoa
${button_mhbh_themmoi_hh}   //div[contains(@class,'has-add')]//a[text()='+ Thêm mới hàng hóa']
${textbox_mhbh_mahang}      //input[@ng-model="vm.$scope.product.Code"]
${textbox_mhbh_tenhang}   //input[@ng-model="vm.$scope.product.Name"]
${cell_mhbh_nhomhang}   //span[text()='---Lựa chọn---'][not(@class)]
${item_mhbh_nhomhang_indropdow}   //span[contains(text(),'{0}')]
${textbox_mhbh_giavon}     //input[@ng-model='vm.$scope.product.Cost']
${textbox_mhbh_giaban}    //input[@ng-model="vm.$scope.product.BasePrice"]
${textbox_mhbh_dvcb}    //input[@ng-model="vm.$scope.product.Unit"]
${textbox_mhbh_tonkho}    //input[@ng-model="vm.$scope.product.OnHand"]
${checkbox_mhbh_imei}    //input[@ng-model='vm.$scope.product.IsLotSerialControl']
${button_mhbh_luu_hh}   //span[contains(text(),'Lưu')]

*** Keywords ***
Apply Cash
    [Arguments]    ${input_value}
    Wait Until Page Contains Element    ${textbox_sotien_otherpaymentmethod_popup}
    Sleep    2 s
    Run Keyword If    '${input_value}' == 'all'    Log    Ignore input value
    ...    ELSE    Input data    ${textbox_sotien_otherpaymentmethod_popup}    ${input_value}
    Click Element JS    ${button_cash_otherpaymentmethod_popup}

Apply voucher
    [Arguments]    ${voucher_code}
    Wait Until Element Is Visible    ${button_voucher_otherpaymentmethod_popup}
    Click Element JS    ${button_voucher_otherpaymentmethod_popup}
    Wait Until Keyword Succeeds    3 times    3 s    Input voucher Code    ${voucher_code}
    Wait Until Element Is Visible    ${vouchercode_for_validation_otherpaymentmethod_popup}
    ${get_voucher_code_ui}    Get Text    ${vouchercode_for_validation_otherpaymentmethod_popup}
    Should Be Equal As Strings    ${get_voucher_code_ui}    ${voucher_code}

Apply Card
    [Arguments]    ${input_value}
    Wait Until Page Contains Element    ${textbox_sotien_otherpaymentmethod_popup}
    Sleep    2 s
    Run Keyword If    '${input_value}' == 'all'    Log    Ignore input value    ELSE    Input data    ${textbox_sotien_otherpaymentmethod_popup}    ${input_value}
    Click Element JS    ${button_card_otherpaymentmethod_popup}

Apply Transfer
    [Arguments]    ${input_value}
    Wait Until Page Contains Element    ${textbox_sotien_otherpaymentmethod_popup}
    Sleep    2 s
    Run Keyword If    '${input_value}' == 'all'    Log    Ignore input value    ELSE    Input data    ${textbox_sotien_otherpaymentmethod_popup}    ${input_value}
    Click Element JS    ${button_transfer_otherpaymentmethod_popup}

Go to Release voucher popup
    Wait Until Element Is Visible    ${button_menubar}
    Click Element JS    ${button_menubar}
    Wait Until Element Is Visible    ${item_menu_release_voucher}
    Click Element JS    ${item_menu_release_voucher}

Go to popup for other payment methods
    Wait Until Element Is Visible    ${button_card}
    Click Element JS    ${button_card}
    Wait Until Page Contains    Khách thanh toán

Input voucher Code
    [Arguments]    ${voucher_code}
    Wait Until Element Is Visible    ${textbox_voucher_code_otherpaymentmethod_popup}
    Input Text    ${textbox_voucher_code_otherpaymentmethod_popup}    ${voucher_code}
    Sleep    2 s
    Click Element JS    ${button_apply_voucher_code_otherpaymentmethod}

Release Giveaway voucher Code
    [Arguments]    ${list_voucher_code}
    Wait Until Element Is Visible    ${textbox_search_voucher_code}
    : FOR    ${item_voucher_code}    IN ZIP    ${list_voucher_code}
    \    Input Text    ${textbox_search_voucher_code}    ${item_voucher_code}
    \    Press Key    ${textbox_search_voucher_code}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${radio_button_voucher_giveawaytype}
    Sleep    2 s
    Click Element JS    ${radio_button_voucher_giveawaytype}
    Click Element JS    ${button_save_form_release_voucher}
    Wait Until Page Contains Element    ${button_save_form_release_voucher}

Release sale voucher Code
    [Arguments]    ${list_voucher_code}    ${input_voucher_sale_value}
    Wait Until Element Is Visible    ${textbox_search_voucher_code}
    : FOR    ${item_voucher_code}    IN ZIP    ${list_voucher_code}
    \    Input Text    ${textbox_search_voucher_code}    ${item_voucher_code}
    \    Press Key    ${textbox_search_voucher_code}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${radio_button_voucher_saletype}
    Wait Until Page Contains Element    ${textbox_giaban_otherpaymentmethod_popup}
    Input data    ${textbox_giaban_otherpaymentmethod_popup}    ${input_voucher_sale_value}
    Click Element JS    ${button_save_form_release_voucher}
    Sleep    2 s
    Wait Until Element Is Enabled    ${button_confirm_notinput_data}    3s
    Sleep    2 s
    Click Element    ${button_confirm_notinput_data}
    Wait Until Element Is Not Visible    ${button_confirm_notinput_data}
    Wait Until Element Is Enabled    ${button_confirm_create_receivedform}    3s
    Sleep    2 s
    Click Element    ${button_confirm_create_receivedform}
    Wait Until Element Is Enabled    ${button_confirm_create_receivedform}    3s
    Sleep    2 s
    Click Element    ${button_save_form_release_voucher}
    Wait Until Page Does Not Contain Element    ${button_save_form_release_voucher}

Select received Group
    [Arguments]    ${groupname}
    Wait Until Page Contains Element    ${arrow_dropdown_group_received}
    ${item_group_indropdown}    Format String    ${item_dropdown_group_received}    ${groupname}
    Wait Until Page Contains Element    ${item_group_indropdown}
    Click Element JS    ${item_group_indropdown}
    ${item_af_selected}    Format String    ${textbox_af_selectedgroup}    ${groupname}
    Wait Until Element Is Enabled    ${item_af_selected}

Select received name
    [Arguments]    ${name_received}
    Wait Until Page Contains Element    ${textbox_customer_otherpaymentmethod_popup}
    Input data    ${textbox_customer_otherpaymentmethod_popup}    ${name_received}
    Click Element    //li[1]/p

Click Save Invoice incase having confimation popup
    Wait Until Element Is Enabled    ${button_bh_thanhtoan}
    Click Element JS    ${button_bh_thanhtoan}
    #Wait Until Element Is Enabled    ${button_saveinvoice_confirmation}
    Wait Until Keyword Succeeds    3 x    3 s    Click Yes on Saving Confirmation popup

Click Yes on Saving Confirmation popup
    #Wait Until Element Is Enabled    ${button_saveinvoice_confirmation}    30s
    Wait Until Page Contains Element    ${button_saveinvoice_confirmation}    1 min
    Click Element JS    ${button_saveinvoice_confirmation}

Apply multi method
    [Arguments]     ${dict_method}
    ${list_phuongthuc}     Get Dictionary Keys    ${dict_method}
    ${list_gia_tri}        Get Dictionary Values    ${dict_method}
    Wait Until Element Is Visible    ${button_card}
    Click Element JS    ${button_card}
    Wait Until Page Contains    Khách thanh toán
    Wait Until Page Contains Element    ${textbox_sotien_otherpaymentmethod_popup}
    Sleep    2 s
    :FOR        ${item_phuongthuc}    ${item_giatri}     IN ZIP      ${list_phuongthuc}      ${list_gia_tri}
    \       Input data    ${textbox_sotien_otherpaymentmethod_popup}    ${item_giatri}
    \       Run Keyword If    '${item_phuongthuc}'=='Tiền mặt'    Click Element JS    ${button_cash_otherpaymentmethod_popup}    ELSE IF     '${item_phuongthuc}'=='Thẻ'     Click Element JS    ${button_card_otherpaymentmethod_popup}     ELSE   Click Element JS    ${button_transfer_otherpaymentmethod_popup}

Apply surplus payment
    [Arguments]     ${ma_giaodich}    ${tongthanhtoan}
    Wait Until Element Is Visible    ${button_tinhvaocongno}
    Click Element JS    ${button_tinhvaocongno}
    Click Element JS    ${button_tinhvaocongno}
    Wait Until Element Is Visible    ${checkbox_thanhtoan_in_popuptienthua}
    Click Element JS    ${checkbox_thanhtoan_in_popuptienthua}
    Sleep    2s
    ${code}     Get Text    ${invoice_code_in_popuptienthua}
    ${payment}  Get Text    ${invoice_payment_in_popuptienthua}
    ${payment}    Replace String    ${payment}    ,       ${EMPTY}
    Should Be Equal As Strings    ${code}    ${ma_giaodich}
    Should Be Equal As Numbers    ${payment}    ${tongthanhtoan}
    Wait Until Element Is Visible    ${button_dongy_in_popuptienthua}
    Click Element JS    ${button_dongy_in_popuptienthua}

Switch branch in sale form
    [Arguments]     ${input_ten_branch}
    ${cell_item_branch}   Format String   ${cell_item_branch}     ${input_ten_branch}
    KV Click Element JS     ${icon_select_branch_in_mhbh}
    KV Click Element JS By Code    ${cell_item_branch}     ${input_ten_branch}

Open DS phim tat and click Exx
    Wait Until Page Contains Element    ${button_ds_phimtat}    1 min
    Click Element    ${button_ds_phimtat}
    Wait Until Page Contains Element    ${label_exx}    20s
    Click Element    ${label_exx}
    Click Element    ${button_ds_phimtat}
