*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot

*** Variables ***
${textbox_xh_search_sp}    //input[@id='productSearchInput']
${xh_item_indropdown_search}    //div[contains(@class,'ovh')]//p[contains(text(),'{0}')]
${xh_cell_first_product_code}    //tr[1]//td[@class='cell-code']
${xh_cell_first_gia_von}    //tr[1]//td[@class='tdPrice']
${xh_cell_first_giatri_huy}    //tr[1]//td[@class='tdPrice ng-binding']
${textbox_xh_nhap_maphieu}    //input[@placeholder='Mã phiếu tự động']
${cell_xh_lastest_num}    //label[contains(text(),'Tổng giá trị hủy ')]//span[contains(@class,'qty')]
${cell_xh_tong_gt_huy}    //label[contains(text(),'Tổng giá trị hủy ')]//..//div
${textbox_xh_nhap_soluong}    //tr[1]//td[contains(@class,'cell-qty-numb')]//input
${button_xh_hoanthanh}    //a[@ng-click="saveData(true)"]
${button_xh_luutam}    //a[contains(text(),'Lưu tạm')]
${cell_xh_unit}    //td[contains(@class,'cell-dvt')]//span[contains(@class,"slcUnit")]
${item_unit_xh_inlist}    //span[contains(@class,'slcUnit')]//select//option[contains(text(),'{0}')]
${textbox_xh_nhaplo}    //input[@placeholder="Nhập lô, hạn sử dụng"]
${xh_cell_first_lo}    //em[contains(text(),'{0}')]    #0: ten lo
${xh_cell_ten_lo}    //div[@class='tags']
${button_xh_xoa_sp}    //td[contains(text(),'{0}')]//..//a[@title="Xóa"]    #0: ma sp
${textbox_xh_nhap_soluong_theo_sp}    //td[contains(text(),'{0}')]//..//input
