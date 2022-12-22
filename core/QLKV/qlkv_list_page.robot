*** Variables ***
#form login
${textbox_qlkv_username}    //input[@id='UserName']
${textbox_qlkv_password}    //input[@id='Password']
${button_qlkv_login}    //input[@name='quan-ly']
#menu
${menu_qlkv}    //a[normalize-space()='{0}']
#domain
#
${button_add_retailer}    //a[contains(text(),' Add retailer')]
${textbox_keyword}      //input[@placeholder='Keyword']
${cell_retail_tenshop}      //a[normalize-space()='{0}']
${cell_retail_first_row}      //tr[1]//td[@class="tdCode"]//a
#form thêm mới
${textbox_qlkv_details_name}    //article[1]//span[contains(text(),'Name')]/..//input
${textbox_qlkv_address}   //span[contains(text(),'Address')]/..//input
${textbox_qlkv_khuvuc}    //input[@id='locationSearchInput']
${textbox_qlkv_phuongxa}    //input[@id='wardSearchInput']
${textbox_qlkv_domain}    //span[contains(text(),'Domain')]/..//input
${textbox_qlkv_phone}    //span[contains(text(),'Phone')]/..//input
${textbox_qlkv_website}   //span[contains(text(),'Website')]/..//input
${combobox_contract_type}   //label//span[contains(text(),'Contract Type:')]/..//span[contains(text(),'select')]
${contract_type}    //li[contains(@class,'k-item')][contains(text(),'{0}')]
${textbox_maximum_branch}    //span[contains(text(),'Maximum Branchs')]/..//input
${textbox_maximum_product}    //span[contains(text(),'Maximum Products')]/..//input
${textbox_maximum_fanpage}    //span[contains(text(),'Maximum Fanpages')]/..//input
${textbox_purchase_kiotmail}    //span[contains(text(),'Purchase KiotMail')]/..//input
${combobox_industry}    //label//span[contains(text(),'Industry')]/..//span[contains(text(),'select')]
${item_industry_indropdown}     //li[contains(text(),'{0}')]
${industry_type}    //li[contains(@class,'k-item')][contains(text(),'{0}')]
${textbox_startdate}   //span[contains(text(),'Start date')]/..//input
${textbox_enddate}   //span[contains(text(),'Expires on')]/..//input
${checkbox_sample_data}   //aside[contains(@class,'frRadioCheck')]//a
${textbox_qlkv_firstbranch_name}    //article[2]//span[contains(text(),'Name')]/..//input
${textbox_qlkv_admin_name}    //article[3]//span[contains(text(),'Name')]/..//input
${textbox_admin_username}   //span[contains(text(),'Username')]/..//input
${textbox_admin_password}   //span[contains(text(),'Password')]/..//input
${button_create}   //button[contains(text(),' Create ')]
#form cập nhật
${button_qlkv_update}     //button[@class='kv2Btn ng-binding']
#
${button_form_retailer}      //span[normalize-space()='{0}']
${body_form_retailer}    //tbody
${cell_branch_first_row}    //tr[1]//td[@class="tdProductName"]
${button_lock_branch}     //a[normalize-space()='Lock']
${link_kiemkho}     //a[text()='Kiểm kho']
${link_hanghoa}     (//a[text()='Hàng hóa'])[1]     #//i[@class='fas fa-cube']/parent::a[text()='Hàng hóa']
${icon_thietlap}    //li[@class='setting']/a
${link_thietlapcuahang}    //a[contains(text(),'Thiết lập cửa hàng')]
