*** Variables ***
${cell_first_ma_hd}    //table//tr[contains(@class, 'k-alt k-master-row')][1]//td[contains(@class, 'tdCode18')]
${cell_ma_sp_hd}    //div[contains(@class, 'invoiceDetail')]//table//tr[{0}]//td[contains(@class, 'tdCode')]
${cell_khachhang_name}    //table//tr[contains(@class, 'k-alt k-master-row')][1]//td[contains(@class, 'tdMin')]//span[contains(@ng-bind, 'Customer.Name')]
${textbox_theo_ma_hd}     //input[@placeholder='Theo mã hóa đơn']
${button_hd_mo_phieu}   //a[@ng-click="updateInvoice()"]
${button_hd_luu}    //a[@kv-taga-disabled="invoiceFrm.$invalid"]
${button_hd_tra_hang}   //a[@ng-show="showReturn"]
${button_hd_in}     //a[@ng-show="showPrint"]
${button_hd_xuatfile_hd}    //span[@ng-show="!noteditable"]//a[@ng-click="exportDetail()"]
${button_hd_sao_chep}     //a[@ng-click="cloneInvoice()"]
${button_hd_huy_bo}     //span[@ng-show="!noteditable"]//a[@ng-click="cancel()"]
${button_hd_xuatfile}   //a[@title="Xuất  file"]
${button_hd_banhang}      //a[@ng-show="rights.canAdd"]
${button_hd_kenhban}      //label[text()='Kênh bán:']//..//span[contains(@class,'k-input')]
${textbox_hd_kenhban}      //div[ul[li[text()='Bán trực tiếp']]]//..//span//input
${item_hd_kenhban_in_dropdown}      //li[text()='{0}']
${button_hd_dongy_huybo}    //div[@id='filterMultiInvoices']//button[@ng-enter="onConfirm()"]
${cell_nguoiban}        //div[@id='salesman1']//span[@class='k-input']
${textbox_nguoiban}     //div[@id='salesman-list']//input[@class='k-textbox']
${item_nguoiban_in_dropdownlist}      //span[contains(text(),'{0}')]
${button_gop_hoa_don}     //a[@ng-click="combineInvoice()"]
${button_dongy_gop_hd}     //a[@ng-click="vm.combine()"]
${checkbox_hoa_don}     //tr[contains(@class,'k-alt k-master-row ng-scope k-master-state')]//td[contains(@class,'cell-check')]//a
${button_gop_don}     //a[contains(text(),'Gộp đơn')]
${button_dongy_tieptuc_gop_hd}      //button[i[@class='fa fa-check']]
${button_luu_tao_vandon_khac}     //div[contains(@class,'k-window-ship')]//button[@class='btn btn-success ng-binding']
${cell_trangthaigiao}      //span[@class='k-input ng-scope'][contains(text(),'Chờ xử lý')]
${textbox_trangthaigiao}     //div[@id='deliveryStatus-list']//input[@class='k-textbox']
${item_trangthaigiao}     //li[text()='{0}']
${button_close_luu_y}     //div[@class='k-widget k-window k-window-poup delivery-warning-popup']//a[@class='k-window-action k-link']
  #popup Gop hoa don
${checkbox_hoa_don_gop}     //td[a[text()='{0}']]//..//td[contains(@class,'cell-btn-choose')]//span
${button_gop_don_theo_kh}     //div[@id="gridCombineInvoiceItem{0}"]//..//div//a[@ng-enter="vm.combine()"]
#----bao mat kh---
${button_dropdown_search}    //button[@class='btn-icon dropdown-toggle']
${button_morong_timkiem}    //a[@ng-hide='showInvoiceSearch'][contains(text(),'Mở rộng ')]
${textbox_tim_kiem_ma_ten_sdt_kh}    //input[@placeholder='Theo mã, tên, số điện thoại khách hàng']
${button_search}    //button[@ng-click="quickSearch()"]
${text_ma_hoa_don}     //label[contains(text(),'Mã hóa đơn:')]/..//strong[contains(text(),'{0}')]     #invoice_code
${khach_hang}    //a[contains(text(),'{0} - {1}')]    #0:cus_code 1:cus_name
#dong bo omni
${button_omni_dongbo}    //i[@class='fas fa-sync-alt']
${textbox_omni_search_theo_mahd}   //input[@ng-model="vm.orderCode"][@placeholder="Theo mã hóa đơn"]
${label_omni_ma_hd}   //strong[@class='txt-dark ng-binding']
${button_omni_chon_imei}    //a[contains(@ng-click,"vm.showpopup({0}")]      #0:id sp
${button_omni_imei}     //span[contains(text(),'{0}')]
${button_omni_tim_imei}     //div[@class='k-widget k-window k-window-custom k-window-serial kv-window']//input[@id='idTxtSearch']
${button_omni_chon_imei_xong}   //div[@class='k-widget k-window k-window-custom k-window-serial kv-window']//button[@class='btn btn-success ng-binding'][contains(text(),'Xong')]
${button_omni_dongbo_tungdon}   //a[@class='txtGreen fas fa-sync-alt pull-right']
${button_omni_chon_lo}      //a[contains(text(),'Chọn lô')]
${textbox_omni_tim_lo}      //input[@id='idTxtSearchBatch']
${label_omni_chon_lo}     //span[contains(text(),'{0}')]
${button_omni_chon_lo_xong}     //div[@kendo-window='batchexpiretWindow']//i[@class='fa fa-check-square']
