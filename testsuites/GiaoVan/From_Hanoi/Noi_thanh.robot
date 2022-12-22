*** Settings ***
Suite Setup
Test Setup        Before Test Giao Van
Test Teardown     After Test
Resource          ../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../../../core/share/util_giaovan.robot
Resource          ../../../config/Env_9k7/element_access_page.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_Van/giaovan_price.robot

*** Test Cases ***    Ten           SDT                                                  Dia chi       Khu vuc                       Phuong xa                 Trong luong    L     W     H
Noi thanh voi trong luong va kich thuoc chuan
                      [Template]    Basic input to noi thanh
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Ba Đình         Phường Điện Biên          500
                      Ms Lô Lô      45662                                                Ngách 3899    Hà Nội - Quận Cầu Giấy        Phường Dịch Vọng          2000
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Đống Đa         Phường Ngã Tư Sở          500
                      Ms Lô Lô      45662                                                Ngách 3899    Hà Nội - Quận Hai Bà Trưng    Phường Bách Khoa          500
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Hoàn Kiếm       Phường Chương Dương Độ    5000
                      Ms Lô Lô      45662                                                Ngách 3899    Hà Nội - Quận Hoàng Mai       Phường Đại Kim            500
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Tây Hồ          Phường Nhật Tân           500
                      Ms Lô Lô      45662                                                Ngách 3899    Hà Nội - Quận Thanh Xuân      Phường Phương Liệt        500

Ngoai thanh 1 voi trong luong va kich thuoc chuan
                      [Template]    Basic input to ngoai thanh 1
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Hà Đông         Phường Đồng Mai           500
                      Ms La la      45662                                                Ngách 3899    Hà Nội - Quận Bắc Từ Liêm     Phường Đông Ngạc          500

Ngoai thanh 2 voi trong luong va kich thuoc chuan
                      [Template]    Basic input to ngoai thanh 2
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Huyện Đông Anh       Thị trấn Đông Anh         4000

Noi thanh voi trong luong tinh phi
                      [Template]    Input to noi thanh if having trong luong tinh phi
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Quận Đống Đa         Phường Ngã Tư Sở          30000          50    50    50
                      Ms Lô Lô      45662                                                Ngách 3899    Hà Nội - Quận Hai Bà Trưng    Phường Bách Khoa          5000           50    50    50

Noi vung voi trong luong va kich thuoc chuan
                      [Template]    Basic input to noi vung
                      Ms Lô Lô      789                                                  ngõ 9         Hà Nội - Huyện Đông Anh       Thị trấn Đông Anh         4000

*** Keywords ***
Basic input to noi thanh
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    [Timeout]    2 minutes
    Input mandatory fields in Giao Hang form    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ${get_tongphi_chuan}    Get tong phi Dich vu chuan
    Should Be Equal    ${get_tongphi_chuan}    20,900
    [Teardown]

Basic input to ngoai thanh 1
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    Input mandatory fields in Giao Hang form    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ${get_tongphi_chuan}    Get tong phi Dich vu chuan
    Should Be Equal    ${get_tongphi_chuan}    31,900
    [Teardown]

Basic input to ngoai thanh 2
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    Input mandatory fields in Giao Hang form    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ${get_tongphi_chuan}    Get tong phi Dich vu chuan
    Should Be Equal    ${get_tongphi_chuan}    42,900
    [Teardown]

Input to noi thanh if having trong luong tinh phi
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ...    ${input_length}    ${input_w}    ${input_h}
    [Timeout]    2 minutes
    Input data incl kich thuoc    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ...    ${input_length}    ${input_w}    ${input_h}
    ${result_tongphi_chuan}    Price after VAT    ${tuyen_noitinh_noithanh}
    ${get_tongphi_chuan}    Get tong phi Dich vu chuan
    ${get_tongphi_chuan}    Convert Any To Number    ${get_tongphi_chuan}
    ###
    ${klqd}    Replace String    ${input_trongluong}    000    ${EMPTY}
    ${klqd}    Convert Any To Number    ${klqd}
    ${klqd_theo_trong_luong}    Tinh phi theo trong luong    ${input_length}    ${input_w}    ${input_h}
    Run Keyword If    '${klqd}' > '${klqd_theo_trong_luong}'    Assert cost if weight is greater than converted weight    ${klqd}    ${input_trongluong}    ${get_tongphi_chuan}
    ...    ELSE    Assert cost if weight is lower than converted weight    ${klqd_theo_trong_luong}    ${get_tongphi_chuan}
    [Teardown]

Basic input to noi vung
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    Input mandatory fields in Giao Hang form    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ${get_tongphi_chuan}    Get tong phi Dich vu chuan
    Should Be Equal    ${get_tongphi_chuan}    42,900
    [Teardown]
