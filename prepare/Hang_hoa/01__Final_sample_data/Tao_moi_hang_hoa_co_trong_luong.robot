*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../Sources/hanghoa.robot

*** Test Cases ***    Mã SP         Tên SP                                          Nhóm hàng    Giá bán    Giá vốn    Tồn kho    Trọng lượng
CT_HHT_trongluong     [Template]    Add HH co trong luong thr API
                      TL001         Khi hơi thở hóa thinh không                     Sách         50000      20000      1200       1.2
                      TL002         Nhà giả kim                                     Sách         60000      30000      1200       0
                      TL003         Tuổi trẻ đáng giá bao nhiêu                     Sách         70000      40000      1200       1.4
                      TL004         Chủ nghĩa tối giản                              Sách         80000      50000      1200       0
                      TL005         Đời ngắn đừng ngủ dài                           Sách         90000      60000      1200       1.6
                      TL006         Tony Buổi Sáng - Trên Đường Băng                Sách         100000     70000      1200       0
                      TL007         Thất Tịch Không Mưa                             Sách         110000     80000      1200       1.8
                      TL008         Khéo Ăn Nói Sẽ Có Được Thiên Hạ                 Sách         120000     90000      1200       0

CT_SI_trongluong      TL009         Giết Con Chim Nhại                              Sách         130000     100000     1200       2
                      TL010         Tiếng chim hót trong bụi mận gai                Sách         140000     110000     1200       0
                      TL011         Cà Phê Cùng Tony                                Sách         150000     120000     1200       2.2
                      TL012         5 Centimet Trên Giây                            Sách         160000     130000     1200       2.3
                      TL013         Bắt Trẻ Đồng Xanh                               Sách         170000     140000     1200       2.4
                      TL014         Sự Im Lặng Của Bầy Cừu                          Sách         180000     150000     1200       2.5
                      TL015         Sức Mạnh Tiềm Thức                              Sách         190000     160000     1200       2.6

CT_CB_trongluong      TL016         Khi Mọi Điểm Tựa Đều Mất                        Sách         200000     170000     1200       2.7
                      TL017         5 Centimet Trên Giây                            Sách         210000     180000     1200       2.8
                      TL018         Tôi Tài Giỏi - Bạn Cũng Thế                     Sách         210000     180000     1200       2.8
                      TL019         Bảy Bước Tới Mùa Hè                             Sách         210000     180000     1200       2.8
                      TL020         Nghĩ Đơn Giản, Sống Đơn Thuần                   Sách         210000     180000     1200       2.8
                      TL021         Quẳng Gánh Lo Đi Và Vui Sống                    Sách         200000     170000     1200       2.7
                      TL022         Hành Trình Về Phương Đông                       Sách         210000     180000     1200       2.8

CT_DV_trongluong      TL023         Tuổi Trẻ Không Trì Hoãn                         Sách         210000     180000     1200       2.8
                      TL024         Người Giàu Có Nhất Thành Babylon                Sách         210000     180000     1200       2.8
                      TL025         Chuyện Con Mèo Dạy Hải Âu Bay                   Sách         210000     180000     1200       2.8
                      TL026         Người Bán Hàng Vĩ Đại Nhất Thế Giới             Sách         210000     180000     1200       2.8
                      TL027         Điều Kỳ Diệu                                    Sách         210000     180000     1200       2.8
                      TL028         Nhân Tố Enzyme - Phương Thức Sống Lành Mạnh.    Sách         210000     180000     1200       2.8
                      TL029         Ai Lấy Miếng Pho Mát Của Tôi                    Sách         210000     180000     1200       2.8

CT_DVT_trongluong     TL030         Chạm Tới Giấc Mơ                                Sách         210000     180000     1200       2.8
                      TL031         Giới Hạn Của Bạn Chỉ Là Xuất Phát Điểm Của      Sách         210000     180000     1200       2.8
                      TL032         Sẽ Có Cách, Đừng Lo                             Sách         210000     180000     1200       2.8
                      TL033         Lược Sử Thời Gian                               Sách         210000     180000     1200       2.8
                      TL034         Dám Bị Ghét                                     Sách         210000     180000     1200       2.8
                      TL035         Sự Im Lặng Của Bầy Cừu                          Sách         210000     180000     1200       2.8
                      TL036         Hài Hước Một Chút Thế Giới Sẽ Khác Đi           Sách         210000     180000     1200       2.8

*** Keywords ***
Add trong luong hh combo
