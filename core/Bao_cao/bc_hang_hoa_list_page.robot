*** Variables ***
${checkbox_bchh_loinhuan}    //div[label[contains(text(),'Lợi nhuận')]]//a
${textbox_bchh_hanghoa}    //input[@placeholder='Theo tên hoặc mã hàng']
${button_bchh_show_hanghoa}    //h3[contains(text(),'Hàng hóa')]//a//i
${cell_product_in_table_report}    //div[contains(@class,'layer')]//div[contains(@class,'txtProduct')][{0}]//div     #số thứ tự
${label_filter_thoigian}    //aside[contains(@class,'boxLeftC')]//li[1]//label[text()='Tuần này']
${link_filter_thangnay}   //div[h3[text()='Theo tháng']]//ul//a[text()='Tháng này']
${label_soluong_mathang}    //div[contains(@class,'textBox23')]//div
${radiobutton_khach_theo_hang_ban}    //label[contains(text(),'Khách theo hàng bán')]/..//a
${textbox_khach_hang}    //input[@ng-model="kvModel.CustomerKey"]
${hang_hoa}    //div[contains(text(),'{0}')]
