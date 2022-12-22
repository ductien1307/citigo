*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/soquy.robot

*** Test Cases ***    Mã đối tác          Loại thu chi    Giá trị    Ghi chú     Phương thức    TKNH
KH - thu NH           [Tags]              SQA
                      [Template]          kh_thu_nh
                      CTKH001             Thu 1           80000      thu tiền    Card           1234
                      CTKH002             Thu 2           65000      thu tiền    Transfer       2134

KH - chi NH           [Tags]              SQA
                      [Template]          kh_chi_nh
                      CTKH003             Thu 3           35000      chi tiền    Card           1234
                      CTKH004             Thu 4           50000      chi tiền    Transfer       3325

Khac - thu NH         [Tags]              SQA
                      [Template]          khac_thu_nh
                      Nguyễn Văn An       Thu 1           50000      thu tiền    Card           1234    true
                      Phạm Phương Thảo    Thu 2           75000      thu tiền    Transfer       2134    true
                      Phạm Phương Thảo    Thu 1           65000      thu tiền    Transfer       3325    false
                      Nguyễn Văn An       Thu 2           35000      thu tiền    Card           1234    false

Khac - chi NH         [Tags]              SQA
                      [Template]          khac_chi_nh
                      Nguyễn Văn An       Chi 1           50000      chi tiền    Card           1234    true
                      Phạm Phương Thảo    Chi 2           75000      chi tiền    Transfer       2134    true
                      Phạm Phương Thảo    Chi 3           65000      chi tiền    Transfer       3325    false
                      Nguyễn Văn An       Chi 2           35000      chi tiền    Card           1234    false

Nhan vien - thu NH    [Tags]              SQA
                      [Template]          nv_thu_nh
                      Đỗ Xuân Sơn         Thu 1           50000      thu tiền    Card           1234    true
                      Nguyễn Thị An       Thu 2           75000      thu tiền    Transfer       2134    true
                      Đỗ Xuân Sơn         Thu 3           65000      thu tiền    Transfer       3325    false
                      Nguyễn Thị An       Thu 2           35000      thu tiền    Card           1234    false

Nhan vien - chi NH    [Tags]              SQA
                      [Template]          nv_chi_nh
                      Đỗ Xuân Sơn         Chi 1           50000      chi tiền    Card           1234    true
                      Nguyễn Thị An       Chi 2           475000     chi tiền    Transfer       2134    true
                      Đỗ Xuân Sơn         Chi 3           650000     chi tiền    Transfer       3325    false
                      Nguyễn Thị An       Chi 4           35000      chi tiền    Card           1234    false

*** Keywords ***
kh_thu_nh
    [Arguments]    ${ma_kh}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for customer and not used for financial reporting    ${ma_kh}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}
    Sleep    5s
    #validate chi tiet phieu
    ${ten_kh}    Get customer name frm API    ${ma_kh}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_kh}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail for customer not used for financial reporting    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
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

kh_chi_nh
    [Arguments]    ${ma_kh}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for customer and not used for financial reporting    ${ma_kh}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}
    Sleep    5s
    #validate chi tiet phieu
    ${ten_kh}    Get customer name frm API    ${ma_kh}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_kh}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail for customer not used for financial reporting    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    #validate tab cong no
    ${get_no}    Get customer debt after cash flow    ${ma_kh}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_no}    ${gia_tri}
    Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}

khac_thu_nh
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for other    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}    ${hach_toan}
    Sleep    5s
    #validate chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nop}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

khac_chi_nh
    [Arguments]    ${ten_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for other    ${ten_nguoi_nhan}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}    ${hach_toan}
    Sleep    5s
    #validate chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

nv_thu_nh
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add receipt    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for employee    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}    ${hach_toan}
    Sleep    5s
    #validate chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nop}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}

nv_chi_nh
    [Arguments]    ${ten_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Ngan hang af add payment    ${gia_tri}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    ${ma_phieu}    Add cash flow in tab Ngan hang for employee    ${ten_nguoi_nhan}    ${loai_chi}    ${result_gia_tri}    ${ghi_chu}    ${phuong_thuc}
    ...    ${tk_nh}    ${hach_toan}
    Sleep    5s
    #validate chi tiet phieu
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuong_thuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    ${phuong_thuc}
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='true'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Delete payment frm API    ${ma_phieu}
