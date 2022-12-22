*** Settings ***
Library           SeleniumLibrary
Resource          ../share/computation.robot

*** Variables ***
#page list
${button_add_new_supplier}          //aside//a[@ng-click="addSupplier()"]
${textbox_search_matensdt}    //input[@placeholder='Theo mã, tên, điện thoại']
${button_them_nhom_ncc}    //kv-supplier-filter//article[contains(@class, 'boxLeft')]//a[@title='Thêm nhóm nhà cung cấp']
${tab_nocantra_ncc}    //td[contains(@class, 'k-detail-cell')]//li/span[contains(text(), 'Nợ cần trả NCC')]
${cell_nocantra_ncc}    //div[contains(@class, 'form-wrapper supplierDebtList')]//div[contains(@class, 'k-grid-content ')]//tr[{0}]//td[contains(@class, 'tdCode txtR')]
${cell_giatri}    //div[contains(@class, 'form-wrapper supplierDebtList')]//div[contains(@class, 'k-grid-content ')]//tr[{0}]//td[contains(@class, 'tdTotal')]
${cell_no_cantra_hientai_onrow}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdDebt txtR')]
${button_update_supplier}  //div//a[@ng-click='editSupplier(dataItem)']
${button_active_supplier}   //div//a[@ng-click='activeSupplier(dataItem)']
${button_delete_supplier}   //div//a[@ng-click='deleteSupplier(dataItem)']
#nha cung cap popup
${textbox_supplier_code}        //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Mã nhà cung cấp')]//..//input
${textbox_supplier_name}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Tên nhà cung cấp')]//..//input
${textbox_supplier_mobile}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Điện thoại')]//..//input
${textbox_supplier_address}       //div[contains(@class,'k-window-supplieriorder')]//textarea[@ng-model='supplier.Address']
${textbox_supplier_location}       //div[contains(@class,'k-window-supplieriorder')]//input[@id='locationSearchInput']
${dropdown_supplier_location}        //ul//li[@val='{0}']
${textbox_supplier_ward}       //div[contains(@class,'k-window-supplieriorder')]//input[@id='wardSearchInput']
${textbox_supplier_email}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Email')]//..//input
${textbox_supplier_company}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Công ty')]//..//input
${textbox_supplier_mst}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Mã số thuế')]//..//input
${textbox_supplier_group}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Nhóm NCC')]//..//div
${textbox_supplier_note}       //div[contains(@class,'k-window-supplieriorder')]//label[contains(text(),'Ghi chú')]//..//div//textarea
${button_supplier_luu}       //div[contains(@class,'k-window-supplieriorder')]//a[contains(text(),'Lưu')]
#popup điều chỉnh
${button_edit_dieuchinh_ncc_capnhat}      //div[@class='adjustBox']//button[@class='btn btn-success ng-binding'][contains(text(),'Cập nhật')]
${button_huybo_phieutt_ncc}     //a[@class='btn btn-danger ng-binding'][@ng-click="cancel()"]
${button_capnhat_phieutt_ncc}     //div[contains(@class,'k-window-paymentDetail')]//a[@class='btn btn-success ng-binding'][contains(text(),'Cập nhật')]
