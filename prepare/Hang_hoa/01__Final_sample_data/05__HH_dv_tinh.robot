*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ma SP              TenSP                                                           Nhomhang              Giaban       Giavon      Ton     DVCB     TenDVT1          GTQD1    Giaban1     MaHH1       TenDVT2          GTQD2    Giaban2      MaHH2
HH 2 don vi tinh n Gia ban bang 0
                      [Tags]             CBU
                      [Template]         Add product incl 2 units thrAPI
                      [Timeout]
                      DVT04A             Bánh Gavottes Plaisir Dentelle Hỗn Hợp (240g)                   Đồ ăn vặt             0            5000        1200    cái      hộp tự chọn      6        0           QD019       hộp lớn          10       60000        QD020
                      DVT05A             Bánh Hura Hương Dâu Hộp Demi Bibica (300g)                      Đồ ăn vặt             0            5000        0       chiếc    hộp tự chọn      3        0           QD021       hộp lớn          5        280000       QD022
                      DVT06A             Bánh Hura Swissroll Hương Bơ Sữa Bibica                         Đồ ăn vặt             0            7000        0       chiếc    hộp tự chọn      3        0           QD023       hộp lớn          6        25000        QD024       #ton kho am
                      DVT17A             Kẹo Ngậm Không Đường Mentos Pure Fresh                          Đồ ăn vặt             0            5000        1200    cái      hộp tự chọn      6        0           QD043       hộp lớn          10       60000        QD044
                      DVT18A             Socola Viên Milo Nuggets                                        Đồ ăn vặt             0            5000        0       chiếc    hộp tự chọn      3        0           QD045       hộp lớn          5        280000       QD046
                      DVT19A             Bánh Quy Socola hạt chocochip                                   Đồ ăn vặt             0            7000        0       chiếc    hộp tự chọn      3        0           QD047       hộp lớn          6        25000        QD048       #ton kho am
                      DVT37A             Kẹo Foxs Hương Trái Cây                                         Đồ ăn vặt             0            7000        0       chiếc    hộp tự chọn      3        0           QD083       hộp lớn          6        25000        QD084       #ton kho am

DH_Nhieu_dong_1dvt       [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT01              Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL001
                      DVT02              Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL002
                      DVT03              Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL003     #ton kho am
                      DVT04              Gói Mì Chapagetti                                               Đồ ăn vặt             0            3000        1200    cái      hộp thập phân    4.5      28000       QDKL007
                      DVT05              Chai Nước Uống Thể Thao Aquarius                                Đồ ăn vặt             5000         2000        0       chiếc    hộp thập phân    3.5      180000      QDKL008
                      DVT06              Chai Nước Giải Khát Coca-Cola                                   Đồ ăn vặt             11000        7000        0       chiếc    hộp thập phân    0.5      15000       QDKL009     #ton kho am
                      DVT07              Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL004
                      DVT08              Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL005
                      DVT09              Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL006     #ton kho am
                      DVT10              Thanh Bánh Chocolate KitKat Trà Xanh                            Đồ ăn vặt             0            3000        1200    cái      hộp thập phân    4.5      28000       QDKL010
                      DVT11              Bánh Pía Sầu Riêng Truly Vietnam Có Trứng                       Đồ ăn vặt             0            2000        0       chiếc    hộp thập phân    3.5      180000      QDKL011
                      DVT12              Kẹo Mềm Alpenliebe 2Chew Hương Hỗn Hợp Dâu                      Đồ ăn vặt             0            7000        0       chiếc    hộp thập phân    0.5      15000       QDKL012     #ton kho am
                      DVT13              Bánh Trứng Tik-Tok Cappuccino                                   Đồ ăn vặt             0            3000        1200    cái      hộp thập phân    4.5      28000       QDKL013
                      DVT14              Bánh quy nhân sầu riêng                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL014
                      DVT15              Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL015
                      DVT16              Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL016     #ton kho am
                      DVT17              Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL017
                      DVT18              Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL018
                      DVT19              Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL019     #ton kho am

DH_Nhieu_dong_khachle_1dvt       [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT20              Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL020
                      DVT21              Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL021
                      DVT22              Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL022     #ton kho am
                      DVT23              Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QDKL023
                      DVT24              Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDKL024
                      DVT25              Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QDKL025     #ton kho am

Shop config         [Tags]             EDH    TL
                      [Template]         Add product incl 2 units thrAPI
                      DVT26              Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD1007      hộp lớn          10       72000        QD1008

Remain         [Tags]
                      [Template]         Add product incl 2 units thrAPI
                      DVT27              Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD1009      hộp lớn          6        362000       QD1010
                      DVT28              Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD1011      hộp lớn          10       52000        QD1012      #ton kho am
                      DVT29              Bánh gà                                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD1013      hộp thập phân    5.5      38500        QD1014
                      DVT30              Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           QD1015      hộp thập phân    5.5      330000       QD1016
                      DVT31              Kem marino                                                      Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           QD1017      hộp thập phân    5.5      27500        QD1018      #ton kho am
                      DVT32              Đơn vị tính 32                                                  Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDDE026     hộp thập phân    5.5      385000       QDDE027
                      DVT33              Đơn vị tính 33                                                  Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDDE028     hộp thập phân    5.5      330000       QDDE029

Khuyen_mai_auto       [Tags]             EDPROMO
                      [Template]         Add product incl 2 units thrAPI
                      DVT34              Đơn vị tính 34                                                  Máy KM                50000        20000       0       chiếc    hộp tự gen       3        150000      QDDE030     hộp thập phân    5.5      275000       QDDE031
                      DVT35              Đơn vị tính 35                                                  Đồ ăn vặt             2000000      25000       1200    cái      hộp tự gen       4        280000      QDDE032     hộp lớn          10       700000       QDDE033
                      DVT36              Đơn vị tính 36                                                  KM Hàng mua           1500000      30000       1200    chiếc    hộp tự gen       3        180000      QDDE034     hộp lớn          6        420000       QDDE035

Khuyen_mai_gop        [Tags]             EDPROMO
                      [Template]         Add product incl 2 units thrAPI
                      DVT37              Đơn vị tính 37                                                  KM Hàng mua           500000       20000       1200    chiếc    hộp tự gen       3        150000      QDDE036     hộp lớn          6        500000       QDDE037
                      DVT38              Đơn vị tính 38                                                  KM Hàng mua           70000        25000       1200    cái      hộp tự gen       4        280000      QDDE038     hộp thập phân    5.5      385000       QDDE039
                      ##thu khac
                      DVT39              Đơn vị tính 39                                                  KM Hàng mua           60000        30000       1200    chiếc    hộp tự gen       3        180000      QDDE040     hộp thập phân    5.5      330000       QDDE041

Khuyen_mai_phamvi_apdung
                      [Tags]                                                          PROMOTION
                      [Template]         Add product incl 2 units thrAPI
                      DVTKM01            Hàng ĐVT khuyen mai 01                                          KM hàng               80000        2000        1200    chiếc    hộp tự gen       3        240000      QDKM01      hộp lớn          6        540000       QDKM02
                      DVTKM02            Hàng ĐVT khuyen mai 02                                          KM hàng               90000        2000        1200    chiếc    hộp tự gen       3        270000      QDKM03      hộp thập phân    5.5      495000       QDKM04
                      DVTKM03            Hàng ĐVT khuyen mai 03                                          KM Hàng mua           80000        2000        1200    chiếc    hộp tự gen       3        240000      QDKM05      hộp lớn          6        540000       QDKM06
                      DVTKM04            Hàng ĐVT khuyen mai 04                                          KM Hàng mua           90000        2000        1200    chiếc    hộp tự gen       3        270000      QDKM07      hộp thập phân    5.5      495000       QDKM08

Doi_tra_hang_thukhac
                      [Tags]             DTH
                      [Template]         Add product incl 2 units thrAPI
                      #thu khac
                      DTU001             Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QDDT1       hộp thập phân    5.5      38500        QDDT2
                      DTU002             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           QDDT3       hộp thập phân    5.5      330000       QDDT4
                      DTU003             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           QDDT5       hộp thập phân    5.5      27500        QDDT6       #ton kho am
                      DTU004             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QDDT7       hộp lớn          10       72000        QDDT8
                      #nhieu dong
                      DTU005             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QDDT9       hộp lớn          6        362000       QDDT10
                      DTU006             Bánh Yến Mạch + gạo lức Fine                                    Đồ ăn vặt             90000        40000       0       chiếc    hộp nhỏ          2        180000      QDDT11      hộp lớn          5        450000       QDDT12

HH 2 don vi tinh      [Tags]             CBU
                      [Template]         Add product incl 2 units thrAPI
                      DVT13B             Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD037       hộp thập phân    5.5      38500        QD038
                      DVT14B             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           QD039       hộp thập phân    5.5      330000       QD040
                      DVT15B             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           QD041       hộp thập phân    5.5      27500        QD042       #ton kho am
                      DVT21A             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD052       hộp lớn          10       72000        QD053
                      DVT22A             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD054       hộp lớn          6        362000       QD055
                      DVT23A             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD056       hộp lớn          6        52000        QD057       #ton kho am
                      DVT21B             Bánh Yến Mạch + gạo lức Fine                                    Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD058       hộp thập phân    5.5      38500        QD059
                      DVT27A             Kẹo Không Đường Kopiko F40KOP                                   Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD063       hộp lớn          10       72000        QD064
                      DVT28A             Kẹo Ngậm Không Đường Jila                                       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD065       hộp lớn          6        362000       QD066
                      DVT29A             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD067       hộp lớn          6        52000        QD068       #ton kho am
                      DVT27B             Kẹo Gừng Gingerbon                                              Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD069       hộp thập phân    5.5      38500        QD070
                      DVT34A             Sing Gum Không Đường Mentos Pure Fresh                          Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD075       hộp lớn          10       72000        QD076
                      DVT35A             Socola KitKat Trà Xanh 4F                                       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD077       hộp lớn          6        362000       QD078
                      DVT36A             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD079       hộp lớn          6        52000        QD080       #ton kho am
                      DVT34B             Kẹo Golia Activ Plus                                            Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD081       hộp thập phân    5.5      38500        QD082
                      DVT41A             Kẹo Kalfany K150BH - Vị Bạc Hà                                  Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD088       hộp lớn          10       72000        QD089
                      DVT42A             Snack Poca Khoai Tây Vị Sườn Nướng BBQ                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD090       hộp lớn          6        362000       QD091
                      DVT43A             Snack Lays Stax Thái Vị Tự Nhiên                                Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD092       hộp lớn          6        52000        QD093       #ton kho am
                      DVT41B             Snack rong biển Tao Kae Noi Tempura vị Cay                      Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD094       hộp thập phân    5.5      38500        QD095

Dat_hang_thuong_2dvt       [Tags]             EDH
                      [Template]         Add product incl 2 units thrAPI
                      DVT44              Kẹo Foxs Hương Bạc Hà Hộp 180g                                  Đồ ăn vặt             7000.05      5000        1200    cái      hộp nhỏ          4        23000       QD096       hộp lớn          10       72000        QD097
                      DVT45              Snack Mực Tẩm Gia Vị Cay Ngọt Bento (24g)                       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD098       hộp lớn          6        362000       QD099
                      DVT46              Combo 3 Hộp Kẹo Tic Tac Hương Vị Bạc Hà Lục                     Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD100       hộp lớn          10       52000        QD101
                      DVT47              Socola Kinder Joy Dành Cho Bé Trai (20g)                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        28000       QD102       hộp thập phân    5.5      38500        QD103
                      DVT48              Kẹo Cay Con Tàu Fishermans Friend                               Đồ ăn vặt             60000.8      30000       0       chiếc    hộp tự chọn      3        180000      QD104       hộp thập phân    5.5      330000       QD105
                      DVT49              Kẹo Dẻo Haribo Goldbears (100g)                                 Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        15000       QD106       hộp thập phân    5.5      27500        QD107
                      DVT50              Hộp 3 Kẹo Socola Kinder Cho Bé Gái                              Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD108       hộp lớn          10       72000        QD109
                      DVT51              Hộp 3 Kẹo Socola Kinder Cho Bé Trai                             Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD110       hộp lớn          6        362000       QD111
                      DVT52              Bánh Mcvities Digestive Dark Chocolate                          Đồ ăn vặt             5000.13      2000        0       chiếc    hộp nhỏ          3        10000       QD112       hộp lớn          10       52000        QD113
                      DVT53              Bánh Trứng Tik-Tok Sầu Riêng                                    Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        28000       QD114       hộp thập phân    5.5      38500        QD115
                      DVT54              Bánh Trứng Tik-Tok Bơ Sữa (120g)                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        180000      QD116       hộp thập phân    5.5      330000       QD117
                      DVT55              Kẹo Mềm Alpenliebe 2Chew Hương Nho                              Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        15000       QD118       hộp thập phân    5.5      27500        QD119
                      DVT56              Socola KitKat Bites Gói 100g                                    Đồ ăn vặt             7000.22      5000        1200    cái      hộp nhỏ          4        23000       QD120       hộp lớn          10       72000        QD121
                      DVT57              Lốc 12 Gói Snack Mực Tẩm Gia Vị Cay Bento                       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD122       hộp lớn          6        362000       QD123
                      DVT58              Combo 3 Hộp Kẹo Tic Tac Hương Vị Dau                            Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD124       hộp lớn          6        52000        QD125

Dat_hang_thuong_1dvt       [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT59              Kẹo Cao Su Thổi Big Babol Tô Màu Hộp 12 Hũ 18g                  Đồ ăn vặt             7000.34      5000        1200    cái      hộp tự gen       4        28000       QD126
                      DVT60              Kẹo nhai Mentos cầu vòng hộp 16 thỏi 11 viên (29.7g/thỏi)       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD127

Thu_khac_DH_1dvt       [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT61              Sing Gum Mentos Fresh Action Hương Bạc Hà Mạnh (Hộp 6 Hũ)       Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QD128
                      DVT62              Kẹo nhai Mentos bạc hà (hộp 16 thỏi 11 viên - 29.7g/thỏi)       Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QD129
                      DVT63              Kẹo Mềm Alpenliebe 2Chew Hương Trái Cây (Hộp 16 Thỏi)           Đồ ăn vặt             60000.48     30000       0       chiếc    hộp tự gen       3        180000      QD130
                      DVT64              Sing Gum Happy Dent (Gói 40 Viên)                               Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QD131
                      DVT65              Lốc 6 Mì Ly Kim Chi Nongshim (75g / Ly)                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QD132
                      DVT66              Lốc 6 Gói Bánh U-Gua Nongshim (80g / Gói)                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD133
                      DVT67              Thùng Mì Gói Hảo Hảo Hương Vị Tôm Chua Cay.                     Đồ ăn vặt             5000.51      2000        0       chiếc    hộp tự gen       3        15000       QD134

Remain
                      DVT68              Rong Biển Sấy Chú Tiểu (50g)                                    Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QD135
                      DVT69              Khô Gà Sấy Lá Chanh MAMIFOODS (500g) Cay Vừa                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD136
                      DVT70              Rong Biển Sấy Tỏi Muối Tôm Chú Tiểu (50g)                       Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QD137
                      DVT71              Khô Gà Sấy Lá Chanh MAMIFOODS (250g) Cay Vừa                    Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       QD138
                      DVT72              Lương Khô Bay - Công Ty Cổ Phần 22 (1000g)                      Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD139
                      DVT73              Lốc 6 Gói Bánh Khoai Tây Nongshim (70g / Gói)                   Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD140
                      DVT74              Khoai Tây Chiên Slide Kinh Đô vị Barbecue                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD141
                      DVT75              Snack Mực Tẩm Gia Vị Cay Ngọt Bento (24g)                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD142
                      DVT76              Snack Poca Khoai Tây Wavy Vị Bò Bít Tết                        Đồ ăn vặt             70000.67     25000       1200    cái      hộp tự gen       4        280000      QD143
                      DVT77              Snack Poca Khoai Tây Wavy Vị Bò Bít Tết.                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD144
                      DVT78              Bánh Snack Khoai Tây Vị Pho Mai Ligo (160g)                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD145

Tra hang              [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT79              Lốc 12 Gói Snack Mực Tẩm Gia Vị Cay Ngọt                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD146
                      DVT80              Bánh Snack Khoai Tây Vị Thịt Nướng Ligo                         Đồ ăn vặt             60000.73     30000       0       chiếc    hộp tự gen       3        180000      QD147
                      DVT81              Khoai Tây Chiên Lorenz Crunchips Vị Ớt                          Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD148
                      DVT82              Bắp Rang Uncle Jax Vị Trà Xanh (160g)                           Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD149
                      DVT83              Snack Mực Tẩm Gia Vị Cay Bento (24g)                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD150
                      DVT84              Bánh Ngũ Cốc Không Chiên Sunbites Rong Biển                     Đồ ăn vặt             50000.83     20000       0       chiếc    hộp tự gen       3        150000      QD151
                      DVT85              Snack rong biển Tao Kae Noi Crispy Seaweed                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD152

Doi tra hang          [Tags]             EDH
                      [Template]         Add product incl 1 unit thrAPI
                      DVT86              Poca Khoai Tây Phô Mai Cheeda 52g                               Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD153
                      DVT87              Hộp 6 gói Snack rong biển Tao Kae Noi Big                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD154
                      DVT88              Snack Phô Mai Cheddar Ball No Brand 170g                        Đồ ăn vặt             70000.99     25000       1200    cái      hộp tự gen       4        280000      QD155
                      DVT89              Hộp 12 gói Snack rong biển Tao Kae Noi Big                      Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD156
                      DVT90              Khoai Tây Chiên Vị Kem Chua Lorenz Pomsticks                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD157

Remain
                      DVT91              Khoai Tây Chiên Lorenz Crunchips Vị Muối                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD158
                      DVT92              Bánh snack khoai tây Angry Birds vị Kem Hành                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD159
                      DVT93              Snack Khoai Lang Tím No Brand 110g                              Đồ ăn vặt             50000.04     20000       0       chiếc    hộp tự gen       3        150000      QD160
                      DVT94              Hộp Hạnh Nhân Kèm Bánh Quy Vị Wasabi Sunnuts                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD161
                      DVT95              Hạnh Nhân Vị Sữa Chuối Sunnuts 30g Banana                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD162
                      DVT96              Hạnh Nhân vị Bơ Mật Ong Sunnuts 30g Honey                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD163

HH 2 dvt_EDU_op       [Tags]
                      [Template]         Add product incl 2 units thrAPI
                      #taohoadon
                      DVT97              Hạnh Nhân vị Gà Cay Sunnuts 30g Spicy                           Đồ ăn vặt             70000.11     25000       1200    cái      hộp tự gen       4        280000      QD172       hộp thập phân    5.5      385000       QD173
                      DVT98              Hạnh Nhân Kèm Bánh Quy Vị Wasabi Sunnuts 30g                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD174       hộp thập phân    5.5      330000       QD175
                      DVT99              Bắp Rang Uncle Jax Vị Hỗn Hợp                                   Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD176       hộp thập phân    5.5      275000       QD177
                      DVT100             Bánh Snack Khoai Tây Vị Thịt Nướng Ligo.                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD178       hộp lớn          10       700000       QD179
                      DVT101             Snack Khoai Tây Pringels Cream Và Onion                         Đồ ăn vặt             60000.23     30000       0       chiếc    hộp tự gen       3        180000      QD180       hộp lớn          6        420000       QD181
                      DVT102             Snack rong biển Tao Kae Noi Tempura vị Cay                      Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD182       hộp lớn          6        500000       QD183
                      DVT103             Kem đậu xanh Vinamilk hộp 1L                                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD184       hộp thập phân    5.5      385000       QD185
                      DVT104             Kem sữa tươi đánh tiệt trùng Anchor hộp 1L                      Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD186       hộp thập phân    5.5      330000       QD187
                      DVT105             Kem Milo sô cô la lúa mạch Nestlé hộp 375g                      Đồ ăn vặt             50000.36     20000       0       chiếc    hộp tự gen       3        150000      QD188       hộp thập phân    5.5      275000       QD189
                      DVT106             Kem sữa có đường tiệt trùng dạng xịt Paysan Breton chai 250g    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD190       hộp lớn          10       700000       QD191
                      DVT107             Kem Nestlé hương vani hộp 375g                                  Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD192       hộp lớn          6        420000       QD193
                      DVT108             Kem bánh cá đậu đỏ Ginggrae                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD194       hộp lớn          6        500000       QD195
                      DVT109             Kem bánh cá sô cô la Melona                                     Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD196       hộp thập phân    5.5      385000       QD197
                      DVT110             Kem bánh cá trà xanh Binggrae                                   Đồ ăn vặt             60000.45     30000       0       chiếc    hộp tự gen       3        180000      QD198       hộp thập phân    5.5      330000       QD199
                      DVT111             Kem bánh cá trà xanh Binggrae                                   Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD200       hộp thập phân    5.5      275000       QD201
                      DVT112             Kem hương dâu Vinamilk                                          Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD202       hộp lớn          10       700000       QD203
                      DVT113             Kem dâu Melona                                                  Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD204       hộp lớn          6        420000       QD205
                      DVT114             Kem hương chuối Melona Binggrae                                 Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD206       hộp lớn          6        500000       QD207
                      DVT115             Kem sữa Elle & Vire hộp 1L                                      Đồ ăn vặt             70000.55     25000       1200    cái      hộp tự gen       4        280000      QD208       hộp thập phân    5.5      385000       QD209
                      DVT116             Kem nấu tiệt trùng Anchor hộp 1L                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD210       hộp thập phân    5.5      330000       QD211
                      DVT117             Kem khoai môn Cremo hộp 450g                                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD212       hộp thập phân    5.5      275000       QD213
                      DVT118             Kem ốc quế Chocolate & Cookies LaBeaute Lavelee                 Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD214       hộp lớn          10       700000       QD215
                      DVT119             Kem sữa Elle&Vire vani                                          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD216       hộp lớn          6        420000       QD217
                      DVT120             Kem xoài 30% Lavelee Ice Bar                                    Đồ ăn vặt             50000.61     20000       0       chiếc    hộp tự gen       3        150000      QD218       hộp lớn          6        500000       QD219
                      DVT121             Kem sữa chua việt quất Lavelee                                  Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD220       hộp thập phân    5.5      385000       QD221
                      DVT122             Sữa chua hoa quả Le Petit Plaisir Bauer vỉ 6 hộp x 50g          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD222       hộp thập phân    5.5      330000       QD223
                      #thua
                      DVT123             Sữa chua uống lên men hương tự nhiên Betagen chai 700ml         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD224       hộp thập phân    5.5      275000       QD225
                      DVT124             Váng sữa uống hương vani Zott Monte lốc 4 chai x 95ml           Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD226       hộp thập phân    5.5      330000       QD227
                      DVT125             Phô mai tươi trái cây Helio vị vani - dâu lốc 4 hộp x 50g       Đồ ăn vặt             60000.72     30000       0       chiếc    hộp tự gen       3        180000      QD228       hộp thập phân    5.5      275000       QD229

HH 2 don vi tinh-EKU
                      [Tags]             EMKU                                                            EB1
                      [Template]         Add product incl 2 units thrAPI
                      [Timeout]
                      DVTK01A            Bánh xu kem Nhật                                                Kho1                  7000         5000        1200    cái      hộp nhỏ          4        23000       QDK007      hộp lớn          10       72000        QDK008
                      DVTK02A            Ô mai chanh đào Hồng Lam                                        Kho1                  60000        30000       0       chiếc    hộp nhỏ          3        175000      QDK009      hộp lớn          6        355899.36    QDK010

HH 2 don vi tinh-ECU
                      [Tags]             EMCU                                                            EB1
                      [Template]         Add product incl 2 units thrAPI
                      [Timeout]
                      DVTC01A            Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QDC007      hộp lớn          10       65455.98     QDC008
                      DVTC02A            Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             59355.45     30000       0       chiếc    hộp nhỏ          3        175000      QDC009      hộp lớn          6        362000       QDC010
                      DVTC03A            Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QDC011      hộp lớn          10       50499.35     QDC012      #ton kho am
                      DVTC01B            Bánh gà                                                         Đồ ăn vặt             6899.05      5000        1200    cái      hộp tự chọn      4        0           QDC013      hộp thập phân    5.5      38500        QDC014

Nang cap chuyen hang
                      [Tags]             NCCH                                                            EB1
                      [Template]         Add product incl 2 units thrAPI
                      [Timeout]
                      DVTCH01            Sữa đặc nguyên kem ít béo MIOD                                  Chuyển 1              5000         2000        0       chiếc    hộp nhỏ          3        10000       QDCH01      hộp lớn          10       50499.35     QDCH02      #ton kho am

EBU_2dvt              [Tags]             EBU                                                             TWO                   EB           NOI
                      [Template]         Add product incl 2 units thrAPI
                      DVT0201            Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD007       hộp lớn          10       61299.35     QD008
                      DVT0202            Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             57499.35     30000       0       chiếc    hộp nhỏ          3.4      175000      QD009       hộp lớn          6.5      362000       QD010
                      DVT0203            Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        9555.25     QD011       hộp lớn          10       51899.45     QD012       #ton kho am
                      DVT0204            Bánh gà                                                         Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD013       hộp lớn          5.5      38500        QD014
                      DVT0205            Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3.2      175000      QD015       hộp lớn          5.5      330000       QD016
                      DVT0206            Kem marino                                                      Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       QD017       hộp lớn          5.5      27234.68     QD018       #ton kho am

ETTHN                 [Documentation]    Du lieu cho tra hang nhap
                      [Tags]             ETTHN                                                           EB1
                      [Template]         Add product incl 2 units thrAPI
                      DVT0207            Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4.5      23000       QD031       hộp lớn          10       72000        QD032
                      DVT0208            Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      QD033       hộp lớn          6        362000       QD034
                      DVT0209            Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        9589.78     QD035       hộp lớn          10       52000        QD036       #ton kho am
                      DVT0210            Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       QD037       hộp lớn          5.5      38548.89     QD038

UEBM                  [Tags]             UEBM                                                            EB1
                      [Template]         Add product incl 2 units thrAPI
                      DVT0211            Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             58000        30000       0       chiếc    hộp nhỏ          3.5      175000      QD039       hộp lớn          5.5      330000       QD040
                      DVT0212            Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             65995        2000        0       chiếc    hộp nhỏ          3        10000       QD041       hộp lớn          5.5      27500        QD042       #ton kho am
                      DVT0213            Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             57988        5000        1200    cái      hộp nhỏ          4        22899.45    QD052       hộp lớn          10       72000        QD053

CBPPI                 [Tags]             CBPPI                                                           EB1
                      [Template]         Add product incl 2 units thrAPI
                      DVT0214            Bánh Hura Hương Cốm Hộp Demi Bibica                             KM Hàng tặng          600000       30000       0       chiếc    hộp nhỏ          3.2      1750000     QD054       hộp lớn          6        3620000      QD055
                      DVT0215            Kẹo Alpenliebe Hương Dâu Kem                                    KM Hàng tặng          598885.47    2000        0       chiếc    hộp nhỏ          3        100000      QD056       hộp lớn          6        520000       QD057       #ton kho am
                      ###

EBU_1dvt              [Tags]             EBU                                                             ONE                   EB
                      [Template]         Add product incl 1 unit thrAPI
                      [Timeout]
                      DVT0101            Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             69899.67     5000        1200    cái      hộp tự gen       4        28000       QD001
                      DVT0102            Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       1200    chiếc    hộp tự chọn      3        0           QD002
                      DVT0103            Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        1200    chiếc    hộp tự gen       3        15000       QD003

UEBM                  [Tags]             UEBM                                                            EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVT0104            Gói Mì Chapagetti                                               Đồ ăn vặt             0            3000        1200    cái      hộp tự gen       4.5      28489.68    QD004
                      DVT0105            Chai Nước Uống Thể Thao Aquarius                                Đồ ăn vặt             0            2000        1200    chiếc    hộp tự chọn      3.5      0           QD005
                      DVT0106            Chai Nước Giải Khát Coca-Cola                                   Đồ ăn vặt             0            7000        1200    chiếc    hộp tự gen       0.5      15000       QD006       #ton kho am

CON_PROMO_TK          [Tags]             CONPROTK                                                        EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVT0107            Chocolate Sữa Vietnamcacao                                      KM Hàng mua           258999       500000      1200    cái      hộp tự chọn      4        758999      QD025

EKG                   [Tags]             EKG                                                             EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVT0108            Bánh Cuộn Yuki & Love Whole Grains Energy                       Kiểm kho Nhóm         60000        30000       0       chiếc    hộp tự gen       3        180000      QDK026

ECG                   [Tags]             ECG                                                             EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVT0109            Bánh Chocolate KitKat 4F Thanh 34g                              Chuyển Nhóm           5000         2000        450     chiếc    hộp tự chọn      3        15000       QDCG027     #ton kho am

EN_2dvt               [Tags]             EN
                      [Template]         Add product incl 2 units thrAPI
                      NDVT01             Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       NQD01       hộp lớn          10       72000        NQD101
                      NDVT02             Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      NQD02       hộp lớn          6        362000       NQD102
                      NDVT03             Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       NQD03       hộp lớn          10       52000        NQD103
                      NDVT04             Bánh gà                                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           NQD04       hộp thập phân    5.5      38500        NQD104
                      NDVT05             Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           NQD05       hộp thập phân    5.5      330000       NQD105
                      NDVT06             Kem marino                                                      Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           NQD06       hộp thập phân    5.5      27500        NQD106
                      NDVT07             Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       NQD07       hộp lớn          10       72000        NQD107
                      NDVT08             Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      NQD08       hộp lớn          6        362000       NQD108
                      NDVT09             Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       NQD09       hộp lớn          10       52000        NQD109
                      NDVT10             Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           NQD10       hộp thập phân    5.5      38500        NQD110
                      NDVT11             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           NQD11       hộp thập phân    5.5      330000       NQD111
                      NDVT12             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           NQD12       hộp thập phân    5.5      27500        NQD112
                      NDVT13             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       NQD13       hộp lớn          10       72000        NQD113
                      NDVT14             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      NQD14       hộp lớn          6        362000       NQD114
                      NDVT15             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       NQD15       hộp lớn          6        52000        NQD115

EN_1dvt              [Tags]             EN    TEST
                      [Template]         Add product incl 1 unit thrAPI
                      [Timeout]
                      NHDVT01            Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             69899.67     5000        1200    cái      hộp tự gen       4        28000       QDN001
                      NHDVT02            Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       1200    chiếc    hộp tự chọn      3        0           QDN002
                      NHDVT03            Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        1200    chiếc    hộp tự gen       3        15000       QDN003
                      NHDVT04            Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000     QDN004

EX_2dvt               [Tags]             EX
                      [Template]         Add product incl 2 units thrAPI
                      XDVT01             Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       XQD01       hộp lớn          10       72000        XQD101
                      XDVT02             Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      XQD02       hộp lớn          6        362000       XQD102
                      XDVT03             Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       XQD03       hộp lớn          10       52000        XQD103
                      XDVT04             Bánh gà                                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           XQD04       hộp thập phân    5.5      38500        XQD104
                      XDVT05             Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           XQD05       hộp thập phân    5.5      330000       XQD105
                      XDVT06             Kem marino                                                      Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           XQD06       hộp thập phân    5.5      27500        XQD106
                      XDVT07             Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       XQD07       hộp lớn          10       72000        XQD107
                      XDVT08             Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      XQD08       hộp lớn          6        362000       XQD108
                      XDVT09             Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       XQD09       hộp lớn          10       52000        XQD109

EBG                   [Tags]             EBG
                      [Template]         Add product incl 2 units thrAPI
                      GHU0001            Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       GHQD0001    hộp lớn          10       72000        GHQD1001
                      GHU0002            Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      GHQD0002    hộp lớn          6        362000       GHQD1002
                      GHU0003            Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       GHQD0003    hộp lớn          10       52000        GHQD1003
                      GHU0004            Bánh gà                                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           GHQD0004    hộp thập phân    5.5      38500        GHQD1004
                      GHU0005            Kem milo                                                        Nhà cửa               60000        30000       0       chiếc    hộp tự chọn      3        0           GHQD0005    hộp thập phân    5.5      330000       GHQD1005
                      GHU0006            Kem marino                                                      Văn phòng phẩm        5000         2000        0       chiếc    hộp tự chọn      3        0           GHQD0006    hộp thập phân    5.5      27500        GHQD1006
                      GHU0007            Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             7000         5000        1200    cái      hộp nhỏ          4        23000       GHQD0007    hộp lớn          10       72000        GHQD1007
                      GHU0008            Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      GHQD0008    hộp lớn          6        362000       GHQD1008
                      GHU0009            Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       GHQD0009    hộp lớn          10       52000        GHQD1009
                      GHU0010            Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           GHQD0010    hộp thập phân    5.5      38500        GHQD1010

EDN                   [Tags]             EDN
                      [Template]         Add product incl 2 units thrAPI
                      DNU001             Bánh xu kem Nhật                                                Đồ ăn vặt             7000         5000        20.4    cái      hộp nhỏ          4        23000       DNQD001     hộp lớn          10       72000        DNQD101
                      DNU002             Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000.74    0       chiếc    hộp nhỏ          3        175000      DNQD002     hộp lớn          6        362000       DNQD102
                      DNU003             Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             5000         2000.65     0       chiếc    hộp nhỏ          3        10000       DNQD003     hộp lớn          10       52000        DNQD103
                      DNU004             Bánh gà                                                         Đồ ăn vặt             7000         5000        30      cái      hộp tự chọn      4        0           DNQD004     hộp thập phân    5.5      38500        DNQD104
                      DNU005             Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           DNQD005     hộp thập phân    5.5      330000       DNQD105
                      DNU006             Kem marino                                                      Đồ ăn vặt             5000         2000        0       chiếc    hộp tự chọn      3        0           DNQD006     hộp thập phân    5.5      27500        DNQD106
                      DNU007             Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             7000         5000        60      cái      hộp nhỏ          4        23000       DNQD007     hộp lớn          10       72000        DNQD107
                      DNU008             Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000.82    0       chiếc    hộp nhỏ          3        175000      DNQD008     hộp lớn          6        362000       DNQD108
                      DNU009             Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       DNQD009     hộp lớn          10       52000        DNQD109
                      DNU010             Sữa Quasure Light Bibica                                        Đồ ăn vặt             7000         5000        25      cái      hộp tự chọn      4        0           DNQD010     hộp thập phân    5.5      38500        DNQD110
                      DNU011             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           DNQD011     hộp thập phân    5.5      330000       DNQD111
                      DNU012             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             5000         2000.23     0       chiếc    hộp tự chọn      3        0           DNQD012     hộp thập phân    5.5      27500        DNQD112
                      DNU013             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             7000         5000        30      cái      hộp nhỏ          4        23000       DNQD013     hộp lớn          10       72000        DNQD113
                      DNU014             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp nhỏ          3        175000      DNQD014     hộp lớn          6        362000       DNQD114
                      DNU015             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             5000         2000        0       chiếc    hộp nhỏ          3        10000       DNQD015     hộp lớn          6        52000        DNQD115

CRP                   [Tags]
                      [Template]         Add product incl 1 unit thrAPI
                      RPU01              Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD001
                      RPU02              Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD002
                      RPU03              Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD003
                      RPU04              Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD004
                      RPU05              Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD005
                      RPU06              Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD006
                      RPU07              Bánh quy nhân sầu riêng                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD007
                      RPU08              Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD008
                      RPU09              Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD009
                      RPU10              Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD010
                      RPU11              Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD011
                      RPU12              Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD012
                      RPU13              Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD013
                      RPU14              Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD014
                      RPU15              Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD015
                      RPU16              Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       RPQD016
                      RPU17              Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      RPQD017
                      RPU18              Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       RPQD018

HH 1 don vi tinh      [Tags]
                      [Template]         Add product incl 1 unit thrAPI
                      DVT03              Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       QD003A      #ton kho am

PM                    [Tags]             PM                                                              EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVTP04             Nước hoa xịt phòng                                              Văn phòng phẩm        509000       3000        1200    cái      hộp thập phân    4.5      28000       QD004A
                      #DVT05             Chai Nước Uống Thể Thao Aquarius                                Đồ ăn vặt             0            2000        0       chiếc    hộp thập phân    3.5      180000      QD005A
                      #DVT06             Chai Nước Giải Khát Coca-Cola                                   Đồ ăn vặt             0            7000        0       chiếc    hộp thập phân    0.5      15000       QD006A      #ton kho am

THKL                  [Tags]             THKL
                      [Template]         Add product incl 1 unit thrAPI
                      KLU01              Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       KLQD001
                      KLU02              Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      KLQD002
                      KLU03              Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        200     chiếc    hộp tự gen       3        15000       KLQD003
                      KLU04              Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             7000         5000        800     cái      hộp tự gen       4        28000       KLQD004
                      KLU05              Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      KLQD005
                      KLU06              Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             5000         2000        500     chiếc    hộp tự gen       3        15000       KLQD006
                      KLU07              Bánh quy nhân sầu riêng                                         Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       KLQD007
                      KLU08              Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      KLQD008
                      KLU09              Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             5000         2000        80      chiếc    hộp tự gen       3        15000       KLQD009
                      KLU10              Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             7000         5000        1200    cái      hộp tự gen       4        28000       KLQD010
                      KLU11              Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             60000        30000       50      chiếc    hộp tự gen       3        180000      KLQD011
                      KLU12              Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       KLQD012
                      KLU13              Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             7000         5000        1000    cái      hộp tự gen       4        28000       KLQD013
                      KLU14              Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             60000        30000       600     chiếc    hộp tự gen       3        180000      KLQD014
                      KLU15              Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       KLQD015
                      KLU16              Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             7000         5000        150     cái      hộp tự gen       4        28000       KLQD016
                      KLU17              Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      KLQD017
                      KLU18              Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             5000         2000        200     chiếc    hộp tự gen       3        15000       KLQD018
                      KLU19              Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       100     chiếc    hộp tự gen       3        180000      KLQD019
                      KLU20              Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             5000         2000        0       chiếc    hộp tự gen       3        15000       KLQD020

DTH_PM                [Tags]             DTH
                      [Template]         Add product incl 1 unit thrAPI
                      DTPMU01            Bia Larue Special (330ml/Lon)                                   Kho1                  7000         5000        1200    cái      hộp tự gen       4        28000       QDPMU01
                      DTPMU02            Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Kho1                  60000        30000       0       chiếc    hộp tự gen       3        180000      QDPMU02

Cong_no_KH            [Tags]             PBCNKH
                      [Template]         Add product incl 2 units thrAPI
                      CNKHU01            Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Kho1                  7000         5000        30      cái      hộp tự chọn      4        0           QDCNKH01    hộp thập phân    5.5      38500        QDCNKH02
                      CNKHU02            Chocolate Sữa Vietnamcacao 1                                    Kho1                  7000         5000        30      cái      hộp tự chọn      4        0           QDCNKH03    hộp thập phân    5.5      38500        QDCNKH04
                      CNKHU03            Chocolate Sữa Vietnamcacao 2                                    Kho1                  7000         5000        30      cái      hộp tự chọn      4        0           QDCNKH05    hộp thập phân    5.5      38500        QDCNKH06
                      CNKHU04            Chocolate Sữa Vietnamcacao 3                                    Kho1                  7000         5000        30      cái      hộp tự chọn      4        0           QDCNKH07    hộp thập phân    5.5      38500        QDCNKH08

Bao hanh bao tri      [Tags]             BHBT
                      [Template]         Add produt incl 2 unit have guarantess
                      DVTBH01            Hàng đvt bảo hành 01                                            Bảo hành - bảo trì    70000        25000       1200    cái      hộp tự gen       4        280000      QDBH01      hộp thập phân    5.5      385000       QDBH02      50             1        3        2
                      DVTBH02            Hàng đvt bảo hành 02                                            Bảo hành - bảo trì    60000        30000       0       chiếc    hộp tự gen       3        180000      QDBH03      hộp thập phân    5.5      330000       QDBH04      12             2        45       1
                      DVTBH03            Hàng đvt bảo hành 03                                            Bảo hành - bảo trì    50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBH05      hộp thập phân    5.5      275000       QDBH06      2              3        1        3
                      DVTBH04            Hàng đvt bảo hành 04                                            Bảo hành - bảo trì    70000        25000       1200    cái      hộp tự gen       4        280000      QDBH07      hộp thập phân    5.5      385000       QDBH08      60             1        1        2
                      DVTBH05            Hàng đvt bảo hành 05                                            Bảo hành - bảo trì    60000        30000       0       chiếc    hộp tự gen       3        180000      QDBH09      hộp thập phân    5.5      330000       QDBH10      24             2        1        3
                      DVTBH06            Hàng đvt bảo hành 06                                            Bảo hành - bảo trì    50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBH11      hộp thập phân    5.5      275000       QDBH12      1              3        60       1

Hàng ĐVT bán trực tiếp
                      [Tags]             BTT
                      [Template]         Add product incl 2 units for allow sale
                      BTT01              Hàng đvt bán trực tiếp 01                                       Hạt nhập khẩu         70000        25000       1200    cái      hộp tự gen       4        280000      QDBTT01     hộp thập phân    5.5      385000       QDBTT02     false          true     false
                      BTT02              Hàng đvt bán trực tiếp 02                                       Hạt nhập khẩu         60000        30000       0       chiếc    hộp tự gen       3        180000      QDBTT03     hộp thập phân    5.5      330000       QDBTT04     true           false    false
                      BTT03              Hàng đvt bán trực tiếp 03                                       Hạt nhập khẩu         50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBTT05     hộp thập phân    5.5      275000       QDBTT06     false          false    true
                      BTT04              Hàng đvt bán trực tiếp 04                                       Hạt nhập khẩu         70000        25000       1200    cái      hộp tự gen       4        280000      QDBTT07     hộp thập phân    5.5      385000       QDBTT08     false          true     true
                      BTT05              Hàng đvt bán trực tiếp 05                                       Hạt nhập khẩu         60000        30000       0       chiếc    hộp tự gen       3        180000      QDBTT09     hộp thập phân    5.5      330000       QDBTT10     true           true     false
                      BTT06              Hàng đvt bán trực tiếp 06                                       Hạt nhập khẩu         50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBTT11     hộp thập phân    5.5      275000       QDBTT12     true           false    true
                      BTT07              Hàng đvt bán trực tiếp 07                                       Hạt nhập khẩu         70000        25000       1200    cái      hộp tự gen       4        280000      QDBTT13     hộp thập phân    5.5      385000       QDBTT14     false          true     false
                      BTT08              Hàng đvt bán trực tiếp 08                                       Hạt nhập khẩu         60000        30000       0       chiếc    hộp tự gen       3        180000      QDBTT15     hộp thập phân    5.5      330000       QDBTT16     true           false    false
                      BTT09              Hàng đvt bán trực tiếp 09                                       Hạt nhập khẩu         50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBTT17     hộp thập phân    5.5      275000       QDBTT18     false          false    true
                      BTT10              Hàng đvt bán trực tiếp 10                                       Hạt nhập khẩu         70000        25000       1200    cái      hộp tự gen       4        280000      QDBTT19     hộp thập phân    5.5      385000       QDBTT20     false          true     true
                      BTT11              Hàng đvt bán trực tiếp 11                                       Hạt nhập khẩu         60000        30000       0       chiếc    hộp tự gen       3        180000      QDBTT21     hộp thập phân    5.5      330000       QDBTT22     true           true     false
                      BTT12              Hàng đvt bán trực tiếp 12                                       Hạt nhập khẩu         50000        20000       1200    chiếc    hộp tự gen       3        150000      QDBTT23     hộp thập phân    5.5      275000       QDBTT24     true           false    true

Import-export         [Tags]             IP                                                              EB1
                      [Template]         Add product incl 1 unit thrAPI
                      DVTI01             Kem milo                                                        Hạt nhập khẩu         70000        25000       1200    cái      hộp tự gen       4        280000      QDI001
                      DVTI02             Kem marino                                                      Hạt nhập khẩu         60000        30000       0       chiếc    hộp tự gen       3        180000      QDI002

EDU_2dvt_update2      [Tags]
                      [Template]         Add product incl 2 units thrAPI
                      DVT115             Kem sữa Elle & Vire hộp 1L                                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD208       hộp thập phân    5.5      385000       QD209
                      DVT116             Kem nấu tiệt trùng Anchor hộp 1L                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD210       hộp thập phân    5.5      330000       QD211
                      DVT117             Kem khoai môn Cremo hộp 450g                                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD212       hộp thập phân    5.5      275000       QD213
                      DVT118             Kem ốc quế Chocolate & Cookies LaBeaute Lavelee                 Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD214       hộp lớn          10       700000       QD215
                      DVT119             Kem sữa Elle&Vire vani                                          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD216       hộp lớn          6        420000       QD217
                      DVT120             Kem xoài 30% Lavelee Ice Bar                                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD218       hộp lớn          6        500000       QD219
                      DVT121             Kem sữa chua việt quất Lavelee                                  Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD220       hộp thập phân    5.5      385000       QD221
                      DVT122             Sữa chua hoa quả Le Petit Plaisir Bauer vỉ 6 hộp x 50g          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD222       hộp thập phân    5.5      330000       QD223
                      DVT123             Sữa chua uống lên men hương tự nhiên Betagen chai 700ml         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD224       hộp thập phân    5.5      275000       QD225
                      DVT124             Váng sữa uống hương vani Zott Monte lốc 4 chai x 95ml           Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QD226       hộp thập phân    5.5      330000       QD227
                      DVT125             Phô mai tươi trái cây Helio vị vani - dâu lốc 4 hộp x 50g       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QD228       hộp thập phân    5.5      275000       QD229

EDU_1dvt_update3      [Tags]
                      [Template]         Add product incl 1 unit thrAPI
                      DVT162             Bánh xu kem Nhật                                                Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD001
                      DVT163             Ô mai chanh đào Hồng Lam                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD002
                      DVT164             Sữa đặc nguyên kem ít béo MIOD                                  Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD003
                      DVT165             Bánh gà                                                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD004
                      DVT166             Kem milo                                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD005
                      DVT167             Kem marino                                                      Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD006
                      DVT168             Bánh Orion Chocopie Dark vị Cacao                               Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD007
                      DVT169             Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD008
                      DVT170             Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD009
                      DVT171             Sữa Quasure Light Bibica                                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD010
                      DVT172             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD011
                      DVT173             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD012
                      DVT174             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD013
                      DVT175             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD014
                      DVT176             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD015
                      DVT177             Bánh Yến Mạch + gạo lức Fine                                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD016
                      DVT178             Kẹo Không Đường Kopiko F40KOP                                   Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD017
                      DVT179             Kẹo Ngậm Không Đường Jila                                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD018
                      DVT180             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD019
                      DVT181             Kẹo Gừng Gingerbon                                              Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD020
                      DVT182             Sing Gum Không Đường Mentos Pure Fresh                          Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD021
                      DVT183             Socola KitKat Trà Xanh 4F                                       Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD022
                      DVT184             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD023
                      DVT185             Kẹo Golia Activ Plus                                            Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD024
                      DVT186             Kẹo Kalfany K150BH - Vị Bạc Hà                                  Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD025
                      DVT187             Snack Poca Khoai Tây Vị Sườn Nướng BBQ                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD026
                      DVT188             Snack Lays Stax Thái Vị Tự Nhiên                                Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD027
                      DVT189             Snack rong biển Tao Kae Noi Tempura vị Cay                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD028
                      DVT190             Khay 20 Gói Bánh Solite Swissroll Vị Dâu - Kinh Đô (360g)       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD029
                      DVT191             Kẹo Hồng Sâm Vitamin Daegoung Food                              Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD030
                      DVT192             Sữa Quasure Light Bibica                                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD031
                      DVT193             Túi 8 Bánh Socola Kitkat Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD032
                      DVT194             Kẹo Gum Không Đường Trident Hương Dưa Hấu                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD033
                      DVT195             Kẹo Golia Activ Plus (Gói 3 Thỏi)                               Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD034
                      DVT196             Bánh Hura Hương Cốm Hộp Demi Bibica                             Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD035
                      DVT197             Kẹo Alpenliebe Hương Dâu Kem                                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD036

EDU_2dvt_taohoadon    [Tags]
                      [Template]         Add product incl 2 units thrAPI
                      DVT199             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD038      hộp thập phân    5.5      385000       QDD039
                      DVT200             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD040      hộp thập phân    5.5      330000       QDD041
                      DVT201             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD042      hộp thập phân    5.5      275000       QDD043
                      DVT202             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD044      hộp lớn          10       700000       QDD045
                      DVT203             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD046      hộp lớn          6        420000       QDD047
                      DVT204             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD048      hộp lớn          6        500000       QDD049
                      DVT205             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD050      hộp thập phân    5.5      385000       QDD051
                      DVT206             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD052      hộp thập phân    5.5      330000       QDD053
                      DVT207             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD054      hộp thập phân    5.5      275000       QDD055
                      DVT208             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD056      hộp thập phân    5.5      330000       QDD057
                      DVT209             Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD058      hộp thập phân    5.5      275000       QDD059
                      DVT210             Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD060      hộp thập phân    5.5      385000       QDD061
                      DVT211             Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD062      hộp thập phân    5.5      330000       QDD063
                      DVT212             Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD064      hộp thập phân    5.5      275000       QDD065
                      DVT213             Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD066      hộp lớn          10       700000       QDD067
                      DVT214             Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD068      hộp lớn          6        420000       QDD069
                      DVT215             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD070      hộp lớn          6        500000       QDD071
                      DVT216             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD073      hộp thập phân    5.5      385000       QDD074
                      DVT217             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD075      hộp thập phân    5.5      330000       QDD076
                      DVT218             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD077      hộp thập phân    5.5      275000       QDD078
                      DVT219             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD079      hộp thập phân    5.5      330000       QDD080
                      DVT220             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD081      hộp thập phân    5.5      275000       QDD082
                      DVT221             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD083      hộp thập phân    5.5      385000       QDD084
                      DVT222             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD085      hộp thập phân    5.5      330000       QDD086
                      DVT223             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD087      hộp thập phân    5.5      275000       QDD088
                      DVT224             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD089      hộp lớn          10       700000       QDD090
                      DVT225             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD091      hộp lớn          6        420000       QDD092
                      DVT226             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD093      hộp lớn          6        500000       QDD094
                      DVT227             Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD095      hộp thập phân    5.5      385000       QDD096
                      DVT228             Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD097      hộp thập phân    5.5      330000       QDD098
                      DVT229             Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD099      hộp thập phân    5.5      275000       QDD100
                      DVT230             Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD101      hộp thập phân    5.5      330000       QDD102
                      DVT231             Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD103      hộp thập phân    5.5      275000       QDD104
                      DVT232             Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD105      hộp thập phân    5.5      385000       QDD106
                      DVT233             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD107      hộp thập phân    5.5      330000       QDD108
                      DVT234             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD109      hộp thập phân    5.5      275000       QDD110
                      DVT235             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD111      hộp lớn          10       700000       QDD112
                      DVT236             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD113      hộp lớn          6        420000       QDD114
                      DVT237             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD115      hộp lớn          6        500000       QDD116
                      DVT238             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD117      hộp thập phân    5.5      385000       QDD118
                      DVT239             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD119      hộp thập phân    5.5      330000       QDD120
                      DVT240             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD121      hộp thập phân    5.5      275000       QDD122
                      DVT241             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD123      hộp thập phân    5.5      330000       QDD124
                      DVT242             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD125      hộp thập phân    5.5      275000       QDD126
                      DVT243             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD127      hộp thập phân    5.5      385000       QDD128
                      DVT244             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD129      hộp thập phân    5.5      330000       QDD130
                      DVT245             Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD131      hộp thập phân    5.5      275000       QDD132
                      DVT246             Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD133      hộp lớn          10       700000       QDD134
                      DVT247             Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD135      hộp lớn          6        420000       QDD136
                      DVT248             Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD137      hộp lớn          6        500000       QDD138
                      DVT249             Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD139      hộp thập phân    5.5      385000       QDD140
                      DVT250             Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD141      hộp thập phân    5.5      330000       QDD142
                      DVT251             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD143      hộp thập phân    5.5      275000       QDD144
                      DVT252             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD145      hộp thập phân    5.5      330000       QDD146
                      DVT253             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD147      hộp thập phân    5.5      275000       QDD148
                      DVT254             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD149      hộp thập phân    5.5      385000       QDD150
                      DVT255             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD151      hộp thập phân    5.5      330000       QDD152
                      DVT256             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD153      hộp thập phân    5.5      275000       QDD154
                      DVT257             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD155      hộp lớn          10       700000       QDD156
                      DVT258             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD157      hộp lớn          6        420000       QDD158
                      DVT259             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD159      hộp lớn          6        500000       QDD160
                      DVT260             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD161      hộp thập phân    5.5      385000       QDD162
                      DVT261             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD163      hộp thập phân    5.5      330000       QDD164
                      DVT262             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD165      hộp thập phân    5.5      275000       QDD166
                      DVT263             Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD167      hộp thập phân    5.5      330000       QDD168
                      DVT264             Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD169      hộp thập phân    5.5      275000       QDD170
                      DVT265             Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD171      hộp thập phân    5.5      385000       QDD172
                      DVT266             Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD173      hộp thập phân    5.5      330000       QDD174
                      DVT267             Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD175      hộp thập phân    5.5      275000       QDD176
                      DVT268             Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD177      hộp lớn          10       700000       QDD178
                      DVT269             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD179      hộp lớn          6        420000       QDD180
                      DVT270             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD181      hộp lớn          6        500000       QDD182
                      DVT271             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD183      hộp thập phân    5.5      385000       QDD184
                      DVT272             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD185      hộp thập phân    5.5      330000       QDD186
                      DVT273             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD187      hộp thập phân    5.5      275000       QDD188
                      DVT274             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD189      hộp thập phân    5.5      330000       QDD190
                      DVT275             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD191      hộp thập phân    5.5      275000       QDD192
                      DVT276             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD193      hộp thập phân    5.5      385000       QDD194
                      DVT277             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD195      hộp thập phân    5.5      330000       QDD196
                      DVT278             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD197      hộp thập phân    5.5      275000       QDD198
                      DVT279             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD199      hộp lớn          10       700000       QDD200
                      DVT280             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD201      hộp lớn          6        420000       QDD202
                      DVT281             Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD203      hộp lớn          6        500000       QDD204
                      DVT282             Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD205      hộp thập phân    5.5      385000       QDD206
                      DVT283             Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD207      hộp thập phân    5.5      330000       QDD208
                      DVT284             Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD209      hộp thập phân    5.5      275000       QDD210
                      DVT285             Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD211      hộp thập phân    5.5      330000       QDD212
                      DVT286             Kẹo Foxs Hương Bạc Hà                                           Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD213      hộp thập phân    5.5      275000       QDD214
                      DVT287             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD215      hộp thập phân    5.5      385000       QDD216
                      DVT288             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD217      hộp thập phân    5.5      330000       QDD218
                      DVT289             Kẹo Gum Không Đường Trident                                     Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD219      hộp thập phân    5.5      275000       QDD220
                      DVT290             Bánh Chocolate KitKat Bites                                     Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD221      hộp lớn          10       700000       QDD222
                      DVT291             Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD223      hộp lớn          6        420000       QDD224
                      DVT292             Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD225      hộp lớn          6        500000       QDD226
                      DVT293             Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD227      hộp thập phân    5.5      385000       QDD228
                      DVT294             Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD229      hộp thập phân    5.5      330000       QDD230
                      DVT295             Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD231      hộp thập phân    5.5      275000       QDD232
                      DVT296             Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD233      hộp thập phân    5.5      330000       QDD234
                      DVT297             Bánh quy nhân sầu riêng                                         Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD235      hộp thập phân    5.5      275000       QDD236
                      DVT298             Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QDD237      hộp thập phân    5.5      275000       QDD238
                      DVT299             Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             70000        25000       1200    cái      hộp tự gen       4        280000      QDD239      hộp thập phân    5.5      330000       QDD240
                      DVT300             Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             60000        30000       0       chiếc    hộp tự gen       3        180000      QDD241      hộp thập phân    5.5      275000       QDD242

Test                  [Tags]
                      [Template]         Add product incl 2 units thrAPI
                      DVT123             Sữa chua uống lên men hương tự nhiên Betagen chai 700ml         Đồ ăn vặt             50000        20000       0       chiếc    hộp tự gen       3        150000      QD224       hộp thập phân    5.5      275000       QD225

NHND                  [Tags]             NHND
                      [Template]         Add product incl 1 unit thrAPI
                      NHMU001            Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       NHMQD001
                      NHMU002            Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       80      chiếc    lốc              3        180000      NHMQD002
                      NHMU003            Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       NHMQD003
                      NHMU004            Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       NHMQD004
                      NHMU005            Bánh Cuộn Yuki & Love Whole Grains Energy                       Đồ ăn vặt             60000        30000       800      chiếc    lốc              3        180000      NHMQD005
                      NHMU006            Bánh Chocolate KitKat 4F Thanh 34g                              Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       NHMQD006
                      NHMU007            Bánh quy nhân sầu riêng                                         Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       NHMQD007
                      NHMU008            Kẹo Gừng Chanh Mật Ong Gingerbon                                Đồ ăn vặt             60000        30000       80      chiếc    lốc              3        180000      NHMQD008
                      NHMU009            Kẹo Thảo Mộc Alpin Fresh Ricola                                 Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       NHMQD009
                      NHMU010            Bánh Quy Socola Phủ Đường Barilla                               Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       NHMQD010
                      NHMU011            Kẹo Cao Su Thổi Big Babol                                       Đồ ăn vặt             60000        30000       80      chiếc    lốc              3        180000      NHMQD011
                      NHMU012            Kẹo Dẻo Haribo Goldbears                                        Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       NHMQD012
                      NHMU013            Bánh Snack Khoai Tây Angry Birds Vị Muối                        Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       NHMQD013
                      NHMU014            Kẹo dẻo FINI Cola 100g                                          Đồ ăn vặt             60000        30000       80      chiếc    lốc              3        180000      NHMQD014
                      NHMU015            Bắp Rang Bơ Cheetos Popcorn Caramel 57g                         Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       NHMQD015

Gộp hóa đơn           [Tags]             GHD
                      [Template]         Add product incl 1 unit thrAPI
                      GHDU001            Bia Larue Special (330ml/Lon)                                   Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       GHDUQD001
                      GHDU002            Bánh Milano Vị Bạc Hà Pepperidge Farm (198g)                    Đồ ăn vặt             60000        30000       80      chiếc    lốc              3        180000      GHDUQD002
                      GHDU003            Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                         Đồ ăn vặt             5000         2000        80      chiếc    lốc              3        15000       GHDUQD003
                      GHDU004            Chocolate Sữa Vietnamcacao                                      Đồ ăn vặt             7000         5000        80      cái      lốc              4        28000       GHDUQD004
                      GHDU005            Bánh Cuộn Yuki & Love Whole Grains Energy                       Dịch vụ KM             60000        30000       800      chiếc    lốc              3        180000     GHDUQD005
                      GHDU006            Bánh Chocolate KitKat 4F Thanh 34g                              Dịch vụ KM             5000         2000        80      chiếc    lốc              3        15000       GHDUQD006

HH 2 don vi tinh      [Tags]             GDH
                      [Template]         Add product incl 2 units thrAPI
                      DVT301             Kẹo Quasure Light Cherry                                        Đồ ăn vặt             7000         5000        1200    cái      hộp tự chọn      4        0           QD243       hộp thập cẩm    5.5      38500        QD245
                      DVT302             Túi 3 Bánh Socola Custas Trà Xanh SB                            Đồ ăn vặt             60000        30000       0       chiếc    hộp tự chọn      3        0           QD244       hộp thập cẩm    5.5      330000       QD246

HHKK 2 don vi tinh      [Tags]             HHKK
                        [Template]         Add product incl 2 units thrAPI
                        DVTKK0001          Kẹo Quasure Light Cherry                                    Kiểm kho API             7000         5000       1200    cái      hộp tự chọn      4        0        QDKK0001      hộp thập cẩm    5.5      38500       QDKK0002
                        DVTKK0002          Túi 3 Bánh Socola Custas Trà Xanh SB                        Kiểm kho API            60000        30000       0       chiếc    hộp tự chọn      3        0         QDKK0003       hộp thập cẩm    5.5      330000     QDKK0004

*** Keywords ***
Add produt incl 2 unit have guarantess
    [Arguments]    ${mahh}    ${ten_hh}    ${ten_nhom}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${tendv2}
    ...    ${gtqd2}    ${giaban2}    ${ma_hh2}    ${time_bh}    ${timetype_bh}    ${time_bt}
    ...    ${timetype_bt}
    ${get_product_id1}    ${get_product_id2}    ${get_product_id3}    Add product incl 2 units have guarantee    ${mahh}    ${ten_hh}    ${ten_nhom}
    ...    ${giaban}    ${giavon}    ${ton}    ${dvcb}    ${tendv1}    ${gtqd1}
    ...    ${giaban1}    ${ma_hh1}    ${tendv2}    ${gtqd2}    ${giaban2}    ${ma_hh2}
    ...    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    Save unit procut guarantee after create product    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}    ${get_product_id1}    ${get_product_id2}
    ...    ${get_product_id3}
