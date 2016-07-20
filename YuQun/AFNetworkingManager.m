//
//  AFNetworkingManager.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "AFNetworkingManager.h"
#import "AFNetworking.h"
#import "AHeader.h"
#import "Model.h"
#import "XMLReader.h"
#import "JPUSHService.h"
@implementation AFNetworkingManager
+(void)userLoginWithTel:(NSString *)tel Pas:(NSString *)pas succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"%@",tel);
    NSLog(@"%@",pas);
    NSDictionary * dic = @{@"tel":tel,
                           @"pwd":pas,
                           @"osType":@"IOS"
                           };
    NSString * urlStr = [NSString stringWithFormat:@"%@/UserLogin",HTTP_UserOperation];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            //存入本地
            NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *path=[docPath stringByAppendingPathComponent:@"YuQunData.plist"];
            
            [NSKeyedArchiver archiveRootObject:[infoDic objectForKey:@"Data"] toFile:path];
            
            [[NSUserDefaults standardUserDefaults]setObject:pas forKey:@"pass"];
            [[NSUserDefaults standardUserDefaults]setObject:tel forKey:@"tel"];
            
            
            [UserLogin shareUserWithData:[infoDic objectForKey:@"Data"]];
            
            [JPUSHService setTags:[NSSet setWithObject:tel] callbackSelector:nil object:nil];
            
            successBlack([infoDic objectForKey:@"Data"]);
            
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
    

}

//用户注册
+(void)userRegisterWithUserName:(NSString *)name tel:(NSString *)tel PWD:(NSString *)PWD recommendedUserID:(NSString *)recommendedUserID SMSCode:(NSString *)SMSCode Tag:(NSString *)tag  gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue cityId:(NSString *)cityId job:(NSString *)job OsType:(NSString *)OsType Succeed:(void(^)(id complate))successBlock Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{
                           @"Name":name,
                           @"Tel":tel,
                           @"PWD":PWD,
                           @"RecommendedUserID":recommendedUserID,
                           @"SMSCode":SMSCode,
                           @"tags":tag,
                           @"gender":gender,
                           @"birthday":birthday,
                           @"Education":education,
                           @"Revenue":revenue,
                           @"CityID":cityId,
                           @"Job":job,
                           @"OsType":OsType
                          
                           };
    NSString * urlStr = [NSString stringWithFormat:@"%@/UserRegDeliver",HTTP_UserOperation];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlock([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];

}

//用户修改密码
+(void)userChangePasWithUserID:(NSString *)userID pwd:(NSString *)pwd  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"pwd":pwd
                           };
    NSString * urlStr = [NSString stringWithFormat:@"%@/ChangePWD",HTTP_UserOperation];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            [[NSUserDefaults standardUserDefaults]setObject:pwd forKey:@"pass"];
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//获取验证码
+(void)getCodeWithTel:(NSString *)aTel  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"tel":aTel};
    NSString * urlStr = [NSString stringWithFormat:@"%@/SendSMSCode",HTTP_SmsOperation];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock([error localizedDescription]);
    }];
}

//获取所有用户标签
+(void)getTypeOfUserTagssucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetTypeOfUserTags",HTTP_TagOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failedBlock([error localizedDescription]);
    }]; 
}

//用户找回密码
+(void)userForgetPWDWithTel:(NSString *)tel SMSCode:(NSString *)SMSCode pwd:(NSString *)pwd  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ForgetPWD",HTTP_UserOperation];
    NSDictionary * dic = @{
                           @"tel":tel,
                           @"SMSCode":SMSCode,
                           @"pwd":pwd
                           };
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];
    
}
//获取城市列表
+(void)GetCityssucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetCitys",HTTP_BaseOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}
//获取学历列表
+(void)GetEducationListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock

{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetEducationList",HTTP_BaseOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}
//获取职位列表
+(void)GetJobListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetJobList",HTTP_BaseOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}
//获取收入范围列表
+(void)GetRevenueListsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetRevenueList",HTTP_BaseOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}

//获取获取我的邀请
+(void)GetUserDirectAgentsSummaryListWithUserID:(NSString *)userID curPage:(NSString *)curPage pageSize:(NSString *)pageSize succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetUserDirectAgentsSummaryList",HTTP_YaoqingOperation];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"curPage":curPage,
                           @"pageSize":pageSize
                           };
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

}

//+ 修改用户信息(不修改姓名) 没有头像

+(void)UpdateUserInfoWithOutUserNameNoImgWithTag:(NSString *)tag gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue tel:(NSString *)tel cityId:(NSString *)cityId job:(NSString *)job Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/UpdateUserInfoWithOutUserNameNoImg",HTTP_UserOperation];
    
    NSDictionary * dic = @{
                           @"tags":tag,
                           @"gender":gender,
                           @"birthday":birthday,
                           @"Education":education,
                           @"Revenue":revenue,
                           @"Tel":tel,
                           @"CityID":cityId,
                           @"Job":job
                           };

    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}


//+ 修改用户信息 没有头像
+(void)UpdateUserInfoWithNoImgWithTag:(NSString *)tag name:(NSString *)name gender:(NSString *)gender birthday:(NSString *)birthday education:(NSString *)education revenue:(NSString *)revenue tel:(NSString *)tel cityId:(NSString *)cityId job:(NSString *)job Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/UpdateUserInfoWithNoImg",HTTP_UserOperation];
    
    NSDictionary * dic = @{
                           @"tags":tag,
                           @"name":name,
                           @"gender":gender,
                           @"birthday":birthday,
                           @"Education":education,
                           @"Revenue":revenue,
                           @"Tel":tel,
                           @"CityID":cityId,
                           @"Job":job
                           };
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

}

//GetOptions
+(void)GetOptionsSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetOptions",HTTP_UserOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

}

//xieyi
+(void)getXieyiSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getXieyi",HTTP_BaseOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//邀请朋友问答
+(void)getConstAnswerYaoqingSucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getConstAnswerYaoqing",HTTP_CommenOperation];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];

    
}

//获取用户基本信息
+(void)GetUserBaseInfoWithUserID:(NSString *)userID tel:(NSString *)tel Succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetUserBaseInfo",HTTP_UserOperation];
    
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"tel":tel
                           };
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        
        if (successNum)
        {
            NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *path=[docPath stringByAppendingPathComponent:@"YuQunData.plist"];
            
            [NSKeyedArchiver archiveRootObject:[infoDic objectForKey:@"Data"] toFile:path];
            
            [UserLogin shareUserWithData:[infoDic objectForKey:@"Data"]];
            
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//获取任务列表
+(void)getJobInfoWithUserID:(NSString *)aUserID page:(NSString *)aPage type:(NSString *)aType succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetCanAcceptTaskList",HTTP_TaskOperation];
    
    
    NSDictionary * dic =@{@"uid":aUserID,@"page":aPage,@"type":aType};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"11%@",infoDic);
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//获取未接受任务详情
+(void)getJobDetailWithTaskID:(NSString *)aTaskID UserID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetDetail",HTTP_TaskOperation];
    
    
    NSDictionary * dic =@{@"taskID":aTaskID,@"uid":aUserID};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger successNum = [[infoDic objectForKey:@"RC"] integerValue];
        
        switch (successNum) {
            case 0:
            {
                failedBlock([infoDic objectForKey:@"ED"]);
            }break;
            case 1:
            {
                successBlack(@[[infoDic objectForKey:@"Data"],@"1"]);
            }break;
            case 2:
            {
                successBlack(@[[infoDic objectForKey:@"Data"],@"2"]);
            }break;
            case 3:
            {
                successBlack(@[[infoDic objectForKey:@"Data"],@"3"]);
            }break;
            case 4:
            {
                successBlack(@[[infoDic objectForKey:@"Data"],@"4"]);
            }break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//获取已接受任务详情
+(void)getMyJobDetailWithOrderID:(NSString *)aOrderID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetOrderDetailInfo",HTTP_TaskOperation];
    
    
    NSDictionary * dic =@{@"orderID":aOrderID};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//接收任务
+(void)acceptJobWithuserID:(NSString *)aUserID tid:(NSString *)aTid curIP:(NSString *)acurIP succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    NSURL *url = [NSURL URLWithString:@"http://1212.ip138.com/ic.asp"];
    NSError * error = nil;
    
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding  error:&error];
    
    if (error)
    {
        str = @"192.168.1.1";
    }
    else
    {
       str = [[str componentsSeparatedByString:@"["][1] componentsSeparatedByString:@"]"][0];
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/AcceptTask",HTTP_TaskOperation];

    NSDictionary * dic =@{@"userID":aUserID,@"tid":aTid,@"curIP":str};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"ED"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//上传任务图片
+(void)uploadJobimgWithImgs:(NSArray *)aImgArr OID:(NSString *)aOID UID:(NSString *)aUID TID:(NSString *)aTID orderstate:(NSString *)aOrderstate succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/TaskOrderFinlishForApp",HTTP_PointOperation];
    NSString * base64 = [aImgArr objectAtIndex:0];
    
    
    for ( int i = 1;i<[aImgArr count];i++)
    {
        
        NSString * str = [aImgArr objectAtIndex:i];
        base64 =[NSString stringWithFormat:@"%@|%@",base64,str];
    }
    
    
    NSDictionary * dic =@{@"oid":aOID,@"tid":aTID,@"uid":aUID,@"orderstate":aOrderstate,@"base64":base64};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上传结果>>>>>>>>>>>%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//奖金流水
+(void)getjiangjinliushuiWithpageSize:(NSString *)aPageSize curPage:(NSString *)aCurPage userID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetFundsList",HTTP_FundsOperation];
    
    NSDictionary * dic =@{@"pageSize":aPageSize,@"curPage":aCurPage,@"userID":aUserID};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//奖金
+(void)getJiangjinWithUserID:(NSString *)aUserID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/GetMoneyDetail",HTTP_FundsOperation];
    
    NSDictionary * dic =@{@"uid":aUserID};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//提现问答
+(void)gettixianwendasucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getConstAnswer",HTTP_CommenOperation];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//获取客服
+(void)getKefusucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getKefu",HTTP_CommenOperation];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];

}

//共多少小鱼
+(void)getAllCountsucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getAllCount",HTTP_UserOperation];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//通过code获取access_token
+(void)getaccesstokenWithcode:(NSString *)aCode succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    NSDictionary * dic = @{@"appid":@"",@"secret":@"",@"code":aCode,@"grant_type":@"authorization_code"};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString * errorCoder =[infoDic objectForKey:@"errcode"];
        if (errorCoder)
        {
            failedBlock(infoDic[@"errmsg"]);
        }
        else
        {
            successBlack(infoDic);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//刷新access_token有效期
+(void)refreshaccesstokenWithrefreshtoken:(NSString *)arefreshtoken succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = @"https://api.weixin.qq.com/sns/oauth2/refresh_token";
    NSDictionary * dic = @{@"appid":@"",@"refresh_token":@"",@"grant_type":@"refresh_token"};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * errorCoder =[infoDic objectForKey:@"errcode"];
        if (errorCoder)
        {
            failedBlock(infoDic[@"errmsg"]);
        }
        else
        {
            successBlack(infoDic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//放弃任务
+(void)cancleJobWiorderID:(NSString *)aorderID succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/TaskCancel",HTTP_TaskOperation];
    
    
    NSDictionary * dic =@{@"orderID":aorderID};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//任务保证金问答
+(void)getBaozhengjinwendasucceed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/getDeposit",HTTP_CommenOperation];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//绑定微信信息
+(void)addWeiXinInfoWithUserID:(NSString *)aUserID WeiXinID:(NSString *)aWeiXinID Userheadpic:(NSString *)aUserheadpic Tel:(NSString *)aTel succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/UpdateWeiXinID",HTTP_UserOperation];
    NSDictionary * dic =@{@"uid":aUserID,@"wxid":aWeiXinID,@"userheadpic":aUserheadpic,@"tel":aTel};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//微信获取accessToken
+(void)getWeiXinAccessTokenWithUserID:(NSString * )aUserID Code:(NSString *)aCode Tel:(NSString *)aTel succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/getAccessToken",HTTP_MoneyOperation];
    NSDictionary * dic =@{@"uid":aUserID,@"code":aCode,@"tel":aTel};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//获取微信用户个人信息
+(void)getWeiXinUserInfoWithOpenid:(NSString *)aOpenid Accesstoken:(NSString *)aAccesstoken succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",aAccesstoken,aOpenid];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[infoDic allKeys] count] > 2)
        {
            successBlack(infoDic);
        }
        else
        {
            failedBlock(infoDic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failedBlock([error localizedDescription]);
    }];
}

//账户提现
+(void)tixianWithUserID:(NSString * )aUserID userTel:(NSString *)aTel weixinid:(NSString *)aWeixinID money:(NSString *)aMoney succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/Reflect",HTTP_MoneyOperation];
    NSDictionary * dic =@{@"uid":aUserID,@"weixinid":aWeixinID,@"utel":aTel,@"money":aMoney};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}

//账户充值
+(void)chongzhiWithUserID:(NSString * )aUserID money:(NSString *)aMoney succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/WxPay",HTTP_MoneyOperation];
    
    NSDictionary * dic =@{@"uid":aUserID,@"paymoney":aMoney};
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
//获取公告
+(void)getNotiByTelWithutel:(NSString *)utel type:(NSString *)type succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/getNotiByTel",HTTP_BaseOperation];
    
    
    NSDictionary * dic =@{@"utel":utel,
                          @"type":type
                          };
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",infoDic);
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}


//实名认证
+(void)guserRenZhengWithuid:(NSString *)uid name:(NSString *)name  sfz:(NSString *)sfz img:(NSMutableArray *)img succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/userRenZheng",HTTP_UserOperation];
    NSString * base64 = [img objectAtIndex:0];
    
    
    for ( int i = 1;i<[img count];i++)
    {
        NSString * str = [img objectAtIndex:i];
        base64 =[NSString stringWithFormat:@"%@|%@",base64,str];
    }
    
    
    NSDictionary * dic =@{@"uid":uid,
                          @"name":name,
                          @"sfz":sfz,
                          @"img":base64
                          };
    
    NSLog(@"%@",base64);
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上传结果>>>>>>>>>>>%@",infoDic);
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
    
}


//获取实名认证信息
+(void)getRenZhengInfoWithuuid:(NSString *)uid  succeed:(void(^)(id complate))successBlack Failed:(void(^)(id error))failedBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.operationQueue cancelAllOperations];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/getRenZhengInfo",HTTP_UserOperation];
    
    
    NSDictionary * dic =@{@"uid":uid,
                          
                          };
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",infoDic);
        
        BOOL successNum = [[infoDic objectForKey:@"RC"] boolValue];
        if (successNum)
        {
            successBlack([infoDic objectForKey:@"Data"]);
        }
        else
        {
            failedBlock([infoDic objectForKey:@"ED"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock([error localizedDescription]);
        
    }];
}
@end
