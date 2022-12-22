*** Settings ***
Library           SeleniumLibrary

*** Variables ***
#page list
${button_add_deliverypartner}          //aside//a[@ng-click="addDeliveryPartner()"]
${textbox_search_deliverypartner}     //input[@placeholder='Theo mã, tên, điện thoại']
${button_them_nhom_}       abc
${tab_nocantra_dtgh}       //span[contains(text(),'Phí cần trả đối tác GH')]
${cell_nocantra}    abc
${cell_giatri}      abc
${cell_no_cantra_hientai_onrow}    abc
#tao moi giaohang popup
${radiobutton_deliverypartner_type}      //div[contains(@class,'form-wrapper')]//div[label[contains(text(),'{0}')]]//a      # text Cá nhân or Công ty
${textbox_deliverypartner_code}        //div[contains(@class, 'k-window-delivery kv-window')]//input[@placeholder='Mã mặc định']
${textbox_deliverypartner_name}       //div[contains(@class, 'k-window-delivery kv-window')]//label[contains(text(),'Tên đối tác')]//..//input
${textbox_deliverypartner_mobile}       //div[contains(@class, 'k-window-delivery kv-window')]//label[contains(text(),'Điện thoại')]//..//input
${textbox_deliverypartner_address}       //div[contains(@class, 'k-window-delivery kv-window')]//textarea[@ng-model='deliveryPartner.Address']
${textbox_deliverypartner_location}       //div[contains(@class, 'k-window-delivery kv-window')]//input[@id='locationSearchInput']
${dropdown_deliverypartner_location}        //ul//li[@val='{0}']
${textbox_deliverypartner_ward}       //div[contains(@class, 'k-window-delivery kv-window')]//input[@id='wardSearchInput']
${textbox_deliverypartner_email}       //div[contains(@class, 'k-window-delivery kv-window')]//label[contains(text(),'Email')]//..//input
${textbox_deliverypartner_group}       //div[contains(@class, 'k-window-delivery kv-window')]//label[contains(text(),'Nhóm đối tác')]//..//div
${textbox_deliverypartner_note}       //div[contains(@class, 'k-window-delivery kv-window')]//label[contains(text(),'Ghi chú')]//..//div//textarea
${button_deliverypartner_luu}        //div[contains(@class, 'k-window-delivery kv-window')]//a[contains(text(),'Lưu')]
${button_update_delivery}  //div//a[@ng-click='editDeliveryPartner(dataItem)']
${button_active_delivery}   //div//a[@ng-click='activeDeliveryPartner(dataItem)']
${button_delete_delivery}   //div//a[@ng-click='deleteDeliveryPartner(dataItem)']
##tab đối tác giao dịch
${tab_tichhop}    //div[contains(@class,'kvTabs')]//a[text()='Tích hợp']
${tab_khac}    //div[contains(@class,'kvTabs')]//a[text()='Khác']
