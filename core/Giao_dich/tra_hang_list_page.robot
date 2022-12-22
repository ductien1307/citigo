*** Variables ***
${button_trahang}    //*[contains(@class, 'headerContent')]//a[contains(@class, 'kv2Btn') and contains(text(), 'Trả hàng')]
${textbox_theo_ma_phieu_tra}      //input[@placeholder='Theo mã phiếu trả']
${button_th_luu}      //span[@ng-show="!noteditable"]//a[@ng-click="update()"]
${button_th_in}     //span[@ng-show="!noteditable"]//a[@ng-show="canPrint"]
${button_th_xuatfile_th}      //refund-form[@class='ng-isolate-scope']//a[@ng-click="exportDetail()"]
${button_th_saochep}     //span[@ng-show="!noteditable"]//a[@ng-show="showCopy"]
${button_th_huybo}      //refund-form[@class='ng-isolate-scope']//a[@ng-click="cancel()"]
${button_th_xuatfile}     //a[@title="Xuất  file"]
${button_th_dongy_huybo}      //button[@ng-enter="onConfirm()"]
#---BMKH----
${btn_dropdown_search}    //button[@class='btn-icon dropdown-toggle']
${button_tim_kiem_mo_rong}    //a[contains(text(),'Mở rộng ')]
${textbox_timkiem_theo_khach_hang}    //input[@placeholder='Theo mã, tên, số điện thoại khách hàng']
${button_search}    //button[@ng-click="quickSearch()"]
${ma_phieu}     //span[contains(text(),'{0}')]     #return_code
${khach_hang}    //a[contains(text(),'{0} - {1}')]    #0:cus_code 1:cus_name
