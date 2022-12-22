*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/soquy.robot

*** Test Cases ***    Mã đối tác          Loại thu chi    Giá trị    Ghi chú
KH - ko ht - thu TM
                      [Tags]              SQA
                      [Template]          kh_thu_tm
                      CTKH005             Thu 1           15000      thu tiền

KH - ko ht - chi TM
                      [Tags]              SQA
                      [Template]          kh_chi_tm
                      CTKH006             Chi 2           95000      chi tiền

Khac - thu TM         [Tags]              SQA
                      [Template]          khac_thu_tm
                      Nguyễn Văn An       Thu 2           65200      thu tiền    true
                      Phạm Phương Thảo    Thu 1           65000      thu tiền    false

Khac - chi TM         [Tags]              SQA
                      [Template]          khac_chi_tm
                      Nguyễn Văn An       Chi 1           65200      chi tiền    true
                      Phạm Phương Thảo    Chi 2           458000     chi tiền    false

Nhan vien - thu TM    [Tags]              SQA
                      [Template]          nv_thu_tm
                      Đỗ Xuân Sơn         Thu 2           65200      thu tiền    true
                      Nguyễn Thị An       Thu 1           125000     thu tiền    false

Nhan vien -chi TM     [Tags]              SQA
                      [Template]          nv_chi_tm
                      Đỗ Xuân Sơn         Chi 1           65200      chi tiền    true
                      Nguyễn Thị An       Chi 2           112000     chi tiền    false

*** Keywords ***
kh_thu_tm
    [Arguments]    ${ma_kh}    ${loai_thu}    ${gia_tri}    ${ghi_chu}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${ma_kh}    ${loai_thu}    ${gia_tri}    ${ghi_chu}
    Sleep    5s
    #validate thong tin cb va chi tiet phieu
    ${ten_kh}    Get customer name frm API    ${ma_kh}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_kh}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail for customer not used for financial reporting    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    #validate tab cong no
    ${get_no}    Get customer debt after cash flow    ${ma_kh}    ${ma_phieu}
    ${get_no}    Minus    0    ${get_no}
    Should Be Equal As Numbers    ${get_no}    ${gia_tri}
    Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}

kh_chi_tm
    [Arguments]    ${ma_kh}    ${loai_chi}    ${gia_tri}    ${ghi_chu}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${ma_kh}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}
    Sleep    5s
    #validate thong tin, chi tiet phieu
    ${ten_nguoi_nhan}    Get customer name frm API    ${ma_kh}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail for customer not used for financial reporting    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    #validate tab cong no
    ${get_no}    Get customer debt after cash flow    ${ma_kh}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_no}    ${gia_tri}
    Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}

khac_thu_tm
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for other    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    Sleep    5s
    #validate thong tin cb va chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nop}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hach_toan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

khac_chi_tm
    [Arguments]    ${ten_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for other    ${ten_nguoi_nhan}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}    ${hach_toan}
    Sleep    5s
    #validate thong tin, chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hach_toan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

nv_thu_tm
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for employee    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    Sleep    5s
    #validate thong tin cb va chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nop}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hach_toan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

nv_chi_tm
    [Arguments]    ${ten_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Tien mat for employee    ${ten_nguoi_nhan}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}    ${hach_toan}
    Sleep    5s
    #validate thong tin, chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hach_toan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}
