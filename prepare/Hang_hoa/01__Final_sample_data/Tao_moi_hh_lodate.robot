*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../Sources/giaodich.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Mã sp         Tên sp                                          Tên nhóm    Giá bán    Giá nhập    Số lượng    Tên lô
EBL                   [Tags]        EBL
                      [Template]    create hh lodate
                      LD01          Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g    Lô date     70000      50000       120         ABC
                      LD02          Túi 8 Bánh Socola Kitkat Trà Xanh SB            Lô date     60000      30000       22          ABC
                      LD03          Gói 6 Thanh Bánh Socola KitKat 2F 17g           Lô date     70000      35000       89          ABC
                      LD04          Kẹo Hồng Sâm Vitamin Daegoung Food              Lô date     0          50000       1200        ABC
                      LD05          Bánh Chocolate Kem Marshmallow Phaner Pie       Lô date     44.895     30000       90          ABC
                      LD06          Túi 12 Thanh Socola KitKat 2F (Thanh 17g)       Lô date     25.459     35000       10          ABC
                      LD07          Kẹo Gừng Gingerbon Hộp 620g                     Lô date     70000      50000       120         ABC
                      LD08          Kẹo Chanh & Bạc Hà Ricola F122672 (40g)         Lô date     70000      50000       90          ABC
                      LD09          Kẹo Cay Con Tàu Fishermans Friend Vị Cam        Lô date     70000      50000       110         ABC

Nang cap chuyen hang                   [Tags]        EBL
                      [Template]    create hh lodate
                      LD10          Bánh quy vị Vani              Lô date     120000      40000       120         XYZ
Kiểm kho API          [Tags]        HHKK    SONVH12
                      [Template]    create hh lodate
                      LDKK0001     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0002     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0003     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0004     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0005     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0006     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0007     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ
                      LDKK0008     Bánh quy vị Vani               Lô date     120000      40000       120         XYZ



*** Keywords ***
create hh lodate
    [Arguments]    ${ui_product_code}    ${tensp}    ${tennhom}    ${giaban}    ${gianhap}    ${sum_soluong}
    ...    ${tenlo}
    ${get_product_id}    Add lodate product thr API    ${ui_product_code}    ${tensp}    ${tennhom}    ${giaban}
    ${get_user_id}    Get User ID
    ${date}    Get Current Date
    ${hsd}=    Add Time To Date    ${date}    30 days
    import Lot for prd    ${get_product_id}    ${sum_soluong}    ${tenlo}    ${hsd}    ${gianhap}    ${get_user_id}
