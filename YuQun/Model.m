//
//  Model.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "Model.h"

@implementation Model

@end
/**
 *  登陆
 */

@implementation UserLogin

static UserLogin * aUser = nil;

+(UserLogin *)shareUserWithData:(id)aData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        aUser = [[UserLogin alloc]init];
        
    });
    
    
    if ([aData isKindOfClass:[NSArray class]]) {
        NSDictionary * aDic = [aData objectAtIndex:0];
        aUser.UID = [aDic objectForKey:@"UID"];
        aUser.RecommendedUserName = [aDic objectForKey:@"RecommendedUserName"];
        aUser.Name = [aDic objectForKey:@"Name"];
        aUser.Tel = [aDic objectForKey:@"Tel"];
        aUser.WeiXinID = [aDic objectForKey:@"WeiXinID"];
        aUser.Gender = [aDic objectForKey:@"Gender"];
        aUser.GenderCN = [aDic objectForKey:@"GenderCN"];
        aUser.Age = [aDic objectForKey:@"Age"];
        aUser.AgeCN = [aDic objectForKey:@"AgeCN"];
        aUser.Job = [aDic objectForKey:@"Job"];
        aUser.JobName = [aDic objectForKey:@"JobName"];
        aUser.State = [aDic objectForKey:@"State"];
        aUser.Points = [aDic objectForKey:@"Points"];
        aUser.UserLevel = [aDic objectForKey:@"UserLevel"];
        aUser.AmountMoney = [aDic objectForKey:@"AmountMoney"];
        aUser.MoneyCanWithdrawals = [aDic objectForKey:@"MoneyCanWithdrawals"];
        aUser.BankName = [aDic objectForKey:@"BankName"];
        aUser.BankCardCode = [aDic objectForKey:@"BankCardCode"];
        aUser.BankCardPersonName = [aDic objectForKey:@"BankCardPersonName"];
        aUser.RegDate = [aDic objectForKey:@"RegDate"];
        aUser.RegIP = [aDic objectForKey:@"RegIP"];
        aUser.LastOptDate = [aDic objectForKey:@"LastOptDate"];
        aUser.LastOptIP = [aDic objectForKey:@"LastOptIP"];
        aUser.UserSource = [aDic objectForKey:@"UserSource"];
        aUser.CityID = [aDic objectForKey:@"CityID"];
        aUser.CityName = [aDic objectForKey:@"CityName"];
        aUser.Birthday = [aDic objectForKey:@"Birthday"];
        aUser.UserHeadPic = [aDic objectForKey:@"UserHeadPic"];
        aUser.PWD = [aDic objectForKey:@"PWD"];
        aUser.Tags = [aDic objectForKey:@"Tags"];
        aUser.AmountOfYestBonus = [aDic objectForKey:@"AmountOfYestBonus"];
        aUser.Education = [aDic objectForKey:@"Education"];
        aUser.EducationName = [aDic objectForKey:@"EducationName"];
        aUser.Revenue = [aDic objectForKey:@"Revenue"];
        aUser.RevenueName = [aDic objectForKey:@"RevenueName"];
        aUser.NPointFreezeStartDate = [aDic objectForKey:@"NPointFreezeStartDate"];
        aUser.num = [aDic objectForKey:@"num"];
        aUser.OS = [aDic objectForKey:@"OS"];
        aUser.JobStr = [aDic objectForKey:@"JobStr"];
        aUser.EduStr = [aDic objectForKey:@"EduStr"];
        aUser.CityStr = [aDic objectForKey:@"CityStr"];
        aUser.RevStr = [aDic objectForKey:@"RevStr"];
//        aUser.Unionid =[aDic objectForKey:@"Unionid"];
        aUser.passAuthentication =[aDic objectForKey:@"passAuthentication"];
        aUser.passAuthenticationStr =[aDic objectForKey:@"passAuthenticationStr"];
        aUser.passAuthDate =[aDic objectForKey:@"passAuthDate"];
        aUser.cerCode =[aDic objectForKey:@"cerCode"];
        
        
    }
    
    return aUser;
}

+(void)killUser
{
    
    aUser.UID = nil;
    aUser.RecommendedUserName = nil;
    aUser.Name = nil;
    aUser.Tel = nil;
    aUser.WeiXinID = nil;
    aUser.Gender = nil;
    aUser.GenderCN = nil;
    aUser.Age = nil;
    aUser.AgeCN = nil;
    aUser.Job = nil;
    aUser.JobName = nil;
    aUser.State = nil;
    aUser.Points = nil;
    aUser.UserLevel =nil;
    aUser.AmountMoney = nil;
    aUser.MoneyCanWithdrawals = nil;
    aUser.BankName = nil;
    aUser.BankCardCode = nil;
    aUser.BankCardPersonName = nil;
    aUser.RegDate = nil;
    aUser.RegIP =nil;
    aUser.LastOptDate = nil;
    aUser.LastOptIP = nil;
    aUser.UserSource = nil;
    aUser.CityID = nil;
    aUser.CityName = nil;
    aUser.Birthday = nil;
    aUser.UserHeadPic = nil;
    aUser.PWD = nil;
    aUser.Tags = nil;
    aUser.AmountOfYestBonus = nil;
    aUser.Education = nil;
    aUser.EducationName = nil;
    aUser.Revenue = nil;
    aUser.RevenueName = nil;
    aUser.NPointFreezeStartDate = nil;
    aUser.num = nil;
    aUser.OS = nil;
    aUser.OSDesc = nil;

    aUser.JobStr = nil;
    aUser.EduStr = nil;
    aUser.CityStr =nil;
    aUser.RevStr = nil;
//    aUser.Unionid = nil;
    aUser.passAuthentication = nil;
    aUser.passAuthenticationStr = nil;
    aUser.passAuthDate = nil;
    aUser.cerCode = nil;
}

@end

/**
 *  热门标签
 */

@implementation userTagsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

/**
 *  获取城市列表
 */

@implementation CitysModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

/**
 * 获取学历列表
 */

@implementation EducationModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

/**
 *  获取职位列表
 */

@implementation JobModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

/**
 *  获取收入范围列表
 */

@implementation RevenueModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

//获取我的邀请
@implementation YaoQingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

//获取我的邀请
@implementation YaoQingListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

@implementation OptionsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

//邀请朋友问答
@implementation AnswerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
@implementation JobInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end


@implementation YijieRenWu

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation JiangjinLiushui

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation KeFuModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation GongGaoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation RenZhengInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end