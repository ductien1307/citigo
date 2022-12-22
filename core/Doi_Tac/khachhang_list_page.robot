*** Variables ***
${textbox_search_matensdt}   //input[@ng-enter="quickSearch(true)"]
${tab_lichsu_ban_tra}    //ul[contains(@class, 'k-tabstrip-items k-reset')]//span[contains(@class, 'k-link') and contains(text(), 'Lịch sử bán')]
${tab_lichsu_dathang}    //ul[contains(@class, 'k-tabstrip-items k-reset')]//span[contains(@class, 'k-link') and contains(text(), 'Lịch sử đặt hàng')]
${cell_tab_lsban_tongcong}    //div[contains(@class,'form-wrapper customerInvoiceList')]//tr[1]//td[contains(@class, 'tdTotal')]
${cell_tab_lsban_maHD}    //div[contains(@class,'form-wrapper customerInvoiceList')]//tr[1]//td[contains(@class, 'tdCode')]//a
${tab_nocan_thu}    //ul[contains(@class, 'k-tabstrip-items k-reset')]//span[contains(@class, 'k-link') and contains(text(), 'Nợ cần thu từ khách')]
${tab_lichsu_tichdiem}        //span[contains(text(),'Lịch sử tích điểm')]
${cell_tong_ban}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdTotal')][1]
${cell_no_hientai}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdDateTime txtR')]
${cell_tong_ban_tru_trahang}    //tbody[contains(@role, 'rowgroup')]//tr[contains(@class, 'k-master-state')]//td[contains(@class, 'tdCodePur txtR')]
${cell_tab_lsdat_maDH}    //div[contains(@class,'form-wrapper customerOrderList')]//tr[1]//td[contains(@class, 'tdCode')]//a
${cell_du_no_cuoi_kh}    //div[contains(@class, 'auto-scrollable')]//tbody[@role='rowgroup']//tr[@role ='row'][1]//td[contains(@class, 'tdTotalPro')]
${textbox_search_customer}    //input[@ng-enter='quickSearch(true)']
${button_update_customer}   //div//a[@ng-click='editCustomer(dataItem)']
${button_active_customer}   //div//a[@ng-click='activeCustomer(dataItem)']
${button_delete_customer}   //div//a[@ng-click='deleteCustomer(dataItem)']
##
${button_add_new_customer}   //aside//a[@ng-click="addCustomer()"]
${button_file}        //span[text()='File']
${item_button_import}   //a[text()=' Import']
${button_chon_file_du_lieu}   //input[@id='files']
${text_file_name__after_import}   //span[@class='k-filename']
${button_thuc_hien}    //button[text()='Thực hiện']
${text_after_import_successful}    //div[@id='importExportContent']//span
${button_x_after_import_export_successful}    //span[text()='Xử lý thiết lập, import, xuất file, thanh toán']/following-sibling::span/a[@title='Đóng']
${item_button_export}   //div[contains(@class,'addProductBtn')][1]//ul//a[@ng-click='export()']
${button_thao_tac}    //span[text()='Thao tác']
${link_thao_tac_xoa}   //a[text()=' Xóa']
${cell_item_export}    //a[@ng-click='exportMulti()']
${link_tai_xuong}    //a[text()='Nhấn vào đây để tải xuống']
${text_name_export_file}    //div[@id='importExportContent']//h5[contains(text(),'DanhSachKhachHang')]       #//div[@id='importExportContent']//h5
${button_dongy_xoa}    //div[contains(@style,'display: block')]//button[text()='Đồng ý']
${button_viewinfo_open}    //div[@id='columnSelection']//span[@class='k-link']
${button_viewinfo_close}    //li[@id='columnSelection_mn_active']
##add new customer popup
${radiobutton_custumer_type}    //div[contains(@class,'radio-custom')]//div[label[contains(text(),'{0}')]]//a    # text Cá nhân or Công ty
${textbox_customercode}    //input[@placeholder='Mã mặc định']
${textbox_customername}    //div[label[@class='form-label control-label ng-binding'][contains(text(),'Tên khách hàng')]]//input
${textbox_customermobile}    //input[@ng-model='customer.ContactNumber']
${textbox_customer_birthdate}    //input[@k-ng-model='customer.BirthDate']
${textbox_customer_address}    //textarea[@ng-model='customer.Address']
${textbox_customer_khuvuc}    //div[@class='col-md-6']//input[@id='locationSearchInput']
${dropdown_customer_khuvuc}    //div[contains(@class,'form-wrap loc')]//li[@val='{0}']
${dropdown_customer_phuongxa}    //div[contains(@class,'form-group mb10')]//li[@val='{0}']
${textbox_customer_phuongxa}    //div[@class='col-md-6']//input[@id='wardSearchInput']
${textbox_customer_group}    //div[label[@class='form-label control-label ng-binding'][contains(text(),'Nhóm')]]/div/div/div//input
${textbox_customer_mst}    //div[contains(@class,'customer-info')]//label[contains(@class,'form-label control-label')][contains(text(),'Mã số thuế')]//..//input
${textbox_customer_company}    //div[contains(@class,'customer-info')]//label[contains(@class,'form-label control-label')][contains(text(),'Công ty')]//..//input
${radiobutton_customer_gender}    //div[contains(@class,'form-group')]//label[contains(text(),'{0}')]//..//a    #text Nam or Nữ
${textbox_customer_email}    //div[contains(@class,'customer-info')]//label[contains(@class,'form-label control-label')][contains(text(),'Email')]//..//input
${textbox_customer_facebook}    //div[contains(@class,'customer-info')]//label[contains(@class,'form-label control-label')][contains(text(),'Facebook')]//..//input
${textbox_customer_note}    //div[contains(@class,'customer-info')]//label[contains(@class,'form-label control-label')][contains(text(),'Ghi chú')]//..//textarea
${button_customer_luu}    //kv-customer-form[contains(@class,'ng-isolate-scope')]//div[contains(@class,'kv-window-footer')]//a[contains(text(),'Lưu')]
${button_dieuchinh_congno}    //a[contains(text(),'Điều chỉnh')]
${button_thanhtoan_congno}    //a[contains(text(),'Thanh toán')]
#tab điều chỉnh
${textbox_giatri_no_dieuchinh}    //div[label[contains(text(),'Giá trị nợ điều chỉnh')]]//input
${textbox_mota}   //div[label[contains(text(),'Mô tả')]]//textarea
${button_capnhat_dieuchinh}   //button[contains(text(),'Cập nhật')]
${cell_ma_phieu_canbang}      //a[contains(text(),'{0}')]
${button_edit_dieuchinh_capnhat}      //div[@class='uln lbl-cl control-poup adjustBox ng-hide']//button[@class='btn btn-success ng-binding'][contains(text(),'Cập nhật')]
${button_huybo_dieuchinh}     //button[@class='btn btn-danger ng-binding']
${button_dongy_huybo_dieuchinh}     //button[@class='btn-confirm btn btn-success']
#tab no can thu
${textbox_thu_tu_khach_in_customer}       //div[label[text()='Thu từ khách']]//input
${textbox_tien_thu_theo_hoadon}     //td[contains(text(),'{0}')]//..//td//input       #0: hoa don
${button_tao_phieu_thu_in_customer}       //a[text()=' Tạo phiếu thu']
${cell_chon_phuong_thuc}      //div[label[text()='Phương thức']]//span[contains(@class,'k-input')]
${phuong_thuc_in_dropdownlist}     //li[text()='{0}']    #0: Thẻ or Chuyển khoản
${cell_chon_tai_khoan_nh}        //span[text()='---Lựa chọn---']
${tai_khoan_in_dropdownlist}        //span//b[text()='{0}']         #0: số tài khoản

### elements in customer list
${checkbox_customercode}        //xpath_customer_code
${button_merge_customer}       //xpath_merge
${cell_cus1_name_popupscr}       //xpath_cus1_name
${cell_cus2_name_popupscr}       //xpath_cus2_name
${cell_cus1_address_popupscr}       //xpath_cus1_name
${cell_cus2_address_popupscr}       //xpath_cus2_name
${text_merge_popupscr}         //xpath_text_location_merge_popup
${button_confirm_merge_popupscr}       //xpath_btn_merge_confirm
${button_cancel_merge_popupscr}       //xpath_btn_cancel
${button_merge_confirmation_popup}       //xpath_btn_merge_confirmation_popup

${button_capnhat_phieutt}     //div[@class='kv-window-footer']//a[i[@class='fa fa-check-square']]
${button_huybo_phieutt}       //button[i[@class='fa fa-close']]
# Điều chỉnh tích điểm
${button_dieuchinh_tichdiem}    //div[@data-title="Lịch sử tích điểm"]//..//article//a[i[@class="fa fa-refresh"]]
${textbox_diem_moi}     //label[contains(text(),'Điểm mới')]//..//input
${button_capnhat_tichdiem}      //button[contains(text(),'Cập nhật')]
#
${format_mail}     {0}@gmail.com
${cell_soluong_kh}    //tbody[@role="rowgroup"]//tr[contains(@class,'k-master-row')]
${textbox_search_emailcustomer}    //input[@ng-model="custFilter.EmailKeyword"]
${dropdown_timkiem}    //button[@class='btn-icon dropdown-toggle']
${cell_info_customer_email_and_phonenumber}    //strong[contains(text(),'{0}')]
${button_confirm_delete_customer}    //div[div[p[strong[contains(text(),'{0} ')]]]]/..//div[@class="kv-window-footer"]//button[@ng-enter="onConfirm()"]     #makh
${checkbox_select_customer}    //tr[contains(@class,'k-alt k-master-row ng-scope k-master-state')]//td[contains(@class,'cell-check')]//a
${checkbox_listview_diachi}    //label[text()='Địa chỉ']

${DYNAMIC_CHECKBOX_KHACHHANGLIST}     //span[text()='{0}']/parent::td/preceding-sibling::td[@class='cell-check']//a
${DYNAMIC_TEXT_TENKHACHHANG_THEOMAKH}    //span[text()='{0}']/parent::td/following-sibling::td[@class='cell-name' and not(contains(@style,'display:none'))]
${DYNAMIC_TEXT_SDT_THEOMAKH}      //span[text()='{0}']/parent::td/following-sibling::td[@class='cell-phone ng-binding' and not(contains(@style,'display:none'))]
${DYNAMIC_TEXT_DIACHI_THEOMAKH}      //span[text()='{0}']/parent::td/following-sibling::td[@class='cell-address' and not(contains(@style,'display:none'))]
