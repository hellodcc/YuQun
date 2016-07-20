//
//  Model.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject



@end

/**
 *  登陆
 */
@interface UserLogin : NSObject

@property(nonatomic,copy)NSString * UID;
@property(nonatomic,copy)NSString * RecommendedUserID;
@property(nonatomic,copy)NSString * RecommendedUserName;
@property(nonatomic,copy)NSString * Name;
@property(nonatomic,copy)NSString * Tel;
@property(nonatomic,copy)NSString * WeiXinID;
//@property(nonatomic,copy)NSString * Unionid;



@property(nonatomic,copy)NSString * Gender;
@property(nonatomic,copy)NSString * GenderCN;
@property(nonatomic,copy)NSString * Age;
@property(nonatomic,copy)NSString * AgeCN;
@property(nonatomic,copy)NSString * Job;
@property(nonatomic,copy)NSString * JobName;
@property(nonatomic,copy)NSString * State;
@property(nonatomic,retain)NSNumber * Points;
@property(nonatomic,retain)NSNumber * UserLevel;
@property(nonatomic,copy)NSString * AmountMoney;
@property(nonatomic,copy)NSString * MoneyCanWithdrawals;
@property(nonatomic,copy)NSString * BankName;
@property(nonatomic,copy)NSString * BankCardCode;
@property(nonatomic,copy)NSString * BankCardPersonName;
@property(nonatomic,copy)NSString * RegDate;
@property(nonatomic,copy)NSString * RegIP;
@property(nonatomic,copy)NSString * LastOptDate;
@property(nonatomic,copy)NSString * LastOptIP;
@property(nonatomic,copy)NSString * UserSource;
@property(nonatomic,copy)NSString * CityID;
@property(nonatomic,copy)NSString * CityName;
@property(nonatomic,copy)NSString * Birthday;
@property(nonatomic,copy)NSString * UserHeadPic;
@property(nonatomic,copy)NSString * PWD;
@property(nonatomic,retain)NSArray * Tags;
@property(nonatomic,copy)NSString * AmountOfYestBonus;
@property(nonatomic,copy)NSString * Education;
@property(nonatomic,copy)NSString * EducationName;
@property(nonatomic,copy)NSString * Revenue;
@property(nonatomic,copy)NSString * RevenueName;
@property(nonatomic,copy)NSString * NPointFreezeStartDate;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * OS;
@property(nonatomic,copy)NSString * OSDesc;
@property(nonatomic,copy)NSString * JobStr;
@property(nonatomic,copy)NSString * EduStr;
@property(nonatomic,copy)NSString * CityStr;
@property(nonatomic,copy)NSString * RevStr;
@property(nonatomic,copy)NSString * passAuthentication;
@property(nonatomic,copy)NSString * passAuthenticationStr;
@property(nonatomic,copy)NSString * passAuthDate;
@property(nonatomic,copy)NSString * cerCode;

+(UserLogin *)shareUserWithData:(id)aData;
+(void)killUser;

@end


/**
 * 获取所有用户标签
 */
@interface userTagsModel : NSObject
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * Name;
@property(nonatomic,copy)NSString * TagType;
@property(nonatomic,copy)NSString * DelFlag;
@end

/**
 *  获取城市列表
 */
@interface CitysModel : NSObject
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * PY;
@property(nonatomic,copy)NSString * FirstLetter;
@property(nonatomic,copy)NSString * CityName;
@end

/**
 *  获取学历列表
 */
@interface EducationModel : NSObject
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * EducationName;

@end

/**
 *  获取职位列表
 */
@interface JobModel : NSObject
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * JobName;

@end

/**
 *  获取收入范围列表
 */
@interface RevenueModel : NSObject
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * RangeName;
@property(nonatomic,copy)NSString * OrderID;
@end


/**
 *  获取我的邀请
 */
@interface YaoQingModel : NSObject
@property(nonatomic,copy)NSString * myyaoqingnum;
@property(nonatomic,copy)NSString * totalmoney;
@property(nonatomic,copy)NSArray * flowlist;
@end


@interface YaoQingListModel : NSObject
@property(nonatomic,copy)NSString * Name;
@property(nonatomic,copy)NSString * Tel;
@property(nonatomic,copy)NSString * RegDate;
@property(nonatomic,copy)NSString * AgentNumCount;
@property(nonatomic,copy)NSString * BounsMoney;
@end


@interface OptionsModel : NSObject
@property(nonatomic,copy)NSString * MPRate;
@property(nonatomic,copy)NSDictionary * LvDefine;
@property(nonatomic,copy)NSString * DirectRecommenderBonusRange;
@property(nonatomic,copy)NSString * CrossLvRecommenderBonusRange;
@property(nonatomic,copy)NSString * NegativePointFreezeDays;
@property(nonatomic,copy)NSString * WithdrawalsMoneyStartingPoint;
@property(nonatomic,copy)NSString * PointWhenReg;
@property(nonatomic,copy)NSString * MoneyWhenReg;
@property(nonatomic,copy)NSString * NegativePointsAutoLock;
@property(nonatomic,copy)NSString * SignBonus;
@property(nonatomic,copy)NSString * SingleWithdrawalsMoneyLimit;
@property(nonatomic,copy)NSString * WithdrawalsMoneyLimitInOneDay;

@end



//邀请朋友问答
@interface AnswerModel : NSObject
@property(nonatomic,copy)NSString * Queation;
@property(nonatomic,copy)NSString * Answer;
@property(nonatomic,copy)NSString * img;
@end

/*
 *任务模型
 */
@interface JobInfo : NSObject

@property(nonatomic,retain)NSNumber * TID;
@property(nonatomic,copy)NSString *releasePoint;

@property(nonatomic,retain)NSNumber * CID;
@property(nonatomic,copy)NSString * CName;
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString * Content;
@property(nonatomic,copy)NSString * Link;
@property(nonatomic,copy)NSString * FinlishStandard;
@property(nonatomic,retain)NSNumber * Price;
@property(nonatomic,copy)NSString * PriceStr;
@property(nonatomic,retain)NSNumber * PerSettlemenDate;
@property(nonatomic,copy)NSString * FinlishDate;
@property(nonatomic,retain)NSNumber * ExpectedToTake;
@property(nonatomic,retain)NSNumber * TaskPersonLimit;
@property(nonatomic,retain)NSNumber * TaskAcceptNum;
@property(nonatomic,retain)NSNumber * GenderNeeded;
@property(nonatomic,retain)NSNumber * AgeLimitLow;
@property(nonatomic,retain)NSNumber * AgeLimitHigh;
@property(nonatomic,retain)NSNumber * Deposit;
@property(nonatomic,retain)NSNumber * ClickNum;
@property(nonatomic,retain)NSNumber * State;
@property(nonatomic,retain)NSNumber * TaskType;
@property(nonatomic,copy)NSString * IssueDate;
@property(nonatomic,copy)NSString * IssueIP;
@property(nonatomic,copy)NSString * LastModifyDate;
@property(nonatomic,copy)NSString * LastModifyIP;
@property(nonatomic,retain)NSNumber *IssuerID ;
@property(nonatomic,retain)NSNumber * LastModifierID;
@property(nonatomic,retain)NSArray * Tags;
@property(nonatomic,copy)NSString * TagsString;
@property(nonatomic,retain)NSNumber * PurchasePrice;
@property(nonatomic,retain)NSNumber * TaskTotalPurchasePrice;
@property(nonatomic,retain)NSNumber * TaskFinlishNumber;
@property(nonatomic,copy)NSString * TaskFinlishDateLimit;

@property(nonatomic,retain)NSNumber * JobLimit;
@property(nonatomic,retain)NSNumber * UserLevelLimit;
@property(nonatomic,copy)NSString * BirthdayLimit;
@property(nonatomic,retain)NSNumber * EducationLimit;
@property(nonatomic,retain)NSNumber * RevenueLimit;
@property(nonatomic,retain)NSNumber * CityLimit;
@property(nonatomic,retain)NSNumber * TagLimit;
@property(nonatomic,retain)NSNumber * TaskOrderID;

@property(nonatomic,retain)NSNumber * CanFinlishUploadTimeSpan;
@property(nonatomic,retain)NSNumber * TaskOrderState;

@property(nonatomic,retain)NSNumber * OSLimit;

@property(nonatomic,copy)NSString * taskIsnew;

@property(nonatomic,copy)NSString * ExpectedToTakeTimeStr;

@property(nonatomic,copy)NSString * DepositStr;


@property(nonatomic,copy)NSString * AuthLimit;


@end

@interface YijieRenWu :NSObject

@property(nonatomic,retain)NSDictionary * TaskInfo;

@property(nonatomic,retain)NSNumber * OID;
@property(nonatomic,retain)NSNumber * TID;
@property(nonatomic,retain)NSNumber * UserID;
@property(nonatomic,retain)NSNumber * OrderState;
@property(nonatomic,retain)NSNumber * SettlementState;
@property(nonatomic,retain)NSNumber * CID;
@property(nonatomic,copy)NSString *  OrderTime;
@property(nonatomic,copy)NSString *  OrderIP;
@property(nonatomic,copy)NSString *  Comment;
@property(nonatomic,copy)NSString *  OrderBack;
@property(nonatomic,copy)NSString *  OrderBackPic;
@property(nonatomic,copy)NSString *  OrderCheckDate;
@property(nonatomic,copy)NSString *  OrderFinlishDate;
@property(nonatomic,copy)NSString *  CustomerName;

@property(nonatomic,retain)NSDictionary * UserInfo;

@end


/*
 *奖金流水
 */
@interface JiangjinLiushui : NSObject


@property(nonatomic,copy)NSString * OccurredDate;
@property(nonatomic,copy)NSString * FundsTypeDesc;
@property(nonatomic,copy)NSString * StateDesc;
@property(nonatomic,copy)NSString * TaskTitle;
@property(nonatomic,copy)NSString * OrderCode;
@property(nonatomic,retain)NSNumber *ID ;
@property(nonatomic,retain)NSNumber *UserID;
@property(nonatomic,retain)NSNumber * TaskID;
@property(nonatomic,retain)NSNumber * AmountMoney;
@property(nonatomic,retain)NSNumber * FundsType;
@property(nonatomic,retain)NSNumber *State;
@property(nonatomic,copy)NSString * AmountMoneyStr;

@end

/*
 *kefu
 */
@interface KeFuModel : NSObject


@property(nonatomic,retain)NSString * kefuTel;
@property(nonatomic,retain)NSString * time;
@property(nonatomic,retain)NSString * weixin;


@end
@interface GongGaoModel : NSObject


@property(nonatomic,retain)NSString * ID;
@property(nonatomic,retain)NSString * UserTel;
@property(nonatomic,retain)NSString * Notification;
@property(nonatomic,retain)NSString * Type;
@property(nonatomic,retain)NSString * CreateTime;
@property(nonatomic,retain)NSString * Content;


@end


@interface RenZhengInfoModel : NSObject


@property(nonatomic,retain)NSString * ID;
@property(nonatomic,retain)NSString * UID;
@property(nonatomic,retain)NSString * RealName;
@property(nonatomic,retain)NSString * CertifyCode;
@property(nonatomic,retain)NSString * Photo;
@property(nonatomic,retain)NSString * AuthenticationState;
@property(nonatomic,retain)NSString * FailedReson;


@end