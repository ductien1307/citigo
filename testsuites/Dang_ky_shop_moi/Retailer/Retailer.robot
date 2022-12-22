*** Settings ***
Test Setup        Before Test Dang Ky Shop Moi    ${remote}
Test Teardown     After Test
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Dang_ky_moi/dangkymoi_action.robot
Resource          ../../../config/envi.robot
Resource          kw_dky.robot

*** Variables ***
&{invoice_1}      SP000023=1    SP000025=2
@{discount_type_1}    dis    changeup
@{discount_1}     10    150000

*** Test Cases ***    Ngành hàng    Tên dky    Sdt           Tên dn    Mật khẩu    Phường xã       Địa chỉ    SP-SL           Discount         Discount type         GGHD    Mã kh       Khách tt
Tao moi shop          [Tags]        ANR        AN
                      [Template]    eds
                      Tạp hóa       Huyền      0123456789    admin     123         Quận Ba Đình    Hà Nội     ${invoice_1}    ${discount_1}    ${discount_type_1}    10      KH0003      50000

*** Keyword ***
