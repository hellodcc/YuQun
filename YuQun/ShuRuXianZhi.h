//
//  ShuRuXianZhi.h
//  MaiCheTong
//
//  Created by chehuiMAC on 15/6/18.
//  Copyright (c) 2015年 何威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuRuXianZhi : NSObject
//手机号
+(BOOL)matchingTel:(NSString *)aTel;
//纯数字
+(BOOL)matchingFigure:(NSString *)aFigure;
//限制位数的纯数字
+(BOOL)matchingFigure:(NSString *)aFigure length:(NSInteger) alength;
//邮箱
+(BOOL)matchingEmail:(NSString *)Email;
//银行卡
+(BOOL)matchingbankCard:(NSString *)aCardNum;
//数字或者小数
+(BOOL)matchingDecimal:(NSString *)aDecimal;
//身份证
+(BOOL)matchingIDCard:(NSString *)aIDCard;

@end
