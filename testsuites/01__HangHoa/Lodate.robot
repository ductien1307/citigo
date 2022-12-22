*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown     After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***    Ten HH         Nhom Hang    Gia Ban    Gia Von      Ton Kho
Thêm                  [Tags]         EPL
                      [Template]     eld1
                      [Documentation]   Thêm mới hàng lodate
                      GreenCross     Lô date      80000      60000        2
                      GreenCross     Lô date      80000      60000        2

Sửa                   [Tags]         EPL
                      [Template]     eld2
                      [Documentation]   Cập nhật hàng lodate
                      Thuóc nhuộm    20000        Lô date    Bánh oreo    Dịch vụ    455555
                      Thuóc nhuộm    20000        Lô date    Sữa hộp      Dịch vụ    455555

Xóa                   [Tags]         EPL
                      [Template]     eld3
                      [Documentation]   Xóa hàng lodate
                      Bút bi CBA         23233        Lô date

*** Keyword ***
eld1
    [Arguments]    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Reload Page
    Go to Them moi Hang Hoa
    ${ma_hh}    Generate code automatically    HL
    Create lodate product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}
    Click Element    ${button_luu}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    0    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

eld2
    [Arguments]    ${ten_hanghoa}    ${giaban}    ${nhom_hang}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    ${ma_hh}    Generate code automatically    HL
    Add lodate product thr API    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}
    Reload Page
    Search product code and click update product    ${ma_hh}
    ${mahh_up}    Generate code automatically    HL
    Input data in Them hang hoa form without cost and onhand    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    0    0    ${giaban_up}
    Delete product thr API    ${mahh_up}

eld3
    [Arguments]    ${ten_hanghoa}    ${giaban}    ${nhom_hang}
    ${ma_hh}    Generate code automatically    HH
    Add lodate product thr API    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}
    Reload Page
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
    Reload Page
