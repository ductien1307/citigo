*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ma SP                        Ten sp                     Nhom hang     Gia ban       Gia von
EBD                   [Tags]                       EBD                        EB
                      [Template]                   create service
                      DV025                        Cắt tóc Nam                Dịch vụ       100000        50000
                      DV026                        Cắt tóc nữ                 Dịch vụ       0             0
                      DV027                        Uốn tóc - Obistan          Dịch vụ       349789.76     100000
                      DV028                        Dập phồng tóc - Obistan    Dịch vụ       100000        50000
                      DV029                        Nhuộm tóc - Obistan        Dịch vụ       0             0
                      DV030                        Uốn tóc - Loreal           Dịch vụ       349789.76     100000

CBPI_GIFT             [Tags]                       EB
                      [Template]                   create service
                      DV031                        Dập phồng tóc - Loreal     Dịch vụ KM    30000         12000
                      DV032                        Nhuộm tóc - Loreal         Dịch vụ KM    40000         16000
                      DV033                        Hấp phục hồi Loreal        Dịch vụ KM    20000         13000

UEBM                  [Tags]                    UEBM      EB1
                                            [Template]                   create service
                      DV034                        Phục hồi tóc               Dịch vụ      160890.49        70000
                      DV035                        Nail (sơn thường)          Dịch vụ      190000        70000
                      DV036                        Nail (sơn gel)             Dịch vụ      180000         50000

CBPPI                [Tags]           CBPPI      EB1
                      [Template]                   create service
                      DV037                        Đính đá (Viên)             KM Hàng mua      1589998.18         0
                      DV038                        Nối mi                     KM Hàng mua      1500000        70000

CON_PROMO_TK          [Tags]                  CONPROTK      EB1
                      [Template]                   create service
                      DV039                        Xăm mày                    KM Hàng tặng      50000         0

Import_export                [Tags]         IP    EB1
                      [Template]                   create service
                      DV040                        Phun mày                   Dịch vụ      1200000       0
                      DV041                        Spa mặt 13 bước cơ bản     Dịch vụ      0             50000

Shop config           [Tags]      EDH   TL
                      [Template]                   create service
                      DV042                        Spa mặt trị mụn            Dịch vụ      0             99000

remain                [Tags]
                      [Template]                   create service
                      DV042                        Spa mặt trị mụn            Dịch vụ      0             99000
                      DV043                        Spa lăn kim                Dịch vụ      250000        100000
                      DV044                        Spa cấy collagen           Dịch vụ      300000        0
                      DV045                        Điều trị hư tổn tóc        Dịch vụ      0             120000
                      DV046                        Gội chữa trị               Dịch vụ      0             23000

Nhieu_dong                  [Tags]                       EDH
                      [Template]                   create service
                      DV001                        Cắt tóc Nam                Dịch vụ       100000        50000
                      DV002                        Cắt tóc nữ                 Dịch vụ       200000        98000
                      DV003                        Uốn tóc - Obistan          Dịch vụ       350000        100000
                      DV004                        Dập phồng tóc - Obistan    Dịch vụ       250000        200000
                      DV005                        Nhuộm tóc - Obistan        Dịch vụ       0             300000
                      DV006                        Uốn tóc - Loreal           Dịch vụ       190000        90000
                      DV007                        Dập phồng tóc - Loreal     Dịch vụ       300000        120000
                      DV008                        Nhuộm tóc - Loreal         Dịch vụ       400000        160000
                      DV009                        Hấp phục hồi Loreal        Dịch vụ       250000        130000
                      DV010                        Hấp tóc                    Dịch vụ       500000        190000
                      DV011                        Phục hồi tóc               Dịch vụ       160000        70000
                      DV012                        Nail (sơn thường)          Dịch vụ       190000        70000
                      DV013                        Nail (sơn gel)             Dịch vụ       90000         50000
                      DV014                        Đính đá (Viên)             Dịch vụ       50000         17000
                      DV015                        Nối mi                     Dịch vụ       150000        70000
                      DV016                        Xăm mày                    Dịch vụ       200000        100000
                      DV017                        Phun mày                   Dịch vụ       1200000       0
                      DV018                        Spa mặt 13 bước cơ bản     Dịch vụ       0             50000
                      DV019                        Spa mặt trị mụn            Dịch vụ       0             99000
                      DV020                        Spa lăn kim                Dịch vụ       2500000       100000

Dat_hang_thuong       [Tags]                       EDH
                      [Template]                   create service
                      DV049                        Nails 1                    Dịch vụ       25000.06      15000
                      DV050                        Nails 2                    Dịch vụ       26000         15000
                      DV051                        Nails 3                    Dịch vụ       27000         15000
                      DV052                        Nails 4                    Dịch vụ       28000.16      15000
                      DV053                        Nails 5                    Dịch vụ       29000         15000
                      DV054                        Nails 6                    Dịch vụ       30000         15000
                      DV055                        Nails 7                    Dịch vụ       31000         15000
                      DV056                        Nails 8                    Dịch vụ       32000.23      15000
                      DV057                        Nails 9                    Dịch vụ       33000         15000
                      DV058                        Nails 10                   Dịch vụ       34000         15000
                      DV059                        Nails 11                   Dịch vụ       35000         15000
                      DV060                        Nails 12                   Dịch vụ       36000.38      15000
                      DV061                        Nails 13                   Dịch vụ       37000         15000
                      DV062                        Nails 14                   Dịch vụ       38000         15000
                      DV063                        Nails 15                   Dịch vụ       39000         15000
                      DV064                        Nails 16                   Dịch vụ       40000.45      15000

Thu_khac_dathang       [Tags]                       EDH
                      [Template]                   create service
                      DV065                        Nails 17                   Dịch vụ       41000         15000
                      DV066                        Nails 18                   Dịch vụ       42000         15000
                      DV067                        Nails 19                   Dịch vụ       43000         15000
                      DV068                        Nails 20                   Dịch vụ       44000.53      15000
                      DV069                        Nails 21                   Dịch vụ       45000         15000
                      DV070                        Nails 22                   Dịch vụ       46000         15000
                      DV071                        Nails 23                   Dịch vụ       47000         15000

Remain
                      DV072                        Nails 24                   Dịch vụ       48000.66      15000
                      DV073                        Nails 25                   Dịch vụ       49000         15000
                      DV074                        Nails 26                   Dịch vụ       50000         15000
                      DV075                        Nails 27                   Dịch vụ       51000         15000
                      DV076                        Nails 28                   Dịch vụ       52000         15000
                      DV077                        Nails 29                   Dịch vụ       53000.71      15000
                      DV078                        Nails 30                   Dịch vụ       54000         15000
                      DV079                        Uốn tóc 1                  Dịch vụ       150000        50000
                      DV080                        Uốn tóc 2                  Dịch vụ       155000        50000
                      DV081                        Uốn tóc 3                  Dịch vụ       160000        50000
                      DV082                        Uốn tóc 4                  Dịch vụ       165000        50000
                      DV083                        Uốn tóc 5                  Dịch vụ       170000.87     50000

Tra hang              [Tags]                       EDH
                      [Template]                   create service
                      DV084                        Uốn tóc 6                  Dịch vụ       175000        50000
                      DV085                        Uốn tóc 7                  Dịch vụ       180000        50000
                      DV086                        Uốn tóc 8                  Dịch vụ       185000        50000
                      DV087                        Uốn tóc 9                  Dịch vụ       190000        50000
                      DV088                        Uốn tóc 10                 Dịch vụ       195000.95     50000
                      DV089                        Uốn tóc 11                 Dịch vụ       200000        50000
                      DV090                        Uốn tóc 12                 Dịch vụ       205000        50000

 Doi Tra hang         [Tags]                       EDH
                      [Template]                   create service
                      DV091                        Uốn tóc 13                 Dịch vụ       210000        50000
                      DV092                        Uốn tóc 14                 Dịch vụ       215000.02     50000
                      DV093                        Uốn tóc 15                 Dịch vụ       220000        50000
                      DV094                        Uốn tóc 16                 Dịch vụ       225000        50000
                      DV095                        Uốn tóc 17                 Dịch vụ       230000        50000
                      DV096                        Uốn tóc 18                 Dịch vụ       235000.19     50000


Remain
                      DV097                        Uốn tóc 19                 Dịch vụ       240000        50000
                      DV098                        Uốn tóc 20                 Dịch vụ       245000        50000
                      DV099                        Uốn tóc 21                 Dịch vụ       250000        50000
                      DV100                        Uốn tóc 22                 Dịch vụ       255000        50000
                      DV101                        Uốn tóc 23                 Dịch vụ       260000.25     50000
                      DV102                        Uốn tóc 24                 Dịch vụ       265000        50000
                      DV103                        Uốn tóc 25                 Dịch vụ       270000        50000
                      DV104                        Uốn tóc 26                 Dịch vụ       275000        50000
                      DV105                        Uốn tóc 27                 Dịch vụ       280000        50000
                      DV106                        Uốn tóc 28                 Dịch vụ       285000.36     50000
                      DV107                        Uốn tóc 29                 Dịch vụ       290000        50000
                      DV108                        Uốn tóc 30                 Dịch vụ       295000        50000
                      DV109                        Uốn tóc 31                 Dịch vụ       300000        50000
                      DV110                        Uốn tóc 32                 Dịch vụ       305000        50000
                      DV111                        Uốn tóc 33                 Dịch vụ       310000.47     50000
                      DV112                        Uốn tóc 34                 Dịch vụ       315000        50000
                      DV113                        Uốn tóc 35                 Dịch vụ       320000        50000
                      DV114                        Uốn tóc 36                 Dịch vụ       325000        50000
                      DV115                        Uốn tóc 37                 Dịch vụ       330000        50000
                      DV116                        Uốn tóc 38                 Dịch vụ       335000.56     50000
                      DV117                        Uốn tóc 39                 Dịch vụ       340000        50000
                      DV118                        Uốn tóc 40                 Dịch vụ       345000        50000
                      DV119                        Uốn tóc 41                 Dịch vụ       350000        50000
                      DV120                        Uốn tóc 42                 Dịch vụ       355000        50000
                      DV121                        Uốn tóc 43                 Dịch vụ       360000.67     50000
                      DV122                        Uốn tóc 44                 Dịch vụ       365000        50000
                      DV123                        Uốn tóc 45                 Dịch vụ       370000        50000
                      DV124                        Uốn tóc 46                 Dịch vụ       375000        50000
                      DV125                        Uốn tóc 47                 Dịch vụ       380000.78     50000
                      DV126                        Nhuộm tóc 1                Dịch vụ       150000        50000
                      DV127                        Nhuộm tóc 2                Dịch vụ       155000        50000
                      DV128                        Nhuộm tóc 3                Dịch vụ       160000        50000
                      DV129                        Nhuộm tóc 4                Dịch vụ       165000        50000
                      DV130                        Nhuộm tóc 5                Dịch vụ       170000.9      50000
                      DV131                        Nhuộm tóc 6                Dịch vụ       175000        50000
                      DV132                        Nhuộm tóc 7                Dịch vụ       180000        50000
                      DV133                        Nhuộm tóc 8                Dịch vụ       185000        50000
                      DV134                        Nhuộm tóc 9                Dịch vụ       190000        50000
                      DV135                        Nhuộm tóc 10               Dịch vụ       195000        50000
                      DV136                        Nhuộm tóc 11               Dịch vụ       200000        50000
                      DV137                        Nhuộm tóc 12               Dịch vụ       205000        50000
                      DV138                        Nhuộm tóc 13               Dịch vụ       210000        50000
                      DV139                        Nhuộm tóc 14               Dịch vụ       215000        50000
                      DV140                        Nhuộm tóc 15               Dịch vụ       220000        50000
                      DV141                        Nhuộm tóc 16               Dịch vụ       225000        50000

Khach_le              [Tags]        EDH
                      [Template]                   create service
                      DVL001                        Dịch vụ 01               Dịch vụ       100000        50000
                      DVL002                        Dịch vụ 02               Dịch vụ       100000        50000
                      DVL003                        Dịch vụ 03               Dịch vụ       100000        50000
                      DVL004                        Dịch vụ 04               Dịch vụ       100000        50000
                      DVL005                        Dịch vụ 05               Dịch vụ       100000        50000
                      DVL006                        Dịch vụ 06               Dịch vụ       100000        50000
                      DVL007                        Dịch vụ 07               Dịch vụ       100000        50000

Khuyen_mai_DH         [Tags]        EDPROMO
                      [Template]                   create service
                      DVL009                        Dịch vụ 09               Bánh nhập KM        100000        50000
                      DVL010                        Dịch vụ 10               Máy KM       100000        50000
                      DVL011                        Dịch vụ 11               Dịch vụ       100000        50000

Khuyen_mai_DH         [Tags]        EDPROMO
                      [Template]                   create service
                      HKM007                        Hàng khuyến mại 5               KM Hàng tặng       100000        50000
                      HKM008                        Hàng khuyến mại 6               KM Hàng tặng       100000        50000
                      HKM009                        Hàng khuyến mại 7               KM Hàng tặng       100000        50000

Khuyen_mai_phamvi_apdung         [Tags]      PROMOTION
                      [Template]                   create service
                      DVKM01                        Hàng DV khuyến mại 1               Dịch vụ       500000        200000
                      DVKM02                        Hàng DV khuyến mại 2               Dịch vụ       600000        200000

Doi_tra_hang         [Tags]        DTH
                      [Template]                   create service
                      #thu khac
                      DTDV1                        Uốn tóc - Loreal           Dịch vụ       190000        90000
                      DTDV2                        Dập phồng tóc - Loreal     Dịch vụ       300000        120000
                      DTDV3                        Nhuộm tóc - Loreal         Dịch vụ       400000        160000
                      DTDV4                        Hấp phục hồi Loreal        Dịch vụ       250000        130000
                      #nhieu dong
                      DTDV5                        Hấp tóc                    Dịch vụ       500000        190000
                      DTDV6                        Hấp tóc A                   Dịch vụ       300000        190000
                      DTDV7                        Hấp tóc B                    Dịch vụ       400000        190000
                      DTDV8                        Hấp tóc C                    Dịch vụ       600000        190000

EBG                   [Tags]                       EBG
                      [Template]                   create service
                      GHDV001                      Cắt tóc Nam                Dịch vụ       100000        50000
                      GHDV002                      Cắt tóc nữ                 Dịch vụ       0             0
                      GHDV003                      Uốn tóc - Obistan          Dịch vụ       349789.76     100000
                      GHDV004                      Dập phồng tóc - Obistan    Dịch vụ       100000        50000
                      GHDV005                      Nhuộm tóc - Obistan        Nhà cửa       0             0
                      GHDV006                      Uốn tóc - Loreal           Văn phòng phẩm       349789.76     100000

CRP                   [Tags]
                      [Template]                   create service
                      RPDV001                      Dập phồng 1                Dịch vụ       150000        50000
                      RPDV002                      Dập phồng 2                Dịch vụ       155000        50000
                      RPDV003                      Dập phồng 3                Dịch vụ       160000        50000
                      RPDV004                      Dập phồng 4                Dịch vụ       165000        50000
                      RPDV005                      Dập phồng 5                Dịch vụ       170000        50000
                      RPDV006                      Dập phồng 6                Dịch vụ       175000        50000
                      RPDV007                      Dập phồng 7                Dịch vụ       180000        50000
                      RPDV008                      Dập phồng 8                Dịch vụ       185000        50000
                      RPDV009                      Dập phồng 9                Dịch vụ       190000        50000
                      RPDV010                      Dập phồng 10               Dịch vụ       195000        50000
                      RPDV011                      Dập phồng 11               Dịch vụ       200000        50000
                      RPDV012                      Dập phồng 12               Dịch vụ       205000        50000
                      RPDV013                      Dập phồng 13               Dịch vụ       210000        50000
                      RPDV014                      Dập phồng 14               Dịch vụ       215000        50000
                      RPDV015                      Dập phồng 15               Dịch vụ       220000        50000
                      RPDV016                      Dập phồng 15               Dịch vụ       220000        50000
                      RPDV017                      Dập phồng 15               Dịch vụ       220000        50000
                      RPDV018                      Dập phồng 15               Dịch vụ       220000        50000

THKL                  [Tags]                       THKL
                      [Template]                   create service
                      KLDV001                      Dập phồng 1                Dịch vụ       150000        50000
                      KLDV002                      Dập phồng 2                Dịch vụ       155000        50000
                      KLDV003                      Dập phồng 3                Dịch vụ       160000        50000
                      KLDV004                      Dập phồng 4                Dịch vụ       165000        50000
                      KLDV005                      Dập phồng 5                Dịch vụ       170000        50000
                      KLDV006                      Dập phồng 6                Dịch vụ       175000        50000
                      KLDV007                      Dập phồng 7                Dịch vụ       180000        50000
                      KLDV008                      Dập phồng 8                Dịch vụ       185000        50000
                      KLDV009                      Dập phồng 9                Dịch vụ       190000        50000
                      KLDV010                      Dập phồng 10               Dịch vụ       195000        50000
                      KLDV011                      Dập phồng 11               Dịch vụ       200000        50000
                      KLDV012                      Dập phồng 12               Dịch vụ       205000        50000
                      KLDV013                      Dập phồng 13               Dịch vụ       210000        50000
                      KLDV014                      Dập phồng 14               Dịch vụ       215000        50000
                      KLDV015                      Dập phồng 15               Dịch vụ       220000        50000
                      KLDV016                      Dập phồng 15               Dịch vụ       220000        50000
                      KLDV017                      Dập phồng 15               Dịch vụ       220000        50000
                      KLDV018                      Dập phồng 15               Dịch vụ       220000        50000
                      KLDV019                      Dập phồng 15               Dịch vụ       220000        50000
                      KLDV020                      Dập phồng 15               Dịch vụ       220000        50000

DTH_PM                  [Tags]                       DTH
                      [Template]                   create service
                      DTPMDV01                      Dập phồng 1                Dịch vụ       150000        50000
                      DTPMDV02                      Dập phồng 2                Dịch vụ       155000        50000

Cong_no_KH                  [Tags]      PBCNKH
                      [Template]                   create service
                      CNKHDV01                      Cắt tóc 01                Dịch vụ       260000        50000
                      CNKHDV02                      Cắt tóc 02                Dịch vụ       275000        50000
                      CNKHDV03                      Cắt tóc 03                Dịch vụ       285000        50000
                      CNKHDV04                      Cắt tóc 04                Dịch vụ       290000        50000

Bao hanh bao tri                 [Tags]       BHBT
                      [Template]                       Add new service have guarantee
                      DVBH01       Dịch vụ bảo hành 01         Bảo hành - bảo trì            200000.5      60000      40      1       3      2       1      3       5       2
                      DVBH02       Dịch vụ bảo hành 02         Bảo hành - bảo trì            220000        65000      15      1       4      2       2      3       48       1
                      DVBH03       Dịch vụ bảo hành 03         Bảo hành - bảo trì            240000        70000      35      1       5      2       1       3       1.5      3
                      DVBH04       Dịch vụ bảo hành 04         Bảo hành - bảo trì            260000        75000      20      1       6      2       1.5     3       9       2
                      DVBH05       Dịch vụ bảo hành 05         Bảo hành - bảo trì            280000.13     80000      12      1       7      2       2      3       2       3
                      DVBH06       Dịch vụ bảo hành 06         Bảo hành - bảo trì            300000        85000      30      1       8      2       3      3       40      1

EDD_taohoadon_khongtamung
                      [Tags]
                      [Template]                   create service
                      DV142                        Nhuộm tóc 17               Dịch vụ       230000        50000
                      DV143                        Nhuộm tóc 18               Dịch vụ       235000        50000
                      DV144                        Nhuộm tóc 19               Dịch vụ       240000        50000
                      DV145                        Nhuộm tóc 20               Dịch vụ       245000        50000
                      DV146                        Nhuộm tóc 21               Dịch vụ       250000        50000
                      DV147                        Nhuộm tóc 22               Dịch vụ       255000        50000
                      DV148                        Nhuộm tóc 23               Dịch vụ       260000        50000
                      DV149                        Nhuộm tóc 24               Dịch vụ       265000        50000
                      DV150                        Nhuộm tóc 25               Dịch vụ       270000        50000
                      DV151                        Nhuộm tóc 26               Dịch vụ       275000        50000
                      DV152                        Nhuộm tóc 27               Dịch vụ       280000        50000
                      DV153                        Nhuộm tóc 28               Dịch vụ       285000        50000
                      DV154                        Nhuộm tóc 29               Dịch vụ       290000        50000
                      DV155                        Nhuộm tóc 30               Dịch vụ       295000        50000
                      #thay doi gia co ggdh
                      DV156                        Nhuộm tóc 31               Dịch vụ       300000        50000
                      DV157                        Nhuộm tóc 32               Dịch vụ       305000        50000
                      DV158                        Nhuộm tóc 33               Dịch vụ       310000        50000
                      DV159                        Nhuộm tóc 34               Dịch vụ       315000        50000
                      DV160                        Nhuộm tóc 35               Dịch vụ       320000        50000
                      DV161                        Nhuộm tóc 36               Dịch vụ       325000        50000
                      DV162                        Phục hồi tóc 1             Dịch vụ       45000         50000
                      DV163                        Phục hồi tóc 2             Dịch vụ       50000         50000
                      DV164                        Phục hồi tóc 3             Dịch vụ       55000         50000
                      DV165                        Phục hồi tóc 4             Dịch vụ       60000         50000
                      DV166                        Phục hồi tóc 5             Dịch vụ       65000         50000
                      DV167                        Phục hồi tóc 6             Dịch vụ       70000         50000
                      DV168                        Phục hồi tóc 7             Dịch vụ       75000         50000
                      DV169                        Phục hồi tóc 8             Dịch vụ       80000         50000
                      DV170                        Phục hồi tóc 9             Dịch vụ       85000         50000
                      DV171                        Phục hồi tóc 10            Dịch vụ       90000         50000
                      DV172                        Phục hồi tóc 11            Dịch vụ       95000         50000
                      DV173                        Phục hồi tóc 12            Dịch vụ       100000        50000
                      DV174                        Phục hồi tóc 13            Dịch vụ       105000        50000
                      DV175                        Phục hồi tóc 14            Dịch vụ       110000        50000
                      DV176                        Phục hồi tóc 15            Dịch vụ       115000        50000
                      DV177                        Phục hồi tóc 16            Dịch vụ       120000        50000
                      DV178                        Phục hồi tóc 17            Dịch vụ       125000        50000
                      DV179                        Phục hồi tóc 18            Dịch vụ       130000        50000
                      DV180                        Phục hồi tóc 19            Dịch vụ       135000        50000
                      DV181                        Phục hồi tóc 20            Dịch vụ       140000        50000
                      DV182                        Phục hồi tóc 21            Dịch vụ       145000        50000

EDD_taohoadon_layhetDH
                      [Tags]
                      [Template]                   create service
                      #tao dh co giam gia
                      DV183                        Dập phồng 1                Dịch vụ       150000        50000
                      DV184                        Dập phồng 2                Dịch vụ       155000        50000
                      DV185                        Dập phồng 3                Dịch vụ       160000        50000
                      DV186                        Dập phồng 4                Dịch vụ       165000        50000
                      DV187                        Dập phồng 5                Dịch vụ       170000        50000
                      DV188                        Dập phồng 6                Dịch vụ       175000        50000
                      DV189                        Dập phồng 7                Dịch vụ       180000        50000
                      DV190                        Dập phồng 8                Dịch vụ       185000        50000
                      DV191                        Dập phồng 9                Dịch vụ       190000        50000
                      DV192                        Dập phồng 10               Dịch vụ       195000        50000
                      DV193                        Dập phồng 11               Dịch vụ       200000        50000
                      DV194                        Dập phồng 12               Dịch vụ       205000        50000
                      DV195                        Dập phồng 13               Dịch vụ       210000        50000
                      DV196                        Dập phồng 14               Dịch vụ       215000        50000
                      DV197                        Dập phồng 15               Dịch vụ       220000        50000
                      #tao dh khong co giam gia
                      DV198                        Dập phồng 16               Dịch vụ       100000        50000
                      DV199                        Dập phồng 17               Dịch vụ       105000        50000
                      DV200                        Dập phồng 18               Dịch vụ       110000        50000
                      DV201                        Dập phồng 19               Dịch vụ       115000        50000
                      DV202                        Dập phồng 20               Dịch vụ       120000        50000
                      DV203                        Dập phồng 21               Dịch vụ       125000        50000
                      DV204                        Dập phồng 22               Dịch vụ       130000        50000
                      DV205                        Dập phồng 23               Dịch vụ       135000        50000
                      DV206                        Dập phồng 24               Dịch vụ       140000        50000
                      DV207                        Dập phồng 25               Dịch vụ       145000        50000
                      DV208                        Dập phồng 26               Dịch vụ       150000        50000
                      DV209                        Dập phồng 27               Dịch vụ       155000        50000
                      DV210                        Dập phồng 28               Dịch vụ       160000        50000
                      DV211                        Dập phồng 29               Dịch vụ       165000        50000
                      DV212                        Dập phồng 30               Dịch vụ       170000        50000
                      DV213                        Dập phồng 31               Dịch vụ       175000        50000
                      DV214                        Dập phồng 32               Dịch vụ       180000        50000
                      DV215                        Dập phồng 33               Dịch vụ       185000        50000
                      DV216                        Dập phồng 34               Dịch vụ       190000        50000
                      DV217                        Dập phồng 35               Dịch vụ       195000        50000
                      DV218                        Dập phồng 36               Dịch vụ       200000        50000
                      DV219                        Dập phồng 37               Dịch vụ       205000        50000
                      DV220                        Dập phồng 38               Dịch vụ       210000        50000
                      DV221                        Dập phồng 39               Dịch vụ       215000        50000
                      DV222                        Dập phồng 40               Dịch vụ       220000        50000
                      DV223                        Dập phồng 41               Dịch vụ       225000        50000
                      DV224                        Dập phồng 42               Dịch vụ       230000        50000
                      DV225                        Dập phồng 43               Dịch vụ       235000        50000
                      DV226                        Dập phồng 44               Dịch vụ       240000        50000
                      DV227                        Dập phồng 45               Dịch vụ       245000        50000
                      DV228                        Dập phồng 46               Dịch vụ       250000        50000
                      DV229                        Dập phồng 47               Dịch vụ       255000        50000
                      DV230                        Dập phồng 48               Dịch vụ       260000        50000
                      DV231                        Dập phồng 49               Dịch vụ       265000        50000
                      DV232                        Dập phồng 50               Dịch vụ       270000        50000
                      DV233                        Dập phồng 51               Dịch vụ       275000        50000
                      DV234                        Dập phồng 52               Dịch vụ       280000        50000
                      DV235                        Dập phồng 53               Dịch vụ       285000        50000
                      DV236                        Dập phồng 54               Dịch vụ       290000        50000
                      DV237                        Dập phồng 55               Dịch vụ       295000        50000
                      DV238                        Dập phồng 56               Dịch vụ       300000        50000
                      DV239                        Dập phồng 57               Dịch vụ       305000        50000
                      DV240                        Dập phồng 58               Dịch vụ       310000        50000
                      DV241                        Dập phồng 59               Dịch vụ       315000        50000
                      DV242                        Dập phồng 60               Dịch vụ       320000        50000
                      DV243                        Dập phồng 61               Dịch vụ       325000        50000
                      DV244                        Dập phồng 62               Dịch vụ       330000        50000
                      DV245                        Dập phồng 63               Dịch vụ       335000        50000
                      DV246                        Dập phồng 64               Dịch vụ       340000        50000
                      DV247                        Dập phồng 65               Dịch vụ       345000        50000
                      DV248                        Dập phồng 66               Dịch vụ       350000        50000
                      DV249                        Dập phồng 67               Dịch vụ       355000        50000
                      DV250                        Dập phồng 68               Dịch vụ       360000        50000
                      DV251                        Dập phồng 69               Dịch vụ       365000        50000
                      DV252                        Dập phồng 70               Dịch vụ       370000        50000
                      #thua
                      DV253                        Dập phồng 71               Dịch vụ       375000        50000
                      DV254                        Dập phồng 72               Dịch vụ       380000        50000
                      DV255                        Dập phồng 73               Dịch vụ       385000        50000
                      DV256                        Dập phồng 74               Dịch vụ       390000        50000
                      DV257                        Dập phồng 75               Dịch vụ       395000        50000
                      DV258                        Dập phồng 76               Dịch vụ       400000        50000
                      DV259                        Dập phồng 77               Dịch vụ       405000        50000
                      DV260                        Dập phồng 78               Dịch vụ       410000        50000
                      DV261                        Dập phồng 79               Dịch vụ       415000        50000
                      DV262                        Dập phồng 80               Dịch vụ       420000        50000
                      DV263                        Dập phồng 81               Dịch vụ       425000        50000
                      DV264                        Dập phồng 82               Dịch vụ       430000        50000
                      DV265                        Dập phồng 83               Dịch vụ       435000        50000
                      DV266                        Dập phồng 84               Dịch vụ       440000        50000
                      DV267                        Dập phồng 85               Dịch vụ       445000        50000
                      DV268                        Dập phồng 86               Dịch vụ       450000        50000
                      DV269                        Dập phồng 87               Dịch vụ       455000        50000
                      DV270                        Dập phồng 88               Dịch vụ       460000        50000
                      DV271                        Dập phồng 89               Dịch vụ       465000        50000
                      DV272                        Dập phồng 90               Dịch vụ       470000        50000
                      DV273                        Dập phồng 91               Dịch vụ       475000        50000
                      DV274                        Dập phồng 92               Dịch vụ       480000        50000
                      DV275                        Dập phồng 93               Dịch vụ       485000        50000
                      DV276                        Dập phồng 94               Dịch vụ       490000        50000
                      DV277                        Dập phồng 95               Dịch vụ       495000        50000
                      DV278                        Dập phồng 96               Dịch vụ       500000        50000
                      DV279                        Dập phồng 97               Dịch vụ       505000        50000
                      DV280                        Dập phồng 98               Dịch vụ       510000        50000
                      DV281                        Dập phồng 99               Dịch vụ       515000        50000
                      DV282                        Dập phồng 100              Dịch vụ       520000        50000
                      DV283                        Dập phồng 101              Dịch vụ       525000        50000
                      DV284                        Dập phồng 102              Dịch vụ       530000        50000
                      DV285                        Dập phồng 103              Dịch vụ       535000        50000
                      DV286                        Dập phồng 104              Dịch vụ       540000        50000
                      DV287                        Dập phồng 105              Dịch vụ       545000        50000
                      DV288                        Dập phồng 106              Dịch vụ       550000        50000
                      DV289                        Dập phồng 107              Dịch vụ       555000        50000
                      DV290                        Dập phồng 108              Dịch vụ       560000        50000
                      DV291                        Dập phồng 109              Dịch vụ       565000        50000
                      DV292                        Dập phồng 110              Dịch vụ       570000        50000
                      DV293                        Dập phồng 111              Dịch vụ       575000        50000
                      DV294                        Dập phồng 112              Dịch vụ       580000        50000
                      DV295                        Dập phồng 113              Dịch vụ       585000        50000
                      DV296                        Dập phồng 114              Dịch vụ       590000        50000
                      DV297                        Dập phồng 115              Dịch vụ       595000        50000
                      DV298                        Dập phồng 116              Dịch vụ       600000        50000
                      DV299                        Dập phồng 117              Dịch vụ       605000        50000
                      DV300                        Dập phồng 118              Dịch vụ       610000        50000

Test                  [Tags]
                      [Template]                   create service
                      DV133                        Nhuộm tóc 8                Dịch vụ       185000        50000

Gộp hóa đơn           [Tags]                       GHD
                      [Template]                   create service
                      GHDDV001                     Cắt tóc Nam                Dịch vụ       100000        50000
                      GHDDV002                     Cắt tóc nữ                 Dịch vụ       200000        98000
                      GHDDV003                     Uốn tóc - Obistan          Dịch vụ       350000        100000
                      GHDDV004                     Dập phồng tóc - Obistan    Dịch vụ       250000        200000
                      GHDDV005                     Nhuộm tóc - Obistan        Dịch vụ       500000        300000
                      GHDDV006                     Uốn tóc - Loreal           Dịch vụ       190000        90000

GDH                  [Tags]                        GDH
                      [Template]                   create service
                      DV301                        rán nem chua               Dịch vụ       185000        50000
                      DV302                        bánh gà ngon               Dịch vụ       185000        50000

*** Keywords ***
create service
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    Add service    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}

Add new service have guarantee
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${time_bh1}    ${timetype_bh1}
    ...    ${time_bh2}    ${timetype_bh2}    ${time_bh3}    ${timetype_bh3}    ${time_bt}    ${timetype_bt}
    ${product_id}   Add service have genuine guarantees    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${time_bh1}    ${timetype_bh1}
    ...    ${time_bh2}    ${timetype_bh2}    ${time_bh3}    ${timetype_bh3}    ${time_bt}    ${timetype_bt}
    Save multi guarantee after create product    ${time_bh1}    ${timetype_bh1}
    ...    ${time_bh2}    ${timetype_bh2}    ${time_bh3}    ${timetype_bh3}    ${time_bt}    ${timetype_bt}     ${product_id}
