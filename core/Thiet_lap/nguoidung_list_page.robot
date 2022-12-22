*** Variables ***
${button_nguoidung}    //article//aside//a[contains(@ng-click, 'AddUser()')]
${record_thefirst}    //div[contains(@class, 'k-grid-content')]//table//tbody//tr[1]//td[contains(@class, 'tdBranch')]
${tab_thoigian_truycap}    //ul[contains(@class, 'k-tabstrip-items k-reset')]//span[contains(@class, 'k-link') and contains(text(), 'Thời gian truy cập')]
${checkbox_khunggio}    //div[contains(@class, 'clearfix prettycheckbox')]//input[contains(@data-label, 'Chỉ cho phép truy cập theo khung giờ')]
${textbox_search_ten}    //input[@ng-enter='filterByUserName()']
${checkbox_thuhai}    //div[contains(@class, 'clearfix prettycheckbox labelright')]//input[@data-label='Thứ hai']
${textbox_search_user}    //input[@placeholder='Tên đăng nhập, người dùng']
${button_capnhat_user}       //article[contains(@class,'kv-group-btn')]//a[@ng-click='editUser(dataItem)']
${button_delete_user}   //article[contains(@class,'kv-group-btn')]//a[@ng-click='deleteUser(dataItem)']
${button_saochep_user}      //a[contains(text(),'Sao chép')]
${button_ngunghd_user}    //a[@class='btn btn-success btn-danger']
#pop up add user
${textbox_user_name}    //div[contains(@class, 'form-group') and ./label[text()='Tên người dùng']]//input[@type='text']
${textbox_user_username}    //div[contains(@class, 'form-group') and ./label[text()='Tên đăng nhập']]//input[@type='text']
${textbox_user_password}    //div[contains(@class, 'form-group') and ./label[text()='Mật khẩu']]//input[@type='password']
${textbox_user_again_password}    //div[contains(@class, 'form-group') and ./label[text()='Gõ lại mật khẩu']]//input[@type='password']
${combobox_user_permission}    //div[contains(@class, 'form-group') and ./label[text()='Vai trò']]//span[text()='--Chọn vai trò--']
${cell_user_item_permission}    //div[contains(@class, 'k-animation-container')]//div[contains(@class, 'k-list-scroller')]//ul//li[text()='{0}']    #vai tro
${textbox_user_branch}    //div[contains(@class, 'form-group') and ./label[text()='Chi nhánh']]//input[contains(@class, 'input')]
${cell_user_item_branch}      //div[@class="k-animation-container"]//li[text()='{0}']    #ten chi nhanh
${textbox_user_phone}    //div[contains(@class, 'form-group') and ./label[text()='Điện thoại']]//input[@type='text']
${textbox_user_email}    //div[contains(@class,'col-sm-6')][2]//div[contains(@class,'form-group') and ./label[text()='Email']]//input[@type='text']
${textbox_user_address}    //div[contains(@class, 'form-group') and ./label[text()='Địa chỉ']]//input[@type='text']
${textbox_user_location}    //input[@id='locationSearchInput']
${cell_item_user_location}    //div[contains(@class, 'complete')]//ul[li[span[text()='{0}']]]    #khu vuc hoặc phường xã
${textbox_user_ward}    //input[@id='wardSearchInput']
${textbox_user_birthday}    //input[@k-ng-model='user.DOB']
${textbox_user_language}    //div[contains(@class, 'form-group') and ./label[text()='Ngôn ngữ']]//select
${textbox_note}       //div[contains(@class, 'form-group') and ./label[text()='Ghi chú']]//input[@type='text']
${button_save_add_user}   //a[@ng-click="saveUser()"]
${button_cancel_add_user}      //a[text()="Bỏ qua"]
#
${tab_phanquyen}      //span[text()='Phân quyền']
${button_capnhat_phanquyen}     //div[@class='userList uln']//privilege-setting//article[@class='kv-group-btn']//a[text()=' Cập nhật']
${button_dongy_capnhat_phanquyen}     //button[@class='btn-confirm btn btn-success']
${checkbox_all_nguoidung}     //th[@role="columnheader"]//a[@href="javascript:void(0)"]
${button_thaotac_nd}     //span[contains(text(),'Thao tác')]
${button_xuatfile_user}     //a[@ng-click="exportMulti()"]
