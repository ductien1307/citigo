*** Settings ***
Test Setup        Before Test Quan ly
Test Teardown     After test
Force Tags
Test Template     Nhap hang process
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/danh_muc_list_page.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/toast_message.robot

*** Test Cases ***    STT          MaSP              Giá Nhập    Số lượng nhập    Nhà Cung cấp         Ma phieu nhap    Tiền trả NCC
Khong tt cho ncc      [Tags]       ImportProducts
                      [Timeout]
                      1            SP0004            50000       60               Công ty Hoàng Gia    PN016            0

TT cho ncc            [Tags]       ImportProducts
                      [Timeout]
                      1            SP0004            50000       60               Công ty Hoàng Gia    PN023            50000

*** Keywords ***
Nhap hang process
    [Arguments]    ${nh_row}    ${code1}    ${gia1}    ${soluong1}    ${provider}    ${ma_pn}
    ...    ${nh_tientra_ncc}
    [Documentation]    nhập 1 hàng hóa
    #Get Gia von, ton kho cua sp nhap hang
    Go To Danh Muc Hang Hoa
    ${get_giavon_before_import}    ${get_tonkho_beforeimport}    Search product id to get gia von and ton kho    ${code1}
    # get cong no ncc
    Go to Nha cung cap
    ${get_no_ncc_before_import}    Search ncc for gettting no hien tai    ${provider}
    # lap phieu
    Go To nhap Hang
    Go to PNH
    Input products to Phieu Nhap Hang    ${nh_row}    ${code1}    ${gia1}    ${soluong1}
    Input right information purchase order    ${provider}    ${ma_pn}    ${nh_tientra_ncc}
    Click Element    ${button_nh_hoanthanh}
    Pnh message success validation
    ${thanhtien1}    Multiplication    ${gia1}    ${soluong1}
    Wait Until Element Is Visible    ${text_pnh}
    Assert Record By NCC    1    ${provider}    Đã nhập hàng    ${thanhtien1}
    Go To Danh Muc Hang Hoa
    # Verify hang hoa
    ${get_giavon_after_import}    ${get_tonkho_after_import}    Search product id to get gia von and ton kho    ${code1}
    ${result_giavon_tb_after_import}    Average Cost Of Capital    ${get_giavon_before_import}    ${get_tonkho_beforeimport}    ${gia1}    ${soluong1}
    Assert Equals Number    ${result_giavon_tb_after_import}    ${get_giavon_after_import}
    ${result_tonkho}    sum    ${get_tonkho_beforeimport}    ${soluong1}
    Assert Equals Number    ${result_tonkho}    ${get_tonkho_after_import}
    # verify cong no ncc
    ${result_nocantra_ncc}    sum    ${get_no_ncc_before_import}    ${thanhtien1}
    ${result_tong_mua}    Multiplication    ${soluong1}    ${gia1}
    ${nav_tientra_ncc}=    Catenate    -    ${nh_tientra_ncc}
    Go to Nha cung cap
    Run Keyword If    '${nh_tientra_ncc}' == '0'    Assert values in No can tra NCC tab if not paying    ${provider}    ${result_tong_mua}    ${result_nocantra_ncc}
    ...    ELSE    Assert values in No can tra NCC tab if paying    ${provider}    ${result_tong_mua}    ${result_nocantra_ncc}
    Run Keyword If    '${nh_tientra_ncc}' == '0'    Go to So quy and validate ma HD not visible    ${ma_pn}
    ...    ELSE    Validate gia tri nhap hang in so quy    ${ma_pn}    ${nav_tientra_ncc}

Validate gia tri nhap hang in so quy
    [Arguments]    ${get_ma_hd}    ${input_bh_khachtt}
    ${get_hd_loai_thuchi}    ${get_hd_giatri}    Go to So quy and get info    ${get_ma_hd}
    Should Be Equal As Strings    Chi Tiền trả NCC    ${get_hd_loai_thuchi}
    Assert Equals Number    ${get_hd_giatri}    ${input_bh_khachtt}

Assert values in No can tra NCC tab if paying
    [Arguments]    ${provider}    ${result_tong_mua}    ${result_nocantra_ncc}
    ${get_nocantra_ncc}    ${get_giatri}    Search ncc to get info in No can tra ncc tab    2    ${provider}
    Assert Equals Number    ${get_giatri}    ${result_tong_mua}
    Assert Equals Number    ${get_nocantra_ncc}    ${result_nocantra_ncc}

Assert values in No can tra NCC tab if not paying
    [Arguments]    ${provider}    ${result_tong_mua}    ${result_nocantra_ncc}
    ${get_nocantra_ncc}    ${get_giatri}    Search ncc to get info in No can tra ncc tab    1    ${provider}
    Assert Equals Number    ${get_giatri}    ${result_tong_mua}
    Assert Equals Number    ${get_nocantra_ncc}    ${result_nocantra_ncc}
