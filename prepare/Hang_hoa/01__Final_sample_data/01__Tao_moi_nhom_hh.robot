*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ten nhom hang
Nhom hang cap 1       [Tags]                       GROUP
                      [Template]                   Add categories thr API
                      Kẹo bánh
                      Mỹ phẩm
                      Hạt nhập khẩu KM
                      Dịch vụ
                      Đồ ăn vặt
                      Thiết bị số - Phụ kiện số
                      Văn phòng phẩm
                      Smartphone
                      Nhà cửa
                      Kho1
                      Chuyển 1
                      KM hàng
                      Bánh nhập KM
                      Máy KM
                      Dịch vụ KM

Nhom hang KM          [Tags]                       GROUP
                      [Template]                   Add categories thr API
                      KM HĐ HH
                      KM Hàng mua
                      KM Hàng tặng

Kiểm nhóm          [Tags]                       GROUP            EKG
                      [Template]                   Add categories thr API
                      Kiểm kho Nhóm

Chuyển nhóm          [Tags]                       GROUP            ECG
                      [Template]                   Add categories thr API
                      Chuyển Nhóm

Bảo hành bảo trì          [Tags]                       GROUPNEW            GROUP
                      [Template]                   Add categories thr API
                      Bảo hành - bảo trì

Ban trực tiếp ĐVT          [Tags]                       GROUPNEW            GROUP
                      [Template]                   Add categories thr API
                      Hạt nhập khẩu

Hàng lodate           [Tags]                       ULODA           GROUPNEW            GROUP
                      [Template]                   Add categories thr API
                      trackingld

Nhom hang kiem kho       [Tags]                       NHKK
                         [Template]                   Add categories thr API
                         Kiểm kho API
                         Lô date
