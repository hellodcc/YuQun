//
//  AppDelegate.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Model.h"
#import "JPUSHService.h"
#import "HWAlertView.h"
#import "NewfeatureController.h"
#import "AFNetworkingManager.h"
@interface AppDelegate ()<WXApiDelegate,NewfeatureControllerDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self userData];
    [self weatherFirstOpen];
    
    [self.window makeKeyAndVisible];
    
    
    [WXApi registerApp:@"wx00b6fa2dfabdc485"];
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"543bd683f9688c06cf71db45" channel:@"Publish channel" apsForProduction:@"0"];
    [NSThread sleepForTimeInterval:3.0];
    return YES;
}

-(void)weatherFirstOpen
{
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    NSString *saveVersion = [[NSUserDefaults  standardUserDefaults] objectForKey:key];
    if([version  isEqualToString:saveVersion]) {
        MainTabBarController *mainTabBarVc=[MainTabBarController shareMainTabBarController];
        self.window.rootViewController=mainTabBarVc;
    }else
    {
        
        NewfeatureController *newfeatureVc=[[NewfeatureController alloc]init];
        newfeatureVc.delagete=self;
        self.window.rootViewController=newfeatureVc;
        
        
    }
}
-(void)endNewfeature
{
    
    MainTabBarController *mainTabBarVc=[MainTabBarController shareMainTabBarController];
    self.window.rootViewController=mainTabBarVc;
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults  standardUserDefaults] setObject:version forKey:key];
    
    [[NSUserDefaults  standardUserDefaults] synchronize];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return  [WXApi handleOpenURL:url delegate:self];
}
-(void)onReq:(BaseReq *)req
{
    //    onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面
}

-(void)onResp:(BaseResp *)resp
{
    
    //    如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    /***************绑定微信****************/
    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{
                                  @"code":code
                                  };
            if ([code length]> 0)
            {
                
                UserLogin * aUser =[UserLogin shareUserWithData:nil];
                
                [AFNetworkingManager getWeiXinAccessTokenWithUserID:aUser.UID Code:code Tel:aUser.Tel succeed:^(id complate) {
                    
                    //                NSLog(@">>>>>>>>%@",complate);
                    [AFNetworkingManager getWeiXinUserInfoWithOpenid:[complate[0] objectForKey:@"openid"] Accesstoken:[complate[0] objectForKey:@"access_token"] succeed:^(id complate) {
                        
                        
                        //                    NSLog(@">>>>>>>>%@",complate);
                        
                        
                        //                        NSLog(@"unionid>>>>>>>%@",[complate objectForKey:@"unionid"]);
                        
                        [AFNetworkingManager addWeiXinInfoWithUserID:aUser.UID WeiXinID:[complate objectForKey:@"unionid"] Userheadpic:[complate objectForKey:@"headimgurl"] Tel:aUser.Tel succeed:^(id complate) {
                            
                            HWAlertView * alert =[[HWAlertView alloc] initWithTitle:@"绑定微信成功！"];
                            [alert show];
                            
                            //刷新用户信息
                            [AFNetworkingManager userLoginWithTel:aUser.Tel Pas:[[NSUserDefaults standardUserDefaults] objectForKey:@"pass"] succeed:^(id complate) {
                                
                                //                                UserLogin *  User =[UserLogin shareUserWithData:nil];
                                //                                NSLog(@"unionid>>>>>>>%@",User.WeiXinID);
                            } Failed:^(id error) {
                                
                            }];
                            
                        } Failed:^(id error) {
                            
                            HWAlertView * alert =[[HWAlertView alloc] initWithTitle:error];
                            [alert show];
                            
                        }];
                        
                    } Failed:^(id error) {
                        
                        //                    NSLog(@"获取信息失败>>>>>>>%@",error);
                        HWAlertView * alert =[[HWAlertView alloc] initWithTitle:error];
                        [alert show];
                        
                    }];
                    
                } Failed:^(id error) {
                    
                    //                NSLog(@">>>>>>>>>>>>%@",error);
                    
                    HWAlertView * alert =[[HWAlertView alloc] initWithTitle:error];
                    [alert show];
                    
                }];
            }
        }
    }
    /***************微信支付****************/
    else if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        NSNotification * notif = [[NSNotification alloc]initWithName:@"weixinzhifu" object:self userInfo:@{@"errcode":[NSString stringWithFormat:@"%d",resp.errCode]}];
        
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"oauth"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else{
        
        return YES;
        
    }
    
}


-(void)userData
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"YuQunData.plist"];
    NSArray * aUser =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [UserLogin shareUserWithData:aUser];

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
//    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
//    {
//        
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasGongGao"];
////        UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"您收到一条推送" message:@"是查看" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"确定", nil];
////        [message show];
//    }else
//    {
        [self pushActivityWithNotification:userInfo];
//    }
//    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    
//    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
//    {
//        
//        UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"您收到一条推送" message:@"是查看" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"确定", nil];
//        [message show];
//        
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasGongGao"];
//        
//    }else
//    {
        [self pushActivityWithNotification:userInfo];
//    }

    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)pushActivityWithNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasGongGao"];
    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    NSString *msgType=[userInfo objectForKey:@"msgType"];
    if ([msgType isEqualToString:@"6"]||[msgType isEqualToString:@"7"])
    {
        [self userLogiN];
    }



}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber>0)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HasGongGao"];
    }
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)userLogiN
{
    UserLogin *user=[UserLogin shareUserWithData:nil];
    if (user.Tel.length>0)
    {
        [AFNetworkingManager userLoginWithTel:user.Tel Pas:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass" ] succeed:^(id complate) {
            
        } Failed:^(id error) {
            
        }];
    }

    }
@end
