Library           SeleniumLibrary
Library           Collections
Resource          banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Variables ***
${button_facebook}      //a[normalize-space()='Facebook']
${button_fb_dangnhap_facebook}     //button[@class='btn btn-fb']
${textbox_fb_email}    //input[@id='email']
${textbox_fb_matkhau}    //input[@id='pass']
${button_fb_dangnhap}      //input[@value="Đăng nhập"]
${button_fb_in}   //i[@class='fas fa-print']
${toggle_fb_tat_tudong_in}    //span[@title='Tắt chế độ tự động in']
${cell_fb_frirt_conversation}   //div[@class='wrap-content']//div//div[1]//chat-conversation-item[1]//a[1]
${button_fb_donmoi}   //a[contains(text(),'+ Đơn mới')]
${textbox_fb_tim_mat_hang}    //input[@id='productSearchInput']
${item_fb_hanghoa_in_dropdowlist}   //div[@class='autocomplete']//p[contains(text(),'{0}')]
${button_fb_dathang}    //button[contains(text(),'Đặt hàng')]
