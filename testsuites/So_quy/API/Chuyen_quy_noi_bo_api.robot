*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test So Quy
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/soquy.robot
Resource          ../../../core/share/javascript.robot

*** Test Cases ***    Loại thu chi                Giá trị    Đối tượng nộp     Người nộp    Hạch toán        Auto payment type
Phieu thu             [Tags]          ACQNB
                      [Template]      cqnb_thu
                      Chuyển quỹ nội bộ           1200000    Nhánh A             anh.lv       yes           Chi

Phieu chi             [Tags]          ACQNB
                      [Template]      cqnb_chi
                      Chuyển quỹ nội bộ           400000      Nhánh A             anh.lv        no          Thu

*** Keywords ***
cqnb_thu
    [Arguments]    ${loai_thu}    ${gia_tri}    ${input_doituong_nop}    ${input_ten_nguoi_nop}    ${hachtoan}    ${cashflow_type}
    Set Selenium Speed    0.5s
    ${get_branch_id_dtn}    Get BranchID by BranchName    ${input_doituong_nop}
    ${result_quy_dau_ky_dtn}    ${result_tong_thu_dtn}    ${result_tong_chi_dtn}    ${result_ton_quy_dtn}    Compute balance in tab Tien mat with other branch    ${get_branch_id_dtn}
    ...    ${gia_tri}    ${cashflow_type}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add receipt    ${gia_tri}
    ##get data input
    ${ma_phieu}    Generate code automatically    TTM
    ${get_id_nguoiban}    Get User ID
    ${get_hachtoan}   Set Variable If    '${hachtoan}' == 'yes'    true     false
    ${data_str}      Format String     {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"UsedPaymentForInvoiceOrReturn":true,"PartnerType":"H","PaymentMethod":"Cash","CashFlowType":2,"PartnerId":{2},"Code":"{3}","PairedBranchId":{4},"PartnerName":"anh.lv","CashFlowGroupId":null,"AccountId":null,"BranchId":{5}}},"ComparePartnerName":"","CashflowGroupName":"Chuyển quỹ nội bộ","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"Khác","PartnerName":"anh.lv"}}      ${gia_tri}      ${get_hachtoan}
    ...    ${get_id_nguoiban}    ${ma_phieu}    ${get_branch_id_dtn}    ${BRANCH_ID}
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
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển quĩ nội bộ
    Should Be Equal As Strings    ${get_ten}    ${input_ten_nguoi_nop}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_doituong_nop}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    #validate chi tiet phieu tu dong
    ${get_gia_tri_dtn}    ${get_loai_thu_chi_dtn}    ${get_ten_dtn}    ${get_trang_thai_dtn}    ${get_doituongnop_dtn}    ${get_hachtoan_dtn}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    ${gia_tri_dtn}    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri_dtn}    ${gia_tri_dtn}
    Should Be Equal As Strings    ${get_loai_thu_chi_dtn}    Chuyển quĩ nội bộ
    Should Be Equal As Strings    ${get_ten_dtn}    ${input_ten_nguoi_nop}
    Should Be Equal As Strings    ${get_trang_thai_dtn}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_dtn}    Chi nhánh trung tâm
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
    ${get_quy_dau_ky_dtn}    ${get_tong_thu_dtn}    ${get_tong_chi_dtn}    ${get_ton_quy_dtn}    Get balance in So quy Tien mat for other branch    ${get_branch_id_dtn}
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_dtn}    ${result_quy_dau_ky_dtn}
    Should Be Equal As Numbers    ${get_tong_thu_dtn}    ${result_tong_thu_dtn}
    Should Be Equal As Numbers    ${get_tong_chi_dtn}    ${result_tong_chi_dtn}
    Should Be Equal As Numbers    ${get_ton_quy_dtn}    ${result_ton_quy_dtn}
    #Delete payment frm API    ${ma_phieu}

cqnb_chi
    [Arguments]    ${loai_chi}    ${gia_tri}    ${input_doituong_nop}    ${input_ten_nguoi_nop}    ${hachtoan}    ${cashflow_type}
    ${get_branch_id_dtn}    Get BranchID by BranchName    ${input_doituong_nop}
    ${result_quy_dau_ky_dtn}    ${result_tong_thu_dtn}    ${result_tong_chi_dtn}    ${result_ton_quy_dtn}    Compute balance in tab Tien mat with other branch    ${get_branch_id_dtn}
    ...    ${gia_tri}    ${cashflow_type}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add payment    ${gia_tri}
    ${result_giatri}    Minus   0      ${gia_tri}
    ${ma_phieu}    Generate code automatically    CTM
    ${get_id_nguoiban}    Get User ID
    ${get_hachtoan}   Set Variable If    '${hachtoan}' == 'yes'    true     false
    ${result_giatri}    Minus     0      ${gia_tri}
    ${data_str}      Format String     {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"UsedPaymentForInvoiceOrReturn":true,"PartnerType":"H","PaymentMethod":"Cash","CashFlowType":2,"PartnerId":{2},"Code":"{3}","PairedBranchId":{4},"PartnerName":"anh.lv","CashFlowGroupId":null,"AccountId":null,"BranchId":{5}}},"ComparePartnerName":"","CashflowGroupName":"Chuyển quỹ nội bộ","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"Khác","PartnerName":"anh.lv"}}      ${result_giatri}      ${get_hachtoan}
    ...    ${get_id_nguoiban}    ${ma_phieu}    ${get_branch_id_dtn}    ${BRANCH_ID}
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
    ${gia_tri}    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển quĩ nội bộ
    Should Be Equal As Strings    ${get_ten}    ${input_ten_nguoi_nop}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_doituong_nop}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    #validate chi tiet phieu tu dong
    ${get_gia_tri_dtn}    ${get_loai_thu_chi_dtn}    ${get_ten_dtn}    ${get_trang_thai_dtn}    ${get_doituongnop_dtn}    ${get_hachtoan_dtn}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    Should Be Equal As Numbers    ${get_gia_tri_dtn}    ${get_gia_tri_dtn}
    Should Be Equal As Strings    ${get_loai_thu_chi_dtn}    Chuyển quĩ nội bộ
    Should Be Equal As Strings    ${get_ten_dtn}    ${input_ten_nguoi_nop}
    Should Be Equal As Strings    ${get_trang_thai_dtn}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_dtn}    Chi nhánh trung tâm
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan_dtn}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan_dtn}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Log     Validate ton quy tu dong
    #validate ton quy cua phieu tu dong
    ${get_quy_dau_ky_dtn}    ${get_tong_thu_dtn}    ${get_tong_chi_dtn}    ${get_ton_quy_dtn}    Get balance in So quy Tien mat for other branch    ${get_branch_id_dtn}
    ${get_ton_quy_dtn}    Evaluate    round(${get_ton_quy_dtn}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_dtn}    ${result_quy_dau_ky_dtn}
    Should Be Equal As Numbers    ${get_tong_thu_dtn}    ${result_tong_thu_dtn}
    Should Be Equal As Numbers    ${get_tong_chi_dtn}    ${result_tong_chi_dtn}
    Should Be Equal As Numbers    ${get_ton_quy_dtn}    ${result_ton_quy_dtn}
    Delete payment frm API    ${ma_phieu}
