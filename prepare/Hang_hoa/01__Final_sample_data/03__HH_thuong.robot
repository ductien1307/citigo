*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ma SP                            Ten sp                                                        Nhom hang             Gia ban       Gia von     Ton
EBT                   [Tags]                           EBT                                                           EB
                      [Template]                       Add product and wait
                      ## EBT
                      PIB10001                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10002                         Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      PIB10003                         Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      PIB10004                         Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      PIB10005                         Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              89044.895     30000       0       # gia ban tp
                      PIB10006                         Kem whipping cream Anchor                                     Kẹo bánh              20025.459     35000       0       # gia ban tp
                      PIB10007                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10008                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      PIB10009                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am

CBPP                  [Tags]                           EB
                      [Template]                       Add product and wait
                      PIB10010                         Bánh xu kem Nhật                                              Máy KM                100000        50000       1200
                      PIB10011                         Bánh xu kem Nhật                                              Máy KM                998899.45     50000       0
                      PIB10018                         Kem gấu TH true milk                                          Kẹo bánh              1200000       35000       0       #ton am
                      PIB10019                         Trà sữa Royal tea mix Myanma                                  Kẹo bánh              790990.78     50000       1200
                      PIB10028                         Trà sữa Royal tea mix Myanma                                  Bánh nhập KM          95600         50000       1200

ETTHN                 [Tags]                           ETTHN                                                         EB1
                      [Template]                       Add product and wait
                      PIB10012                         Bánh xu kem Nhật                                              KM hàng               70000         49954.34    0
                      PIB10013                         Bánh xu kem Nhật                                              KM hàng               70000         60000       0

VO                    [Tags]                           EB
                      [Template]                       Add product and wait
                      PIB10014                         Bánh xu kem Nhật                                              KM hàng               70000         50000       0
                      PIB10015                         Bánh xu kem Nhật                                              KM hàng               70000         50000       0       #ton am
                      PIB10016                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10017                         Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0

CBTK                  [Tags]                           EB1
                      [Template]                       Add product and wait
                      PIB10029                         Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              50000         30000       0
                      PIB10030                         Kem whipping cream Anchor                                     Kẹo bánh              76455.65      35000       0       #ton am

UEBM                  [Tags]                           UEBM                                                          EB1
                      [Template]                       Add product and wait
                      PIB10031                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10032                         Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      PIB10033                         Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am

CBPPI                 [Tags]                           CBPPI                                                         EB1
                      [Template]                       Add product and wait
                      PIB10034                         Máy ẩm không khí                                              KM HĐ HH              1289999.48    500000      1200
                      PIB10035                         Máy đánh trứng tự động                                        KM HĐ HH              950000        300000      0

PM                    [Tags]                           PM                                                            EB1
                      [Template]                       Add product and wait
                      PIB01                            Máy ẩm không khí                                              Văn phòng phẩm        2289999.78    500000      1200

CON_PROMO_TK          [Tags]                           CONPROTK                                                      EB1
                      [Template]                       Add product and wait
                      PIB10036                         Kem whipping cream Anchor                                     KM HĐ HH              0             0           0
                      PHH01                            Kẹo dẻo                                                       KM Hàng tặng          0             0           0

EKG                   [Tags]                           EKG                                                           EB1
                      [Template]                       Add product and wait
                      PIB02                            Máy ẩm không khí                                              Kiểm kho Nhóm         2289999.78    500000      1200

ECG                   [Tags]                           ECG                                                           EB1
                      [Template]                       Add product and wait
                      PIB03                            Máy ẩm không khí                                              Chuyển Nhóm           890000        500000      1200

Import-export         [Tags]                           IP                                                            EB1
                      [Template]                       Add product and wait
                      PIB04                            Hộp đựng quà                                                  Hạt nhập khẩu         89000         50000       1200
                      PIB05                            Giỏ đựng quà                                                  Hạt nhập khẩu         120000        50000       1200

CBP_gift              [Tags]                           EB
                      [Template]                       Add product and wait
                      NK001                            Hạt tặng 1                                                    Hạt nhập khẩu KM      82000         2000        0
                      NK002                            Hạt tặng 2                                                    Hạt nhập khẩu KM      90000         20000       1200

Khuyen_mai_gop        [Tags]                           EDPROMO
                      [Template]                       Add product and wait
                      HKM003                           Hàng khuyến mại 1                                             KM HĐ HH              195000        300000      0
                      HKM004                           Hàng khuyến mại 2                                             KM HĐ HH              1550000.45    300000      0
                      ##thu khac
                      HKM005                           Hàng khuyến mại 3                                             KM HĐ HH              0             0           0
                      HKM006                           Hàng khuyến mại 4                                             KM Hàng tặng          300000        0           0

Khuyen_mai            [Tags]                           EDPROMO
                      [Template]                       Add product thr API
                      PROMO1                           Kẹo Mút Chupa Chups Hương Trái Cây                            Máy KM                35000         10000       100
                      PROMO2                           Bánh Trứng Tik-Tok Sầu Riêng                                  Máy KM                59000         0           0
                      PROMO3                           Bánh Trứng Tik-Tok Bơ Sữa (120g)                              Bánh nhập KM          19000.02      10000       0       #GGSP
                      PROMO4                           Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g                  Kẹo bánh              2500000       0           100
                      PROMO5                           Túi 8 Bánh Socola Kitkat Trà Xanh SB                          Bánh nhập KM          1000000       300000      0
                      HH0034                           Trà sữa Royal tea mix Myanma                                  Bánh nhập KM          0             50000       1200
                      HH0035                           Kem Hàn Quốc trà xanh XXXD                                    Bánh nhập KM          60000         30000       0
                      HH0036                           Kem whipping cream Anchor                                     Bánh nhập KM          65000         35000       0       #ton am
                      ##gift
                      HKM001                           Gói 6 Thanh Bánh Socola KitKat 2F 17g                         Hạt nhập khẩu KM      35000         0           0
                      HKM002                           Kẹo Hồng Sâm Vitamin Daegoung Food                            Hạt nhập khẩu KM      34000.02      10000       100

Khuyen_mai_phamvi_apdung
                      [Tags]                                                                PROMOTION
                      [Template]                       Add product thr API
                      HTKM01                           Hàng KM theo phạm vi 1                                        Máy KM                500000        200000      1000
                      HTKM02                           Hàng KM theo phạm vi 2                                        Máy KM                510000        200000      1000
                      HTKM03                           Hàng KM theo phạm vi 3                                        KM Hàng tặng          520000        200000      1000
                      HTKM04                           Hàng KM theo phạm vi 4                                        KM Hàng tặng          530000        200000      1000

Dat hang thuong       [Tags]                           EDH
                      [Template]                       Add product thr API
                      HH0040                           Kẹo Mút Chupa Chups Hương Trái Cây                            Kẹo bánh              35000         10000       100
                      HH0041                           Bánh Trứng Tik-Tok Sầu Riêng                                  Kẹo bánh              19000         0           0
                      HH0042                           Bánh Trứng Tik-Tok Bơ Sữa (120g)                              Kẹo bánh              19000.02      10000       0       #GGSP
                      HH0043                           Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g                  Kẹo bánh              38000         0           100
                      HH0044                           Túi 8 Bánh Socola Kitkat Trà Xanh SB                          Kẹo bánh              64000.02      10000       0
                      HH0045                           Gói 6 Thanh Bánh Socola KitKat 2F 17g                         Kẹo bánh              35000         0           0
                      HH0046                           Kẹo Hồng Sâm Vitamin Daegoung Food                            Kẹo bánh              34000.02      10000       100
                      HH0047                           Bánh Chocolate Kem Marshmallow Phaner Pie                     Kẹo bánh              36000         0           0
                      HH0048                           Túi 12 Thanh Socola KitKat 2F (Thanh 17g)                     Kẹo bánh              65000.02      10000       0
                      HH0049                           Kẹo Gừng Gingerbon Hộp 620g                                   Kẹo bánh              59000         0           100
                      HH0050                           Kẹo Chanh & Bạc Hà Ricola F122672 (40g)                       Kẹo bánh              30000.02      10000       0
                      HH0051                           Kẹo Cay Con Tàu Fishermans Friend Vị Cam                      Kẹo bánh              18900         0           0
                      HH0052                           Bánh Pía Sầu Riêng Truly Vietnam Có Trứng                     Kẹo bánh              105000.02     10000       100
                      HH0053                           Bánh Yến Mạch + mè đen Fine                                   Kẹo bánh              45000         0           0
                      HH0054                           Socola Viên Milo Nuggets (30g)                                Kẹo bánh              13900.02      10000       0
                      HH0055                           Kẹo Foxs Hương Bạc Hà Hộp 180g                                Kẹo bánh              39000.02      0           100
                      HH0056                           Snack Mực Tẩm Gia Vị Cay Ngọt Bento (24g)                     Kẹo bánh              25000         10000       0
                      HH0057                           Combo 3 Hộp Kẹo Tic Tac Hương Vị Bạc Hà Lục                   Kẹo bánh              29000         0           0
                      HH0058                           Socola Kinder Joy Dành Cho Bé Trai (20g)                      Kẹo bánh              23000.02      10000       100

Thu khac_DH              [Tags]                           EDH
                      [Template]                       Add product thr API
                      HH0059                           Kẹo Cay Con Tàu Fisherman Friend                              Kẹo bánh              18900         0           0
                      HH0060                           Kẹo Dẻo Haribo Goldbears (100g)                               Kẹo bánh              29000.02      10000       0
                      HH0061                           Hộp 3 Kẹo Socola Kinder Cho Bé Gái                            Kẹo bánh              66000         10000       0
                      HH0062                           Hộp 3 Kẹo Socola Kinder Cho Bé Trai                           Kẹo bánh              66000         0           0
                      HH0063                           Bánh Mcvities Digestive Dark Chocolate                        Kẹo bánh              0             10000       100
                      HH0064                           Bánh Yến Mạch + gạo lức Fine                                  Kẹo bánh              45000         0           0


Shop config
                      [Tags]                           EDH      TL
                     [Template]                       Add product thr API
                      HH0065                           Kẹo Cay Con Tàu Fisherman Friend Vị Bạc Hà                    Kẹo bánh              18900.03      10000       0

Remain
                      [Tags]
                     [Template]                       Add product thr API
                      HH0066                           Snack Lay Stax Thái Vị Tôm Hùm Nướng 110g                     Kẹo bánh              28000         0           100
                      HH0067                           Kẹo Mềm Alpenliebe 2Chew Hương Nho                            Kẹo bánh              12000         10000       0
                      HH0068                           Socola KitKat Bites Gói 100g                                  Kẹo bánh              35000.45      0           100
                      HH0069                           Lốc 12 Gói Snack Mực Tẩm Gia Vị Cay Bento                     Kẹo bánh              78000         10000       0
                      HHD070                           Cơm cháy kho quẹt                                             Kẹo bánh              109999.56     50000       0
                      HHD071                           Socola KitKat Bites Gói 100g                                  Kẹo bánh              55000.45      0           0
                      HHD072                           Kẹo dẻo nhiều vị                                              Kẹo bánh              29999.99      10000       2
                      HHD073                           Trà sữa Royal                                                 Kẹo bánh              150000.99     100000      500
                      HHD074                           Ổi sấy                                                        Kẹo bánh              25999.35      10000       50
                      HH0070                           Kẹo Dẻo Haribo Peaches (80g)                                  Kẹo bánh              25000         10000       100
                      HH0071                           Bánh quy Resoni - Thực phẩm chức năng                         Kẹo bánh              26000         11000       0
                      HH0072                           Socola Sữa Nhân Nho Khô Và Hạt Dẻ Ritter                      Kẹo bánh              27000         12000       0
                      HH0073                           Snack Mực Tẩm Gia Vị Cay Bento (24g)                          Kẹo bánh              28000         13000       100
                      HH0074                           Bánh Trứng No Brand 250g                                      Kẹo bánh              29000         14000       0
                      HH0075                           Kẹo trái cây FINI Beans 90g                                   Kẹo bánh              30000         15000       0
                      HH0076                           Socola Kitkat Bites Vị Trà Xanh (30g)                         Kẹo bánh              31000.32      16000       100
                      HH0077                           Kẹo Nhai Mentos Bạc Hà (Gói 3 Thỏi)                           Kẹo bánh              32000         17000       0

Optimize              [Tags]                           OPT
                      [Template]                       Add product thr API
                      HHTK01                           Socola KitKat Bites Gói 100g                                  Kẹo bánh              5566.45       2000        50

Tra hang              [Tags]                           EDH
                      [Template]                       Add product thr API
                      HH0078                           Bánh Quế Vị Socola Hạt Dẻ Pirouette                           Kẹo bánh              33000         18000       0
                      HH0079                           Bánh Xốp Classic Kem Cacao Loacker (45g)                      Kẹo bánh              34000.18      19000       100
                      HH0080                           Snack rong biển Tao Kae Noi Crispy Seaweed                    Kẹo bánh              35000         20000       0
                      HH0081                           Bánh Snack Ăn Dặm Cho Bé Pigeon (14g)                         Kẹo bánh              36000         21000       0
                      HH0082                           Kẹo Cao Su Thổi Big Babol (Hũ 70 Viên)                        Kẹo bánh              37000         22000       100
                      HH0083                           Socola Đen Nhân Hạt Dẻ Ritter Sport (100g)                    Kẹo bánh              38000.54      23000       0
                      HH0084                           Socola Lindt Swiss Classic Đen (100g)                         Kẹo bánh              39000         24000       0

Doi Tra hang          [Tags]                           EDH
                      [Template]                       Add product thr API
                      HH0085                           Bánh Cupcake - Bơ Sữa (75g)                                   Kẹo bánh              40000         25000       100
                      HH0086                           Kẹo Nhai Mentos Tí Hon Cầu Vồng (Gói 40 Thỏi)                 Kẹo bánh              41000.37      26000       0
                      HH0087                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              10000         5000        1500
                      HH0088                           Kẹo Dẻo Chupa Chups Cool Cola (Gói 90g)                       Kẹo bánh              43000         28000       100
                      HH0089                           Kẹo Ngậm Không Đường Mentos Pure Fresh                        Kẹo bánh              44000.58      29000       0
                      HH0090                           Kẹo Dẻo Haribo Happy Cola (80g)                               Kẹo bánh              45000         30000       0


Remain
                      HH0091                           Kẹo dẻo FINI Neon Bears 100g                                  Kẹo bánh              46000         31000       100
                      HH0092                           Bánh Quy Bơ La Dory Pettit Choco Socola Sữa                   Kẹo bánh              47000.09      32000       0
                      HH0093                           Kẹo Alpenliebe Cofitos Hương Cà Phê Đen                       Kẹo bánh              48000         33000       0
                      HH0094                           Sing Gum Happy Dent                                           Kẹo bánh              49000         34000       100
                      HH0095                           Bánh Hura Swissroll Hương Bơ Sữa Bibica.                      Kẹo bánh              50000         35000       0
                      HH0096                           Combo 3 thanh Kẹo Socola đen đắng 100% cacao                  Kẹo bánh              51000         36000       0
                      HH0097                           Combo 3 thanh Kẹo Socola đen đắng 85% cacao                   Kẹo bánh              52000.99      37000       100
                      HH0098                           Kẹo Sô cô la Andes Bạc Hà                                     Kẹo bánh              53000         38000       0
                      HH0099                           Poca Wavy Vị Cà Chua 52g(bich)                                Kẹo bánh              54000         39000       0
                      HH0100                           Bánh Chocopie Orion vị cacao hộp 360g                         Kẹo bánh              55000         40000       100
                      HH0101                           Bánh kem xốp phô mai Nabati hộp 20 gói x 17g                  Kẹo bánh              56000         41000       0
                      HH0102                           Bánh mochi đậu đỏ Royal Family gói 120g                       Kẹo bánh              57000         42000       0
                      HH0103                           Kẹo gum hương tổng hợp Dr. Xylitol Orion hộp 109.5g           Kẹo bánh              58000.31      43000       100
                      HH0104                           Bánh Choco-Pie Orion hộp 396g                                 Kẹo bánh              59000         44000       0
                      HH0105                           Bánh gạo vị ngọt Richy gói 315g                               Kẹo bánh              60000         45000       0
                      HH0106                           Bánh mè giòn tan Gouté Orion hộp 288g                         Kẹo bánh              61000.05      46000       100
                      HH0107                           Bánh Custas kem trứng Orion hộp 282g                          Kẹo bánh              62000         47000       0
                      HH0108                           Bánh Custas kem trứng Orion hộp 470g                          Kẹo bánh              63000         48000       0
                      HH0109                           Bánh quy Oreo kem vani hộp 352.8g                             Kẹo bánh              64000         49000       100
                      HH0110                           Bánh bông lan Solite Cappuccino 276g                          Kẹo bánh              65000.15      50000       0
                      HH0111                           Bánh ngũ cốc 21 vị Gaemi Food 80g                             Kẹo bánh              66000         51000       0
                      HH0112                           Bánh trứng Tipo Hữu Nghị hộp 250g                             Kẹo bánh              67000         52000       100
                      HH0113                           Bánh Tipo Hữu Nghị trà xanh hộp 90g                           Kẹo bánh              68000         53000       0
                      HH0114                           Bánh bơ trứng Richy gói 270g                                  Kẹo bánh              69000         54000       0
                      HH0115                           Snack Poca vị tảo biển Nori                                   Kẹo bánh              70000         55000       100
                      HH0116                           Bánh gạo One-One vị bò nướng                                  Kẹo bánh              71000.38      56000       0
                      HH0117                           Bánh gạo One-One Gold vị Phô mai ngô                          Kẹo bánh              72000         57000       0
                      HH0118                           Bánh gạo Nhật Ichi Kameda                                     Kẹo bánh              73000         58000       100
                      HH0119                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              74000         59000       0
                      HH0120                           Bánh xốp phô mai Cal Cheese Mayora                            Kẹo bánh              75000.76      60000       0
                      HH0121                           Nước yến sào cao cấp Sanest                                   Kẹo bánh              76000         61000       100
                      HH0122                           Kẹo hương bạc hà nhân sô cô la Dynamite Big Bang JacknJill    Kẹo bánh              77000.01      62000       0
                      HH0123                           Bánh trứng Belgi                                              Kẹo bánh              78000         63000       500
                      HH0124                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0125                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      HH0126                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      HH0127                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      HH0128                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              60000         30000       0
                      HH0129                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      HH0130                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0131                           Bánh Trứng No Brand 250g                                      Kẹo bánh              70000         50000       0
                      HH0132                           Kẹo trái cây FINI Beans 90g                                   Kẹo bánh              70000         50000       0       #ton am

Doi_tra_hang_khac          [Tags]                           DTH
                      [Template]                       Add product thr API
                      #thu khac
                      DTH001                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              10000         5000        1500
                      DTH002                           Bánh xốp phô mai Cal Cheese Mayora                            Kẹo bánh              11000         6000        0
                      DTH003                           Nước yến sào cao cấp Sanest                                   Kẹo bánh              12000         7000        0
                      DTH004                           Kẹo hương bạc hà nhân sô cô la Dynamite Big Bang JacknJill    Kẹo bánh              13000         8000        1500
                      DTH005                           Bánh trứng Belgi                                              Kẹo bánh              240000        9000        0
                      DTH006                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              70000         35000       0       #ton am
                      DTH007                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DTH008                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      #nhieu dong
                      DTH009                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DTH010                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DTH011                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              90000         30000       1500

ENT                   [Tags]                           EN
                      [Template]                       Add product and wait
                      NHP001                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP002                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHP003                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      NHP004                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      NHP005                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      NHP006                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      #### etebh2 and etebh3
                      NHP007                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP008                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      NHP009                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      #### etebh4 and etebh5
                      NHP010                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP011                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      NHP012                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      #### etebh6 to etebh9
                      NHP013                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP014                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      NHP015                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      #### etebh10
                      NHP016                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP017                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHP018                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      #### etebh11 to etebh12
                      NHP019                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP020                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHP021                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      ###
                      NHP022                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP023                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHP024                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      NHP025                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      NHP026                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      NHP027                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      ###
                      NHP028                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHP029                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHP030                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      NHP031                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      NHP032                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      NHP033                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am

ENT_Other                   [Tags]                           EN    TEST
                      [Template]                       Add product and wait
                      NHT01                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      NHT02                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      NHT03                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      NHT04                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200


DH_Nhieudong     [Tags]                           EDH
                      [Template]                       Add product and wait
                      HH0001                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0002                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      HH0003                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      HH0004                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      HH0005                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              60000         30000       0
                      HH0006                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      HH0007                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0008                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      HH0009                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      HH0010                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0011                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      HH0012                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      HH0013                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0014                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      HH0015                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      HH0016                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0017                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      HH0018                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      HH0019                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              70000         50000       1200
                      HH0020                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              60000         30000       0

DH_Nhieudong_khachle  [Tags]                           EDH
                      [Template]                       Add product and wait
                      HH0021                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              70000         35000       0       #ton am
                      HH0022                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0023                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      HH0024                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      HH0025                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0026                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0

Remain
                      HH0027                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      HH0028                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              90000         50000       1200
                      HH0029                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              50000         30000       0
                      HH0030                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      HH0031                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      HH0032                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      HH0033                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am

ECT                   [Tags]                           EMCT                                                          EB1
                      [Template]                       Add product and wait
                      PIB10020                         Trà sữa Royal tea mix Myanma                                  Kẹo bánh              59457.23      30000       1200
                      PIB10021                         Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              70000         35000       0       #ton am
                      PIB10022                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10023                         Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0

EKT                   [Tags]                           EMKT                                                          EB1
                      [Template]                       Add product and wait
                      PIB10024                         Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      PIB10025                         Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      PIB10026                         Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      PIB10027                         Kem gấu TH true milk                                          Kẹo bánh              68345.45      35000       0       #ton am

Nang cap chuyen hang
                      [Tags]                           NCCH                                                          EB1
                      [Template]                       Add product and wait
                      HHCH01                           Trà sữa Royal tea mix Myanma                                  Chuyển 1              59457.23      30000       1200
                      HHCH02                           Kem Hàn Quốc trà xanh XXXD                                    Chuyển 1              70000         35000       0       #ton am

EBG                   [Tags]                           EBG
                      [Template]                       Add product thr API
                      GHT0001                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      GHT0002                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      GHT0003                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0
                      GHT0004                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      GHT0005                          Kem Hàn Quốc trà xanh XXXD                                    Nhà cửa               44.895        30000       0
                      GHT0006                          Kem whipping cream Anchor                                     Văn phòng phẩm        25.459        35000       0
                      GHT0007                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      GHT0008                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      GHT0009                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0

EDN                   [Tags]                           EDN
                      [Template]                       Add product thr API
                      DNT001                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT002                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      DNT003                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DNT004                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      DNT005                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      DNT006                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      DNT007                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT008                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      DNT009                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      DNT010                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT011                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      DNT012                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      DNT013                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT014                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      DNT015                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0       #ton am
                      DNT016                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT017                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      DNT018                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DNT019                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT020                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      DNT021                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DNT022                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT023                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      DNT024                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DNT025                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      DNT026                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      DNT027                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am
                      DNT028                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      DNT029                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      DNT030                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0       #ton am
                      DNT031                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      DNT032                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      DNT033                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0       #ton am

EX                    [Tags]                           EX
                      [Template]                       Add product thr API
                      XT0001                           Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      XT0002                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000.53    0
                      XT0003                           Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0
                      XT0004                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000.62    1200
                      XT0005                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              0             30000       0
                      XT0006                           Kem whipping cream Anchor                                     Kẹo bánh              0             35000       0

CRP                   [Tags]                           CRP
                      [Template]                       Add product thr API
                      RPT0001                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      RPT0002                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      RPT0003                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0
                      RPT0004                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      RPT0005                          Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              89044.895     30000       0
                      RPT0006                          Kem whipping cream Anchor                                     Kẹo bánh              20025.459     35000       0
                      RPT0007                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      RPT0008                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      RPT0009                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      RPT0010                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      RPT0011                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      RPT0012                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0
                      RPT0013                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1200
                      RPT0014                          Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              89044.895     30000       0
                      RPT0015                          Kem whipping cream Anchor                                     Kẹo bánh              20025.459     35000       0
                      RPT0016                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      RPT0017                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      RPT0018                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0

THKL                  [Tags]                           THKL
                      [Template]                       Add product thr API
                      KLT0001                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      KLT0002                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0
                      KLT0003                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       200
                      KLT0004                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       800
                      KLT0005                          Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              89044.895     30000       0
                      KLT0006                          Kem whipping cream Anchor                                     Kẹo bánh              20025.459     35000       500
                      KLT0007                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      KLT0008                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      KLT0009                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      KLT0010                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       1200
                      KLT0011                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       50
                      KLT0012                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       0
                      KLT0013                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              0             50000       1000
                      KLT0014                          Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              89044.895     30000       600
                      KLT0015                          Kem whipping cream Anchor                                     Kẹo bánh              20025.459     35000       0
                      KLT0016                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       150
                      KLT0017                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       0
                      KLT0018                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       200
                      KLT0019                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       100
                      KLT0020                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       0

DTH_PM                [Tags]                           DTH
                      [Template]                       Add product thr API
                      DTPM01                           Chổi lau nhà tự động 1                                        Nhà cửa               2289999.78    500000      1200
                      DTPM02                           Chổi lau nhà tự động 2                                        Nhà cửa               3000000       500000      1200

Cong_no_KH            [Tags]                           PBCNKH
                      [Template]                       Add product thr API
                      CNKH01                           Chổi lau nhà tự động 3                                        Nhà cửa               400000.23     500000      1200
                      CNKH02                           Chổi lau nhà tự động 4                                        Nhà cửa               150000        500000      1200
                      CNKH03                           Chổi lau nhà tự động 5                                        Nhà cửa               321000        500000      1200
                      CNKH04                           Chổi lau nhà tự động 6                                        Nhà cửa               123000.45     500000      1200

Bao hanh bao tri      [Tags]                           BHBT
                      [Template]                       Add new product have guarantee
                      HBH01                            Hàng bảo hành 01                                              Bảo hành - bảo trì    100000.55     30000       1200    50                    1       3             2
                      HBH02                            Hàng bảo hành 02                                              Bảo hành - bảo trì    120000        35000       0       12                    2       45            1
                      HBH03                            Hàng bảo hành 03                                              Bảo hành - bảo trì    140000        40000       1200    2                     3       1             3
                      HBH04                            Hàng bảo hành 04                                              Bảo hành - bảo trì    160000        45000       0       60                    1       1             2
                      HBH05                            Hàng bảo hành 05                                              Bảo hành - bảo trì    180000.13     50000       1200    24                    2       1             3
                      HBH06                            Hàng bảo hành 06                                              Bảo hành - bảo trì    200000        55000       1200    1                     3       60            1

Remain                [Tags]
                      [Template]                       Add product thr API
                      HH0163                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              10000         5000        1500
                      HH0164                           Bánh xốp phô mai Cal Cheese Mayora                            Kẹo bánh              11000         6000        0
                      HH0165                           Nước yến sào cao cấp Sanest                                   Kẹo bánh              12000         7000        0
                      HH0166                           Kẹo hương bạc hà nhân sô cô la Dynamite Big Bang JacknJill    Kẹo bánh              13000         8000        1500
                      HH0167                           Bánh trứng Belgi                                              Kẹo bánh              14000         9000        0
                      HH0168                           Bộ 2 Thảm San Hô Siêu Thấm Homeeasy 35x50cm                   Kẹo bánh              15000         10000       0
                      HH0169                           Bộ Lau Nhà Lồng Inox Homeeasy Supper Price                    Kẹo bánh              16000         11000       1500
                      HH0170                           Cây Lau Nhà Inox Cao Cấp Homeeasy - F22                       Kẹo bánh              17000         12000       0
                      HH0171                           Bộ 2 Thảm San Hô Siêu Thấm Homeeasy 40x60cm                   Kẹo bánh              18000         13000       0
                      HH0172                           Sọt Rác Bàn Đạp Homeeasy 541TT (22.5 x 26.5                   Kẹo bánh              19000         14000       1500
                      HH0173                           Bộ Nồi Xửng Homeeasy HO5019 (26cm)                            Kẹo bánh              20000         15000       0
                      HH0174                           Bánh xu kem Nhật                                              Kẹo bánh              21000         16000       0
                      HH0175                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              22000         17000       1500
                      HH0176                           Kem gấu TH true milk                                          Kẹo bánh              23000         18000       0
                      HH0177                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              24000         19000       0
                      HH0178                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              25000         20000       1500
                      HH0179                           Kem whipping cream Anchor                                     Kẹo bánh              26000         21000       0
                      HH0180                           Bánh xu kem Nhật                                              Kẹo bánh              27000         22000       0
                      HH0181                           Bánh Trứng No Brand 250g                                      Kẹo bánh              28000         23000       1500
                      HH0182                           Kẹo trái cây FINI Beans 90g                                   Kẹo bánh              29000         24000       0
                      HH0183                           Socola Kitkat Bites Vị Trà Xanh (30g)                         Kẹo bánh              30000         25000       0
                      HH0184                           Kẹo Nhai Mentos Bạc Hà (Gói 3 Thỏi)                           Kẹo bánh              31000         26000       1500
                      HH0185                           Bánh Quế Vị Socola Hạt Dẻ Pirouette                           Kẹo bánh              32000         27000       0
                      HH0186                           Bánh xu kem Nhật                                              Kẹo bánh              33000         28000       0
                      HH0187                           Bánh xu kem Nhật                                              Kẹo bánh              34000         29000       1500
                      HH0188                           Bánh xu kem Nhật                                              Kẹo bánh              35000         30000       0
                      HH0189                           Bánh xu kem Nhật                                              Kẹo bánh              36000         31000       0
                      HH0190                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              37000         32000       1500
                      HH0191                           Kem gấu TH true milk                                          Kẹo bánh              38000         33000       0
                      HH0192                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              39000         34000       0
                      HH0193                           Trà sữa Royal tea mix Myanma                                  Kẹo bánh              40000         35000       1500
                      HH0194                           Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              41000         36000       0
                      HH0195                           Bánh xu kem Nhật                                              Kẹo bánh              42000         37000       0
                      HH0196                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              43000         38000       1500
                      HH0197                           Kem gấu TH true milk                                          Kẹo bánh              44000         39000       0
                      HH0198                           Bánh xu kem Nhật                                              Kẹo bánh              45000         40000       0
                      HH0199                           Ô mai chanh đào Hồng Lam                                      Kẹo bánh              46000         41000       1500
                      HH0200                           Gà Viên Chay An Nhiên Gói 150g                                Kẹo bánh              47000         20000       1500
                      HH0201                           Bóng Cá Chay An Nhiên                                         Kẹo bánh              48000         21000       0
                      HH0202                           Chà Bông Thịt Bò Chay An Nhiên                                Kẹo bánh              49000         22000       0
                      HH0203                           Đường Ăn Kiêng Equal Hộp 100                                  Kẹo bánh              50000         23000       1500
                      HH0204                           Rong Biển Khô Tẩm Gia Vị Aji Gin                              Kẹo bánh              51000         24000       0
                      HH0205                           Thùng Mì Gói Hảo Hảo Chay Hương Vị Rau Nấm                    Kẹo bánh              52000         25000       0
                      HH0206                           Rong Biển Khô Chay 20g                                        Kẹo bánh              53000         26000       1500
                      HH0207                           Thùng 30 Gói Mì Unif Chay Nấm Đông Cô 80G                     Kẹo bánh              54000         27000       0
                      HH0208                           Heo Lát Chay An Nhiên Gói 150g                                Kẹo bánh              55000         28000       0
                      HH0209                           Rong Biển Khô Cuốn Sushi Yaki Aji Gin 10 Lá                   Kẹo bánh              56000         29000       1500
                      HH0210                           Cá Cơm Hoa Chuối Kho Tiêu Chay An Nhiên                       Kẹo bánh              57000         30000       0
                      HH0211                           Thùng 30 Gói Mì Chay Tiềm Bát                                 Kẹo bánh              58000         31000       0
                      HH0212                           Cốt Lết Chay An Nhiên                                         Kẹo bánh              59000         32000       1500
                      HH0213                           Hỗn Hợp Củ Quả Sấy Khô 100g                                   Kẹo bánh              60000         33000       0
                      HH0214                           Khổ Qua Sấy Khô Chay 200g                                     Kẹo bánh              61000         34000       0
                      HH0215                           Hỗn Hợp Củ Quả Sấy Khô 200g                                   Kẹo bánh              62000         35000       1500
                      HH0216                           Bò Lát Chay An Nhiên Gói 150g                                 Kẹo bánh              63000         36000       1500
                      HH0217                           Rong Sụn Biển Chay 300g                                       Kẹo bánh              64000         37000       0
                      HH0218                           Sườn Ống Lúa Mạch Chay An Nhiên Gói 150g                      Kẹo bánh              65000         38000       0
                      HH0219                           Rong Sụn Biển Chay                                            Kẹo bánh              66000         39000       1500
                      HH0220                           Sữa Bột Frisolac Gold Pedia                                   Kẹo bánh              67000         40000       0
                      HH0221                           Sữa Bột Abbott Grow 3 AG3M                                    Kẹo bánh              68000         41000       0
                      HH0222                           Sản Phẩm Dinh Dưỡng Nestle Nutren Diabetes                    Kẹo bánh              69000         42000       1500
                      HH0223                           Lốc nước yến cho bé trên 1 tuổi Nunest Kid                    Kẹo bánh              70000         43000       0
                      #tao don hang k co \ giam gia
                      HH0224                           Sữa Bột Bellamys Organic Số 3                                 Kẹo bánh              72000         45000       1500
                      HH0225                           Sữa Bột Dutch Baby Gold Mau Lớn                               Kẹo bánh              73000         46000       0
                      HH0226                           Thùng 48 Hộp Sữa Bột Pha Sẵn Friso Gold Rtd                   Kẹo bánh              74000         47000       0
                      HH0227                           Sữa Bột Abbott Grow 4 DHA AW4L Dành Cho Trẻ                   Kẹo bánh              75000         48000       1500
                      HH0228                           Sữa Bột Vinamilk Dielac Alpha Gold Step 4                     Kẹo bánh              76000         49000       0
                      HH0229                           Sữa Bột Vinamilk Dielac Alpha Gold Step 4                     Kẹo bánh              77000         50000       0
                      HH0230                           Sữa Bột Enfamil A+ 2                                          Kẹo bánh              78000         51000       1500
                      HH0231                           Thùng 30 Gói Mì Chính Hiệu 2 Tôm Vifon                        Kẹo bánh              79000         52000       1500
                      HH0232                           Hộp Quà Tết Langfarm Etsy 19                                  Kẹo bánh              80000         53000       0
                      HH0233                           Thùng Mì Gói Hảo Hảo Hương Vị Tôm Chua Cay                    Kẹo bánh              81000         54000       0
                      HH0234                           Sữa Bột Aptamil Đức số 1                                      Kẹo bánh              82000         55000       1500
                      HH0235                           Sữa Bột Abbott Similac Newborn IQ HMO                         Kẹo bánh              83000         56000       0
                      HH0236                           Bột Ăn Dặm Ngũ Cốc Gạo Sữa Friso Gold                         Kẹo bánh              84000         57000       0
                      HH0237                           Combo 2 Gói Viên Ngậm Lợi Khuẩn Ngừa Sâu                      Kẹo bánh              85000         58000       1500
                      HH0238                           Bột Ăn Dặm Nestlé Cerelac                                     Kẹo bánh              86000         59000       0
                      HH0239                           Bột Ăn Dặm Nestle Cerelac - Gạo Và Trái Cây                   Kẹo bánh              87000         60000       0
                      HH0240                           CRM - Sữa Bột Nestle NAN Optipro 4                            Kẹo bánh              88000         61000       1500
                      HH0241                           Bánh Ăn Dặm Nestlé CERELAC Nutripuffs                         Kẹo bánh              89000         62000       0
                      HH0242                           Bột Ăn Dặm Nestle Cerelac - Lúa Mì Và Sữa                     Kẹo bánh              90000         63000       0
                      HH0243                           Sữa Bột Meiji Nội Địa Hohoemi Milk Số 3                       Kẹo bánh              91000         64000       1500
                      HH0244                           Sữa Bột Meiji Nội Địa Hohoemi Milk Số                         Kẹo bánh              92000         65000       0
                      HH0245                           Sữa Công Thức HiPP 2 Combiotic Organic                        Kẹo bánh              93000         66000       0
                      HH0246                           Bột Ăn Dặm Nestle Cerelac - Rau Xanh Và Bí                    Kẹo bánh              94000         67000       1500
                      HH0247                           Sữa Bột Nestle NAN Optipro 4                                  Kẹo bánh              95000         68000       1500
                      HH0248                           Bánh Ăn Dặm Nestlé CERELAC Nutripuffs Vị                      Kẹo bánh              96000         69000       0
                      HH0249                           Sữa Bột Enfagrow A+ 3                                         Kẹo bánh              97000         70000       0
                      HH0250                           Bột Sữa Dinh Dưỡng HiPP Organic Bích Quy                      Kẹo bánh              98000         71000       1500
                      HH0251                           Sữa Morinaga Số 1 - Hagukumi                                  Kẹo bánh              99000         72000       0
                      HH0252                           Bột Ăn Dặm Nestle Cerelac - Cá Và Rau Xanh                    Kẹo bánh              100000        73000       0
                      HH0253                           Sữa Glico Icreo Số 0                                          Kẹo bánh              101000        74000       1500
                      HH0254                           Sản Phẩm Dinh Dưỡng Nestle Nutren Junior                      Kẹo bánh              102000        75000       0
                      HH0255                           Bột Dinh Dưỡng Sữa Ăn Dặm Khởi Đầu HiPP                       Kẹo bánh              103000        76000       0
                      HH0256                           Yến mạch nguyên chất cán mỏng hiệu Mr Johnny                  Kẹo bánh              104000        77000       1500
                      HH0257                           Sữa Morinaga Số 2 - Chilmil                                   Kẹo bánh              105000        78000       0
                      HH0258                           Combo 3 Gói Cháo Tươi SG Foods Vị Lươn, Cá                    Kẹo bánh              106000        79000       0
                      HH0259                           Hũ Dinh Dưỡng Giăm Bông, Rau Và Mì Sợi HiPP                   Kẹo bánh              107000        80000       1500
                      HH0260                           Sữa Glico Icreo Số 1                                          Kẹo bánh              108000        81000       0
                      HH0261                           Bột Ăn Dặm Nestle Cerelac - Gạo Lức Trộn Sữa                  Kẹo bánh              109000        82000       0
                      HH0262                           Dinh Dưỡng Đóng Hộp Mì Tagliatelle, Cá Hồi,                   Kẹo bánh              110000        83000       1500
                      HH0263                           Sữa Bột Enfagrow A+ 4                                         Kẹo bánh              111000        84000       1500
                      HH0264                           Bánh Qui Dành Cho Trẻ Em Farley Heinz                         Kẹo bánh              112000        85000       0
                      HH0265                           Dinh Dưỡng Đóng Hộp Mì Bẹt, Cá Hồi Sốt Cà                     Kẹo bánh              113000        86000       0
                      HH0266                           Mì Baby Pasta HiPP Organic                                    Kẹo bánh              114000        87000       1500
                      HH0267                           Sinh Tố Táo Dứa Chuối Vitamin C HiPP 8015                     Kẹo bánh              115000        88000       0
                      HH0268                           Nước Ép Hoa Quả HiPP Organic Dành Cho Trẻ                     Kẹo bánh              116000        89000       0
                      HH0269                           Sữa Công Thức HiPP 1 Combiotic Organic                        Kẹo bánh              117000        90000       1500
                      HH0270                           Cháo Ăn Dặm Mabu Hạt Vỡ                                       Kẹo bánh              118000        91000       0
                      HH0271                           Bánh Gạo Bổ Sung Omega 3 Và DHA Apple Monkey                  Kẹo bánh              119000        92000       0
                      HH0272                           Sữa Bột Abbott Grow School G-Power Vanilla                    Kẹo bánh              120000        93000       1500
                      HH0273                           Sữa Bột Aptamil Số 2                                          Kẹo bánh              121000        94000       0
                      HH0274                           Sữa Morinaga Số 1 - Hagukumi                                  Kẹo bánh              122000        95000       0
                      HH0275                           Bột Ăn Dặm Mabu                                               Kẹo bánh              123000        96000       1500
                      HH0276                           Bánh Ăn Dặm Không Chứa Gluten Apple Monkey                    Kẹo bánh              124000        97000       0
                      HH0277                           Sữa Bột Aptamil Số 3                                          Kẹo bánh              125000        98000       0
                      HH0278                           Sữa Công Thức Glico Icreo Balance Milk Số 0                   Kẹo bánh              126000        99000       1500
                      HH0279                           Siro ngủ ngon an thần cho bé Sonno Bimbi                      Kẹo bánh              127000        100000      1500
                      HH0280                           Sữa Bột Abbott Similac IQ3 HMO                                Kẹo bánh              128000        101000      0
                      HH0281                           Sữa Bột Abbott Grow G-Power Vanilla GGM                       Kẹo bánh              129000        102000      0
                      HH0282                           Sữa Bột Abbott Grow 4 DHA AW4M                                Kẹo bánh              130000        103000      1500
                      HH0283                           Sữa Bột Frisolac Gold 4 Cho Trẻ Từ 2-4 Tuổi                   Kẹo bánh              131000        104000      0
                      HH0284                           Sữa Bột Enfagrow A+ 3 (900g)                                  Kẹo bánh              132000        105000      0
                      HH0285                           Sản Phẩm Dinh Dưỡng Nestle Nutren Junior                      Kẹo bánh              133000        106000      1500
                      HH0286                           Sữa Bột Frisolac Gold 3                                       Kẹo bánh              134000        107000      0
                      HH0287                           CRM - Sữa Enfamil A + 1 360Brain DHA+ MFGM                    Kẹo bánh              135000        108000      0
                      HH0288                           Sữa Bột Frisolac Gold 2                                       Kẹo bánh              136000        109000      1500
                      HH0289                           Sữa Bột Enfamil A+ 1                                          Kẹo bánh              137000        110000      0
                      HH0290                           Lốc 6 Chai Sữa Nước Abbott Pediasure Super                    Kẹo bánh              138000        111000      0
                      HH0291                           Sữa Bột Frisolac Gold 1 900g                                  Kẹo bánh              139000        112000      1500
                      HH0292                           Sữa Bột Frisolac Gold 3 1500g                                 Kẹo bánh              140000        113000      0
                      HH0293                           Sữa Công Thức HiPP 3 Junior Combiotic                         Kẹo bánh              141000        114000      0
                      HH0294                           Sữa Morinaga Số 2 - Chilmil                                   Kẹo bánh              142000        115000      1500
                      HH0295                           Sữa Bột Enfagrow A+ 3                                         Kẹo bánh              143000        116000      1500
                      HH0296                           Sữa Bột Nestle NAN Optipro 4                                  Kẹo bánh              144000        117000      0
                      HH0297                           Sữa Bột Abbott Pediasure B/A PCLA                             Kẹo bánh              145000        118000      0
                      HH0298                           Combo 3 Gói Cháo Tươi Em Bé SG Foods Vị Cá                    Kẹo bánh              146000        119000      1500
                      HH0299                           Bánh Ăn Dặm Gerber Vị Chuối                                   Kẹo bánh              147000        120000      0
                      HH0300                           Bánh Ăn Dặm Gerber Vị Dâu Táo (42g)                           Kẹo bánh              148000        121000      0
                      HH0301                           Sữa Bột Frisolac Gold 2                                       Kẹo bánh              149000        122000      1500
                      HH0302                           Sữa Bột Frisolac Gold 1                                       Kẹo bánh              150000        123000      0
                      HH0303                           Sữa Bột Frisolac Gold 3                                       Kẹo bánh              151000        124000      0
                      HH0304                           Sữa Bột Frisolac Gold 5                                       Kẹo bánh              152000        125000      1500
                      HH0305                           Sữa Bột Frisolac Gold 4                                       Kẹo bánh              153000        126000      0
                      HH0306                           Sữa Bột Frisolac Gold Pedia                                   Kẹo bánh              154000        127000      0
                      HH0307                           Thùng 48 Hộp Sữa Bột Pha Sẵn Friso Gold Rtd Vani              Kẹo bánh              155000        128000      1500
                      HH0308                           Sữa Bột Frisolac Gold 4 Cho Trẻ Từ 2-4                        Kẹo bánh              156000        129000      0
                      HH0309                           Thùng 48 Hộp Sữa Bột Pha Sẵn Friso Gold Rtd Vani              Kẹo bánh              157000        130000      0
                      HH0310                           Sữa Bột Frisomum Gold Hương Vani                              Kẹo bánh              158000        131000      1500
                      HH0311                           Sữa Bột Frisomum Gold Hương Cam                               Kẹo bánh              159000        132000      1500
                      HH0312                           Sữa Bột Frisolac Gold Premature                               Kẹo bánh              160000        133000      0
                      HH0313                           Sữa Bột Frisolac Gold Comfort                                 Kẹo bánh              161000        134000      0
                      HH0314                           Sữa Bột Abbott Similac Newborn IQ HMO (400g)                  Kẹo bánh              162000        135000      1500
                      HH0315                           Sữa Bột Abbott Similac IQ2 HMO (900g)                         Kẹo bánh              163000        136000      0
                      HH0316                           Sữa Bột Abbott Similac Newborn IQ HMO (900g)                  Kẹo bánh              164000        137000      0
                      HH0317                           Sữa Bột Abbott Similac IQ2 HMO (400g)                         Kẹo bánh              165000        138000      1500
                      HH0318                           Sữa Bột Abbott Similac IQ3 HMO (400g)                         Kẹo bánh              166000        139000      0
                      HH0319                           Sữa Bột Abbott Similac IQ3 HMO (900g)                         Kẹo bánh              167000        140000      0
                      HH0320                           Sữa Bột Abbott Similac IQ3 HMO (1.7kg)                        Kẹo bánh              168000        141000      1500
                      HH0321                           Sữa Bột Abbott Similac IQ4 HMO (900g)                         Kẹo bánh              169000        142000      0
                      HH0322                           Sữa Bột Abbott Similac IQ4 HMO (1.7kg)                        Kẹo bánh              170000        143000      0
                      HH0323                           Combo 2 Sữa Công Thức Glico Icreo Balance                     Kẹo bánh              171000        144000      1500
                      HH0324                           Sữa Công Thức Glico Icreo Follow Up Milk Số.                  Kẹo bánh              172000        145000      0
                      HH0325                           Sữa Bột Hikid Hương Vani (600g)                               Kẹo bánh              173000        146000      0
                      HH0326                           Sữa bột France Lait 3 (900g)                                  Kẹo bánh              174000        147000      1500
                      HH0327                           Sữa Bột S26 Gold Progress Số 2 (900g)                         Kẹo bánh              175000        148000      1500
                      HH0328                           Sữa bột S26 Gold Junior số 4 (900g)                           Kẹo bánh              176000        149000      0
                      HH0329                           Sữa S26 Gold Junior Số 2 Úc (900g)                            Kẹo bánh              177000        150000      0
                      HH0330                           Sữa Công Thức Glico Icreo Balance Milk                        Kẹo bánh              178000        151000      1500
                      HH0331                           Sữa Dinh Dưỡng Công Thức Physiolac Relais 2                   Kẹo bánh              179000        152000      0
                      HH0332                           Sữa bột cho trẻ nôn trớ, trào ngược France                   Kẹo bánh              180000        153000      0
                      HH0333                           Sữa Bột S26 Gold Toddled Số 3 (900g)                          Kẹo bánh              181000        154000      1500
                      HH0334                           Sữa France Lait LF 400g - Dành cho Trẻ                        Kẹo bánh              182000        155000      0
                      HH0335                           Sữa Dinh Dưỡng Công Thức Physiolac Relais 1                   Kẹo bánh              183000        156000      0
                      HH0336                           Sữa S26 Gold New Born Số 1 Úc (900g)                          Kẹo bánh              184000        157000      1500
                      HH0337                           Sữa bột France Lait 2 (900g)                                  Kẹo bánh              185000        158000      0
                      HH0338                           Sữa S26 Gold Progress Số 2 Úc (900g)                          Kẹo bánh              186000        159000      0
                      HH0339                           Sữa bột France Lait 1 (900g)                                  Kẹo bánh              187000        160000      1500
                      HH0340                           Sữa Bột Nefesure Horu IQ Grow                                 Kẹo bánh              188000        161000      0
                      HH0341                           Sữa Dinh Dưỡng Công Thức Physiolac                            Kẹo bánh              189000        162000      0
                      HH0342                           Sữa cho trẻ sinh non, nhẹ cân Pre France.                   Kẹo bánh              190000        163000      1500
                      HH0343                           Sữa bột France Lait 1 (400g)                                  Kẹo bánh              191000        164000      1500
                      HH0344                           Sữa Bột S26 Gold Newborn Số 1 (900g)                          Kẹo bánh              192000        165000      0
                      HH0345                           Sữa bột France Lait 3 (400g)                                  Kẹo bánh              193000        166000      0
                      HH0346                           Sữa bột Nefesure Horu IQ Grow (800 gram)                      Kẹo bánh              194000        167000      1500
                      HH0347                           Sữa bột Nefesure TiTan Plus                                   Kẹo bánh              195000        168000      0
                      HH0348                           Sữa bột France Lait 2 (400g)                                  Kẹo bánh              196000        169000      0
                      HH0349                           Sữa bột Nefesure Titan Plus (800 gram)                        Kẹo bánh              197000        170000      1500
                      HH0350                           Combo 4 Hộp Sữa Morinaga Hagukumi (850g)                      Kẹo bánh              198000        171000      0

NHND                  [Tags]                           NHND
                      [Template]                       Add product thr API
                      NHMT001                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      NHMT002                          Ô mai chanh đào Hồng Lam                                      Kẹo bánh              60000         30000       80
                      NHMT003                          Kem gấu TH true milk                                          Kẹo bánh              70000         35000       80
                      NHMT004                          Trà sữa Royal tea mix Myanma                                  Kẹo bánh              70000         50000       80
                      NHMT005                          Kem Hàn Quốc trà xanh XXXD                                    Kẹo bánh              70000         30000       800
                      NHMT006                          Kem whipping cream Anchor                                     Kẹo bánh              70000         35000       80
                      NHMT007                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      NHMT008                          Bánh xu kem Nhật                                              Kẹo bánh              70000         35000       80
                      NHMT009                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      NHMT010                          Bánh xu kem Nhật                                              Kẹo bánh              70000         30000       80
                      NHMT011                          Bánh xu kem Nhật                                              Kẹo bánh              70000         35000       80
                      NHMT012                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      NHMT013                          Bánh xu kem Nhật                                              Kẹo bánh              70000         75000       80
                      NHMT014                          Bánh xu kem Nhật                                              Kẹo bánh              70000         50000       80
                      NHMT015                          Bánh xu kem Nhật                                              Kẹo bánh              70000         25000       80

Gộp hóa đơn           [Tags]      GHD
                      [Template]                       Add product thr API
                      GHDT001                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              10000         5000        1500
                      GHDT002                           Bánh xốp phô mai Cal Cheese Mayora                            Kẹo bánh              11000         6000        0
                      GHDT003                           Nước yến sào cao cấp Sanest                                   Kẹo bánh              12000         7000        0
                      GHDT004                           Kẹo hương bạc hà nhân sô cô la Dynamite Big Bang JacknJill    Kẹo bánh              13000         8000        1500
                      GHDT005                           Bánh trứng Belgi                                              Kẹo bánh              14000         9000        0

Hàng tích điểm        [Tags]      GHD
                      [Template]                       Add product have point thr API
                      GHDT011                           Bánh snack khoai tây vị bò bít tết Manhattan Poca             Kẹo bánh              10000         5000        1500      10
                      GHDT012                           Bánh xốp phô mai Cal Cheese Mayora                            Kẹo bánh              11000         6000        0         20

GDH                  [Tags]                           GDH
                     [Template]                       Add product thr API
                      HH0351                          Chè thập cẩm nhiều thứ                                        Kẹo bánh              70000         50000       80
                      HH0352                          sữa chua đá PL                                                Kẹo bánh              60000         30000       80
HHKK                 [Tags]                           HHKK
                     [Template]                       Add product thr API
                     HTKK0001                         Bánh xu kem Nhật                                              Kiểm kho API          70000         50000       80
                     HTKK0002                         Bánh xu kem Nhật                                              Kiểm kho API          70000         25000       20
                     HTKK0003                         Bánh xu kem Nhật                                              Kiểm kho API          70000         70000       0
                     HTKK0004                         Bánh xu kem Nhật                                              Kiểm kho API          70000         60000       0
                     HTKK0005                         Bánh xu kem Nhật                                              Kiểm kho API          70000         50000       1    #tồn âm
                     HTKK0006                         Bánh xu kem Nhật                                              Kiểm kho API          70000         50000       1    #tồn âm
*** Keywords ***
Add new product have guarantee
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    ...    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    ${product_id}    Add product have genuine guarantees    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    ...    ${ton}    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    Save guarantee after create product    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}    ${product_id}
