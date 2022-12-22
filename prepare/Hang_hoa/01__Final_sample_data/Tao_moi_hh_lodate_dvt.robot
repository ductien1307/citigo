*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../Sources/giaodich.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Mã sp         Tên sp                                                 Tên nhóm    Giá bán    DV cơ bản    Mã sp 2    Giá bán2    DV quy đổi     GT quy đổi    Tên lô    Số lượng    Giá nhập
Lodate 1 dvt          [Tags]        EBL
                      [Template]    create hh lodate incl 1 unit
                      LD10          Bánh Chocopie Orion vị cacao hộp 360g                  Lô date     55000      cái          ABC        100         40000
                      LD11          Bánh kem xốp phô mai Nabati hộp 20 gói x 17g           Lô date     56000      hộp          ABC        89          41000
                      LD12          Bánh mochi đậu đỏ Royal Family gói 120g                Lô date     57000      thùng        ABC        22          0
                      LD13          Kẹo gum hương tổng hợp Dr. Xylitol Orion hộp 109.5g    Lô date     58000      cái          ABC        100         43000
                      LD14          Bánh Choco-Pie Orion hộp 396g                          Lô date     59000      hộp          ABC        34          44000
                      LD15          Bánh gạo vị ngọt Richy gói 315g                        Lô date     60000      thùng        ABC        66          45000
                      LD16          Bánh mè giòn tan Gouté Orion hộp 288g                  Lô date     61000      cái          ABC        100         46000
                      LD17          Bánh Custas kem trứng Orion hộp 282g                   Lô date     62000      hộp          ABC        44          47000
                      LD18          Bánh Custas kem trứng Orion hộp 470g                   Lô date     63000      thùng        ABC        55          48000
                      LD19          Kem whipping cream Anchor                              Lô date     0          cái          ABC        90          35000
                      LD20          Bánh xu kem Nhật                                       Lô date     70000      hộp          ABC        50          50000

Lodate 2 dvt          [Tags]        EBL
                      [Template]    create hh lodate incl 2 unit
                      LD21          Bánh Chocopie Orion vị cacao hộp 360g                  Lô date     55000      cái          QD21       125000      hộp nhỏ        3             ABC       100         40000
                      LD22          Bánh kem xốp phô mai Nabati hộp 20 gói x 17g           Lô date     56000      cái          QD22       250000      hộp nhỏ        4             ABC       89          41000
                      LD23          Bánh mochi đậu đỏ Royal Family gói 120g                Lô date     57000      cái          QD23       90000       hộp nhỏ        7             ABC       22          0
                      LD24          Kẹo gum hương tổng hợp Dr. Xylitol Orion hộp 109.5g    Lô date     58000      cái          QD24       150000      hộp tự chọn    5             ABC       100         43000
                      LD25          Bánh Choco-Pie Orion hộp 396g                          Lô date     59000      cái          QD25       170000      hộp tự chọn    4.5           ABC       34          44000
                      LD26          Bánh gạo vị ngọt Richy gói 315g                        Lô date     60000      cái          QD26       300000      hộp tự chọn    3.5           ABC       66          45000
                      LD27          Bánh mè giòn tan Gouté Orion hộp 288g                  Lô date     61000      chiếc        QD27       190000      hộp nhỏ        6             ABC       100         46000
                      LD28          Bánh Custas kem trứng Orion hộp 282g                   Lô date     62000      chiếc        QD28       175000      hộp nhỏ        7             ABC       44          47000
                      LD29          Bánh Custas kem trứng Orion hộp 470g                   Lô date     63000      chiếc        QD29       90000       hộp nhỏ        5             ABC       55          48000
                      LD30          Bánh quy Oreo kem vani hộp 352.8g                      Lô date     0          chiếc        QD30       0           hộp tự chọn    3             ABC       90          35000
                      LD31          Bánh bông lan Solite Cappuccino 276g                   Lô date     70000      chiếc        QD31       170000      hộp tự chọn    1             ABC       50          50000
Kiểm kho API         [Tags]        HHKK    HHKK1
                     [Template]    create hh lodate incl 2 unit
                      LDKK0003     Bánh Chocopie Orion vị cacao hộp 360g                  Lô date     55000      cái          QDKK21       125000      hộp nhỏ        3             ABC       100         40000
                      LDKK0004      Bánh kem xốp phô mai Nabati hộp 20 gói x 17g           Lô date     56000      cái          QDKK22       250000      hộp nhỏ        4             ABC       89          41000
*** Keywords ***
create hh lodate incl 1 unit
    [Arguments]    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}    ${tenlo}
    ...    ${sum_soluong}    ${gianhap}
    ${get_product_id}    Add lodate product incl 1 unit thr API    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}
    ${get_user_id}    Get User ID
    ${date}=    Get Current Date
    ${hsd}=    Add Time To Date    ${date}    30 days
    import Lot for prd    ${get_product_id}    ${sum_soluong}    ${tenlo}    ${hsd}    ${gianhap}    ${get_user_id}

create hh lodate incl 2 unit
    [Arguments]    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}    ${masp2}
    ...    ${giaban2}    ${dvqd}    ${giatriqd}    ${tenlo}    ${sum_soluong}    ${gianhap}
    ${get_product_id}    Add lodate product incl 2 unit thr API    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}
    ...    ${masp2}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_user_id}    Get User ID
    ${date}=    Get Current Date
    ${hsd}=    Add Time To Date    ${date}    30 days
    import Lot for prd    ${get_product_id}    ${sum_soluong}    ${tenlo}    ${hsd}    ${gianhap}    ${get_user_id}
