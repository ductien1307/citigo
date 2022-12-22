*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Import Product
Test Teardown     After Test
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/share/lodate.robot
Resource          ../kw_nhaplo.robot

*** Variables ***
&{dict_imp}       LD02=3,3.5,1    QD22=3,2,1
&{dict_giamoi}    LD02=none    QD22=95000.2
&{dict_gg}        LD02=12    QD22=8000

*** Test Cases ***    Mã NCC        Mã SP - SL      Giá mới            GGSP           GGPN    Tiền trả NCC
Basic                 [Tags]        ENNL
                      [Template]    ennl2
                      NCC0013       ${dict_imp}     ${dict_giamoi}     ${dict_gg}     20      0

*** Keywords ***
