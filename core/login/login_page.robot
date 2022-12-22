*** Settings ***
Documentation     Define page object that includes all interactive component

*** Variables ***
${textbox_login_username}    //*[@id='UserName']
${textbox_login_password}    //*[@id='Password']
${button_quanly}    //section[contains(@class, 'loginBox')]//*[contains(@class, 'lgBtn')]//input[@type='submit']
${text_failvalidation}    //section[contains(@class, 'loginFr')]//div[contains(@class, 'validation-summary-errors')]//ul/li
${button_banhang_login}    //input[@value='Bán hàng']
${button_quanly_login}    //input[@value='Quản lý']
${button_banhang_sale}    //button[@name='ban-hang']
${button_dong_popup}    //span[@class='vodal-close']
${button_close_popup2}    //a[@class='closepop']
${checkbox_disappear_popup}    //div[@class='popup-support']//label[@class='quickaction_chk']
${button_close_popup3}    //a[@class='popup-close']
${checkbox_ko_hien_thi_lan_sau}    //label[contains(text(),'Không hiển thị lần sau')]
${checkbox_ko_hien_thi_lan_sau_2}    //div[@class='pop-note']//label[@class='quickaction_chk']//span
${button_close_popup4}    //div[contains(@class,'kv-timesheet')]//span[text()='Close']
${button_boqua_popup4}     //button[@id='btnCancel']
${button_close_popup5}      //span[@class='vodal-close']
#
${button_login_kvpage}         //ul[@class='nav navbar-nav nav-kiotviet']//a[text()='Đăng Nhập']
${textbox_urladdress_accesspopup_kvpage}         //input[@id='kvs']
${btn_accessurl_accesspopup_kvpage}        //input[@class='step-login kv-login']
#
${textbox_login_tengianhang}      //input[@id='Retailer']
##
${link_quenmatkhau}   //*[@id='forgotPass']
${textbox_username_QMK}   //*[@id='UserName']
${button_laymatkhau_popup}  //section[@class='lgBtn fgBtn btn-custom']//input[@value='Lấy mật khẩu']
${label_notifi_error}   //*[@id='messageOTP']
