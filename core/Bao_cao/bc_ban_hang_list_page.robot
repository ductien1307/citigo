*** Variables ***
${cell_bcbh_thoi_gian}    //div[div[text()='{0}']]    #0: thoi gian
${checkbox_bcbh_loinhuan}    //div[label[contains(text(),'Lợi nhuận')]]//a
${label_doanhthu_thuan}    //div[contains(@class,'textBox8')]//div
${label_doanhthu_thuan_theo_thoigian}     //div[contains(@class,'textBox13')]//div
${label_gio}     //div[contains(@class,'textBox18')]//div
${cell_thoigian}    //li[@class='reportsort reportsortDateTime has-pretty-child']//label[@id='reportsortDateTimeLbl']
${option_thangnay}    //a[@ng-click="filterbyRange('month')"]
${checkbox_luachonkhac}    //li[contains(@class,'reportsort reportsortOther has-pretty-child')]//div[contains(@class,'blue')]//a
