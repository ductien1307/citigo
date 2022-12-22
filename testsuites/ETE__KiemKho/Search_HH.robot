*** Settings ***
Library           SeleniumLibrary
Suite Setup       Init Test Environment Before Test Quản Lý Có API    ${env}    ${remote}    ${account}    ${headless_browser}
Suite Teardown    Close Browser
Test Timeout      3 minutes
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/QLKV/qlkv_list_action.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
*** Variables ***
*** Test Cases ***
Search   [Tags]           CTP
         [Documentation]  ELASTIC SEARCH - MHQL - TÌM KIẾM HÀNG HÓA THƯỜNG THEO TÊN VÀ THEO MÃ TẠI KIỂM KHO
         [template]       Search Hàng Hóa Thường Theo Tên Và Theo Mã
         CodeAutoKiemKho111   Auto HangHoaThuongKiemKho   AutoKiemKho1   20000    30000    30

Search   [Tags]           CTP
         [Documentation]  ELASTIC SEARCH - MHQL - TÌM KIẾM HÀNG HÓA CÓ ĐƠN VỊ TÍNH THEO TÊN VÀ THEO MÃ VÀ THEO MÃ ĐVT TẠI KIỂM KHO
         [template]       Search Hàng Hóa ĐVT Theo Tên Và Theo Mã Và Theo Mã ĐVT
         CodeDVTAuto1   Auto HHDVTKiemKho   20000   30000   30   Chiếc   Lốc   3   90000   CodeDVTAuto2  AutoKiemKho2

Search   [Tags]           CTP
         [Documentation]  ELASTIC SEARCH - MHQL - TÌM KIẾM HÀNG HÓA SẢN XUẤT THEO TÊN VÀ THEO MÃ TẠI KIỂM KHO
         [template]       Search Hàng Hóa Sản Xuất Theo Tên Và Theo Mã
         CodeSanXuatAuto1   Auto HHSanXuatKiemKho   200000   30  AutoKiemKho3

Search   [Tags]           CTP
         [Documentation]  ELASTIC SEARCH - MHQL - TÌM KIẾM HÀNG HÓA IMEI HOẶC LÔ DATE TẠI KIỂM KHO
         [template]       Search Hàng Hóa IMEI Hoặc Lô Date Theo Tên Và Theo Mã
         AutoAuto111  AutoKiemKho4

*** Keywords ***
Search Hàng Hóa Thường Theo Tên Và Theo Mã
      [Arguments]  ${code_hh}  ${ten_hh}  ${ten_nhomhang}  ${gia_ban}  ${gia_von}  ${ton_kho}
      ${id_product}  Get product ID    ${code_hh}
      Run Keyword If    '${id_product}' != '0'    Delete product thr API    ${code_hh}
      ${id_category}  Get category ID    ${ten_nhomhang}
      Run Keyword If    '${id_category}' != '0'    Delete category thr API    ${ten_nhomhang}
      Add categories thr API    ${ten_nhomhang}
      Add product and wait    ${code_hh}    ${ten_hh}    ${ten_nhomhang}    ${gia_ban}    ${gia_von}    ${ton_kho}
      Go To Kiểm Kho
      Click To Kiểm Kho Button
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${ten_hh}
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${code_hh}
      Set Suite Variable    ${code_hh_thuong}    ${code_hh}
      Set Suite Variable    ${nhomhang_hh_thuong}    ${ten_nhomhang}

Search Hàng Hóa ĐVT Theo Tên Và Theo Mã Và Theo Mã ĐVT
      [Arguments]  ${code_hh}  ${ten_hh}  ${gia_ban}  ${gia_von}  ${ton_kho}   ${don_vi_cb}  ${ten_don_vi}  ${giatri_quydoi}  ${gia_ban_dvt}  ${code_hh_dvt}  ${ten_nhomhang}
      ${id_product}  Get product ID    ${code_hh}
      Run Keyword If    '${id_product}' != '0'    Delete product thr API    ${code_hh}
      ${id_category}  Get category ID    ${ten_nhomhang}
      Run Keyword If    '${id_category}' != '0'    Delete category thr API    ${ten_nhomhang}
      Add categories thr API    ${ten_nhomhang}
      Add product incl 1 unit thrAPI    ${code_hh}    ${ten_hh}    ${ten_nhomhang}    ${gia_ban}    ${gia_von}    ${ton_kho}    ${don_vi_cb}    ${ten_don_vi}    ${giatri_quydoi}    ${gia_ban_dvt}    ${code_hh_dvt}
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${ten_hh}
      Wait Until Element Is Visible    //span[text()='${don_vi_cb}']  10s
      Search Text Global With Each Letter  ${code_hh}
      Wait Until Element Is Visible    //p[text()='${ten_hh} ']   10s
      Wait Until Element Is Visible    //span[text()='${don_vi_cb}']  10s
      Search Text Global With Each Letter  ${code_hh_dvt}
      Wait Until Element Is Visible    //p[text()='${ten_hh} ']   10s
      Wait Until Element Is Visible    //span[text()='${ten_don_vi}']  10s
      Set Suite Variable    ${code_hh_DVT}    ${code_hh}
      Set Suite Variable    ${nhomhang_hh_dvt}    ${ten_nhomhang}

Search Hàng Hóa Sản Xuất Theo Tên Và Theo Mã
      [Arguments]  ${code_hh}  ${ten_hh}  ${gia_ban}  ${ton_kho}  ${ten_nhomhang}
      ${id_product}  Get product ID    ${code_hh}
      Run Keyword If    '${id_product}' != '0'    Delete product thr API    ${code_hh}
      ${id_category}  Get category ID    ${ten_nhomhang}
      Run Keyword If    '${id_category}' != '0'    Delete category thr API    ${ten_nhomhang}
      Add categories thr API    ${ten_nhomhang}
      Add product manufacturing    ${code_hh}    ${ten_hh}    ${ten_nhomhang}    ${gia_ban}    ${ton_kho}    ${code_hh_thuong}    1    ${code_hh_DVT}    1
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${ten_hh}
      Search Text Global With Each Letter  ${code_hh}
      Wait Until Element Is Visible    //p[text()=' ${code_hh} ']   10s
      Delete product thr API    ${code_hh}
      Delete product thr API    ${code_hh_thuong}
      Delete product thr API    ${code_hh_DVT}
      Delete category thr API   ${ten_nhomhang}
      Delete category thr API   ${nhomhang_hh_dvt}
      Delete category thr API   ${nhomhang_hh_thuong}

Search Hàng Hóa Lô Date Theo Tên Và Theo Mã
      [Arguments]  ${code_hh}  ${ten_hh}  ${gia_ban}  ${gia_nhap}  ${sum_soluong}  ${ten_lo}  ${ten_nhomhang}
      ${id_product}  Get product ID    ${code_hh}
      Run Keyword If    '${id_product}' != '0'    Delete product thr API    ${code_hh}
      ${id_category}  Get category ID    ${ten_nhomhang}
      Run Keyword If    '${id_category}' != '0'    Delete category thr API    ${ten_nhomhang}
      Add categories thr API    ${ten_nhomhang}
      create hh lodate    ${code_hh}    ${ten_hh}    ${ten_nhomhang}    ${gia_ban}    ${gia_nhap}    ${sum_soluong}    ${ten_lo}
      Go To Kiểm Kho
      Click To Kiểm Kho Button
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${ten_hh}
      Search Text Global With Each Letter  ${code_hh}
      Wait Until Element Is Visible    //p[text()=' ${code_hh} ']   10s
      Delete product thr API    ${code_hh}
      Delete category thr API   ${ten_nhomhang}

Search Hàng Hóa IMEI Theo Tên Và Theo Mã
      [Arguments]  ${code_hh}  ${ten_hh}  ${gia_ban}  ${gia_nhap}  ${serialnums}  ${ten_nhomhang}
      ${id_product}  Get product ID    ${code_hh}
      Run Keyword If    '${id_product}' != '0'    Delete product thr API    ${code_hh}
      ${id_category}  Get category ID    ${ten_nhomhang}
      Run Keyword If    '${id_category}' != '0'    Delete category thr API    ${ten_nhomhang}
      Add categories thr API    ${ten_nhomhang}
      create serial in live env   ${code_hh}  ${ten_hh}  ${ten_nhomhang}  ${gia_ban}  ${gia_nhap}  ${serialnums}  1
      Go To Kiểm Kho
      Click To Kiểm Kho Button
      Wait Until Keyword Succeeds    3x    5s    Search Text Kiểm Kho    ${ten_hh}
      Search Text Global With Each Letter  ${code_hh}
      Wait Until Element Is Visible    //p[text()=' ${code_hh} ']   10s
      Delete product thr API    ${code_hh}
      Delete category thr API   ${ten_nhomhang}

Search Hàng Hóa IMEI Hoặc Lô Date Theo Tên Và Theo Mã
      [Arguments]  ${code_hh}  ${ten_nhomhang}
      Go To Thiết Lập Cửa Hàng
      ${countElemet}   Get Element Count    //h3[text()='Quản lý tồn kho theo Serial/IMEI']
      Run Keyword If    ${countElemet}==1    Search Hàng Hóa IMEI Theo Tên Và Theo Mã    ${code_hh}    AutoEmei111    100000    50000    Auto69  ${ten_nhomhang}  ELSE  Search Hàng Hóa Lô Date Theo Tên Và Theo Mã    ${code_hh}    Auto Lô Date    100000    50000    5    AutoLo  ${ten_nhomhang}

Search Text Kiểm Kho
      [Arguments]  ${text_search}
      Search Text Global With Each Letter  ${text_search}
      Wait Until Element Is Visible    //p[contains(text(),'${text_search}')]   30s
