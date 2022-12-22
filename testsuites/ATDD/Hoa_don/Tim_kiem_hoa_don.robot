*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/ATDD/Hoa_don/search_invoice_info_action.robot

*** Variables ***
@{list_product_search}    NH001   #HDVDB01
&{dict_product_num}    NH001=1   HDVDB01=1
@{list_hoa_don_tc01}    HD000066
@{list_hoa_don_tc02}    HD000083    HD000086    HD000089
@{list_hoa_don_tc03}    HD000087
@{list_tien_hang_tc1}    550,000    25,000    525,000    682,500
@{list_tien_hang_tc2}    2,250,000    180,000    2,070,000    2,388,000
@{list_tien_hang_tc3}    550,000    25,000    525,000    682,500
${ma_san_pham_tc01}    ATDD0000
${ten_san_pham_tc02}    Test hóa đơn lần
${us1_ma_san_pham_tc01}    ATDD00001
${us1_ma_san_pham_1_tc05}    ATDD00001
${us1_ma_san_pham_2_tc05}    ATDD00002
@{us1_list_hoa_don_tc01}    HD000001     HD000005
@{us1_list_tien_hang_tc01}    600,000	    0     600,000    600,000
@{us1_list_hoa_don_tc05}    HD000001    HD000002     HD000005
@{us1_list_tien_hang_tc05}    800,000    0    800,000   800,000
${us1_time_filter_tc_07}    Tháng này
${us1_ma_san_pham_tc07}    ATDD00004
@{us1_list_hoa_don_tc07}    HD000004    HD000006
@{us1_list_tien_hang_tc07}    600,000    0    600,000    600,000
${us1_chi_nhanh_tc09}    auto2811
${us1_ma_san_pham_tc09}    ATDD00004
@{us1_list_tien_hang_tc09}    600,000    0    600,000    600,000
@{us1_list_hoa_don_tc09}    HD000004    HD000006
${us1_ma_san_pham_tc11}    ATDD00004
@{us1_list_tien_hang_tc11}    600,000    0    600,000    600,000
@{us1_list_hoa_don_tc11}    HD000004    HD000006
${us1_ma_san_pham_tc13}    ATDD00009
@{us1_list_tien_hang_tc13}    200,000    0    200,000    200,000
@{us1_list_hoa_don_tc13}    HD000007
${us1_ma_san_pham_tc23}    ATDD00004
@{us1_list_tien_hang_tc23}    600,000    0    600,000    600,000
@{us1_list_hoa_don_tc23}    HD000004     HD000006
@{us1_list_ma_san_pham_tc24}    ATDD00001    ATDD00002    ATDD00003    ATDD00004    ATDD00005    ATDD00006    ATDD00007    ATDD00008    ATDD00009    ATDD00010
@{us1_list_hoa_don_tc24}    HD000001    HD000002    HD000003    HD000004    HD000005    HD000006    HD000007
@{us1_list_tien_hang_tc24}    1,800,000    0    1,800,000    1,800,000
${us1_error_message_tc_25}    Bạn chỉ được chọn tối đa 10 hàng hóa
@{us1_list_ma_san_pham_tc25}    ATDD00001    ATDD00002    ATDD00003    ATDD00004    ATDD00005    ATDD00006    ATDD00007    ATDD00008    ATDD00009    ATDD00010    ATDD00011
${us1_ma_san_pham_tc28}    ATDD00005
${us1_ten_san_pham_tc28}    Test hóa đơn
@{us1_list_hoa_don_tc28}    HD000001    HD000005
@{us1_list_tien_hang_tc28}    600,000    0    600,000    600,000
${us1_chi_nhanh_tc033}    Hà Nội
@{us1_list_hoa_don_tc33}    HD000008
@{us1_list_tien_hang_tc33}    200,000   0    200,000     200,000
${us1_ma_san_pham_tc33}    ATDD00012
${us1_ma_san_pham_tc36}    ATDD00013

${us2_ma_san_pham_tc01}    ATDD0001
${us2_ma_san_pham_tc03}    ATDD0001
${us2_ten_san_pham_tc02}    Test hóa đơn
@{us2_list_hoa_don_tc01}    HD000008
@{us2_list_hoa_don_tc02}    HD000001     HD000002    HD000003    HD000004    HD000005    HD000006     HD000007    HD000008
@{us2_list_hoa_don_tc03}    HD000008
@{us2_list_tien_hang_tc01}    200,000    0    200,000    200,000
@{us2_list_tien_hang_tc02}    2,000,000    0    2,000,000    2,000,000
@{us2_list_tien_hang_tc03}    200,000    0    200,000    200,000

*** Test Cases ***
US0 [TC01] - Tìm kiếm sản phẩm theo mã hàng hoặc tên hàng      [Tags]     ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    # Test case 01
    Log    Start TC01
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${ma_san_pham_tc01}
    Then Check kết quả hiển thị đúng mã sản phẩm    ${ma_san_pham_tc01}

US0 [TC02] - Tìm kiếm sản phẩm theo mã hàng hoặc tên hàng      [Tags]     ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    # Test case 02
    Log    Start TC02
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${ten_san_pham_tc02}
    Then Check kết quả hiển thị đúng tên sản phẩm    ${ten_san_pham_tc02}

US1 [TC01] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    # Test case 01
    Log    Start TC01
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc01}
    And Click outside
    And Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc01}   ${us1_list_tien_hang_tc01}

US1 [TC05] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    # Test case 05
    Log    Start TC05
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_1_tc05}
    And Chọn sản phẩm gợi ý
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_2_tc05}
    And Chọn sản phẩm gợi ý
    And Click outside
    And Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc05}    ${us1_list_tien_hang_tc05}

US1 [TC07] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    #Test case 07
    Log    Start TC07
    When Chọn filter date    ${us1_time_filter_tc_07}
    And Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc07}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc07}    ${us1_list_tien_hang_tc07}

US1 [TC09] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 09
    Log    Start TC09
    When Nhập chi nhánh    ${us1_chi_nhanh_tc09}
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc09}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc09}    ${us1_list_tien_hang_tc09}

US1 [TC11] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 11
    Log    Start TC11
    When Chọn trạng thái hoàn thành
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc11}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc11}    ${us1_list_tien_hang_tc11}

US1 [TC13] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 13
    Log    Start TC13
    When Chọn trạng thái chờ xử lý
    And Chọn trạng thái hoàn thành
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc13}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc13}    ${us1_list_tien_hang_tc13}

US1 [TC23] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 23
    Log    Start TC23
    When Chọn trạng thái kênh trực tiếp
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc23}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc23}    ${us1_list_tien_hang_tc23}

US1 [TC24] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 24
    Log    Start TC24
    When Chọn tìm kiếm sản phẩm
    And Nhập nhiểu mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_list_ma_san_pham_tc24}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc24}    ${us1_list_tien_hang_tc24}

US1 [TC25] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 25
    Log    Start TC25
    When Chọn tìm kiếm sản phẩm
    And Nhập nhiểu mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_list_ma_san_pham_tc25}
    Then Check thông báo lỗi hiển thị    ${us1_error_message_tc_25}

US1 [TC28] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 28
    Log    Start TC28
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc28}
    And Chọn sản phẩm gợi ý
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ten_san_pham_tc28}
    And Click enter    ${textbox_search_product_invoice}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc28}    ${us1_list_tien_hang_tc28}

US1 [TC33] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    #Test case 33
    Log    Start TC33
    When Nhập chi nhánh    ${us1_chi_nhanh_tc033}
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc33}
    Click outside
    Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us1_list_hoa_don_tc33}    ${us1_list_tien_hang_tc33}

US1 [TC36] Tìm kiếm hoá đơn bán chính xác theo 1 hoặc nhiều tên/mã hàng    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    #Test case 36
    Log    Start TC36
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us1_ma_san_pham_tc36}
    Then Check hệ thống không gợi ý mã sản phẩm


US2 [TC01] Tìm kiếm hoá đơn có bán các hàng hoá theo 1 từ khoá bất kì    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn
    # Test case 01
    Log    Start TC01
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us2_ma_san_pham_tc01}
    And Click outside
    And Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us2_list_hoa_don_tc01}    ${us2_list_tien_hang_tc01}

US2 [TC02] Tìm kiếm hoá đơn có bán các hàng hoá theo 1 từ khoá bất kì    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    # Test case 02
    Log    Start TC02
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us2_ten_san_pham_tc02}
    And Click outside
    And Click tìm kiếm
    Then Check giá trị hoá đơn trả về    ${us2_list_hoa_don_tc02}    ${us2_list_tien_hang_tc02}

US2 [TC03] Tìm kiếm hoá đơn có bán các hàng hoá theo 1 từ khoá bất kì    [TAGS]    ATDD_TEST
    Given Đi tới trang quản lý hoá đơn

    # Test case 03
    Log    Start TC03
    When Chọn tìm kiếm sản phẩm
    And Nhập mã hàng hoặc tên hàng vào ô tìm kiếm    ${us2_ma_san_pham_tc03}
    And Click enter    ${textbox_search_product_invoice}
    Then Check giá trị hoá đơn trả về    ${us2_list_hoa_don_tc03}    ${us2_list_tien_hang_tc03}
