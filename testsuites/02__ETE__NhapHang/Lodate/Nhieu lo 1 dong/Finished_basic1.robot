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
&{dict_imp}       LD03=2,3    QD23=5,2.3
&{dict_giamoi}    LD03=none    QD23=112000
&{dict_gg}        LD03=10    QD23=12000.2

*** Test Cases ***    Mã NCC        Mã SP - SL      Giá mới            GGSP           GGPN     Tiền trả NCC
Basic                 [Tags]        ENNL
                      [Template]    ennl3
                      NCC0015       ${dict_imp}     ${dict_giamoi}     ${dict_gg}     50000    70000

*** Keywords ***
