*** Variables ***
${textbox_search_serial}    //article[contains(@class, 'columnViewTwo')]//input[contains(@placeholder, 'Theo Serial/IMEI')]
${textbox_search_maphieukiem}    //article[contains(@class, 'columnViewTwo')]//input[@ng-enter='quickSearch(true)']
${checkbox_trangthai_phieu}    //article[contains(@class,'ovh clb k-gridNone k-grid-Scroll stocktakePage')]//td[contains(@class,'cell-code') and ./span[contains(text(),'{0}')]]//..//td[contains(@class,'cell-status')]//span
${button_kiemkho}    //a[@title='Kiểm kho']
${button_select_search}   //button[@class='btn-icon dropdown-toggle']
${button_huy_phieukiem}     //a[contains(@class,'btn btn-danger')]
${button_luu_phieukiem}     //i[@class='fas fa-save']
${button_xuatfile_phieukiem}      //a[contains(@class,'btn btn-default kv2BtnExport')]
${button_saochep_phieukiem}     //a[i[@class='fa fa-clone']]
${button_in_phieukiem}      //a[i[@class='fa fa-print']]
${button_dongy_huy_phieukiem}     //button[@class='btn-confirm btn btn-success']
#kiểm hàng lô date
${textbox_input_lots}    //input[@placeholder="Nhập lô, hạn sử dụng"]
${textbox_sl_lo_thuc_te}     //input[@ng-model="product.ActualCount"]
${button_save_lo}    //a[@ng-enter="SaveBatchexpire()"]
