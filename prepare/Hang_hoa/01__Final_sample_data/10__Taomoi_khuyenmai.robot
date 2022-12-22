*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../Sources/thietlap.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_thietlap.robot
Library           DateTime

*** Test Cases ***    Code           Name                           Gia tri VND       Gia tri %       Loai discount       Giatri HD
Tao moi KM hoa don giam gia
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice with discount invoice
                      KM01         Khuyến mại giảm giá Hóa đơn VNĐ              20000           null          VND         5000000
                      KM02         Khuyến mại giảm giá Hóa đơn %                   null          5              %          4000000

Tao moi KM hoa don tang hang
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice with give away
                      KM03         Khuyến mại hóa đơn tặng hàng             5000000           Dịch vụ KM

Tao moi KM hóa đơn giảm giá SP
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice with product discount
                      KM04         Khuyến mại hóa đơn giảm giá SP vnd                                     5000000           1        Dịch vụ KM         20000           null          VND
                      KM05         Khuyến mại hóa đơn giảm giá SP %                                      5000000           2          Dịch vụ KM          null          10              %

Tao moi KM hóa đơn giảm giá SP va tặng hàng
                      [Tags]        PROMOTION
                      [Template]    Create promotion by product with product discount
                      KM06         KM theo HH hình thức mua hàng GG hàng vnd                    5           1          2            30000           null           VND         Bánh nhập KM        Hạt nhập khẩu KM
                      KM07         KM theo HH hình thức mua hàng GG hàng %           5           1          2            null           5           %         Bánh nhập KM        Hạt nhập khẩu KM
                      KM08         KM theo HH hinh thuc mua hang tặng hàng          6           1          2            null           null           %         Bánh nhập KM        Hạt nhập khẩu KM

Tao moi KM hóa đơn giảm giá SP
                      [Tags]        PROMOTION
                      [Template]    Create promotion by product with baseprice based on quantity
                      KM09         KM theo HH hình thức giá bán theo SL mua                               Máy KM        3          80000        null        null
                      KM10         KM theo HH hình thức giá bán theo SL mua GG vnd                        Máy KM        2          null        20000        null
                      KM11         KM theo HH hình thức giá bán theo SL mua GG %                          Máy KM        3          null        null        20

Tao moi KM theo HĐ và HH hình thức GG HĐ
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice and product with invoice discount
                      KM012         KM theo HH và HĐ hình thức GG HĐ VND                             KM HĐ HH        5000000          200000        null        VND
                      KM013         KM theo HH và HĐ hình thức GG HĐ %                               KM HĐ HH        4000000          null        5        %

Tao moi KM theo HĐ và HH hình thức tặng hàng
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice and product with giveaway
                      KM014         KM theo HH và HĐ hình thức tặng hàng                   5000000           KM Hàng mua        3           KM Hàng tặng       1

Tao moi KM theo HĐ và HH hình thức giảm giá hàng
                      [Tags]         PROMOTION
                      [Template]    Create promotion by invoice and product with product discount
                      KM015         KM theo HH và HĐ hình thức GG hàng VND           3000000           KM Hàng mua        2           KM Hàng tặng       1          50000           null           VND
                      KM016         KM theo HH và HĐ hình thức GG hàng %          4000000           KM Hàng mua        3           KM Hàng tặng       1          6               6             %

Tao moi KM theo HĐ - HH hình thức giảm giá hàng và tự động fill
                      [Tags]        PROMOTION
                      [Template]    Create promotion by invoice and product with product discount and auto fill
                      KM017         KM theo HH và HĐ hình thức GG hàng %          4000000           KM Hàng mua        2           KM Hàng mua       1          null               10             %

Tao moi KM theo HĐ giảm giá và theo chi nhánh
                    [Tags]         PROMOTION
                    [Template]    Create promotion by invoice with discount invoice and not for all branch
                    KM018         Khuyến mại giảm giá Hóa đơn VNĐ theo chi nhanh              200000           null          VND         5000000      Nhánh A

Tao moi KM hóa đơn giảm giá SP và theo user
                    [Tags]         PROMOTION
                    [Template]    Create promotion by product with baseprice based on quantity and not for all user
                    KM019         KM theo HH hình thức giá bán theo SL mua theo user          KM hàng        3          50000        tester

Tao moi KM hóa đơn giảm giá SP và theo nhóm KH
                    [Tags]        PROMOTION
                    [Template]    Create promotion by invoice and product with giveaway and not for all customers
                    KM020         KM theo HH và HĐ hình thức tặng hàng theo nhóm KH        5000000           Dịch vụ        2           Bánh nhập KM       1      Nhóm khách VIP

Tao moi KM theo HĐ và HH hình thức giảm giá hàng và không áp dụng all filter
                    [Tags]      PROMOTION
                    [Template]    Create promotion by invoice and product with product discount and not for all filter
                    KM021         KM theo HH và HĐ hình thức GG hàng VND và không áp dụng all filter     5000000     KM Hàng mua        3     KM Hàng tặng       1    60000     null     VND      Nhánh A    tester   Nhóm khách VIP

Activate promotion
                      [Tags]        ACPROMOTION
                      [Template]    Toggle status of promotion
                      KM001         0
                      #KM002        1
                      #KM003        1
                      #KM004        1
                      #KM005        1
                      #KM006        1
                      #KM007        1
                      #KM008        1
                      #KM009        1
                      #KM010        1
                      #KM011        1

Get va

                    [Tags]        GETPRO
                    [Template]      Get Invoice value - Discounts - Promotion Name from Promotion Code
                    KM001
