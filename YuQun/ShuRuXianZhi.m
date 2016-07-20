//
//  ShuRuXianZhi.m
//  MaiCheTong
//
//  Created by chehuiMAC on 15/6/18.
//  Copyright (c) 2015年 何威. All rights reserved.
//

#import "ShuRuXianZhi.h"

@implementation ShuRuXianZhi
//手机号
+(BOOL)matchingTel:(NSString *)aTel
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:aTel];
    
    return isValid;
}
//纯数字
+(BOOL)matchingFigure:(NSString *)aFigure
{
    NSString *phoneRegex = @"/[^0-9]+/";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:aFigure];
    
    return isValid;
}
//限制位数的纯数字
+(BOOL)matchingFigure:(NSString *)aFigure length:(NSInteger) alength
{
    NSString *phoneRegex = [NSString stringWithFormat:@"^\\d{%ld}$",(long)alength];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:aFigure];
    
    return isValid;
}
//邮箱
+(BOOL)matchingEmail:(NSString *)Email
{
    NSString *phoneRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:Email];
    
    return isValid;
}
//银行卡
+(BOOL)matchingbankCard:(NSString *)aCardNum
{
    NSString *phoneRegex = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:aCardNum];
    
    return isValid;
}
//数字或者小数
+(BOOL)matchingDecimal:(NSString *)aDecimal
{
    NSString *phoneRegex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:aDecimal];
    
    return isValid;
}
//身份证
+(BOOL)matchingIDCard:(NSString *)aIDCard
{
    NSString *phoneRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isValid = [predicate evaluateWithObject:aIDCard];
    return isValid;
}

@end
