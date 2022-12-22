*** Settings ***
Library           SeleniumLibrary
Resource          ../share/discount.robot

*** Variables ***
${textbox_sq_nhap_ma_phieu}    //input[@placeholder='Mã phiếu tự động']
${cell_nhom_nguoi_nop/nhan}    //div[label[contains(text(),'Đối tượng')]]//span[text()='Khác']
${item_nhomnguoinop/nhan_indropdow}    //ul[@id="ddlCashflowType_listbox"]//li[contains(text(),'{0}')]
${textbox_ten_nguoi_nop/nhan}    //input[@id='partnerSearchInput']
${cell_tim_loai_thu_chi}   //span[contains(@class,'k-input ')][contains(text(),'Chọn loại')]
${textbox_loai_thu_chi}    //div[@id='ddlCashflowGroup-list']//input
${item_loaithuchi_indropdown}    //ul[@id="ddlCashflowGroup_listbox"]//li[contains(text(),'{0}')]
${textbox_sq_gia_tri}    //div[label[contains(text(),'Giá trị')]]//input
${textbox_sq_ghi_chu}   //textarea[@ng-model="item.Description"]
${button_sq_luu}    //a[@ng-click="savePayment()"][contains(text(),'Lưu')]
${cell_phuongthuc}    //span[contains(text(),'--Chọn phương thức--')]
${item_phuongthuc_indropdown}    //ul[@id='ddlbankMethod_listbox']//li[contains(text(),'{0}')]    #0: thẻ, chuyển khoản
${button_dongy_chon_doi_tac}    //button[contains(@class,'btn-confirm')]
${cell_tim_loai_chi}    //span[@unselectable="on"][contains(text(),'Tìm loại chi')]
${item_tennguoi_indropdow}    //p[b[contains(text(),'{0}')]]    #0: ten nguoi nop, nhan
${cell_ten_nguoi_nop}    //input[@class='form-control name']
${checkbox_hach_toan}    //div[input[contains(@kv-change,"useforReportChanged")]]//a
${cell_chon_tai_khoan}    //span[contains(text(),'Chọn tài khoản')]
${item_tai_khoan_indropdown}    //div[b[contains(text(),'{0}')]]
${button_huybo}    //div[@class='kv-window-footer']//a[@ng-click='voidPayment(item.Code,item.Value)']
${button_dongy_huybo}    //div[@class='kv-window-footer']//button[@ng-enter='onConfirm()']
${button_thaydoi_congno_co}     //button[@class='btn-confirm btn btn-success']
${button_thaydoi_congno_khong}      //button[@class='btn-cancel btn btn-default']
## chuyen quy noi bo
${cell_doituongnop}      //div[label[contains(text(),'Đối tượng nộp')]]//span[text()='-- Chọn chi nhánh nộp --']
${item_doituong_indropdown}   //div[contains(@class,'k-animation-container')]//ul//li[text()='{0}']   #ten chi nhánh
${cell_doituongnhan}      //div[label[contains(text(),'Đối tượng nhận')]]//span[text()='-- Chọn chi nhánh nhận --']
${textbox_ten_nguoi_nop}    //kv-internal-group-cash-flow//input[@id='partnerSearchInput']
${cell_chon_tai_khoan_indropdown}    //span[contains(text(),'-- {0} --')]   # gia trị mặc định
${item_taikhoan_thuchi_indropdown}  //li[span[div[b[contains(text(),'{0}')]]]]//..//li//b[text()='{1}']    #(0)- giá trị mặc định {1}ten tai khoan
