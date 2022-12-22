*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/soquy.robot
Resource          ../../../core/share/javascript.robot

*** Test Cases ***    Loại thu chi       Giá trị        Tài khoản nộp       Hạch toán        Cashflow cash type     Cashflow transfer type
Tien_mat             [Tags]          ACR
                      [Template]      chuyenrut_tm
                      Chuyển/Rút       500000         1900347347348       yes           Thu                    Chi
                      Chuyển/Rút       1000000         005407093473        no            Chi                    Thu

Ngan_hang             [Tags]          ACR
                      [Template]      chuyenrut_nh
                      Chuyển/Rút       4000000      1900347347348       44509300485745      yes           Thu                    Chi
                      Chuyển/Rút       350000      44509300485745      005407093473        no            Chi                    Thu


*** Keywords ***
chuyenrut_tm
    [Arguments]    ${loai_thu_chi}    ${gia_tri}    ${input_taikhoan}    ${hachtoan}    ${cashflow_cash_type}    ${cashflow_bank_type}
    Set Selenium Speed    0.5s
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat with other branch    ${BRANCH_ID}
    ...    ${gia_tri}    ${cashflow_cash_type}
    ${result_quy_dau_ky_bank}    ${result_tong_thu_bank}    ${result_tong_chi_bank}    ${result_ton_quy_bank}    Compute balance in tab Ngan hang with other branch    ${BRANCH_ID}
    ...    ${gia_tri}    ${cashflow_bank_type}
    ${ma_phieu}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'    Generate code automatically    TTM    ELSE    Generate code automatically    CTM
    ${get_bank_id}    Get bank account id    ${input_taikhoan}
    ${get_hachtoan}   Set Variable If    '${hachtoan}' == 'yes'    true     false
    ${result_giatri}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'    Set Variable    ${gia_tri}    ELSE      Minus     0    ${gia_tri}
    ${data_str}      Format String     {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"UsedPaymentForInvoiceOrReturn":true,"PartnerType":"B","PaymentMethod":"Cash","CashFlowType":1,"PartnerId":{2},"Code":"{3}","CashFlowGroupId":null,"AccountId":null,"BranchId":{4}}},"ComparePartnerName":"","CashflowGroupName":"Chuyển/Rút","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"Khác"}}      ${result_giatri}
    ...      ${get_hachtoan}    ${get_bank_id}    ${ma_phieu}     ${BRANCH_ID}
    Log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /cashflow    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    ${get_maphieu_tudong}   Get automatic payment code frm api    ${ma_phieu}
    #validate chi tiet phieu
    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}    ${get_doituongnop}    ${get_hachtoan}    Get cashflow info frm API    ${ma_phieu}
    ${gia_tri}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_taikhoan}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    ${gia_tri}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    #validate chi tiet phieu tu dong
    ${get_gia_tri_bank}    ${get_loai_thu_chi_bank}    ${get_ten_bank}    ${get_trang_thai_bank}    ${get_doituongnop_bank}    ${get_hachtoan_bank}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    ${gia_tri_bank}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri_bank}    ${gia_tri_bank}
    Should Be Equal As Strings    ${get_loai_thu_chi_bank}    0
    Should Be Equal As Strings    ${get_trang_thai_bank}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_bank}    anh.lv
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Log     Validate ton quy tu dong
    #validate ton quy cua phieu tu dong
    ${get_quy_dau_ky_bank}    ${get_tong_thu_bank}    ${get_tong_chi_bank}    ${get_ton_quy_bank}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_bank}    ${result_quy_dau_ky_bank}
    Should Be Equal As Numbers    ${get_tong_thu_bank}    ${result_tong_thu_bank}
    Should Be Equal As Numbers    ${get_tong_chi_bank}    ${result_tong_chi_bank}
    Should Be Equal As Numbers    ${get_ton_quy_bank}    ${result_ton_quy_bank}
    Delete payment frm API    ${ma_phieu}

chuyenrut_nh
    [Arguments]    ${loai_thu_chi}    ${gia_tri}    ${input_taikhoan_nop}    ${input_taikhoan_nhan}    ${hachtoan}    ${cashflow_bank_type}    ${cashflow_bank1_type}
    Set Selenium Speed    0.5s
    ${get_quy_dau_ky_bank_bf_ex}    ${get_tong_thu_bank_bf_ex}    ${get_tong_chi_bank_bf_ex}    ${get_ton_quy_bank_bf_ex}    Get balance in So quy Ngan hang
    ${result_tong_thu_bank}   Sum    ${get_tong_thu_bank_bf_ex}    ${gia_tri}
    ${result_tong_chi_bank}   Minus    ${get_tong_chi_bank_bf_ex}    ${gia_tri}
    ${ma_phieu}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'    Generate code automatically    TNHH    ELSE    Generate code automatically    CNH
    ${get_bank_id_nop}    Get bank account id    ${input_taikhoan_nop}
    ${get_bank_id_nhan}    Get bank account id    ${input_taikhoan_nhan}
    ${get_hachtoan}   Set Variable If    '${hachtoan}' == 'yes'    true     false
    ${result_giatri}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'    Set Variable    ${gia_tri}    ELSE      Minus     0    ${gia_tri}
    ${data_str}      Format String     {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"UsedPaymentForInvoiceOrReturn":true,"PartnerType":"B","PaymentMethod":"Transfer","CashFlowType":1,"Code":"{2}","PartnerId":{3},"CashFlowGroupId":null,"AccountId":{4},"BranchId":{5}}},"ComparePartnerName":"","CashflowGroupName":"Chuyển/Rút","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"Khác"}}      ${result_giatri}
    ...      ${get_hachtoan}    ${ma_phieu}    ${get_bank_id_nop}    ${get_bank_id_nhan}     ${BRANCH_ID}
    Log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /cashflow    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    ${get_maphieu_tudong}   Get automatic payment code frm api    ${ma_phieu}
    #validate chi tiet phieu
    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}    ${get_doituongnop}    ${get_hachtoan}    Get cashflow info frm API    ${ma_phieu}
    ${gia_tri}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_taikhoan_nop}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    ${gia_tri}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    #validate chi tiet phieu tu dong
    ${get_gia_tri_bank}    ${get_loai_thu_chi_bank}    ${get_ten_bank}    ${get_trang_thai_bank}    ${get_doituongnop_bank}    ${get_hachtoan_bank}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    ${gia_tri_bank}    Run Keyword If    '${cashflow_bank1_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri_bank}    ${gia_tri_bank}
    Should Be Equal As Strings    ${get_loai_thu_chi_bank}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai_bank}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_bank}    ${input_taikhoan_nhan}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    #validate ton quy cua phieu tu dong
    ${get_quy_dau_ky_bank}    ${get_tong_thu_bank}    ${get_tong_chi_bank}    ${get_ton_quy_bank}    Get balance in So quy Ngan hang
    ${get_ton_quy_bank}    Evaluate    round(${get_ton_quy_bank}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_bank}    ${get_quy_dau_ky_bank_bf_ex}
    Should Be Equal As Numbers    ${get_tong_thu_bank}    ${result_tong_thu_bank}
    Should Be Equal As Numbers    ${get_tong_chi_bank}    ${result_tong_chi_bank}
    Should Be Equal As Numbers    ${get_ton_quy_bank}    ${get_ton_quy_bank_bf_ex}
    #Delete payment frm API    ${ma_phieu}
