Library           SeleniumLibrary
Library           Collections
Resource          banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Variables ***
${button_dky_dung_thu_mien_phi}    //div[@class='text-banner']//button[@id='show_signup']
${button_nganh_hang}     //p[contains(text(),'{0}')]
${textbox_dky_ho_ten}   //input[@id='fullname']
${textbox_dky_dien_thoai}   //input[@id='phone']
${textbox_dky_ten_cua_hang}   //input[@id='code']
${textbox_dky_ten_dang_nhap}    //input[@id='name']
${textbox_dky_mat_khau}   //input[@id='pass']
${button_dky_tiep_theo}   //a[@class='register-btn pull-right register-step2']
${cell_dky_thanh_pho}   //a[@class='select2-choice']//span
${textbox_dky_thanh_pho}    //div[@class='select2-search']//input
${item_thanhpho_in_dropdowlist}     //select[@id='location']//option[contains(text(),'{0}')]
${textbox_dky_captcha}    //input[@id='captcha']
${button_dky_dang_ky}   //a[@class='register-btn pull-right register-step3']
${textbox_dky_dia_chi}    //input[@id='address']
${button_bat_dau_kd}     //button[@class='register register-step4']
${checkbox_taodulieumau}     //div[contains(@class,'fs14')]//a
${button_hoanthanh_taodulieumau}    //div[contains(@class,'box-btn')]//a
${cell_diachi_gh}       //h5[@id='store-url']//a[contains(text(),'https://{0}.kiotviet.vn')]
${cell_diachi_fnb}      //h5[@id='store-url']//a[contains(text(),'https://fnb.kiotviet.vn/{0}')]
${button_tao_du_lieu_mau_fnb}     //a[@ng-click="doIntitialData()"]
