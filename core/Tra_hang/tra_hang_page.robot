*** Variables ***
# Trả hàng
${button_th}      //*[@id='saveRefund']
${cell_th_giamoi_hangtra}    //cart-products-component//div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-change-price')]//button[contains(@class, 'form-control')]
${texbox_th_soluong_tra}    //cart-products-component//div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-quatity')]//input
${textbox_th_giamoi}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-group') and ./label[span[text()='Giá mới']]]//input[@type='text']
${button_giamgia_th}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label/span[contains(text(), 'Giảm giá')]]//button[contains(@uib-popover-template, 'quickRefundDiscount')]
${textbox_th_giamgia}    //div[contains(@class, 'popover-content')]//div[contains(@class, 'form-group') and ./label[text()='Giảm giá']]//input[@type='text']
${button_th_giamgia%}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-output kv-toggle')]//kv-toggle/a[contains(@class, 'toggle-btn') and text()='%']
${textbox_th_khachttTraHang}    //*[@id='payingAmtRefund']
${textbox_th_search_tra}    //*[@id='productSearchInput']
${cell_laster_numbers_return}    //payment-refund-component//label[text()='Tổng tiền hàng trả ']//span[@class='badge']
## Đổi trả hàng
${cell_th_giamoi_hangdoi}    //cart-refund-products-component//div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-change-price')]//button[contains(@class, 'form-control')]
${textbox_th_search_hangdoi}    //cart-refund-products-component//*[@id="newItemsSearch"]
${button_mhbh_themmoi_hh_hangdoi}    //input[@id='newItemsSearch']//..//div//a[text()='+ Thêm mới hàng hóa']
${textbox_th_soluong_doi}    //cart-refund-products-component//div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-quatity')]//input
${cell_tongsoluong_hangdoi}    //payment-refund-component//label[contains(text(),'Tổng tiền hàng ')]//span
${button_giamgia_dth}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label[contains(text(), 'Giảm giá ')]]//button[contains(@uib-popover-template, 'newDiscountCart')]
## thanh toán đổi và trả hàng
${cell_tong_tien_tra}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label/span[contains(text(), 'Tổng tiền trả')]]//div//strong
${cell_tong_tien_mua}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label/span[contains(text(), 'Tổng tiền mua')]]//div//strong
${cell_khach_tt_avg}    //payment-refund-component//div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label/strong]//div
${cell_payment_status}    //payment-refund-component//div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group')]//label/strong
${button_phi_trahang}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label/span[contains(text(), 'Phí trả hàng')]]//button[contains(@uib-popover-template, 'ReturnFee')]
${textbox_phi_th_giamgia}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-group')]//label[contains(text(), 'Phí trả hàng')]//..//input[@type='text']
${textbox_phi_th_giamgia%}    //div[contains(@class, 'popover-content')]//div[contains(@class, 'form-group')]//label[contains(text(), 'Phí trả hàng')]//..//input[@type='text']
${textbox_dth_tientrakhach}    //div[contains(@class, 'payment-component')]//h4[span[span[text()='Mua hàng']]]//..//span[text()= 'Tiền trả khách (F8) ']//..//input[contains(@class, 'payingAmt')]
${textbox_dth_khachthanhtoan}    //div[contains(@class, 'payment-component')]//h4[span[span[text()='Mua hàng']]]//..//span[text()= 'Khách thanh toán (F8) ']//..//input[contains(@class, 'payingAmt')]
${textbox_thukhac_doitrahang}    //a[@id='btnSurchargeRefund']
${button_giamgia_doitrahang}    //div[contains(@class, 'payment-component')]//h4[span[span[text()='Mua hàng']]]//..//label[text()= 'Giảm giá ']//..//button[contains(@class, 'form-control')]
##popup lưu trả hàng cho mh đổi trả hàng theo hoa đơn
${button_dongy}       //div[contains(@class, 'window-danger')]//button[text()= 'Đồng ý']
${cell_surcharge_return}    //payment-refund-component//div[span[text()='Hoàn trả thu khác ']]/..//a[contains(@class, 'form-control')]
##payment type
${button_refund_card}    //payment-refund-component//i[@class='fa fa-credit-card']
## phân bổ công nợ khách hàng
${button_tinhvaocongno_th}    //payment-refund-component//span[@ng-click='vm.makepaymentSurplus()']
${checkbox_thanhtoanno_in_popuptienno}  //payment-surplus-component//span[text()='Thanh toán cho phiếu trả còn nợ']
${payment_in_popuptienthua}   //div[contains(@class,'col-md-offset')]//span[text()='Tổng phân bổ cho phiếu trả:']//..//..//strong
${button_dongy_in_popuptienno}   //div[contains(@class,'k-footer')]//button[contains(@class,'btn btn-success')]
${button_dongy_trahang_ngungkd}     //button[@class='btn btn-danger btn-confirm']//i[@class='fa fa-check-square']

*** Keywords ***
Go to popup for other payment methods for refund
    [Arguments]    ${button_refund_card}    ${tongtienmua}    ${tongtientra}
    Wait Until Element Is Visible    ${button_refund_card}
    Click Element JS    ${button_refund_card}
    ${validate popup}   Set Variable If    ${tongtienmua}>${tongtientra}    Khách thanh toán    Tiền trả khách
    Wait Until Page Contains    ${validate popup}

Apply allocate payment
    [Arguments]     ${tongthanhtoan}
    Wait Until Element Is Visible    ${button_tinhvaocongno_th}
    Click Element JS    ${button_tinhvaocongno_th}
    Wait Until Element Is Visible    ${checkbox_thanhtoanno_in_popuptienno}
    Click Element JS    ${checkbox_thanhtoanno_in_popuptienno}
    ${payment}  Get Text    ${payment_in_popuptienthua}
    ${payment}    Replace String    ${payment}    ,       ${EMPTY}
    Should Be Equal As Numbers    ${payment}    ${tongthanhtoan}
    Wait Until Element Is Visible    ${button_dongy_in_popuptienno}
    Click Element JS    ${button_dongy_in_popuptienno}
