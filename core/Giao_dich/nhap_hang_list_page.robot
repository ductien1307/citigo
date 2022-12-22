*** Variables ***
${cell_ncc}       //*[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-alt')][{0}]//td[contains(@class, 'tdMin')]/span
${cell_cantra_ncc}    //*[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-alt')][{0}]//td[contains(@class, 'tdSLC txtR')][2]
${cell_trang_thai}    //*[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-alt')][{0}]//td[contains(@class, 'tdStatus')]
${text_pnh}       //span[contains(text(),'Phiếu nhập hàng')]
${textbox_searh_ma_pn}    //input[@ng-model="filterQuickSearch"]
${cell_ncc_onrow}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[span[contains(@ng-bind, 'dataItem.Supplier.Name')]]
${cell_cantra_ncc_onrow}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdSLC txtR')][1]
${cell_trangthai_onrow}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdStatus')]
${button_nhap_hang}    //a[@ng-show="hasAdd"]
${cell_ma_phieunhap}    //*[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-alt')]//td[contains(@class, 'tdCode')]//span[@data-code= '{0}']    #ma phieu nhap
${cell_tongso_mathang}    //article[contains(@class, 'form-wrapper')]//div[contains(@class, 'table-responsive')]//td[contains(text(),'Tổng số mặt hàng')]/..//td[contains(@class, 'ng-binding')][2]
${cell_nguoinhap}    //div[contains(@class, 'row ')]//label[contains(text(),'Người nhập')]/..//span[contains(@class, 'k-input')]
##
${cell_purchase_code}        //tr/td/span[contains(text(),'{0}')]        #mã phiếu nhập
${button_trahangnhap_in_importform}       //a[@class='btn btn-success ng-binding'][contains(text(),'Trả hàng nhập')]
#
${button_mo_phieu_nhap}       //a[@ng-click="updatePurchaseOrder()"]
${button_nh_luu_pn}      //span[@class='kv-group-btn-editable']//a[i[@class='fas fa-save']]
${button_in_tem_ma}     //a[contains(text(),'In tem mã')]
${button_nh_huy_bo}     //a[i[@class='fa fa-close']]
${button_nh_group}    //button[@id='btnGroupDrop1']
${button_nh_saochep}      //a[i[@class='fa fa-clone']]
${button_dongy_huybo_pn}      //div[@class='k-widget k-window k-window-poup k-window-alert kv-window kv-close-popup window-error']//button[@class='btn-confirm btn btn-success'][contains(text(),'ng ý')]
