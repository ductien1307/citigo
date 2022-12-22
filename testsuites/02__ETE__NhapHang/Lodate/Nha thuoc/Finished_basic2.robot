*** Settings ***
Suite Setup       Init Test Environment    NT    ${remote}    ${account}     ${headless_browser}
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
&{dict_imp1}      T00003=3,2    T00004=4.2,5,2
&{dict_giamoi1}    T00003=85000    T00004=none
&{dict_gg1}       T00003=5000.8    T00004=10

*** Test Cases ***    Mã NCC        Mã SP - SL      Giá mới            GGSP           GGPN     Tiền trả NCC
Basic                 [Tags]        EBNT
                      [Template]    ennl4
                      NCC0004       ${dict_imp1}    ${dict_giamoi1}    ${dict_gg1}    50000    all

*** Keywords ***
