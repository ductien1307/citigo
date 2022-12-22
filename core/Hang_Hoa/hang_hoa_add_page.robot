*** Variables ***
### Input
${textbox_ma_hh}    //div[contains(@class, 'k-window')]//div[contains(@class, 'form-group') and ./label[contains(text(),'Mã hàng')]]//input[@type='text']
${textbox_ten_hh}    //div[contains(@class, 'k-window')]//div[contains(@class, 'form-group') and ./label[contains(text(),'Tên hàng')]]//input[@type='text']
${textbox_mavach}   //div[contains(@class, 'k-window')]//div[contains(@class, 'form-group') and ./label[contains(text(),'Mã vạch')]]//input[@type='text']
#thuong hieu
${cell_chon_thuonghieu}     //span[contains(text(),'---Chọn thương hiệu---')]
${textbox_chon_thuonghieu}    //div[@id='ddlTradeMark-list']//input[@class='k-textbox']
${item_thuonghieu_indropdown}     //ul[@id='ddlTradeMark_listbox']//li[1]
### Button
${button_luu}     //div[contains(@class, 'k-window-poup') and contains(concat(' ',normalize-space(@style),' '),' display: block; ')]//div[contains(@class, 'kv-window-footer')]//a[@ng-enter="SaveProduct()"]
${button_dongy_apdung_giavon}     //a[i[@class='fa fa-check']]
### Label
${label_nhom_hang}    Nhóm hàng
${textbox_hh_giaban}    //div[contains(@class, 'form-group') and ./label[text()='Giá bán']]//input[@type='text']
${textbox_giavon}    //div[contains(@class, 'form-group') and ./label[text()='Giá vốn']]//input[@type='text']
${textbox_tonkho}    //div[contains(@class, 'form-group') and ./label[text()='Tồn kho']]//input[@type='text']
## Element
${text_element}    //div[contains(@class, 'k-widget k-window')]//span[contains(text(), 'Thêm hàng hóa')]
${checkbox_serial_imei}    //label[text()='Serial/Imei']//..//a
${tab_thanhphan_in_add_hh_page}    //li[a[contains(text(), 'Thành phần')]]
${tab_mota_chitiet}    //div[contains(@class, 'k-window')]//div[contains(@class, 'kvTabs clearfix ulN')]//li[a[contains(text(), 'Mô tả chi tiết')]]
${textbox_hanghoa_thanhphan}    //div[contains(@class, 'k-window')]//input[@id='productSearchInput']
${cell_luachon_nhomhang}    //span[contains(@class,'product-select')]//span[@class='k-icon k-i-arrow-s'][contains(text(),'select')]
${textbox_ton_itnhat}    //div[contains(@class, 'form-group') and ./label[text()='Ít nhất']]//input[@type='text']
${textbox_ton_nhieunhat}    //div[contains(@class, 'form-group') and ./label[text()='Nhiều nhất']]//input[@type='text']
${checkbox_tichdiem}    //aside//div[contains(@class, 'prettycheckbox')]//label[contains(text(), 'Tích điểm')]/..//a
${item_nhomhang}    //div[contains(@class, 'k-popup k-group')][1]//ul//li[span[text()='{0}']]
${tab_theo_doi_thuoc_tinh}    //a[contains(text(),'Thuộc tính')]
${cell_thuoctinh}    //div[contains(@class, 'k-window')]//span[text()='Chọn thuộc tính...']
${item_thuoctinh}    //li[contains(text(),'{0}')]
${textbox_thanhphan_soluong}    //td[text()='{0}']//..//td//input[@ng-model="item.Quantity"]
${cell_tong_giavon}    //td[contains(text(),'Tổng giá vốn thành phần')]//following-sibling::*
${cell_tong_giaban}    //td[contains(text(),'Tổng giá bán thành phần')]//following-sibling::*
${checkbox_lodate}    //label[text()='Lô, hạn sử dụng']//..//a
${tab_donvitinh}    //a[contains(text(),'Đơn vị tính')]
${textbox_donvi_coban}    //div[@class='autocomplete dropdown-list-autocomplete']//input[@id='idSuggestProductNameSearchTerm']
${button_them_donvi}    //button[@ng-click="addMoreUnit()"]
${textbox_tendonvi_0}    //td[@class='cell-name unitName']//input[@id='idSuggestProductNameSearchTerm']
${textbox_giatri_quydoi_0}    //td[@class='cell-units unitPrice']//input
${textbox_tendonvi_1}    //tr[3]//td[1]//unit-product-suggestion-input-form[1]//autocomplete[1]//input
${textbox_giatri_quydoi_1}    //tr[3]//td[unit-product-suggestion-input-form[1]]//..//td[@class="cell-units unitPrice"]//input
${textbox_mavach_0}     //input[contains(@class,'iptPriceCost_0')]/..//..//td//input[@ng-model="item.Barcode"]
${textbox_mavach_1}     //input[contains(@class,'iptPriceCost_1')]/..//..//td//input[@ng-model="item.Barcode"]
${textbox_nhapthuoctinh}    //input[@placeholder="Nhập giá trị và enter"]
${button_them_thuoctinh}    //button[@ng-click="addMoreAttributes()"]
${textbox_vitri}    //kv-shelves-drop-down-list[@product-shelves-list="product.ProductShelves"]//input
${item_vitri}     //div[@class='k-animation-container']//div[@class='k-list-scroller']//div[contains(text(),'{0}')]
${cell_mahang}    //span[text()='{0} ']
${textbox_nhap_ma_qd_1}    //input[contains(@class,"iptPriceCost_0")]/..//..//td//input[@ng-model="item.Code"]
${textbox_nhap_ma_qd_2}    //input[contains(@class,"iptPriceCost_1")]/..//..//td//input[@ng-model="item.Code"]
## hàng DVT bán trực tiếp
${checkbox_bantructiep_coban}   //div[contains(@class,'form-inline')]//div[contains(@class,'prettycheckbox')]//a
${checkbox_bantructiep_quydoi}    //input[contains(@class,'iptPriceCost_{0}')]/..//..//td//div[contains(@class,'prettycheckbox')]//a   #thu tu them hang quy doi tu 0,1,2...
##nganh nha thuoc
${textbox_ten_thuoc}      //input[@id='idMedicineSearchTerm']
${textbox_ten_viet_tat}     //div[contains(@class, 'k-window')]//div[contains(@class, 'form-group') and ./label[contains(text(),'Tên viết tắt')]]//input[@type='text']
${item_thuoc_indropdown}    //li[@suggestion][1]//span[contains(text(),'{0}')]
${cell_duong_dung}   //select[@id="ddlRoa"]//..//span//span[contains(@class,'k-input')]
${textbox_duong_dung}    //div[@id='ddlRoa-list']//span//input
${item_duongdung_indropdow}   //ul//li[contains(text(),'{0}')]
${button_xoa_ten_thuoc}     //a[@id='idRemoveMedicine']//i
${dropdown_sobanghi}      //label[contains(text(),'Số bản ghi')]//..//span[contains(@class,'k-dropdown-wrap')]
${item_sobanghi_in_dropdown}      //li[contains(text(),'{0}')][@role]
#lien ket kenh ban
${tab_lienket_kenhban}      //span[contains(text(),'Liên kết kênh bán')]
${button_capnhat_kenhban}     //a[@class='btn btn-success ng-binding ng-scope']
${checkbox_kenhban_tiki}      //span[img[@src="Content/retailer/img/tiki-ico.png"]][@class="ng-binding"][contains(text(),'{0}')]
${checkbox_kenhban_lazada}    //span[img[@src="Content/retailer/img/lazada-icon-active.png"]][@class="ng-binding"][contains(text(),'{0}')]
${checkbox_kenhban_shopee}    //span[img[@src="Content/retailer/img/shopee-icon-active.png"]][@class="ng-binding"][contains(text(),'{0}')]
${checkbox_kenhban_sendo}     //span[img[@src="Content/retailer/img/sendo-icon.png"]][@class="ng-binding"][contains(text(),'{0}')]
${cell_chonhang_lienket}    //td[div[p[a[text()='{0}']]]]//..//kv-product-mapping-cell[@channel-id="{1}"]//span[@ng-show="!isSearch"]      #0: Mã sp, 1: id kênh bán
${textbox_chonhang_lienket}    //td[div[p[a[text()='{0}']]]]//..//kv-product-mapping-cell[@channel-id="{1}"]//input
${item_hang_lienket_in_dropdown}     //li[@suggestion]
#thao tac
${button_thaotac}     //span[contains(normalize-space(),'Thao tác')]
${button_lienket_kenhban}     //a[@ng-click='mappingChannelProduct()']
${checkbox_hanghoa}     //span[contains(text(),'{0}')]/..//..//td[@class="cell-check"]//a
${text_noti_import_success}     //span[text()='Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.']
