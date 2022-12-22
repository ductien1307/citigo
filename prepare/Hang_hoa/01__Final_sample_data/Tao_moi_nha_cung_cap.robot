*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../Sources/doitac.robot

*** Test Cases ***    Mã NCC             Tên NCC                                SĐT
EN                    [Tags]             EN
                      [Template]         Add new supplier
                      NCC0001            Rau sạch vietgab                       0977654890
                      NCC0002            Hoa quả sạch tiki                      0977654891
                      NCC0003            NXB Nhã Nam                            0977654892
                      NCC0004            NXB Kim Đồng                           0977654893
                      NCC0005            Nhà phân phối Sakuko                   0977654894
                      NCC0006            Trang sức PNJ                          0977654895
                      NCC0007            NCC Hoa quả sạch                       0977654896
                      NCC0008            NCC Thái Bình                          0977654897
                      NCC0009            NCC Anh Nam                            0977654898
                      NCC0010            NCC Thu Hương                          0977654899
                      NCC0011            NCC Hàng Hải                           0977654900
                      NCC0012            NCC Shop Nhật 247                      0977654901
                      NCC0013            NCC Waki                               0977654902
                      NCC0014            NCC SOFT DECOR                         0977654903
                      NCC0015            NCC Thiên hương                        0977654904
                      NCC0016            NCC Gia dụng Đức                       0977654905
                      NCC0017            NCC JYSK Living                        0977654906

EN                    [Tags]             EN   TEST
                      [Template]         Add new supplier
                      NCCN0001            NSX Thu Hương                       0977654111
                      NCCN0002            NCC Mai An                          0977654222


THN                   [Tags]             THN
                      [Template]         Add new supplier
                      NCC0018            NCC Anka Center                        0990654902
                      NCC0019            NCC Alex House                         0977690990
                      NCC0020            NCC Cyber Gargen                       0977651206
                      NCC0021            NCC Công ty Thạch Linh                 09988654906

EDN                   [Tags]             EDN
                      [Template]         Add new supplier
                      NCC0022            Rau sạch vietgab                       977632514
                      NCC0023            Hoa quả sạch tiki                      977632515
                      NCC0024            NXB Nhã Nam                            977632516
                      NCC0025            NXB Kim Đồng                           977632517
                      NCC0026            Nhà phân phối Sakuko                   977632518
                      NCC0027            Trang sức PNJ                          977632519
                      NCC0028            NCC Hoa quả sạch                       977632520
                      NCC0029            NCC Thái Bình                          977632521
                      NCC0030            NCC Anh Nam                            977632522
                      NCC0031            NCC Thu Hương                          977632523
                      NCC0032            NCC Hàng Hải                           977632524
                      NCC0033            NCC Shop Nhật 247                      977632525
                      NCC0034            NCC Waki                               977632526
                      NCC0035            NCC SOFT DECOR                         977632527
                      NCC0036            NCC Thiên hương                        977632528
                      NCC0037            NCC Gia dụng Đức                       977632529
                      NCC0038            NCC JYSK Living                        977632530
                      NCC0039            Rau sạch vietgab                       977632531
                      NCC0040            Hoa quả sạch tiki                      977632532
                      NCC0041            NXB Nhã Nam                            977632533
                      NCC0042            NXB Kim Đồng                           977632534

ETN                   [Tags]        ETTHN
                      [Documentation]          Suppliers for order supplier return
                      [Template]    Add new supplier
                      NCC0043       NCC TH true milk          2321632514
                      NCC0044       Công ty Manufactory         2323254334
                      #NCC0045       NCC prenan Loong          233423212
                      #NCC0046       NCC kimmy           43231754565
                      #NCC0047       Công ty legal         96578657865
                      #NCC0048       Công ty Mộc Lan         234576575

CRP                   [Tags]             CRP
                      [Template]         Add new supplier
                      RPNCC001           NCC TH true milk                       2632545525
                      RPNCC002           Công ty Manufactory                    2632545526
                      RPNCC003           NCC prenan Loong                       2632545527
                      RPNCC004           NCC kimmy                              2632545528
                      RPNCC005           Công ty legal                          2632545529

*** Keywords ***
Add new supplier
    [Arguments]    ${input_ma_ncc}    ${input_ten_ncc}    ${input_sdt}
    Add supplier    ${input_ma_ncc}    ${input_ten_ncc}    ${input_sdt}
