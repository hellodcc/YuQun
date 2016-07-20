//
//  AFNetworkingManager.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetworkingManager : NSObject
//用户登录
+(void)userLoginWithTel:(NSString *)tel Pas:(NSString *)pas succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;


//用户注册
+(void)userRegisterWithUserName:(NSString *)name tel:(NSString *)tel PWD:(NSString *)PWD recommendedUserID:(NSString *)recommendedUserID SMSCode:(NSString *)SMSCode Tag:(NSString *)tag  gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue cityId:(NSString *)cityId job:(NSString *)job OsType:(NSString *)OsType Succeed:(void(^)(id complate))successBlock Failed:(void(^)(id error))failedBlock;



//用户修改密码
+(void)userChangePasWithUserID:(NSString *)userID pwd:(NSString *)pwd  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取验证码
+(void)getCodeWithTel:(NSString *)aTel  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;



//用户标签
+(void)getTypeOfUserTagssucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//用户找回密码
+(void)userForgetPWDWithTel:(NSString *)tel SMSCode:(NSString *)SMSCode pwd:(NSString *)pwd  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取城市列表
+(void)GetCityssucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取学历列表
+(void)GetEducationListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取职位列表
+(void)GetJobListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取收入范围列表
+(void)GetRevenueListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取获取我的邀请
+(void)GetUserDirectAgentsSummaryListWithUserID:(NSString *)userID curPage:(NSString *)curPage pageSize:(NSString *)pageSize succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//+ 修改用户信息(不修改姓名) 没有头像
+(void)UpdateUserInfoWithOutUserNameNoImgWithTag:(NSString *)tag gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue tel:(NSString *)tel cityId:(NSString *)cityId job:(NSString *)job Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//+ 修改用户信息 没有头像
+(void)UpdateUserInfoWithNoImgWithTag:(NSString *)tag name:(NSString *)name gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue tel:(NSString *)tel cityId:(NSString *)cityId job:(NSString *)job Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//+ 获取等级
+(void)GetOptionsSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//xieyi
+(void)getXieyiSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//邀请朋友问答
+(void)getConstAnswerYaoqingSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取用户基本信息
+(void)GetUserBaseInfoWithUserID:(NSString *)userID tel:(NSString *)tel Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取任务列表
+(void)getJobInfoWithUserID:(NSString *)aUserID page:(NSString *)aPage type:(NSString *)aType succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取未接受任务详情
+(void)getJobDetailWithTaskID:(NSString *)aTaskID UserID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取已接受任务详情
+(void)getMyJobDetailWithOrderID:(NSString *)aOrderID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//接收任务
+(void)acceptJobWithuserID:(NSString *)aUserID tid:(NSString *)aTid curIP:(NSString *)acurIP succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//上传任务图片
+(void)uploadJobimgWithImgs:(NSArray *)aImgArr OID:(NSString *)aOID UID:(NSString *)aUID TID:(NSString *)aTID orderstate:(NSString *)aOrderstate succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//奖金流水
+(void)getjiangjinliushuiWithpageSize:(NSString *)aPageSize curPage:(NSString *)aCurPage userID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//奖金
+(void)getJiangjinWithUserID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;


//提现问答
+(void)gettixianwendasucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取客服
+(void)getKefusucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//共多少小鱼
+(void)getAllCountsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//放弃任务
+(void)cancleJobWiorderID:(NSString *)aorderID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//通过code获取access_token
+(void)getaccesstokenWithcode:(NSString *)aCode succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//刷新access_token有效期
+(void)refreshaccesstokenWithrefreshtoken:(NSString *)arefreshtoken succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//任务保证金问答
+(void)getBaozhengjinwendasucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//绑定微信信息
+(void)addWeiXinInfoWithUserID:(NSString *)aUserID WeiXinID:(NSString *)aWeiXinID Userheadpic:(NSString *)aUserheadpic Tel:(NSString *)aTel succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//微信获取accessToken
+(void)getWeiXinAccessTokenWithUserID:(NSString * )aUserID Code:(NSString *)aCode Tel:(NSString *)aTel succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取微信用户个人信息
+(void)getWeiXinUserInfoWithOpenid:(NSString *)aOpenid Accesstoken:(NSString *)aAccesstoken succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//账户提现
+(void)tixianWithUserID:(NSString * )aUserID userTel:(NSString *)aTel weixinid:(NSString *)aWeixinID money:(NSString *)aMoney succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//账户充值
+(void)chongzhiWithUserID:(NSString * )aUserID money:(NSString *)aMoney succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
//获取公告
+(void)getNotiByTelWithutel:(NSString *)utel type:(NSString *)type succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//实名认证
+(void)guserRenZhengWithuid:(NSString *)uid name:(NSString *)name  sfz:(NSString *)sfz img:(NSMutableArray *)img succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;

//获取实名认证信息
+(void)getRenZhengInfoWithuuid:(NSString *)uid  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock;
@end
