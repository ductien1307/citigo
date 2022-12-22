*** Variables ***
${textbox_search_maten}    //input[@ng-model="filterQuickSearch"]
${tab_thanhphan}    //div[@class='k-tabstrip-wrapper']//*[text()='Thành phần']
${button_capnhat_in_thanhphantab}    //div[@class='k-content k-state-active']//article[contains(@class, 'boxBtn')]//a
${button_ngungkinhdoanh}    //div[@class='kv-group-btn']//a[contains(text(), ' Ngừng kinh doanh')]
${button_in_tem_ma}     //a[contains(text(),'In tem mã')]
${button_sao_chep}      //a[contains(text(),'Sao chép')]
${button_xoa_hh}    //div[@class='kv-group-btn']//a[contains(text(),'Xóa')]
${button_capnhat_hh}    //div[@class='kv-group-btn']//a[contains(text(),'Cập nhật')]
${button_dongy_xoahh}    //button[contains(text(),'Đồng ý')]
##import export
${button_import}    //aside[contains(@class,'header-filter-buttons')]//a[contains(@class,'kv2BtnImport')]
${button_chonfile}    //div[contains(@class,'k-upload-button')]//input[@id='files']
${button_uploadfile}    //button[contains(@class,'k-upload-selected')]
${toast_message_import}    //div[@id='importExportContent']//span[@ng-hide='item.readyDownload']
${button_export}    //aside[contains(@class,'header-filter-buttons')]//a[contains(@class,'kv2BtnExport')]
${cell_name_export_file}    //div[@id='importExportContent']//h5
${button_dongy_ngung_kd}    //a[contains(text(),'Đồng ý')]
${checkbox_ngungkd_theo_cn}     //label[contains(text(),'Chi nhánh')]//..//a
${button_delete_cn_popup_ngungkd}     //span[contains(text(),'delete')]
${button_chon_cn_apdung}     //label[text()='Chi nhánh']//..//div[@class="form-wrap"]//div[@class="k-multiselect-wrap k-floatwrap"]
${dropdownlist_chinhanh}      //div[@class='k-animation-container']//li[@role='option'][normalize-space()='{0}']
${checkbox_filter_hang_ngung_kd}      //label[text()='Hàng ngừng kinh doanh']//..//a
${button_cho_phep_kd}     //a[contains(text(),'Cho phép kinh doanh')]
##filter
${checkbox_filter_hang_hoa}      //label[contains(text(),'{0}')]//..//a
#nhom hang
${cell_filter_nhom_hang}     //span[text()='{0}'][@id]
${label_page_hh_infor}       //span[contains(@class,'k-pager-info')]
#
${cell_filter_chon_thuong_hieu}      //select[@k-data-source="trademarks"]//..//div
${item_thuonghieu_in_dropdow}     //li[contains(text(),'{0}')]
#
${cell_filter_thuoc_tinh}     //span[contains(text(),'{0}')]//..//select//..//div
${cell_filter_chon_vi_tri}      //span[contains(text(),'Chọn vị trí')]//..//select//..//div
#in tem ma
${button_xembanin_theo_kho_giay}     //p[contains(text(),'{0}')]//..//a
${text_message}     //div[@class="trv-error-message"]
${text_ma_sp}      //*[name()='tspan' and contains(text(),'{0}')]
${text_gia_sp}    //div[contains(@class,'textBox2')]
${button_export_tem}    //body//div[@id='reportViewer']//div//div//div//li[2]//a[1]//i[1]
${button_export_excel_tem}    //span[contains(text(),'Excel 97-2003')]
#nhom hang
${button_them_nhomhang}   //i[@class='far fa-plus-circle']
${textbox_tennhom}    //input[@id='idCategorySearchTerm']
${button_luu_tennhom}   //a[@class='btn btn-success ng-binding'][contains(text(),'Lưu')]
