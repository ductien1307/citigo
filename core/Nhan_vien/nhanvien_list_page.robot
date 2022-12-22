*** Variables ***
#list page
${textbox_search_nv}    //input[@ng-model="vm.filters.Keyword"]
${button_capnhat_nv}    //button[@ng-show="vm.tsPrivilegeHelperFactory.has('Employee_Update') && vm.setting.TimeSheet"]
${button_xoa_nv}   //button[normalize-space()='Xóa nhân viên']
${button_dongy_xoa_nv}     //button[contains(text(),'Đồng ý')]
${button_boqua_xoa_nv}      //button[contains(text(),'Bỏ qua')]
#ada page
${button_them_nhan_vien}    //button[@ng-click="vm.openEmployeeForm()"]
${textbox_ma_nhan_vien}     //input[@id='employeeCode']
${textbox_ten_nhan_vien}    //input[@ng-model="vm.employee.name"]
${textbox_ngay_sinh_nv}     //input[@id='dobDate']
${button_ngaysinh_nv}       //input[@id='dobDate']/parent::span//span[@class='k-select']
${checkbox_gioitinh}      //label[contains(text(),'{0}')]//..//a      #0: gioi tinh
${textbox_cmtnd_nv}     //input[@ng-model="vm.employee.identityNumber"]
${cell_chonphongban}      //span[text()='Chọn phòng ban'][@class="k-input ng-scope"]
${cell_chonchucdanh}      //span[text()='Chọn chức danh'][@class="k-input ng-scope"]
${item_phongban_chucdanh_in_dropdownlist}      //li[text()='{0}']
${textbox_ghichu_nv}      //textarea[@ng-model="vm.employee.note"]
${cell_chonnguoidung}     //span[contains(text(),'Chọn người dùng')]
${item_nguoidung_in_dropdownist}    //p[@class="item-name"][text()='{0}']
${textbox_sdt_nv}     //input[@ng-model="vm.employee.mobilePhone"]
${textbox_email_nv}     //input[@ng-model="vm.employee.email"]
${textbox_facebook_nv}      //input[@ng-model="vm.employee.facebook"]
${textbox_diachi_nv}      //input[@ng-model="vm.employee.address"]
${textbox_khuvuc_nv}      //input[@id='locationSearchInput']
${textbox_phuongxa_nv}      //input[@id='wardSearchInput']
${item_kv_px_indropdownlist}      //span[text()='{0}']
${button_them_nguoi_dung}     //button[@ng-click="vm.openCreateUserForm()"]
${button_luu_nv}      //button[@ng-click="vm.handleClickSave()"]
#
${tab_noluong_nv}   //span[contains(text(),'Nợ lương nhân viên')]
${tab_thietlapluong}      //span[contains(text(),'Thiết lập lương')]
${button_capnhat_thietlapluong}     //button[@id='btnPayment']//i[@class='fa fa-check-square']
${button_luu_thietlapluong}     //kv-time-sheet-pay-rate-form[@class='ng-scope ng-isolate-scope']//button[@id='btnSave']
