*** Variables ***
${checkbox_loai_hh_variable}    //ul[@class='pretty-checkbox-mobile']//label[contains(text(),'{0}')]/../a
${checkbox_tonkho_variable}    //article[@class='boxLeft uln leftStatus']//ul[@class='pretty-radio-mobile']//label[contains(text(),'{0}')]/../a
${checkbox_trangthai_variable}    //article[@class='boxLeft reportHide uln sortTime sortView']//*[contains(text(),'{0}')]/../a
${checkbox_loc_theo_tichdiem}    //article[h3[contains(text(), 'Lọc theo tích điểm ')]]//ul[@class='pretty-radio-mobile']//label[contains(text(),'{0}')]/../a
${textcell_nhomhang}    //ul[@class='k-group k-treeview-lines']//li//span[contains(@class, 'nametreeview') and text()='{0}']
${textbox_search_nhomhang}    //aside[@class='boxLeftC']//input[@placeholder='Tìm kiếm nhóm hàng']
