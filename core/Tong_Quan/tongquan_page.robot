*** Variables ***
${cell_text_username}   //li[contains(@class,'dashboard-{0}')][1]//a[@href='#/Invoices?DeliveryKey={1}'][1]/..//a[@ng-click='viewEmployee(act.UserId)'][1]    #0: name giao dich Transfer,invoice... - 1:ma giao dich
${cell_text_active}   //li[contains(@class,'dashboard-{0}')][1]//span[2]    #0: name giao dich
${cell_text_huy_giaodich}   //li[contains(@class,'dashboard-{0}')][1]//a[@href='#/Invoices?DeliveryKey={1}'][1]/..//a[@ng-href='#/{0}?Code={1}&Status=4']     #0: name giao dich Transfer,invoice... - 1:ma giao dich
${cell_text_giatri}   //li[contains(@class,'dashboard-{0}')][1]//a[@href='#/Invoices?DeliveryKey={1}'][1]/..//span[@class='ng-binding'][2]   #0: name giao dich Transfer,invoice... - 1:ma giao dich
