*** Variables ***
${textbox_branch_name}    //div[contains(@kendo-window,'branchWindow')]//div[contains(@class, 'form-group') and ./label[text()='Tên chi nhánh']]//input[@type='text']
${textbox_branch_phone1}    //label[text()='Điện thoại']//..//input[@ng-model="Branch.ContactNumber"]
${textbox_branch_phone2}    //div[contains(@kendo-window,'branchWindow')]//div[contains(@class, 'form-group') and ./label[text()='Điện thoại']]//input[@type='text'][2]
${textbox_branch_email}    //div[contains(@kendo-window,'branchWindow')]//div[contains(@class, 'form-group') and ./label[text()='Email']]//input[@type='text']
${textbox_branch_address}    //div[contains(@kendo-window,'branchWindow')]//div[contains(@class, 'form-group') and ./label[text()='Địa chỉ']]//textarea[@type='text']
${textbox_branch_location}    //kv-search-location[@kv-model='Branch']//div[contains(@class, 'form-group') and ./label[text()='Khu vực']]//input[@type='text']
${cell_branch_item_location}    //ul//li[span[text()='{0}']]    #phuong hoac khu vuc
${textbox_branch_ward}    //kv-search-location[@kv-model='Branch']//div[contains(@class, 'form-group') and ./label[text()='Phường xã']]//input[@type='text']
${button_branch_save}    //kv-branch-form//a[contains(text(),'Lưu')]
${button_branch_cancel}    //kv-branch-form//a[contains(text(),'Bỏ qua')]
${textbox_search_branch}       //input[@placeholder='Tên chi nhánh']
${button_capnhat_branch}   //article[contains(@class,'kv-group-btn')]//a[@ng-click='updateBranch(dataItem)']
${button_delete_branch}   //article[contains(@class,'kv-group-btn')]//a[@ng-click='deleteBranch(dataItem)']
${button_active_branch}   //article[contains(@class,'kv-group-btn')]//a[@ng-click='activeBranch(dataItem)']
${button_ngaylamviec_theothu}     //button[contains(text(),'{0}')]
${cell_ngaylamviec}     //label[text()='Ngày làm việc:']//..//div//strong
#
${textbox_branch_address_fnb}       //input[@ng-model="Branch.Address"]
${button_co_huy_lich_lv}      //span[contains(text(),'Có')]
${textbox_apdung_tungay}      //input[@data-role="datepicker"]
${button_dongy_thaydoi}     //button[@ng-click="vm.save()"]
