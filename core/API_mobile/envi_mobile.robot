*** Settings ***
Library       OperatingSystem
Library       AppiumLibrary
Resource      api_access_mobile.robot

*** Keywords ***
Fill mobile env
    [Arguments]    ${env}    ${remote}    ${account}    ${screen}
    Log    ${env}
    ${DICT_API_URL}    Create Dictionary    live1=https://autobot.kiotviet.vn/api    live2=https://autoto.kiotviet.vn/api    live3=https://autobot2.kiotviet.vn/api    live4=https://autobot3.kiotviet.vn/api
    ...    ZONE1=https://auto1.kiotviet.vn/api
    ...    ZONE2=https://auto2.kiotviet.vn/api    ZONE3=https://auto3.kiotviet.vn/api    ZONE4=https://auto4.kiotviet.vn/api    ZONE5=https://auto5.kiotviet.vn/api    ZONE6=https://auto6.kiotviet.vn/api
    ...    ZONE8=https://auto8.kiotviet.vn/api    ZONE9=https://auto9.kiotviet.vn/api    ZONE10=https://auto10.kiotviet.vn/api    ZONE11=https://auto11.kiotviet.vn/api    ZONE12=https://auto12.kiotviet.vn/api
    ...    ZONE13=https://auto13.kiotviet.vn/api    ZONE14=https://auto14.kiotviet.vn/api    ZONE17=https://auto17.kiotviet.vn/api    ZONE18=https://auto18.kiotviet.vn/api    ZONE19=https://auto19.kiotviet.vn/api
    ...    ZONE20=https://auto20.kiotviet.vn/api    ZONE21=https://auto21.kiotviet.vn/api     ZONE23=https://man2.kiotapi.com/api        ZONE24=https://auto24.kiotviet.vn/api       ZONE26=https://auto26.kiotviet.vn/api     LD=https://autoloda.kiotviet.vn/api    DR=https://autotestdr.kiotviet.vn/api
    ...    59922=https://auto59925.kvpos.com:59922/api        59925=https://auto59925.kvpos.com:59925/api    59909=https://autotest.kvpos.com:59909/api    59927=https://auto59927.kvpos.com:59927/api
    ...    59920=https://auto59920.kvpos.com:59920/api     59912=https://auto59912.kvpos.com:59912/api     59913=https://auto59913.kvpos.com:59913//api      ML=https://autocheck.kiotviet.vn/api     NT=https://autonhathuoc1.kiotviet.vn/api      FNB=https://fnb.kiotviet.vn/api
    ...    59916=https://auto59916.kvpos.com:59916/api   CS=https://auto231.kiotviet.vn/api     59511=https://fnb.kvpos.com:59511/api     59910=https://auto59910.kvpos.com:59910/api     59517=https://fnb.kvpos.com:59517/api     59924=https://auto59924.kvpos.com:59924/api
    ...    59919=https://auto9019.kvpos.com:59919/api     59918=https://auto59918.kvpos.com:59918/api     9009=https://auto9009.kvpos.com:9009/api     9001=https://auto9001.kvpos.com:9001/api     NHIEUDL=https://nhieudata59922.kvpos.com:59922/api      ZONE28=https://auto28.kiotviet.vn/api   ZONE29=https://auto29.kiotviet.vn/api
    ...     ZONE30=https://testh80qns08.kiotviet.vn/api    9002=https://auto9002.kvpos.com:9002/api     ZONE32=https://auto32.kiotviet.vn/api     ZONE35=https://testz35.kiotviet.vn/api    ZONE36=https://testz36.kiotviet.vn/api
    ${DICT_RETAILER_NAME}    Create Dictionary    live1=autobot    live2=autoto    live3=autobot2    live4=autobot3    ZONE1=auto1    ZONE2=auto2    ZONE3=auto3    ZONE4=auto4
    ...    ZONE5=auto5    ZONE6=auto6    ZONE8=auto8    ZONE9=auto9    ZONE10=auto10    ZONE11=auto11    ZONE12=auto12    ZONE13=auto13    ZONE14=auto14
    ...    ZONE17=auto17    ZONE18=auto18    ZONE19=auto19    ZONE20=auto20    ZONE21=auto21    ZONE23=auto23       ZONE24=auto24    ZONE26=auto26   LD=autoloda    DR=autotestdr    59922=auto59925    59925=auto59925
    ...    59909=autotest     59927=auto59927     59920=auto59920    59912=auto59912    59913=auto59913    ML=autocheck      NT=autonhathuoc1      FNB=autotestfnb     59916=auto59916   CS=auto231    59511=auto59511     59910=auto59910   59517=auto59517     59924=auto59924
    ...    59919=auto9019     59918=auto59918     9009=auto9009     9001=auto9001      NHIEUDL=nhieudata59922     ZONE28=auto28     ZONE29=auto29
    ...    ZONE30=testh80qns08    9002=auto9002     ZONE32=auto32     ZONE35=testz35      ZONE36=testz36
    ${DICT_BRANCH_ID}    Create Dictionary    live1=62644    live2=74831    live3=11352    live4=32224    ZONE1=172786    ZONE2=85976    ZONE3=152624    ZONE4=201570
    ...    ZONE5=50018    ZONE6=80994    ZONE8=76246    ZONE9=138    ZONE10=30530    ZONE11=76360    ZONE12=181235    ZONE13=43334    ZONE14=110843
    ...    ZONE17=63219    ZONE18=8309    ZONE19=48009    ZONE20=64629    ZONE21=14     ZONE23=29    ZONE24=46988    ZONE26=35    LD=11889    DR=28    59922=35    59925=35
    ...    59909=1184     59927=1016     59920=15359    59912=3873    59913=5572       ML=4114       NT=9459     FNB=17050    59916=6077      CS=14   59511=7160      59910=9105     59517=7395      59924=17297
    ...    59919=14097      59918=22167     9009=14739    9001=15315    NHIEUDL=10691     ZONE28=41159     ZONE29=3241
    ...    ZONE30=43       9002=19373     ZONE32=4    ZONE35=100046      ZONE36=100046
    ${DICT_LATESTBRANCH}    Create Dictionary    live1=LatestBranch_294113_172395    live2=LatestBranch_307027_201567    live3=LatestBranch_437336_20447    live4=LatestBranch_764833_61034    ZONE1=LatestBranch_366420_441968
    ...    ZONE2=LatestBranch_366521_196750    ZONE3=LatestBranch_366523_386013    ZONE4=LatestBranch_366526_492065    ZONE5=LatestBranch_366528_160324    ZONE6=LatestBranch_364689_192226
    ...    ZONE8=LatestBranch_366532_225382    ZONE9=LatestBranch_364685_1784    ZONE10=LatestBranch_388337_65584    ZONE11=LatestBranch_366647_226492    ZONE12=LatestBranch_339758_438680
    ...    ZONE13=LatestBranch_614772_84572    ZONE14=LatestBranch_614773_223338     ZONE17=LatestBranch_614774_120324    ZONE18=LatestBranch_561711_18176    ZONE19=LatestBranch_559564_100334
    ...    ZONE20=LatestBranch_415547_110623    ZONE21=LatestBranch_425301_29    ZONE23=LatestBranch_863297_509   ZONE24=LatestBranch_683557_106871    ZONE26=LatestBranch_725753_60    LD=LatestBranch_437946_21557    DR=LatestBranch_526696_44    59922=LatestBranch_19_47    59925=LatestBranch_19_47    59909=LatestBranch_279846_10752
    ...    59927=LatestBranch_523851_10030     59920=LatestBranch_391425_153582    59912=LatestBranch_1007125_25168    59913=LatestBranch_636438_53085        ML=LatestBranch_634535_16640      NT=LatestBranch_663303_20988
    ...    FNB=LatestBranch_678521_36317    59916=LatestBranch_386330_90282   CS=LatestBranch_698269_29   59511=LatestBranch_386331_82001     59910=LatestBranch_384313_140323      59517=LatestBranch_583284_130900      59924=LatestBranch_15143_170278
    ...    59919=LatestBranch_433237_162865     59918=LatestBranch_308164_213837    9009=LatestBranch_20201_160824    PRELIVE=LatestBranch_20_8     9001=LatestBranch_18117_160376      ZONE28=LatestBranch_846995_88766      ZONE29=LatestBranch_833753_6101
    ...     ZONE30=LatestBranch_877746_533      9002=LatestBranch_15064_190432     ZONE32=LatestBranch_916469_8      ZONE35=LatestBranch_810143_100544      ZONE36=LatestBranch_961894_100544
    ${DICT_URL}    Create Dictionary    live1=https://autobot.kiotviet.vn    live2=https://autoto.kiotviet.vn    live3=https://autobot2.kiotviet.vn    live4=https://autobot3.kiotviet.vn    ZONE1=https://auto1.kiotviet.vn    ZONE2=https://auto2.kiotviet.vn    ZONE3=https://auto3.kiotviet.vn
    ...    ZONE4=https://auto4.kiotviet.vn    ZONE5=https://auto5.kiotviet.vn    ZONE6=https://auto6.kiotviet.vn    ZONE8=https://auto8.kiotviet.vn    ZONE9=https://auto9.kiotviet.vn    ZONE10=https://auto10.kiotviet.vn    ZONE11=https://auto11.kiotviet.vn
    ...    ZONE12=https://auto12.kiotviet.vn    ZONE13=https://auto13.kiotviet.vn    ZONE14=https://auto14.kiotviet.vn    ZONE17=https://auto17.kiotviet.vn    ZONE18=https://auto18.kiotviet.vn    ZONE19=https://auto19.kiotviet.vn
    ...    ZONE20=https://auto20.kiotviet.vn    ZONE21=https://auto21.kiotviet.vn     ZONE23=https://auto23.kiotviet.vn    ZONE24=https://auto24.kiotviet.vn     ZONE26=https://auto26.kiotviet.vn   LD=https://autoloda.kiotviet.vn    DR=https://autotestdr.kiotviet.vn    59922=https://auto59925.kvpos.com:59922    59925=https://auto59925.kvpos.com:59925
    ...    59909=https://autotest.kvpos.com:59909     59927=https://auto59927.kvpos.com:59927     59920=https://auto59920.kvpos.com:59920    59912=https://auto59912.kvpos.com:59912    59913=https://auto59913.kvpos.com:59913      ML=https://autocheck.kiotviet.vn       NT=https://autonhathuoc1.kiotviet.vn
    ...    FNB=https://fnb.kiotviet.vn       59916=https://auto59916.kvpos.com:59916   CS=https://auto231.kiotviet.vn      59511=https://fnb.kvpos.com:59511     59910=https://auto59910.kvpos.com:59910      59517=https://fnb.kvpos.com:59517     59924=https://auto59924.kvpos.com:59924
    ...    59919=https://auto9019.kvpos.com:59919       59918=https://auto59918.kvpos.com:59918     9009=https://auto9009.kvpos.com:9009    PRELIVE=https://autoprelive1.kiotviet.fun      9001=https://auto9001.kvpos.com:9001     ZONE28=https://auto28.kiotviet.vn     ZONE29=https://auto29.kiotviet.vn
    ...    ZONE30=https://testh80qns08.kiotviet.vn      9002=https://auto9002.kvpos.com:9002     ZONE32=https://auto32.kiotviet.vn      ZONE35=https://testz35.kiotviet.vn    ZONE36=https://testz36.kiotviet.vn
    ${DICT_ADMIN}    Create Dictionary    live1=admin    live2=admin    live3=admin    live4=admin    ZONE1=admin    ZONE2=admin    ZONE3=admin    ZONE4=admin
    ...    ZONE5=admin    ZONE6=admin    ZONE8=admin    ZONE9=admin    ZONE10=admin    ZONE11=admin    ZONE12=admin    ZONE13=admin    ZONE14=admin
    ...    ZONE17=admin    ZONE18=admin    ZONE19=admin    ZONE20=admin    ZONE21=admin   ZONE23=admin   ZONE24=admin     ZONE26=admin   LD=admin    DR=admin    59922=admin    59925=admin
    ...    59909=admin     59927=admin     59920=admin    59912=admin    59913=admin       ML=admin    NT=admin      FNB=admin   59916=admin   CS=admin      59511=admin      59910=admin     59517=admin      59924=admin
    ...    59919=admin      59918=admin   9009=admin    PRELIVE=admin       9001=admin    ZONE28=admin      ZONE29=admin
    ...    ZONE30=admin      9002=admin     ZONE32=admin        ZONE35=admin    ZONE36=admin
    ${DICT_USER}    Create Dictionary    live1=admin    live2=admin    live3=tester    live4=admin    ZONE1=tester    ZONE2=tester    ZONE3=tester    ZONE4=tester
    ...    ZONE5=tester    ZONE6=tester    ZONE8=tester    ZONE9=tester    ZONE10=tester    ZONE11=tester    ZONE12=tester    ZONE13=tester    ZONE14=tester
    ...    ZONE17=tester    ZONE18=tester    ZONE19=tester    ZONE20=tester    ZONE21=tester    ZONE23=tester    ZONE24=tester     ZONE26=tester   LD=tester    DR=tester    59922=tester    59925=tester
    ...    59909=tester     59927=tester     59920=tester    59912=tester    59913=tester     ML=admin      NT=admin    FNB=admin     59916=admin     CS=tester   59511=admin     59910=admin    59517=admin    59924=tester
    ...    59919=tester     59918=tester      9009=tester    PRELIVE=admin      9001=tester    ZONE28=tester     ZONE29=tester
    ...    ZONE30=tester    9002=admin     ZONE32=tester      ZONE35=tester    ZONE36=tester
    ${DICT_PASSWORD}    Create Dictionary    live1=123    live2=123    live3=123    live4=123    ZONE1=123    ZONE2=123    ZONE3=123    ZONE4=123
    ...    ZONE5=123    ZONE6=123    ZONE8=123    ZONE9=123    ZONE10=123    ZONE11=123    ZONE12=123    ZONE13=123    ZONE14=123
    ...    ZONE17=123    ZONE18=123    ZONE19=123    ZONE20=123    ZONE21=123    ZONE23=123   ZONE24=123     ZONE26=123   LD=123    DR=123    59922=123    59925=123
    ...    59909=123     59927=123     59920=123    59912=123    59913=123       ML=123      NT=123      FNB=123   59916=123     CS=123    59511=123     59910=123     59517=123     59924=123
    ...    59919=123      59918=123     9009=123    PRELIVE=123     9001=123     ZONE28=123     ZONE29=123    ZONE30=123        9002=123     ZONE32=123      ZONE35=123    ZONE36=123
    ${DICT_ENV}    Create Dictionary    live1=live    live2=live    live3=live    live4=live    ZONE1=live    ZONE2=live    ZONE3=live    ZONE4=live
    ...    ZONE5=live    ZONE6=live    ZONE8=live    ZONE9=live    ZONE10=live    ZONE11=live    ZONE12=live    ZONE13=live    ZONE14=live
    ...    ZONE17=live    ZONE18=live    ZONE19=live    ZONE20=live    ZONE21=live    ZONE23=live   ZONE24=live     ZONE26=live   LD=live    DR=live    59922=dev    59925=dev
    ...    59909=dev     59927=dev     59920=dev    59912=dev    59913=dev       ML=live      NT=live      FNB=live   59916=dev     CS=live    59511=dev     59910=dev     59517=dev     59924=dev
    ...    59919=dev      59918=dev     9009=dev    PRELIVE=live     9001=dev     ZONE28=live     ZONE29=live    ZONE30=live        9002=dev     ZONE32=live       ZONE35=live     ZONE36=live
    ${DICT_SALE_API_URL}    Create Dictionary    live1=https://sale.kiotapi.com/api    live2=https://sale.kiotapi.com/api    live3=https://sale.kiotapi.com/api    live4=https://sale.kiotapi.com/api    ZONE1=https://sale.kiotapi.com/api    ZONE2=https://sale.kiotapi.com/api    ZONE3=https://sale.kiotapi.com/api
    ...    ZONE4=https://sale.kiotapi.com/api    ZONE5=https://sale.kiotapi.com/api    ZONE6=https://sale.kiotapi.com/api    ZONE8=https://sale.kiotapi.com/api    ZONE9=https://sale.kiotapi.com/api    ZONE10=https://sale.kiotapi.com/api    ZONE11=https://sale.kiotapi.com/api
    ...    ZONE12=https://sale.kiotapi.com/api    ZONE13=https://sale.kiotapi.com/api    ZONE14=https://sale.kiotapi.com/api    ZONE17=https://sale.kiotapi.com/api    ZONE18=https://sale.kiotapi.com/api    ZONE19=https://sale.kiotapi.com/api
    ...    ZONE20=https://sale.kiotapi.com/api    ZONE21=https://sale.kiotapi.com/api     ZONE24=https://sale.kiotapi.com/api     ZONE23=https://sale.kiotapi.com/api     ZONE26=https://sale.kiotapi.com/api     LD=https://sale.kiotapi.com/api    DR=https://sale.kiotapi.com/api    59922=https://kvpos.com:59322/api    59925=https://kvpos.com:54925/api
    ...    59909=https://autotest.kvpos.com:59909/api     59927=https://saleapi.kvpos.com:59327/api     59920=https://auto59920.kvpos.com:59920/api    59912=https://auto59912.kvpos.com:59912/api    59913=https://auto59913.kvpos.com:59913/api     ML=https://sale.kiotapi.com/api
    ...    NT=https://sale.kiotapi.com/api   FNB=https://fnb.kiotviet.vn/api      59916=https://kvpos.com:59316/api   CS=https://sale.kiotapi.com/api     59511=https://fnb.kvpos.com:59511/api     59910=https://auto59910.kvpos.com:59910/api   59517=https://fnb.kvpos.com:59517/api     59924=https://kvpos.com:59324/api
    ...    59919=https://auto9019.kvpos.com:59919/api     59918=https://auto59918.kvpos.com:59918/api     9009=https://auto9009.kvpos.com:9009/api    PRELIVE=https://sale.kiotviet.fun/api     9001=https://auto9001.kvpos.com:9001/api         ZONE28=https://sale.kiotapi.com/api      ZONE29=https://sale.kiotapi.com/api
    ...    ZONE30=https://sale.kiotapi.com/api            9002=https://saleapihcm.kvpos.com:9302/api     ZONE32=https://sale.kiotapi.com/api       ZONE35=https://sale.kiotapi.com/api    ZONE36=https://sale.kiotapi.com/api
    ${DICT_WARRANTY_API}    Create Dictionary    live1=https://api-guarantee.kiotviet.vn/api    live2=https://api-guarantee.kiotviet.vn/api    live3=https://api-guarantee.kiotviet.vn/api    live4=https://api-guarantee.kiotviet.vn/api    ZONE1=https://api-guarantee.kiotviet.vn/api
    ...    ZONE2=https://api-guarantee.kiotviet.vn/api    ZONE3=https://api-guarantee.kiotviet.vn/api    ZONE4=https://api-guarantee.kiotviet.vn/api    ZONE5=https://api-guarantee.kiotviet.vn/api    ZONE6=https://api-guarantee.kiotviet.vn/api
    ...    ZONE8=https://api-guarantee.kiotviet.vn/api    ZONE9=https://api-guarantee2.kiotviet.vn/api    ZONE10=https://api-guarantee.kiotviet.vn/api    ZONE11=https://api-guarantee.kiotviet.vn/api    ZONE12=https://api-guarantee.kiotviet.vn/api
    ...    ZONE13=https://api-guarantee.kiotviet.vn/api    ZONE14=https://api-guarantee.kiotviet.vn/api     ZONE17=https://api-guarantee.kiotviet.vn/api    ZONE18=https://api-guarantee.kiotviet.vn/api    ZONE19=https://api-guarantee.kiotviet.vn/api
    ...    ZONE20=https://api-guarantee.kiotviet.vn/api    ZONE21=https://api-guarantee.kiotviet.vn/api   ZONE23=https://api-guarantee.kiotviet.vn/api     ZONE24=https://api-guarantee.kiotviet.vn/api     ZONE26=https://api-guarantee.kiotviet.vn/api   LD=https://api-guarantee.kiotviet.vn/api    DR=https://api-guarantee.kiotviet.vn/api    59922=https://kvpos.com:53322/api
    ...    59925=https://kvpos.com:53325/api    59909=https://kvpos.com:53309/api    59927=https://kvpos.com:53227/api       59920=https://kvpos.com:53220/api    59912=https://kvpos.com:53312/api     59913=https://kvpos.com:53313/api   ML=https://api-guarantee.kiotviet.vn/api      NT=https://api-guarantee.kiotviet.vn/api
    ...    FNB=https://api-guarantee.kiotviet.vn/api    59916=https://warrantyhcm.kvpos.com:9000/api    CS=https://api-guarantee.kiotviet.vn/api    59511=https://fnb.kvpos.com:59511/api   59910=https://kvpos.com:53310/api     59517=https://api-guarantee.kiotviet.vn/api     59924=https://kvpos.com:53324/api
    ...    59919=https://kvpos.com:53309/api    59918=https://kvpos.com:53318/api     9009=https://warrantyhcm.kvpos.com:9000/api    PRELIVE=https://guaranteeapi.kiotviet.fun/api    9001=https://api-guarantee.kiotviet.vn/api        ZONE28=https://api-guarantee.kiotviet.vn/api     ZONE29=https://api-guarantee.kiotviet.vn/api
    ...    ZONE30=https://api-guarantee.kiotviet.vn/api    9002=https://warrantyhcm.kvpos.com:19002/api     ZONE32=https://api-guarantee.kiotviet.vn/api      ZONE35=https://api-guarantee.kiotviet.vn/api      ZONE36=https://api-guarantee.kiotviet.vn/api
    ${DICT_PROMO_API}    Create Dictionary    live1=https://promotion.kiotapi.com/api    live2=https://promotion.kiotapi.com/api    live3=https://promotion.kiotapi.com/api    live4=https://promotion.kiotapi.com/api    ZONE1=https://promotion.kiotapi.com/api
    ...    ZONE2=https://promotion.kiotapi.com/api    ZONE3=https://promotion.kiotapi.com/api    ZONE4=https://promotion.kiotapi.com/api    ZONE5=https://promotion.kiotapi.com/api    ZONE6=https://promotion.kiotapi.com/api
    ...    ZONE8=https://promotion.kiotapi.com/api    ZONE9=https://api-promotion2.kiotviet.vn/api   ZONE10=https://promotion.kiotapi.com/api    ZONE11=https://promotion.kiotapi.com/api    ZONE12=https://promotion.kiotapi.com/api
    ...    ZONE13=https://promotion.kiotapi.com/api    ZONE14=https://promotion.kiotapi.com/api     ZONE17=https://promotion.kiotapi.com/api    ZONE18=https://promotion.kiotapi.com/api    ZONE19=https://promotion.kiotapi.com/api
    ...    ZONE20=https://promotion.kiotapi.com/api    ZONE21=https://promotion.kiotapi.com/api   ZONE23=https://promotion.kiotapi.com/api    ZONE24=https://promotion.kiotapi.com/api     ZONE26=https://promotion.kiotapi.com/api   LD=https://promotion.kiotapi.com/api    DR=https://promotion.kiotapi.com/api    59922=https://kvpos.com:53222/api    59925=https://kvpos.com:53225/api    59909=https://kvpos.com:53209/api
    ...    59927=https://kvpos.com:53227/api       59920=https://kvpos.com:53220/api    59912=https://kvpos.com:53212/api     59913=https://kvpos.com:53213/api     59916=https://promotionhcm.kvpos.com:9000/api     CS=https://promotion.kiotapi.com/api
    ...    ML=https://promotion.kiotapi.com/api      NT=https://promotion.kiotapi.com/api      FNB=https://promotion.kiotapi.com/api      59511=https://fnb.kvpos.com:59511/api       59910=https://kvpos.com:3209/api   59517=https://promotion.kiotapi.com/api     59924=https://kvpos.com:53224/api
    ...    59919=https://kvpos.com:53209/api      59918=https://kvpos.com:53218/api     9009=https://promotionhcm.kvpos.com:9000/api    PRELIVE=https://promotionapi.kiotviet.fun/api      9001=https://promotion.kiotapi.com/api       ZONE28=https://promotion.kiotapi.com/api    ZONE29=https://promotion.kiotapi.com/api
    ...    ZONE30=https://promotion.kiotapi.com/api     9002=https://promotionhcm.kvpos.com:9002/api     ZONE32=https://promotion.kiotapi.com/api       ZONE35=https://promotion.kiotapi.com/api    ZONE36=https://promotion.kiotapi.com/api
    ${DICT_ACTIVITY_NAME}    Create Dictionary      pos=net.citigo.kiotviet.ui.SaleFirstActivity    man=net.citigo.kiotviet.manager.ui.MainActivity
    ${DICT_PACKAGE_NAME}    Create Dictionary      pos=net.citigo.kiotviet    man=net.citigo.kiotviet.manager
    ${DICT_MOBILE_API_URL}    Create Dictionary    live1=https://mobile.kiotapi.com    live2=https://mobile.kiotapi.com    live3=https://mobile.kiotapi.com    live4=https://mobile.kiotapi.com    ZONE1=https://mobile.kiotapi.com
    ...    ZONE2=https://mobile.kiotapi.com    ZONE3=https://mobile.kiotapi.com    ZONE4=https://mobile.kiotapi.com    ZONE5=https://mobile.kiotapi.com    ZONE6=https://mobile.kiotapi.com
    ...    ZONE8=https://mobile.kiotapi.com    ZONE9=https://mobile.kiotapi.com   ZONE10=https://mobile.kiotapi.com    ZONE11=https://mobile.kiotapi.com    ZONE12=https://mobile.kiotapi.com
    ...    ZONE13=https://mobile.kiotapi.com    ZONE14=https://mobile.kiotapi.com     ZONE17=https://mobile.kiotapi.com    ZONE18=https://mobile.kiotapi.com    ZONE19=https://mobile.kiotapi.com
    ...    ZONE20=https://mobile.kiotapi.com    ZONE21=https://mobile.kiotapi.com   ZONE23=https://mobile.kiotapi.com     ZONE24=https://mobile.kiotapi.com     ZONE26=https://mobile.kiotapi.com   LD=https://mobile.kiotapi.com    DR=https://mobile.kiotapi.com    59922=https://kvpos.com:53322/api
    ...    59925=https://mobile.kiotapi.com    59909=https://mobile.kiotapi.com     59927=https://mobile.kiotapi.com        59920=https://kvpos.com:53220/api    59912=https://kvpos.com:53312/api     59913=https://kvpos.com:53313/api   ML=https://mobile.kiotapi.com      NT=https://mobile.kiotapi.com
    ...    FNB=https://mobile.kiotapi.com    59916=https://warrantyhcm.kvpos.com:9000/api    CS=https://mobile.kiotapi.com    59511=https://fnb.kvpos.com:59511/api   59910=https://kvpos.com:53310/api     59517=https://mobile.kiotapi.com     59924=https://kvpos.com:53324/api
    ...    59919=https://mobile.kiotapi.com    59918=https://mobile.kiotapi.com      9009=https://mobile.kiotapi.com     PRELIVE=https://mobile.kiotapi.com     9001=https://mobile.kiotapi.com        ZONE28=https://mobile.kiotapi.com     ZONE29=https://mobile.kiotapi.com
    ...    ZONE30=https://mobile.kiotapi.com    9002=https://warrantyhcm.kvpos.com:19002/api     ZONE32=https://mobile.kiotapi.com      ZONE35=https://mobile.kiotapi.com   ZONE36=https://mobile.kiotapi.com
    ###
    ${API_URL}    Get From Dictionary    ${DICT_API_URL}    ${env}
    ${BRANCH_ID}    Get From Dictionary    ${DICT_BRANCH_ID}    ${env}
    ${LATESTBRANCH}    Get From Dictionary    ${DICT_LATESTBRANCH}    ${env}
    ${URL}    Get From Dictionary    ${DICT_URL}    ${env}
    ${USER_ADMIN}    Get From Dictionary    ${DICT_ADMIN}    ${env}
    ${USER_ND}    Get From Dictionary    ${DICT_USER}    ${env}
    ${PASSWORD}    Get From Dictionary    ${DICT_PASSWORD}    ${env}
    ${ENVIRONMENT}    Get From Dictionary    ${DICT_ENV}    ${env}
    ${RETAILER_NAME}    Get From Dictionary    ${DICT_RETAILER_NAME}    ${env}
    ${SALE_API_URL}    Get From Dictionary    ${DICT_SALE_API_URL}    ${env}
    ${PROMO_API}    Get From Dictionary    ${DICT_PROMO_API}    ${env}
    ${WARRANTY_API}    Get From Dictionary    ${DICT_WARRANTY_API}    ${env}
    ${ACTIVITY_NAME}    Get From Dictionary    ${DICT_ACTIVITY_NAME}    ${screen}
    ${PACKAGE_NAME}    Get From Dictionary    ${DICT_PACKAGE_NAME}    ${screen}
    ${MOBILE_API_URL}    Get From Dictionary    ${DICT_MOBILE_API_URL}    ${env}
    #${REMOTE_URL}    Set variable    ${remote}
    Set Global Variable    \${PLATFORM_NAME}    Android
    Set Global Variable    \${PLATFORM_VER}    9.0
    Set Global Variable    \${DEVICE_NAME}    emulator-5554
    Set Global Variable    \${PACKAGE_NAME}    ${PACKAGE_NAME}
    Set Global Variable    \${ACTIVITY_NAME}    ${ACTIVITY_NAME}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${BRANCH_ID}    ${BRANCH_ID}
    Set Global Variable    \${LATESTBRANCH}    ${LATESTBRANCH}
    Set Global Variable    \${URL}    ${URL}
    Run Keyword If    '${account}'=='admin'    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}      ELSE      Set Global Variable    \${USER_NAME}    ${USER_ND}
    Set Global Variable    \${USER_ADMIN}    ${USER_ADMIN}
    Set Global Variable    \${PASSWORD}    ${PASSWORD}
    Set Global Variable    \${RETAILER_NAME}    ${RETAILER_NAME}
    Set Global Variable    \${SALE_API_URL}    ${SALE_API_URL}
    Set Global Variable    \${PROMO_API}    ${PROMO_API}
    Set Global Variable    \${WARRANTY_API}    ${WARRANTY_API}
    Set Global Variable    \${MOBILE_API_URL}    ${MOBILE_API_URL}

Init Test Mobile Environment
    [Arguments]    ${env}    ${remote}    ${account}    ${screen}
    Fill mobile env    ${env}    ${remote}     ${account}    ${screen}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    ${token_value_mobile}    ${resp.cookies_mobile}    Get mobile BearerToken from API
    Set Global Variable    \${bearertoken_mobile}    ${token_value_mobile}
    Set Global Variable    \${resp.cookies_mobile}    ${resp.cookies_mobile}
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Append To Environment Variable    PATH    ${EXECDIR}${/}drivers
