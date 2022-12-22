*** Variables ***
#poup them bang hoa hong
${button_them_banghoahong}      //a[@title="Thêm bảng hoa hồng"]
${textbox_ten_banghoahong}    //body//div[contains(@class,'kv-timesheet')][1]//input[@id="commissionName"]
${button_luu_banghoahong}     //button[@ng-click="vm.handleClickSave()"]
${checkbox_chinhanh_banghoahong}      //div[contains(@class,'form-list-check has-pretty-child')]//a
${textbox_chonchinhanh_banghoahong}     //div[contains(@class,'k-widget k-multiselect k-header form-control-kv ng-scope')]//input[contains(@class,'k-input k-readonly')]
${item_chinhanh_bhh_indropdown}     //ul[@id="commissionMultiSelect_listbox"]//li[text()='{0}']
#
${cell_tatca_nhomhang}      //div[@id='idProductCatTreeAll']//a//i
${cell_nhomhang_banghoahong}    //span[contains(text(),'{0}')]//..//i
${textbox_chon_banghoahong}    //input[contains(@class,"k-input")]
${item_banghoahong_indropdown}      //option[text()='{0}']
${button_chinhsua_banghoahong}      //i[@class="fa fa-pencil-square-o"]
${button_xoa_banghoahong}   //button[normalize-space()='Xóa']
${button_xoa_bhh_dongy}   //button[@ng-enter="onConfirm()"]
${textbox_muc_hoa_hong_first_product}     //tr[1]//input[@ng-disabled="!vm._p.has('Commission_Update')"]
${textbox_muc_hoa_hong}    //input[@id='commissionValueInput' or @id='commissionValueInput1']
${button_doanhthu}      //a[contains(text(),'% Doanh thu')]
${checkbox_apdung}    //label[contains(text(),'Áp dụng cho ')]//..//a
${button_dongy_muchoahong}    //a[contains(text(),'Đồng ý')]
${button_themvao_banghoahong_first_product}      //tr[1]//i[@class="far fa-plus Cd0"]
