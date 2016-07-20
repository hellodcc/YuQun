//
//  AHeader.h
//  TonightQunar
//
//  Created by chehuiMAC on 15/3/5.
//  Copyright (c) 2015年 何威. All rights reserved.
//


#ifndef TonightQunar_AHeader_h
#define TonightQunar_AHeader_h
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define COLOR_RBG(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define COLOR_LAN [UIColor colorWithRed:44/255.0 green:100/255.0 blue:162/255.0 alpha:1]

#define COLOR_ORANGE [UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1]

#define COLOR_NAV [UIColor colorWithRed:44/255.0 green:100/255.0 blue:162/255.0 alpha:1]

#define COLOR_BACK [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

#define COLOR_CHENG [UIColor colorWithRed:252/255.0 green:153/255.0 blue:40/255.0 alpha:1]

#define COLOR_TEXTWHITE [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#define COLOR_GREEN [UIColor colorWithRed:118/255.0 green:192/255.0 blue:90/255.0 alpha:1]

#define COLOR_RED [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define COLOR_Red [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define COLOR_progressHUD [UIColor blackColor]


//圆角大小
#define CORNERRADIUS 5
//
#define TIMEOUT 60

//判断是不是iPhone4s
#define KYX_IS_IPHONE4S ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 480)
//判断是不是iPhone5
#define KYX_IS_IPHONE5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 568)
//判断是不是iPhone6
#define KYX_IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 667)
//判断是不是iPhone6plus
#define KYX_IS_IPHONE6PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 736)

//#define HTTP_UserOperation @"http://192.168.1.252:8029/UserOperation.asmx"
//#define HTTP_SmsOperation @"http://192.168.1.252:8029/SmsOperation.asmx"
//#define HTTP_TagOperation @"http://192.168.1.252:8029/TagOperation.asmx"
//#define HTTP_BaseOperation @"http://192.168.1.252:8029/BaseOperation.asmx"
//#define HTTP_YaoqingOperation @"http://192.168.1.252:8029/YaoqingOperation.asmx"
//#define HTTP_CommenOperation @"http://192.168.1.252:8029/CommenOperation.asmx"
//#define HTTP_TaskOperation @"http://192.168.1.252:8029/TaskOperation.asmx"
//
//#define HTTP_FundsOperation   @"http://192.168.1.252:8029/FundsOperation.asmx"
//
//#define HTTP_CommenOperation    @"http://192.168.1.252:8029/CommenOperation.asmx"
//
//#define HTTP_PointOperation @"http://192.168.1.252:8029/PointOperation.asmx"
//
//#define HTTP_MoneyOperation @"http://192.168.1.252:8029/MoneyOperation.asmx"
//
#define HTTP_UserOperation @"http://yuqunwebservice.17yuqun.com/UserOperation.asmx"
#define HTTP_SmsOperation @"http://yuqunwebservice.17yuqun.com/SmsOperation.asmx"
#define HTTP_TagOperation @"http://yuqunwebservice.17yuqun.com/TagOperation.asmx"
#define HTTP_BaseOperation @"http://yuqunwebservice.17yuqun.com/BaseOperation.asmx"
#define HTTP_YaoqingOperation @"http://yuqunwebservice.17yuqun.com/YaoqingOperation.asmx"
#define HTTP_CommenOperation @"http://yuqunwebservice.17yuqun.com/CommenOperation.asmx"
#define HTTP_TaskOperation @"http://yuqunwebservice.17yuqun.com/TaskOperation.asmx"

#define HTTP_FundsOperation   @"http://yuqunwebservice.17yuqun.com/FundsOperation.asmx"

#define HTTP_CommenOperation    @"http://yuqunwebservice.17yuqun.com/CommenOperation.asmx"

#define HTTP_PointOperation @"http://yuqunwebservice.17yuqun.com/PointOperation.asmx"

#define HTTP_MoneyOperation @"http://yuqunwebservice.17yuqun.com/MoneyOperation.asmx"



#endif
