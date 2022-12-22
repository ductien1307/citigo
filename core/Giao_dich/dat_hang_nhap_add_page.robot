*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot

*** Variables ***
${textbox_dhn_tim_kiem_sp}    //input[@id='productSearchInput']
${item_dhn_sp_indropdown}    //p[contains(text(),'{0}')]
${cell_dhn_sp}    //td[@class='cell-code']//span
${textbox_dhn_so_luong}    //td[span[contains(text(),'{0}')]]//..//td//div[@class='qtyBox']//input
${textbox_dhn_don_gia}    //td[span[contains(text(),'{0}')]]//..//td//input[@ng-change="ChangePrice(dataItem)"]
${button_dhn_giam_gia_sp}    //td[span[contains(text(),'{0}')]]//..//td//div[contains(@class,'proPrice ')]
${button_dhn_giam_gia_sp_VND}    //kv-popup[@id='productPrice']//a[contains(text(),'VND')]
${button_dhn_giam_gia_sp_%}    //kv-popup[@id='productPrice']//a[contains(text(),'%')]
${textbox_dhn_nha_cung_cap}    //input[@id='idSupplierSearchTerm']
${cell_dhn_nha_cung_cap}    //div[@class='output-complete']//li[1]
${cell_dhn_trang_thai}    //span[contains(text(),'Phiếu tạm')]
${item_dhn_trang_thai_indropdow}    //li[contains(text(),'{0}')]
${button_dhn_giam_gia_phieu_dat}    //a[@id='idDiscountOnOrder']
${textbox_dhn_giam_gia_sp}    //input[@id='priceInput']
${textbox_dhn_giam_gia_phieu}    //input[@id='idDiscountValue']
${button_dat_hang_nhap}    //a[@ng-enter="save(true)"]
${cell_dhn_don_vi_tinh}    //span[@class='slcUnit']
${item_dhn_dvt_intdropdown}    //option[contains(text(),'{0}')]
${textbox_dhn_ma_phieu}    //input[@placeholder='Mã phiếu tự động']
${cell_dhn_tinh_vao_cong_no}    //div[contains(@ng-show,'(cart.PayingAmount <= cart.BalanceDue)')]//label[contains(text(),"Tính vào công nợ")]//..//div
${button_dhn_xoa_sp}    //td[span[contains(text(),'{0}')]]//..//td//a[@title="Xóa"]
${cell_dhn_tong_tien_hang}    //label[contains(text(),'Tổng tiền hàng')]//..//div[@ng-show="viewPrice"]
${textbox_hoan_lai_tam_ung}    //input[@id='advCustomer']
${popup_suggest_dhn}         //div[@class='form-header-content']//li[1]
${button_dexuat_dhn}    //a[@id='grpChooserBtn']//i
${button_dx_chon_ncc}    //div[@class="form-group form-supplier"]//div[@class="k-multiselect-wrap k-floatwrap"]
${input_dx_chon_ncc}      //div[@class="form-group form-supplier"]//div[@class="k-multiselect-wrap k-floatwrap"]//input
${item_dx_ncc_in_drơpdown}      //li[contains(text(),'{0}')]
${checkbox_dx_ko_xet_tonkho}      //label[contains(text(),'Không xét tồn kho')]//..//a
${button_dx_xong}     //i[@class="fas fa-check-square"]
${textbox_dhn_ncc}      //a[@id='idEditSupplier']
${cell_sp_dhn}      //div[@id='cartGrid']//div//table//tbody
${checkbox_dx_ton_it_nhat}      //label[text()='Tồn ít nhất - Tồn hiện tại']//..//a
${checkbox_dx_ton_nhieu_nhat}      //label[text()='Tồn nhiều nhất - Tồn hiện tại']//..//a
${checkbox_dx_dhn_lan_cuoi}      //label[text()='Đặt hàng nhập lần cuối']//..//a
${checkbox_dx_dhn_sl_ban}   //label[contains(text(),'Số lượng bán')]//..//a
#
${buttong_dhn_boqua_mobannhap}      //button[@class='btn-cancel btn btn-default']
#
${checkbox_dhn_cpnh}      //td[text()='{0}']//..//label[@class="quickaction_chk dpb"]//span
