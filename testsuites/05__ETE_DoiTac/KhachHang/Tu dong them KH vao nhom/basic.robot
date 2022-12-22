*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_trahang.robot

*** Variables ***
&{invoice}    	GHDT011=3
&{return}       GHDT012=2

*** Test Cases ***    Nhóm KH              Thiết lập            So sánh   Giá trị           Option                                    Auto     Mã KH       Invoice        Return       khtt
Thêm mới nhóm KH      [Tags]        TNKH
                      [Template]    nkh1
                      [Documentation]     Tự động thêm khách hàng vao nhóm thỏa mãn điều kiện
                      Nhóm test 1     Tống bán (trừ trả hàng)      >       300000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD001    ${invoice}      ${return}     all
                      Nhóm test 2     Tống bán (trừ trả hàng)      >       300000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD002    ${invoice}      ${return}     all
                      Nhóm test 3     Tống bán (trừ trả hàng)      >       300000       Cập nhật lại danh sách theo điều kiện        true      KHTD003    ${invoice}      ${return}     all
                      #Nhóm test 4     Tống bán (trừ trả hàng)      >       300000       Cập nhật lại danh sách theo điều kiện        false     KHTD004    ${invoice}      ${return}     all
                      #Nhóm test 5     Tống bán (trừ trả hàng)      >       300000       Không cập nhật danh sách khách hàng          false     KHTD005    ${invoice}      ${return}     all
                      #Nhóm test 6     Tổng bán                     >       200000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD006    ${invoice}      ${return}     all
                      Nhóm test 7     Tổng bán                     >       200000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD007    ${invoice}      ${return}     all
                      Nhóm test 8     Tổng bán                     >       200000       Cập nhật lại danh sách theo điều kiện        true      KHTD008    ${invoice}      ${return}     all
                      Nhóm test 9     Tổng bán                     >       200000       Cập nhật lại danh sách theo điều kiện        false     KHTD009    ${invoice}      ${return}     all
                      #Nhóm test 10    Tổng bán                     >       200000       Không cập nhật danh sách khách hàng          false     KHTD010    ${invoice}      ${return}     all
                      Nhóm test 11    Công nợ hiện tại             >       200000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD001    ${invoice}      ${return}     150000
                      Nhóm test 12    Công nợ hiện tại             >       200000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD002    ${invoice}      ${return}     150000
                      #Nhóm test 13    Công nợ hiện tại             >       200000       Cập nhật lại danh sách theo điều kiện        true      KHTD003    ${invoice}      ${return}     150000
                      #Nhóm test 14    Công nợ hiện tại             >       200000       Cập nhật lại danh sách theo điều kiện        false     KHTD004    ${invoice}      ${return}     150000
                      #Nhóm test 15    Công nợ hiện tại             >       200000       Không cập nhật danh sách khách hàng          false     KHTD005    ${invoice}      ${return}     150000

Cập nhật nhóm KH      [Tags]      TNKH
                      [Template]    nkh2
                      Nhóm test 1     Tống bán (trừ trả hàng)      >       300000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD001    ${invoice}      ${return}     all
                      Nhóm test 2     Tống bán (trừ trả hàng)      >       300000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD002    ${invoice}      ${return}     all
                      Nhóm test 3     Tống bán (trừ trả hàng)      >       300000       Cập nhật lại danh sách theo điều kiện        true      KHTD003    ${invoice}      ${return}     all
                      #Nhóm test 4     Tống bán (trừ trả hàng)      >       300000       Cập nhật lại danh sách theo điều kiện        false     KHTD004    ${invoice}      ${return}     all
                      #Nhóm test 5     Tống bán (trừ trả hàng)      >       300000       Không cập nhật danh sách khách hàng          false     KHTD005    ${invoice}      ${return}     all
                      Nhóm test 6     Tổng bán                     >       200000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD006    ${invoice}      ${return}     all
                      Nhóm test 7     Tổng bán                     >       200000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD007    ${invoice}      ${return}     all
                      Nhóm test 8     Tổng bán                     >       200000       Cập nhật lại danh sách theo điều kiện        true      KHTD008    ${invoice}      ${return}     all
                      #Nhóm test 9     Tổng bán                     >       200000       Cập nhật lại danh sách theo điều kiện        false     KHTD009    ${invoice}      ${return}     all
                      #Nhóm test 10    Tổng bán                     >       200000       Không cập nhật danh sách khách hàng          false     KHTD010    ${invoice}      ${return}     all
                      Nhóm test 11    Công nợ hiện tại             >       200000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD001    ${invoice}      ${return}     150000
                      Nhóm test 12    Công nợ hiện tại             >       200000       Thêm khách hàng vào nhóm theo điều kiện      false     KHTD002    ${invoice}      ${return}     150000
                      Nhóm test 13    Công nợ hiện tại             >       200000       Cập nhật lại danh sách theo điều kiện        true      KHTD003    ${invoice}      ${return}     150000
                      #Nhóm test 14    Công nợ hiện tại             >       200000       Cập nhật lại danh sách theo điều kiện        false     KHTD004    ${invoice}      ${return}     150000
                      #Nhóm test 15    Công nợ hiện tại             >       200000       Không cập nhật danh sách khách hàng          false     KHTD005    ${invoice}      ${return}     150000

Thêm mới nhóm KH      [Tags]        CTP
                      [Template]    nkh1
                      [Documentation]     Tự động thêm khách hàng vao nhóm thỏa mãn điều kiện
                      Nhóm test 1     Tống bán (trừ trả hàng)      >       300000       Thêm khách hàng vào nhóm theo điều kiện      true      KHTD001    ${invoice}      ${return}     all

*** Keywords ***
nkh1
    [Arguments]   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}   ${ma_kh}    ${dict_invoice}     ${dict_return}    ${input_khtt}
    Log    prepare
    Delete customer if it exists    ${ma_kh}
    Delete customer group if it exists    ${input_ten_nhom}
    ${actual_so_sanh}    Set Variable If    '${input_so_sanh}'=='='    ==    ${input_so_sanh}
    #
    Log    action
    Add customers without contact number    ${ma_kh}    abcd
    :FOR    ${time}     IN RANGE   2
    \   ${invoice_code}     Add new invoice frm API    ${ma_kh}    ${dict_invoice}    ${input_khtt}
    Add new return with customer    ${ma_kh}    ${dict_return}    ${input_khtt}
    Add new group customer by the condition   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}
    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}     Get Customer Debt from API    ${ma_kh}
    ${actual_dieu_kien}     Run Keyword If    '${input_dieu_kien}'=='Tổng bán'    Set Variable    ${get_tongban}      ELSE IF   '${input_dieu_kien}'=='Công nợ hiện tại'    Set Variable    ${get_no}    ELSE    Set Variable    ${get_tongban_tru_trahang}
    ${get_nhom_kh}      Get group of customer thr API    ${ma_kh}
    Run Keyword If      ${actual_dieu_kien} ${actual_so_sanh} ${input_gia_tri} and '${input_dieu_kien}'!='Không cập nhật danh sách khách hàng'       Should Contain           ${get_nhom_kh}    ${input_ten_nhom}       ELSE     Should Not Contain          ${get_nhom_kh}    ${input_ten_nhom}
    #
    Delete invoice by invoice code    ${invoice_code}
    ${get_no_af}    ${get_tongban_af}    ${get_tongban_tru_trahang_af}     Get Customer Debt from API    ${ma_kh}
    ${actual_dieu_kien_af}     Run Keyword If    '${input_dieu_kien}'=='Tổng bán'    Set Variable    ${get_tongban_af}      ELSE IF   '${input_dieu_kien}'=='Công nợ hiện tại'    Set Variable    ${get_no_af}    ELSE    Set Variable    ${get_tongban_tru_trahang_af}
    ${get_nhom_kh_af}      Get group of customer thr API    ${ma_kh}
    Run Keyword If      '${input_dieu_kien}'!='Không cập nhật danh sách khách hàng' and '${input_auto}'=='true' and ${actual_dieu_kien_af} ${actual_so_sanh} ${input_gia_tri}       Should Contain        ${get_nhom_kh_af}    ${input_ten_nhom}       ELSE IF   '${input_dieu_kien}'=='Không cập nhật danh sách khách hàng'     Should Contain      ${get_nhom_kh_af}   ${get_nhom_kh}     ELSE    Should Contain         ${get_nhom_kh_af}   ${get_nhom_kh}
    Delete customer by Customer Code    ${ma_kh}
    Delete customer group thr API    ${input_ten_nhom}

nkh2
    [Arguments]   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}   ${ma_kh}    ${dict_invoice}     ${dict_return}    ${input_khtt}
    Log    prepare
    Delete customer if it exists    ${ma_kh}
    Delete customer group if it exists    ${input_ten_nhom}
    ${actual_so_sanh}    Set Variable If    '${input_so_sanh}'=='='    ==    ${input_so_sanh}
    #
    Log    action
    Add customers without contact number    ${ma_kh}    abcd
    :FOR    ${time}     IN RANGE   2
    \   ${invoice_code}     Add new invoice frm API    ${ma_kh}    ${dict_invoice}    ${input_khtt}
    Add new return with customer    ${ma_kh}    ${dict_return}    ${input_khtt}
    Edit group customer by the condition   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}
    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}     Get Customer Debt from API    ${ma_kh}
    ${actual_dieu_kien}     Run Keyword If    '${input_dieu_kien}'=='Tổng bán'    Set Variable    ${get_tongban}      ELSE IF   '${input_dieu_kien}'=='Công nợ hiện tại'    Set Variable    ${get_no}    ELSE    Set Variable    ${get_tongban_tru_trahang}
    ${get_nhom_kh}      Get group of customer thr API    ${ma_kh}
    Run Keyword If      ${actual_dieu_kien} ${actual_so_sanh} ${input_gia_tri} and '${input_dieu_kien}'!='Không cập nhật danh sách khách hàng'       Should Contain           ${get_nhom_kh}    ${input_ten_nhom}       ELSE     Should Not Contain          ${get_nhom_kh}    ${input_ten_nhom}
    #
    Delete invoice by invoice code    ${invoice_code}
    ${get_no_af}    ${get_tongban_af}    ${get_tongban_tru_trahang_af}     Get Customer Debt from API    ${ma_kh}
    ${actual_dieu_kien_af}     Run Keyword If    '${input_dieu_kien}'=='Tổng bán'    Set Variable    ${get_tongban_af}      ELSE IF   '${input_dieu_kien}'=='Công nợ hiện tại'    Set Variable    ${get_no_af}    ELSE    Set Variable    ${get_tongban_tru_trahang_af}
    ${get_nhom_kh_af}      Get group of customer thr API    ${ma_kh}
    Run Keyword If      '${input_dieu_kien}'!='Không cập nhật danh sách khách hàng' and '${input_auto}'=='true' and ${actual_dieu_kien_af} ${actual_so_sanh} ${input_gia_tri}       Should Contain        ${get_nhom_kh_af}    ${input_ten_nhom}       ELSE IF   '${input_dieu_kien}'=='Không cập nhật danh sách khách hàng'     Should Contain      ${get_nhom_kh_af}   ${get_nhom_kh}     ELSE    Should Contain         ${get_nhom_kh_af}   ${get_nhom_kh}
