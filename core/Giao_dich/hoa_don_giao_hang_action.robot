*** Settings ***
Resource          hoa_don_giao_hang_page.robot
Library           SeleniumLibrary
Library           StringFormat
Resource          hoa_don_list_page.robot
Resource          hoa_don_list_action.robot

*** Keywords ***
Update invoice delivery with textbox field
    [Arguments]    ${input_change}    ${input_value}
    ${ten_field_change}    Format String    ${textbox_giaohang_hd}    ${input_change}
    Input Text    ${ten_field_change}    ${input_value}

Update dia chi frm invoice delivery
    [Arguments]    ${input_value}
    ${diachi_field_change}    Format String    ${textbox_diachi_hd}    Địa chỉ
    Input Text    ${diachi_field_change}    ${input_value}

Update nguoi giao frm invoice delivery
    [Arguments]    ${input_change_value}
    Click Element JS    ${icon_select_nguoigiao}
    ${nguoi_giao}    Format String    ${item_nguoigiao}    ${input_change_value}
    Wait Until Element Is Visible    ${nguoi_giao}
    Click Element JS    ${nguoi_giao}

Select to hoa don
    [Arguments]    ${input_ma_hd}
    ${hoa_don}    Format String    ${select_hoadon}    ${input_ma_hd}
    Wait Until Element Is Visible    ${hoa_don}
    Click Element JS    ${hoa_don}

Update khu vuc frm invoice delivery
    [Arguments]    ${input_khuvuc}
    Click Element JS    ${dropdownlist_Khuvuc_hd}
    Input Text    ${dropdownlist_Khuvuc_hd}    Hà Nội
    ${khu_vuc}    Format String    ${item_khuvuc_hd}    ${input_khuvuc}
    Wait Until Element Is Visible    ${khu_vuc}
    Click Element JS    ${khu_vuc}

Update phuong xa frm invoice delivery
    [Arguments]    ${input_phuongxa}
    Click Element JS    ${dropdowlist_Phuongxa_hd}
    Input Text    ${dropdowlist_Phuongxa_hd}    Phường
    ${phuong_xa}    Format String    ${item_phuongxa_hd}    ${input_phuongxa}
    Wait Until Element Is Visible    ${phuong_xa}
    Click Element JS    ${phuong_xa}

Update trang thai giao hang frm invoice delivery
    [Arguments]    ${input_change_value}
    Click Element JS    ${icon_select_trangthai_gh}
    ${trangthai_gh}    Format String    ${item_ttgh_hd}    ${input_change_value}
    Wait Until Element Is Visible    ${trangthai_gh}
    Click Element JS    ${trangthai_gh}

Update kich thuoc frm invoice delivery
    [Arguments]    ${input_change}    ${input_value}
    ${kichthuoc_field_change}    Format String    ${textbox_kichthuoc_hd}    ${input_change}
    Input Text    ${kichthuoc_field_change}    ${input_value}

Get trong luong phi giao hang frm invoice UI
    [Arguments]    ${input_change}
    ${trongluong_field_change}    Format String    ${textbox_giaohang_hd}    Trọng lượng
    Log    ${trongluong_field_change}
    ${get_trongluong}    Get Text    ${trongluong_field_change}
    ${phi_gh_field_change}    Format String    ${textbox_giaohang_hd}    Phí giao hàng
    Log    ${phi_gh_field_change}
    ${get_phi_gh}    Get Text    ${phi_gh_field_change}
    Return From Keyword    ${get_trongluong}    ${get_phi_gh}

Get kich thuoc frm invoice UI
    [Arguments]    ${input_change}
    ${kichthuoc_field_change}    Format String    ${textbox_kichthuoc_hd}    ${input_change}
    ${get_kichthuoc}    Get Text    ${kichthuoc_field_change}
    Return From Keyword    ${get_kichthuoc}

Get dia chi frm invoice UI
    [Arguments]    ${input_change}
    ${diachi_change}    Format String    ${textbox_diachi_hd}    ${input_change}
    ${get_diachi}    Get Text    ${diachi_change}
    Return From Keyword    ${get_diachi}

Update time giao hang frm invoice delivery
    [Arguments]    ${input_value}
    ${time_gh_field_change}    Format String    ${textbox_time_gh_hd}    Thời gian giao hàng
    Input Text    ${time_gh_field_change}    ${input_value}

Check disable of all field in invoice delivery
    ${textbox_nguoinhan}    Format String    ${textbox_giaohang_hd}    Người nhận
    Element Should Be Disabled    ${textbox_nguoinhan}
    ${textbox_dienthoai}    Format String    ${textbox_giaohang_hd}    Điện thoại
    Element Should Be Disabled    ${textbox_dienthoai}
    Element Should Be Disabled    ${textbox_diachi_hd}
    Element Should Be Disabled    ${dropdownlist_Khuvuc_hd}
    Element Should Be Disabled    ${dropdowlist_Phuongxa_hd}
    Element Should Be Disabled    ${icon_select_nguoigiao}
    ${textbox_mavandon_hd}    Format String    ${textbox_giaohang_hd}    Mã vận đơn
    Element Should Be Disabled    ${textbox_mavandon_hd}
    Element Should Be Disabled    ${icon_select_trangthai_gh}
    ${textbox_trongluong_hd}    Format String    ${textbox_giaohang_hd}    Trọng lượng
    Element Should Be Disabled    ${textbox_trongluong_hd}
    ${textbox_kichthuoc_dai}    Format String    ${textbox_kichthuoc_hd}    Kích thước
    Element Should Be Disabled    ${textbox_kichthuoc_dai}
    ${textbox_kichthuoc_rong}    Format String    ${textbox_kichthuoc_hd}    Kích thước
    Element Should Be Disabled    ${textbox_kichthuoc_rong}
    ${textbox_kichthuoc_cao}    Format String    ${textbox_kichthuoc_hd}    Kích thước
    Element Should Be Disabled    ${textbox_kichthuoc_cao}
    ${textbox_phi_gh_hd}    Format String    ${textbox_giaohang_hd}    Phí giao hàng
    Element Should Be Disabled    ${textbox_phi_gh_hd}
    Element Should Be Disabled    ${textbox_time_gh_hd}

Select delivery status in filter
    ${select_trangthai_gh}    Format String    ${select_trangthai_gh}    Không giao được
    Click Element JS    ${select_trangthai_gh}

