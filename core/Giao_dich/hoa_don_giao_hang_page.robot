*** Variables ***
${textbox_giaohang_hd}    //div[contains(@class, 'form-panel')]//div[contains(@class, 'row')]//div[contains(@class, 'form-group')]//label[contains(text(),'{0}')]/..//input[@type='text']    #Với các trường người nhận, điện thoại, mã vận đơn, trọng lượng, phí giao hàng
${select_hoadon}    //tbody[@role='rowgroup']//tr[contains(@class, 'k-master-row')]//td[contains(@class, 'tdCode18')]//span[text()='{0}']
${button_luu_hd}    //tr[contains(@class, 'detail-row')]//a[text()=' Lưu']
${dropdownlist_Khuvuc_hd}    //kv-search-location[@kv-model= 'dataItem.DeliveryDetail']//div[contains(@class, 'form-group')]//label[text()= 'Khu vực']/..//div[contains(@class, 'form-wrap loc ')]//input[@id='locationSearchInput']    # Khu vực
${item_khuvuc_hd}    //div[contains(@class, 'output-complete')]//ul//span[text()= '{0}']
${dropdowlist_Phuongxa_hd}    //kv-search-location[@kv-model= 'dataItem.DeliveryDetail']//div[contains(@class, 'form-group')]//label[text()= 'Phường xã']/..//div[contains(@class, 'form-wrap')]//input[@id='wardSearchInput']    # phường xã
${item_phuongxa_hd}    //div[contains(@class, 'autocomplete ')]//ul//span[text()= '{0}']
${icon_select_nguoigiao}    //div[contains(@class, 'col-md-6')]//div[contains(@class, 'form-group')]//label[text()='Người giao:']/..//span[text()='select']    # Người giao
${item_nguoigiao}    //div[contains(@class, 'animation-container')]//span[contains(text(), '{0}')]
${icon_select_trangthai_gh}    //div[contains(@class, 'form-group')]//label[text()='Trạng thái giao hàng:']/..//span[text()='select']    # Trạng thái giao hàng
${item_ttgh_hd}    //div[contains(@class, 'animation-container')]//div[contains(@class, 'list-scroller')]//ul//li[text()='{0}']
${cell_ttgh_hd}    //div[contains(@class, 'form-group')]//label[span[text()= 'Trạng thái giao hàng']]
${textbox_kichthuoc_hd}    //div[contains(@class, 'form-group')]//label[text()= 'Kích thước']/..//input[@type='text'][@placeholder= '{0}']    # dài, rộng, cao
${textbox_diachi_hd}    //div[contains(@class, 'form-panel')]//div[contains(@class, 'row')]//div[contains(@class, 'form-group')]//label[contains(text(),'Địa chỉ')]/..//textarea[contains(@class, 'form-control')]
${textbox_time_gh_hd}    //input[@id='ExpectedDelivery1']
${khuvuc_giaohang}    //tr[contains(@class, 'detail-row')]//div[contains(@class, 'tabstrip-wrapper')]//div[contains(@class, 'content ')]//div[contains(@class, 'success')]//div[contains(@class,"row")][1]
${select_trangthai_gh}    //section[contains(@class, 'mainLeft')]//h3[text()= 'Trạng thái']/..//aside[contains(@class, 'leftStatus ')]//label[text()= 'Không giao được']    #Trạng thái giao hàng
