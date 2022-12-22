*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/doitac.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Test Cases ***    Ma                            Ten                          SDT                        Diachi
EB                    [Tags]                        EB
                      [Template]                    Add customers
                      KH001                         Nâu nâu                      0985456321                 Thai Ha
                      KH002                         Nguyễn Thị Vân Anh           0987566985                 ABBC
                      KH003                         Quách Thị Hồng Nhung         0987565452                 789 HND-HN
                      KH004                         Nguyễn Khánh Linh            0985214563                 SHHH
                      KH005                         A Mây                        0987545632                 Thai Ha
                      KH006                         lucky                        0987565456                 ABBC
                      KH007                         Anna                         0985478965                 789 HND-HN
                      KH008                         Aff                          0954753254                 SHHH
                      KH009                         Ma ma choco                  0987563214                 121677 HNDOO
                      KH010                         0932261061                   0932261061                 kl
                      KH011                         0946879883                   0946879883                 310 đội cấn
                      KH012                         chị hiền                     0989463299                 số 50 xóm thuỵ phú diễn từ liêm
                      KH013                         chị loan                     0985220387                 số 9 ngõ 331 nguyễn khang
                      KH014                         chị Nga                      0974691030                 kl                                                                                                                            #sr
                      KH015                         chị Hà 0936584157            0936584157                 54 văn chung p13 tân bình hcm
                      KH016                         Anh Dũng 0982270187          0982270187                 trung tâm huấn luyện thể thao quốc gia 1 nhổn khu A
                      KH017                         CHỊ THẢO                     0982256512                 478 NGUYỄN THỊ MINH KHAI, P2, Q3, TPHCM
                      KH018                         Chị Trang Vũ 0983731096      0983731096                 nhà số 9 tổ 2 ngách 295/5/9 gia quất thượng thanh long biên
                      KH019                         A Luân                       0976297592                 Ngã tư Bình Thái , Q Thủ Đức
                      KH020                         A. TÍN                       0906626101                 CĂN D4, LẦU 3, HQ1, Chung cư HQC Plaza, NGUYỄN VĂN LINH, BÌNH CHÁNH, TPHCM ( GẦN CẦU VƯỢT QUANG TRUNG1)
                      KH021                         chị thuỷ                     0985224479                 số nhà 21 ngõ 165 phố mai dịch
                      KH022                         chị Hạnh                     0986154015                 kl
                      KH023                         anh Hùng                     0947899955                 kl
                      KH024                         Chị Hằng                     0976716583                 số 66 ngách 32/84 đỗ đức dục
                      KH025                         chị Duyên 0983549385         0983549385                 phòng 1932. tầng 19, tòa HH3C, Khu đô thị Linh Đàm
                      KH026                         0927740927                   0927740927                 nhà xe tô châu . người nhận Triệu thị ngọc vân 0909788088 gửi về Cần thơ
                      KH027                         micky                        123                        Bệnh vIện K, Tân Triều, Hà Đông
                      KH028                         mèo mun                      321                        tam đảo, Vĩnh Phúc
                      KH029                         Addin                        456123                     yyyyyyyyyy
                      KH030                         Gấu Pooh                     123456                     Nhà Hàng Chả Cá Hà Thành
CBPPI                [Tags]                      CBPPI      EB1
                      [Template]                    Add customers
                      KH031                         Cháo quẩy                    987654                     945/63/19 đường lê đức thọ p16 quận gò vấp
                      KH032                         C Hương 09839373080          09839373080                Nhà Ngọc Hải Quỳnh Phương - Hoàng Mai- Nghệ An
                      KH033                         Chị Thu                      0965013330                 số 7 ngõ 1150 Đường Láng

CON_PROMO_TK                [Tags]                CONPROTK     EB1
                      [Template]                    Add customers
                      KH034                         C kim chi 01689782498        01689782498                Sảnh căn hộ tòa nhà R1B khu đô thị royal, 72a nguyễn trãi
                      KH035                         0908438455                   0908438455                 Vườn Hoa Phủ Lý - Hà Nam
                      KH036                         Phạm Tuyết 0985810902        0985810902                 K54 hoàng diệu p6 q4

EUBM                  [Tags]           EUBMCUS     EB1
                      [Template]                    Add customers
                      KH037                         Anh Tô Quang Toàn            COD_0963189099             lê hồng phong

PM                [Tags]           PM     EB1
                      [Template]                    Add customers
                      KH038                         Nguyễn Quỳnh 0986229513      0986229513                 Nhà số 22, ngõ thịnh hào 2, Tôn Đức Thắng hn
                      KH039                         Anh Vũ                       0949969869                 Số 15, Ngõ 41, An Xá, Phúc Xá, Ba Đình
                      KH040                         Vương Đại Lợi 0969064364     0969064364                 Số 1, Phạm Văn Bạch, Cầu Giấy
                      KH041                         Chị Mỹ                       0938688548                 Nghệ An

UPC                [Tags]                 UPC     EB1
                      [Template]                    Add customers
                      KH042                         Anh Khanh                    0908222466                 Thôn Ninh Hạ, Nhật Tân, Tiễn Lữ, Hưng Yên:
                      KH043                         chị Hằng 0969953993          0969953993                 40 phố nhà chung, Tòa Giám mục, Hoàn Kiếm

Remain                [Tags]
                      [Template]                    Add customers
                      KH044                         Anh Đô                       0914593902                 Thanh Hóa
                      KH045                         Anh Bằng                     0944864203                 Tầng 2 công ty Việt Thắng, Tòa nhà Vinacom, Ngõ 89 Lê Đức Thọ, sau Fivimart
                      KH046                         anh Huy                      0933322020                 B5 C3 Đại Kim, Hoang Mai (hỏi khách sạn Quê Hương ở đường Nguyễn Cảnh DỊ)
                      KH047                         chị Thúy 0975426392          0975426392                 186 hoa Bằng, cầu Giấy
                      KH048                         chị Cẩm                      0937936352 + 0906387323    155/16 phường 4 nguyễn thái sơn quận gò vấp
                      KH049                         Cô Nga                       0909607055                 kl
                      KH050                         C Thu 0934516465             0934516465                 661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân
                      KH051                         A. Thanh                     0934034440                 Số nhà 112, Ngõ 242, Đường Láng
                      KH052                         Chị Nga                      0927299399                 Nhà c 2/87/409 Kim Mã
                      KH053                         C Trâm                       0986228225                 29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      KH054                         Chị Loan                     0993393938+0994667668      số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      KH055                         Chị Diệu Hà                  COD_0914620024             2a dinh tien hoang Quận 1
                      KH056                         Chị Ngân                     02466608810/01694385104    Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      KH057                         chị Hạnh                     0984550570                 12 Tân Trào . P Tân Phú . Q7
                      KH058                         0902770615                   0902770615                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      KH059                         C Hoài 0906154096            0906154096                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      KH060                         Chị Hương                    0919791528                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      KH061                         C Lương                      0934406687                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      KH062                         Chị Ngọc                     01626870654                số 138-142 Hai Bà Trưng P.Đakao quận 1 TPHCM
                      KH063                         Anh Hà                       0936633383                 50/46 gò giàu phường tân quý quận tân phú
                      KH064                         chị Duyên                    01219670275                12-14 TRẦN PHÚ , NHA TRANG, KHÁNH HÒA
                      KH065                         Chị Huệ                      0935351153                 ffffffff
                      KH066                         09835354812                  09835354812                160/58/24 PHAN HUY ÍCH, P12, GÒ VẤP
                      KH067                         Anh Thạch                    0918379333                 Vincom Plaza Long Biên- Khu đô thị Vinhomes Riverside, Phúc Lợi, Long Biên, Hà Nội
                      KH068                         Chị Thanh                    0981922329                 Số 32, ngách 20, Ngõ 460 Khương Đình
                      KH069                         Lê Thị Nhân 0965162621       0965162621                 sss
                      KH070                         C Mai                        0902560055                 Nhà Hàng Chả Cá Hà Thành
                      KH071                         A Duy                        0982345682                 945/63/19 đường lê đức thọ p16 quận gò vấp
                      KH072                         Anh Đạt                      0903361336                 Nhà Ngọc Hải Quỳnh Phương - Hoàng Mai- Nghệ An
                      KH073                         anh Duẩn                     0964536382                 số 7 ngõ 1150 Đường Láng
                      KH074                         A Long 0983466436            0983466436                 Sảnh căn hộ tòa nhà R1B khu đô thị royal, 72a nguyễn trãi
                      KH075                         Anh Hùng                     01657168288                Vườn Hoa Phủ Lý - Hà Nam
                      KH076                         Anh Lạc                      0939039236                 K54 hoàng diệu p6 q4
                      KH077                         C yên 0945964207             0945964207                 lê hồng phong
                      KH078                         C Hằng 0979379055            0979379055                 Nhà số 22, ngõ thịnh hào 2, Tôn Đức Thắng hn
                      KH079                         Chị Hoa                      0978619937                 Số 15, Ngõ 41, An Xá, Phúc Xá, Ba Đình
                      KH080                         Anh Thái                     0888776222                 Số 1, Phạm Văn Bạch, Cầu Giấy
                      KH081                         A Tiến 0989998357            0989998357                 Nghệ An
                      KH082                         C Minh Giang 0943076112      0943076112                 Thôn Ninh Hạ, Nhật Tân, Tiễn Lữ, Hưng Yên:
                      KH083                         01249962267                  01249962267                40 phố nhà chung, Tòa Giám mục, Hoàn Kiếm
                      KH084                         Chị Thủy                     0981353639                 Thanh Hóa
                      KH085                         Chị Nhớ 01223202997          01223202997                Tầng 2 công ty Việt Thắng, Tòa nhà Vinacom, Ngõ 89 Lê Đức Thọ, sau Fivimart
                      KH086                         Chị Hải                      0973004207                 B5 C3 Đại Kim, Hoang Mai (hỏi khách sạn Quê Hương ở đường Nguyễn Cảnh DỊ)
                      KH087                         Chị Ngọc                     0904861661                 186 hoa Bằng, cầu Giấy
                      KH088                         Anh Thọ 0984660720           0984660720                 155/16 phường 4 nguyễn thái sơn quận gò vấp
                      KH089                         Anh Đức                      0911851201                 kl
                      KH090                         Anh Duơng 0914842006         0914842006                 661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân
                      KH091                         0944246024                   0944246024                 Số nhà 112, Ngõ 242, Đường Láng
                      KH092                         C oanh 0904178091            0904178091                 Nhà c 2/87/409 Kim Mã
                      KH093                         A Thịnh 0982534999           0982534999                 29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      KH094                         C hường 01689955620          01689955620                số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      KH095                         Anh Hải                      0911602828                 2a dinh tien hoang Quận 1
                      KH096                         Lương Như Lập                COD_01645166960            Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      KH097                         anh Dương 0932292832         0932292832                 12 Tân Trào . P Tân Phú . Q7
                      KH098                         Chị Loan                     0986545486                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      KH099                         Chị Xuân                     0913945355                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      KH100                         cô Triệu 0988286908          0988286908                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      KH101                         A lâm 01689946055            01689946055                Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      KH102                         Chị Hai 0936625576           0936625576                 số 138-142 Hai Bà Trưng P.Đakao quận 1 TPHCM
                      KH103                         anh Tuyền 0973388316         0973388316                 50/46 gò giàu phường tân quý quận tân phú
                      KH104                         C Phương                     0906610561                 12-14 TRẦN PHÚ , NHA TRANG, KHÁNH HÒA
                      KH105                         Chị Mai                      0943750057                 sssss
                      KH106                         C Thu 0934516465             982535069                  A
                      KH107                         A. Thanh                     1689955690                 B
                      KH108                         Chị Nga                      911602898                  B
                      KH109                         C Trâm                       1645167030                 V
                      KH110                         Chị Loan                     932292902                  A
                      KH111                         Chị Diệu Hà                  986545556                  B
                      KH112                         Chị Ngân                     913945425                  B
                      KH113                         chị Hạnh                     988286978                  V
                      KH114                         0902770615                   1689946125                 A
                      KH115                         C Hoài 0906154096            936625646                  B
                      KH116                         C Thu 0934516465             973388386                  A
                      KH117                         A. Thanh                     906610631                  B
                      KH118                         Chị Nga                      943750127                  B
                      KH119                         C Trâm                       982535109                  V
                      KH120                         Chị Loan                     1689955730                 A
                      KH121                         Chị Diệu Hà                  911602938                  B
                      KH122                         Chị Ngân                     1645167070                 B
                      KH123                         chị Hạnh                     932292942                  V
                      KH124                         0902770615                   986545596                  A
                      KH125                         C Hoài 0906154096            913945465                  B

EBG                   [Tags]                        EBG
                      [Template]                    Add customer with address
                      Hà Nội - Quận Hai Bà Trưng    Phường Bách Khoa             CTKH001                    Nguyễn Thị Mai Anh                                                                                                            0912754690    1983-09-10T17:00:00    số 11 ngõ 123 \ Trần Đại nghĩa    2
                      Hà Nội - Quận Hai Bà Trưng    Phường Trương Định           CTKH002                    Lê Thị Ngọc Thủy                                                                                                              0912754691    1984-09-11T17:00:01    45 ngách 234/12 Hồng Mai          2
                      Hà Nội - Quận Đống Đa         Phường Trung Tự              CTKH003                    Nguyễn Thị Hoài                                                                                                               0912754692    1985-09-12T17:00:02    70/25 Đặng Văn Ngữ                2
                      Hà Nội - Quận Đống Đa         Phường Phương Liên           CTKH004                    Trần Ngọc Anh                                                                                                                 0912754693    1986-09-13T17:00:03    15 ngõ 4C Đặng Văn Ngữ            2
                      Hà Nội - Quận Hai Bà Trưng    Phường Lê Đại Hành           CTKH005                    Nguyễn Tiến Đạt                                                                                                               0912754694    1987-09-14T17:00:04    5B ngõ Bà Triệu                   1
                      Hà Nội - Quận Cầu Giấy        Phường Mai Dịch              CTKH006                    Trần Lê Cường                                                                                                                 0912754695    1988-09-15T17:00:05    123 Cầu giấy                      1
                      Hà Nội - Quận Bắc Từ Liêm     Phường Cổ Nhuế 1             CTKH007                    Lữ Thị Hoài Thanh                                                                                                             0912754696    1989-09-16T17:00:06    87 Hoàng Quốc Việt                2
                      Hà Nội - Quận Hoàng Mai       Phường Tân Mai               CTKH008                    Lê Thị Ngọc Hà                                                                                                                0912754697    1990-09-17T17:00:07    64 ngõ 389/24 Trương Định         2
                      Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam               CTKH009                    Kiều Quang Thiện                                                                                                              0912754698    1991-09-18T17:00:08    Số 1 Phan Bội Châu                1

Nhieu_dong            [Tags]                        EDH
                      [Template]                    create KH
                      CTKH010                      Chị Trang Vũ 0983731096      0983456789                 54 văn chung p13 tân bình hcm
                      CTKH011                      CHỊ THẢO                     0983456790                 Kim Văn Kim lũ
                      CTKH012                      Anh Dũng 0982270187          0983456791                 số 9 ngõ 331 nguyễn khang
                      CTKH013                      chị Hà 0936584157            0983456792                 số 50 xóm thuỵ phú diễn từ liêm
                      CTKH014                      Anna                         0983456793                 310 đội cấn
                      CTKH015                      lucky                        0983456794                 19 Chợ Hôm
                      CTKH016                      A Mây                        0983456795                 297 Hàng Bài
                      CTKH017                      chị loan                     0983456796                 458 Đường Láng - Ngã Tư Sở
                      CTKH018                      chị hiền                     0983456797                 74 Trung Yên
                      CTKH019                      C Trâm                       0983456798                 29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      CTKH020                      Chị Loan                     0983456799                 số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      CTKH021                      Chị Diệu Hà                  0983456800                 2a dinh tien hoang Quận 1
                      CTKH022                      Chị Ngân                     0983456801                 Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      CTKH023                      chị Hạnh                     0983456802                 12 Tân Trào . P Tân Phú . Q7
                      CTKH024                      902770615                    0983456803                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      CTKH025                      C Hoài 0906154096            0983456804                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      CTKH026                      Chị Hương                    0983456805                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      CTKH027                      C Lương                      0983456806                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      CTKH028                      Chị Ngọc                     0983456807                 số 138-142 Hai Bà Trưng P.Đakao quận 1 TPHCM
                      CTKH029                      Anh Hà                       0983456808                 50/46 gò giàu phường tân quý quận tân phú
                      CTKH030                      chị Duyên                    0983456809                 12-14 TRẦN PHÚ , NHA TRANG, KHÁNH HÒA
                      CTKH031                      Chị Huệ                      0983456810                 ffffffff
                      CTKH032                      1235354812                   0983456811                 160/58/24 PHAN HUY ÍCH, P12, GÒ VẤP

Shop config            [Tags]                        EDH      TL
                      [Template]                    create KH
                      CTKH033                      Khách hàng 1                    0983456812                 Sài gòn 1
                      CTKH034                      Khách hàng 2                    0983456813                 Sài gòn 2


Remain
                      CTKH035                      Khách hàng 3                    0983456814                 Sài gòn 3
                      CTKH036                      Khách hàng 4                    0983456815                 Sài gòn 4
                      CTKH037                      Khách hàng 5                    0983456816                 Sài gòn 5

Khuyen_mai_gop         [Tags]                        EDH
                      [Template]                    create KH
                      CTKH038                      Khách hàng 6                    0983456817                 Sài gòn 6
                      CTKH039                      Khách hàng 7                    0983456818                 Sài gòn 7
                      CTKH040                      Khách hàng 8                    0983456819                 Sài gòn 8
                      CTKH041                      Khách hàng 9                    0983456820                 Sài gòn 9
                      CTKH042                      Khách hàng 10                    0983456821                 Sài gòn 10
                      CTKH043                      Khách hàng 11                    0983456822                 Sài gòn 11

Doi_tra_hang_Other                   [Tags]              DTH
                      [Template]                    create KH
                      #thu khac
                      CTKH044                       Chị Thanh                    0912754733                 Số 32, ngách 20, Ngõ 460 Khương Đình
                      CTKH045                       Chị Phạm Thị Hồng Phú        0912754734                 bến xe Yên Nghĩa
                      CTKH046                       C Linh                       0912754735                 Số Nhà E2 KHU BÁN DẢO TRUNG ƯƠNG - NGÕ 461 nguyễn Văn Ninh
                      CTKH047                       Chị Nhung 0914283555         0912754736                 63/7 T tổ 80 khu phố 7 Phường Tân Thới Nhất - Q12
                      #nhieu dong
                      CTKH048                       Le xuan hieu 0938787926      0912754737                 2385/87/16 P6 Q8 PHẠM THẾ HIỂN
                      CTKH049                       A nam 0981212328             0912754738                 262/66a1 Tôn thất thuyết,f3,q.4.tphcm Quận 4
                      CTKH050                       Chị Mai                      0912754739                 Số 1 Đường 17 Khu Phố 3 Hiệp Bình Phước -Thủ Đức
                      CTKH051                       anh Quát                     0912754740                 Tòa nhà Tây Hà 19 Tố Hữu.
                      ## payment type
                      CTKH052                       A Nam 0963862330             0912754741                 Bệnh vIện K, Tân Triều, Hà Đông
                      CTKH053                       chị Hạnh                     0912754742                 tam đảo, Vĩnh Phúc
                      CTKH054                       chú Kiểm                     0912754743                 Bệnh vIện K, Tân Triều, Hà Đông
                      CTKH055                       919104888                    0912754744                 tam đảo, Vĩnh Phúc

Cong_no_KH                   [Tags]                        PBCNKH
                      [Template]                    create KH
                      CTKH056                       c diễm: 01667412953          0912754745                 Bệnh vIện K, Tân Triều, Hà Đông
                      CTKH057                       Anh Hà 0919096133            0912754746                 tam đảo, Vĩnh Phúc
                      CTKH058                       Lê Thị Nhân 0965162621       0912754747                 sss
                      CTKH059                       C Mai                        0912754748                 Nhà Hàng Chả Cá Hà Thành
                      CTKH060                       A Duy                        0912754749                 945/63/19 đường lê đức thọ p16 quận gò vấp
                      CTKH061                       Anh Đạt                      0912754750                 Nhà Ngọc Hải Quỳnh Phương - Hoàng Mai- Nghệ An
                      CTKH062                       anh Duẩn                     0912754751                 số 7 ngõ 1150 Đường Láng
                      CTKH063                       A Long 0983466436            0912754752                 Sảnh căn hộ tòa nhà R1B khu đô thị royal, 72a nguyễn trãi
                      CTKH064                       Anh Hùng                     0912754753                 Vườn Hoa Phủ Lý - Hà Nam
                      CTKH065                       Anh Lạc                      0912754754                 K54 hoàng diệu p6 q4
                      CTKH066                       C yên 0945964207             0912754755                 lê hồng phong
                      CTKH067                       C Hằng 0979379055            0912754756                 Nhà số 22, ngõ thịnh hào 2, Tôn Đức Thắng hn
                      CTKH068                       Chị Hoa                      0912754757                 Số 15, Ngõ 41, An Xá, Phúc Xá, Ba Đình
                      CTKH069                       Anh Thái                     0912754758                 Số 1, Phạm Văn Bạch, Cầu Giấy

Khuyen_mai_phamvi_apdung          [Tags]     PROMOTION
                      [Template]                    create KH
                      CTKH070                       A Tiến 0989998357            0912754759                 Nghệ An
                      CTKH071                       C Minh Giang 0943076112      0912754760                 Thôn Ninh Hạ, Nhật Tân, Tiễn Lữ, Hưng Yên:
                      CTKH073                       Chị Thủy                     0912754762                 Thanh Hóa
                      CTKH074                       Chị Nhớ 01223202997          0912754763                 Tầng 2 công ty Việt Thắng, Tòa nhà Vinacom, Ngõ 89 Lê Đức Thọ, sau Fivimart

Khuyen_mai_phamvi_apdung          [Tags]     PROMOTION
                      [Template]                    Add new invoice when created customer
                      CTKH072                       1249962267                   0912754761                 40 phố nhà chung, Tòa Giám mục, Hoàn Kiếm     Combo28   3     all
                      CTKH076                       Phạm Thị Thu Hà              0912754765                 Số nhà 112, Ngõ 242, Đường Láng         Combo28       3     all

Bảo hành bảo trì                   [Tags]                        BHBT
                      [Template]                    create KH
                      CTKH075                       Nguyễn Thị Hồng Giang        0912754764                 661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân
                      CTKH078                       Nguyễn Nga Ngọc              0912754767                 29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      CTKH079                       Lâm Thị Anh                  0912754768                 số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      CTKH080                       Trần Thị Vân                 0912754769                 2a dinh tien hoang Quận 1
                      CTKH081                       Phạm Thị Trang               0912754770                 Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      CTKH082                       Đỗ Đình Dinh                 0912754771                 12 Tân Trào . P Tân Phú . Q7

Optimize                   [Tags]                        OPT
                      [Template]                    create KH
                      CTKH083                       Vũ Anh Đức                   0912754772                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3

Dat hang thuong                   [Tags]                        EDH       NEW
                      [Template]                    create KH
                      CTKH084                       Nguyễn Đức Chí               0912754773                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      CTKH085                       Nguyễn Đức Hoằng             0912754774                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      CTKH086                       Lê Minh Tân                  0912754775                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      CTKH087                       Lương Như Lập                0912754776                 Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      CTKH088                       anh Dương 0932292832         0912754777                 12 Tân Trào . P Tân Phú . Q7
                      CTKH089                       Chị Loan                     0912754778                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      CTKH090                       Chị Xuân                     0912754779                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      CTKH091                       cô Triệu 0988286908          0912754780                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      CTKH092                       A lâm 01689946055            0912754781                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      CTKH093                       anh Hưng                     0912754782                 karaoke 454-Tây Sơn - Đống đa
                      CTKH094                       Cô Hiền                      0912754783                 15A Yên phụ - tây hồ-hà nội
                      CTKH095                       Chị Hoa                      0912754784                 karaoke 292 bạch đằng- hoàn kiếm - hà nội.
                      CTKH096                       Chị Huyền                    0912754785                 karaoke 15 nam đồng - xã đàn
                      CTKH097                       Chị Lam                      0912754786                 Tiện Lợi Mart C 3 Nguyễn Cơ Thạch - Nam Từ Liêm
                      CTKH098                       Chị Nguyệt                   0912754787                 Thcs giảng võ số 1 phố trần huy liệu
                      CTKH099                       Trương Huyền ngân            0912754788                 Thpt nguyễn trãi phố nam cao- ba đình
                      CTKH100                       Bác Nguyệt                   0912754789                 2/b2 trần huy liệu
                      CTKH101                       Chị PHạm Thị kim ly          0912754790                 8/477 kim mã - Ba Đình
                      CTKH102                       Nguyễn Thị Thu trang         0912754791                 Dinomart 95 nguyễn thị định cầu giấy

Thu khac_DH                   [Tags]                        EDH      NEW
                      [Template]                    create KH
                      CTKH103                       Chị Ngân                     0912754792                 số nhà 103B khu A16 nghĩa tân cầu giấy
                      CTKH104                       Chị Hương ly                 0912754793                 phúc tâm an lô số 10 - 17T1 - CT2 đường cương kiên - trung văn - nam từ liêm
                      CTKH105                       Chị Đức                      0912754794                 MILIDA MART số 47 nguyễn văn lộc hà đông
                      CTKH106                       Chị Thảo                     0912754795                 43 đặng thùy trâm cầu giấy
                      CTKH107                       Anh Sơn Latco                0912754796                 31 đặng thùy trâm cầu giấy
                      CTKH108                       Sakuara                      0912754797                 A1 nguyễn cơ thạch
                      CTKH109                       Trần Hồng Quang              0912754798                 số 2 ngõ 26 doãn kế thiện
                      CTKH110                       Nguyễn Huyền Trang           0912754799                 tiện lợi mart 115 hạ đình thanh xuân

Khuyen_mai_DH         [Tags]                        PROMOTION
                      [Template]                    create KH
                      CTKH111                       Nguyễn An                    0912754800                 thực phẩm sạch donavi 46 nguyễn thị định cầu giấy
                      CTKH112                       Nguyễn Hoàng Mai             0912754801                 121 yên phụ ( yên phụ nhỏ ) tây hồ
                      CTKH113                       CHỊ THU CT4                  0912754802                 4B PHAN ĐÌNH GIÓT - THANH XUÂN
                      CTKH114                       Luan Nguyen                  0912754803                 Sảnh căn hộ tòa nhà R1B khu đô thị royal, 72a nguyễn trãi
                      CTKH115                       Nguyễn Văn Hải               0912754804                 Vườn Hoa Phủ Lý - Hà Nam
                      CTKH116                       Tuấn - Hà Nội                0912754805                 K54 hoàng diệu p6 q4
                      CTKH117                       Phạm Thu Hương               0912754806                 lê hồng phong
                      CTKH118                       Anh Hoàng - Sài Gòn          0912754807                 Nhà số 22, ngõ thịnh hào 2, Tôn Đức Thắng hn
                      CTKH119                       Anh Giang - Kim Mã           0912754808                 Số 15, Ngõ 41, An Xá, Phúc Xá, Ba Đình
                      CTKH120                       Chị PHạm Thị kim ly          0908222484                 8/477 kim mã - Ba Đình
                      CTKH121                       Nguyễn Thị Thu trang         0908222485                 Dinomart 95 nguyễn thị định cầu giấy
                      CTKH122                       Chị Ngân                     0908222486                 số nhà 103B khu A16 nghĩa tân cầu giấy
                      ###
                      KHKM01                       Khách khuyến mại 1	      0358495456	      	101 Xã Đàn
                      KHKM02                       Khách khuyến mại 2	      0358495457	      	102 Xã Đàn
                      KHKM03                       Khách khuyến mại 3	      0358495458	      	103 Xã Đàn
                      KHKM04                       Khách khuyến mại 4	      0358495459	      	104 Xã Đàn
                      KHKM05                       Khách khuyến mại 5	      0358495460	      	105 Xã Đàn
                      KHKM06                       Khách khuyến mại 6	      0358495461	      	106 Xã Đàn
                      KHKM07                       Khách khuyến mại 7	      0358495462	      	107 Xã Đàn
                      KHKM08                       Khách khuyến mại 8	      0358495463	      	108 Xã Đàn
                      KHKM09                       Khách khuyến mại 9	      0358495464	      	109 Xã Đàn
                      KHKM10                       Khách khuyến mại 10	    0358495465	      	110 Xã Đàn
                      KHKM11                       Khách khuyến mại 11	    0358495466	      	111 Xã Đàn
                      KHKM12                       Khách khuyến mại 12	    0358495467	      	112 Xã Đàn

Tra hang                   [Tags]                        EDH
                      [Template]                    create KH
                      CTKH123                       Chị Hương ly                 0908222487                 phúc tâm an lô số 10 - 17T1 - CT2 đường cương kiên - trung văn - nam từ liêm
                      CTKH124                       Chị Đức                      0908222488                 MILIDA MART số 47 nguyễn văn lộc hà đông
                      CTKH125                       Chị Thảo                     0908222489                 43 đặng thùy trâm cầu giấy
                      CTKH126                       Anh Sơn Latco                0908222490                 31 đặng thùy trâm cầu giấy
                      CTKH127                       Sakuara                      0908222491                 A1 nguyễn cơ thạch
                      CTKH128                       Trần Hồng Quang              0908222492                 số 2 ngõ 26 doãn kế thiện
                      CTKH129                       Nguyễn Huyền Trang           0908222493                 tiện lợi mart 115 hạ đình thanh xuân

Doi Tra hang          [Tags]                        EDH
                      [Template]                    create KH
                      CTKH130                       Nguyễn An                    0908222494                 thực phẩm sạch donavi 46 nguyễn thị định cầu giấy
                      CTKH131                       Nguyễn Hoàng Mai             0908222495                 121 yên phụ ( yên phụ nhỏ ) tây hồ
                      CTKH132                       CHỊ THU CT4                  0908222496                 4B PHAN ĐÌNH GIÓT - THANH XUÂN
                      CTKH133                       Luan Nguyen                  0908222497                 Sảnh căn hộ tòa nhà R1B khu đô thị royal, 72a nguyễn trãi
                      CTKH134                       Nguyễn Văn Hải               0908222498                 Vườn Hoa Phủ Lý - Hà Nam
                      CTKH135                       Tuấn - Hà Nội                0908222499                 K54 hoàng diệu p6 q4
                      CTKH136                       Phạm Thu Hương               0908222500                 lê hồng phong
                      CTKH137                       Anh Hoàng - Sài Gòn          0908222501                 Nhà số 22, ngõ thịnh hào 2, Tôn Đức Thắng hn
                      CTKH138                       Anh Giang - Kim Mã           0908222502                 Số 15, Ngõ 41, An Xá, Phúc Xá, Ba Đình
                      CTKH139                       Nguyễn Hồng Thắm             0908222503                 Số 1, Phạm Văn Bạch, Cầu Giấy
                      CTKH140                       Trịnh Thị Mai Anh            0908222504                 Nghệ An
                      CTKH141                       Trần Thị Vân                 0908222505                 Thôn Ninh Hạ, Nhật Tân, Tiễn Lữ, Hưng Yên:
                      CTKH142                       Phạm Thị Trang               0908222506                 40 phố nhà chung, Tòa Giám mục, Hoàn Kiếm
                      CTKH143                       Vũ Anh Đức                   0908222507                 Thanh Hóa
                      CTKH144                       Nguyễn Đức Chí               0908222508                 Tầng 2 công ty Việt Thắng, Tòa nhà Vinacom, Ngõ 89 Lê Đức Thọ, sau Fivimart
                      CTKH145                       Nguyễn Đức Hoằng             0908222509                 B5 C3 Đại Kim, Hoang Mai (hỏi khách sạn Quê Hương ở đường Nguyễn Cảnh DỊ)
                      CTKH146                       Lê Minh Tân                  0908222510                 186 hoa Bằng, cầu Giấy
                      CTKH147                       Nguyễn Minh Tuấn             0908222511                 155/16 phường 4 nguyễn thái sơn quận gò vấp
                      CTKH148                       Nguyễn Mạnh Cường            0908222512                 kl
                      CTKH149                       Nguyễn Thị Hồng Giang        0908222513                 661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân

CRP                   [Tags]                        CRP
                      [Template]                    create KH
                      CRPKH001                      Nguyễn Thị Hồng Giang        912754764                  661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân
                      CRPKH002                      Phạm Thị Thu Hà              912754765                  Số nhà 112, Ngõ 242, Đường Láng
                      CRPKH003                      Dương Thị Phượng             912754766                  Nhà c 2/87/409 Kim Mã
                      CRPKH004                      Nguyễn Nga Ngọc              912754767                  29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      CRPKH005                      Lâm Thị Anh                  912754768                  số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      CRPKH006                      Trần Thị Vân                 912754769                  2a dinh tien hoang Quận 1
                      CRPKH007                      Phạm Thị Trang               912754770                  Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      CRPKH008                      Đỗ Đình Dinh                 912754771                  12 Tân Trào . P Tân Phú . Q7
                      CRPKH009                      Vũ Anh Đức                   912754772                  Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      CRPKH010                      Nguyễn Đức Chí               912754773                  ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      CRPKH011                      Nguyễn Đức Hoằng             912754774                  241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      CRPKH012                      Lê Minh Tân                  912754775                  Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      CRPKH013                      Lương Như Lập                912754776                  Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      CRPKH014                      anh Dương 0932292832         912754777                  12 Tân Trào . P Tân Phú . Q7
                      CRPKH015                      Chị Loan                     912754778                  Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      CRPKH016                      Chị Xuân                     912754779                  ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      CRPKH017                      cô Triệu 0988286908          912754780                  241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      CRPKH018                      A lâm 01689946055            912754781                  Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )

DHDPT                 [Tags]                        DHDPT
                      [Template]                    create KH
                      DHDPT001   	                  Nguyễn Thị Hồng Giang	        921223631	                661 Hương Lộ 2 , KP3 , P Bình Trị Đông A , Q Bình Tân
                      DHDPT002   	                  Phạm Thị Thu Hà	              921223632	                Số nhà 112, Ngõ 242, Đường Láng
                      DHDPT003   	                  Dương Thị Phượng	            921223633	                Nhà c 2/87/409 Kim Mã
                      DHDPT004                    	Nguyễn Nga Ngọc	              921223634	                29/4 đường số 6, QL13, hiệp bình phước, thủ đức, tphcm
                      DHDPT005                    	Lâm Thị Anh	                  921223635	                số 26B/354 đường Trường Chinh (đi ngõ 72 Tôn Thất Tùng cũng được)
                      DHDPT006                     	Trần Thị Vân	                921223636	                2a dinh tien hoang Quận 1
                      DHDPT007                     	Phạm Thị Trang	              921223637	                Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      DHDPT008                     	Đỗ Đình Dinh	                921223638	                12 Tân Trào . P Tân Phú . Q7
                      DHDPT009                    	Vũ Anh Đức	                  921223639	                Tòa nhà Itasa,126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      DHDPT010   	                  Nguyễn Đức Chí	              921223640	                ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm

PQ                    [Tags]                        PQ
                      [Template]                    Add customers
                      PQKH001                       Nguyễn Đức Chí                 912658973                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      PQKH002                       Nguyễn Đức Hoằng               912658974                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      PQKH003                       Lê Minh Tân                    912658975                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )
                      PQKH004                       Lương Như Lập                  912658976                 Số 15 ngõ 14B Lý Nam Đế, Hoàn Kiếm
                      PQKH005                       anh Dương                      912658977                 12 Tân Trào . P Tân Phú . Q7
                      PQKH006                       Chị Loan                       912658978                 Tòa nhà Itasa, 126 Nguyễn Thị Minh Khai, Phường 6, Quận 3
                      PQKH007                       Chị Xuân                       912658943                 ngách 28/48 Đường Đại Linh, Trung Văn, nam Từ Liêm
                      PQKH008                       cô Triệu                       912658963                 241A Lưu Hữu Phước P15, Quận 8, TP Hồ Chí Minh
                      PQKH009                       A lâm                          912655973                 Đầu Cổng Chào -Gíap Đại Lộ Thăng Long ( Thiên đường Bảo Sơn )

BGPV                  [Tags]                        BGPV
                      [Template]                    Add customers with customer group
                      PVKH001                       Nguyễn Đức Chí                 Thân thiết
                      PVKH002                       Nguyễn Đức Hoằng               Thân thiết
                      PVKH003                       Lê Minh Tân                    Thân thiết
                      PVKH004                       Lương Như Lập                  Thân thiết
                      PVKH005                       anh Dương                      Thành viên
                      PVKH006                       Chị Loan                       Thành viên
                      PVKH007                       Chị Xuân                       Thành viên
                      PVKH008                       cô Triệu                       Thành viên

GDH                   [Tags]                        GDH
                      [Template]                    Add customers
                      KH126                         Nguyễn Thị Ân                0987445665                 Thai Ha
                      KH127                         Nguyễn Thị Vân               0987123258                 ABBC

*** Keywords ***
create KH
    [Arguments]    ${input_makh}    ${input_tenkh}    ${input_sdt}    ${input_diachi}
    Add customers    ${input_makh}    ${input_tenkh}    ${input_sdt}    ${input_diachi}

Add new invoice when created customer
    [Arguments]    ${input_makh}    ${input_tenkh}    ${input_sdt}    ${input_diachi}    ${input_product}    ${input_soluong}    ${input_khtt}
    Add customers    ${input_makh}    ${input_tenkh}    ${input_sdt}    ${input_diachi}
    Add new invoice with product    ${input_makh}    ${input_product}    ${input_soluong}    ${input_khtt}
