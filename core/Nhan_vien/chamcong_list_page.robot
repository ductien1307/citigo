*** Variables ***
${button_lichlamviec_thang}     //button[contains(text(),'Tháng')]
${button_them_ca_lv}    //h5[text()='Ca làm việc']//..//i
${button_them_nv}      //h5[text()='Nhân viên']//..//i
${textbox_ten_ca}     //input[@id='shiftName']
${textbox_giolam_batdau}     //input[@id='shiftFrom']
${textbox_giolam_kethuc}      //input[@id='shiftTo']
${label_tenca}      //h5[@title="{0}"]
${button_edit_ca_lv}      //h5[@title="{0}"]//..//i
${checkbox_ngung_hoadong}   //label[text()='Ngừng hoạt động']//..//a
${button_luu_ca_lv}   //button[@ng-click="vm.handleClickSave()"]
${button_xoa_ca_lv}     //button[@class='kv2Btn kv2BtnDel ng-scope']
${button_dongy_xoa_calv}      //button[@class='btn-confirm btn btn-success']
#
${button_datlich_lamviec}     //a[text()=' Đặt lịch làm việc']
${cell_chonca_lamviec}      //input[@aria-owns="selectShift_taglist selectShift_listbox"]
${item_ca_lamviec_in_dropdown}      //div[@id='selectShift-list']//li[text()='{0}']
${textbox_nhanvien}      //input[@id='employeeAutoSelect']
${item_nv_in_dropdown}      //ul[@id='employeeAutoSelect_listbox']//li[1]
${button_luu_lich_lamviec}   //button[@class='ts-btn ts-btn-success ng-binding']
${checkbox_laplai}      //span[contains(text(),'Lặp lại')]
${textbox_ngaybatdau}     //input[@id='startDate']
${textbox_ngayketthuc}      //input[@id='endDate']
${cell_laplaimoi}     //span[text()='1'][@class="k-input ng-scope"]
${item_ngay_indropdow}     //li[text()='{0}']
${cell_ngay}    //span[contains(text(),'ngày')]
${button_dong_thongbao}    //button[contains(@class,'ts-btn ts-btn-default')]
#
${toggle_chon_chi_tiet_ca_lv}   //span[@class="fc-icon fc-icon- far fa-hand-point-up"]
${button_chi_tiet_ca}     //a[@event-id="{0}"]//span      #0: clocking id
${checkbox_vao}     //span[normalize-space()='Vào']
${checkbox_ra}    //span[normalize-space()='Ra']
${textbox_gio_vao}      //input[@id='checkInDate']
${textbox_gio_ra}       //input[@id='checkOutDate']
${button_luu_chitiet_lamviec}     //button[@ng-click="vm.save()"]
${button_thao_tac_chamcong}      //a[i[@class='fa fa-th']]
${button_chamcong_thucong}    //a[contains(text(),' Chấm công thủ công')]
${button_saochep_lichlamviec}     //a[@ng-click="vm.openCopyWorkingCalendarForm()"]
#popup cham cong thu cong
${button_luu_chamcong_thucong}      //button[@ng-click="vm.handleClickSave()"]
${button_huy_cham_cong}     //button[@class='kv2Btn kv2BtnDel']
${button_dongy_huy_chamcong}      //i[@class='fa fa-check']
${cell_chamcong}      //span[contains(text(),'Đi làm')]
${item_nghilam_indropdown}      //li[text()='Nghỉ làm']
${checkbox_co_phep}     //span[contains(text(),'Có phép')]
# xuat file
${button_xuatfile_lichlv}      //a[@class='kv2Btn ng-binding']
${button_ex_chitiet_calamviec}      //a[@ng-click="vm.exportShift()"]
#popup sao chep lich lam viec
${textbox_lichsaochep_ngaybatdau}     //input[@id='dateFrom']
${textbox_lichsaochep_denngay}      //input[@id='dateTo']
${textbox_saocheptoi_ngaybatdau}      //input[@id='dateCopyFrom']
${textbox_saocheptoi_denngay}     //input[@id='dateCopyTo']
${button_luu_saochep_lichlv}      //button[@class='kv2Btn'][contains(text(),'Lưu')]
