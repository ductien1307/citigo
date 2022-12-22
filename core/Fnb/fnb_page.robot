Library           SeleniumLibrary
Library           Collections
Resource          banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Variables ***
${button_thu_ngan}      //span[contains(text(),'Thu ngân')]
${cell_tn_ten_sp}     //div[@class='cell-name full']//h4
${button_tn_so_luong}     //button[@class='btn-icon down']//..//button[@ class="form-control form-control-sm" ]
${textbox_tn_so_luong}      //div[@class='form-output number-quantity']//input
${button_tn_gia_ban}      //div[@class='row-product']//div[@class='popup-anchor']//button
${textbox_tn_gia_ban}     //input[@id='adjustedPrice']
${button_tn_thanh_toan_F9}   //button[@class='btn btn-success']
${button_tn_thanh_toan}     //button[@class='btn btn-lg btn-success']
${button_tn_giamgia}    //button[@class='form-control']
${textbox_tn_giamgia}      //input[@id='priceInput']
${textbox_tn_khach_tt}    //input[@id='payingAmountTxt']
${textbox_tn_khach_hang}    //input[@id='searchCustomerInput']
${button_tn_them_khachhang}     //button[@id='addCustomer']//i[@class='far fa-plus']
${textbox_tn_ma_kh}    //input[@placeholder='Mã mặc định']
${textbox_tn_ten_kh}   //input[@id='customerName']
${button_tn_them_kh_luu}     //a[@ng-disabled="savingCustomer"]//i[@class='fa fa-save']
