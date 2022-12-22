*** Variables ***
${textbox_ma_phieu_dat}    //input[@placeholder='Theo mã phiếu đặt']
${button_dh_ket_thuc}   //a[@ng-click="finishOrder()"]
${button_dh_luu}      //a[@ng-click="update()"]
${button_dh_xu_ly_dh}   //a[@ng-click="processOrder()"]
${button_dh_in}   //a[@ng-show="showPrint"]
${buttoh_dh_xuatfile_detail}      //span[@ng-show="!noteditable"]//a[@ng-click="exportDetail()"]
${button_dh_saochep}    //A[@ng-click="cloneOrder()"]
${button_dh_huybo}    //span[@ng-show="!noteditable"]//a[@ng-click="cancel()"]
${button_dh_dongy_huybo}    //button[contains(text(),'Đồng ý')]
${checkbox_chon_don_dathang}    //td[span[contains(text(),'{0}')]]//..//td[@class="cell-check"]//a
${button_gopphieu}     //aside[@class='header-filter-buttons']//a[@ng-click='combineMulti()']//span[contains(text(),'Gộp phiếu')]
${button_xacnhan_chonphieugop}    //div[@class='kv-window-footer']//a[@ng-click='vm.combine()']
${button_xacnhan_huyCTKM}    //button[@class='btn-confirm btn btn-success']
${button_xacnhan_hanghoa}    //div[@class='kv-group-btn']//a[@ng-click='onSave()']
${button_xacnhan_gop_phieuthanhtoan}    //div[div[p[contains(text(),'phiếu thanh toán liên quan')]]]//..//div[@class="kv-window-footer"]//button[@class="btn-confirm btn btn-success"]
${droplist_chinhanh}    //article[contains(@class,'branchLeft')]//input[contains(@class,'k-input')]
${item_chinhanh}    //ul[@id='sortBranch_listbox']//li[@class='k-item ng-scope'][contains(text(),'{0}')]    #ten chi nhanh

#------chi tiet dh---
${combobox_trangthai}    //div[@ng-show='enabledEditStatus']//span[@class='k-select']//span[contains(text(),'select')]
${status_dh_daxacnhan}    //ul[contains(@class,'k-list')]//li[contains(text(),'Đã xác nhận')]
${checkbox_chonphieugop_popup}    //td[a[contains(text(),'{0}')]]/..//td//label[contains(@class,'quickaction')]//span    #order_code
${button_gopdon_popup}    //div[@id="gridCombineOrderItem{0}"]/..//div[@class="kv-window-footer"]//a[@ng-click="vm.combine()"]    #maKH
${textbox_search_theo_ma_sdt_khachhang}    //input[@placeholder="Theo mã, tên, số điện thoại khách hàng"]
${button_expanse_search}    //i[@class='fas fa-caret-down']
${button_search}    //button[@ng-click="quickSearch()"]
${ma_phieu}     //span[contains(text(),'{0}')]     #order_code
${khach_hang}    //a[contains(text(),'{0} - {1}')]    #0:cus_code 1:cus_name
