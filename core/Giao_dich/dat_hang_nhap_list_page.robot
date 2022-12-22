*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot

*** Variables ***
${button_tao_phieu_dhn}    //a[@ng-show='hasAdd']
${textbox_dhn_search_ma_phieu}    //input[contains(@placeholder,'Theo mã phiếu đặt hàng nhập')]
${button_dhn_mo_phieu}    //a[contains(@ng-click,"openForm")]
${button_dhn_tao_phieu_nhap}    //a[contains(text(),'Tạo phiếu nhập')]
${button_ketthuc_phieu_dhn}     //a[i[@class='fas fa-file-excel']]
${button_luu_phieu_dhn}     //a[i[@class='fas fa-save']]
${button_huybo_phieu_dhn}     //a[@ng-click="voidOrder(dataItem)"]
${button_group_dhn}     //button[@id='btnGroupDrop1']
${button_dongy_huy_phieu_dhn}     //button[@class='btn-confirm btn btn-success']
${button_dhn_sao_chep}      //a[i[@class='far fa-clone fa-fw']]
${button_dhn_in}      //a[i[@class='far fa-print fa-fw']]
