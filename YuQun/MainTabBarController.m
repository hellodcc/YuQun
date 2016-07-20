//
//  MainTabBarController.m
//  FengXianShengHuo
//
//  Created by dcc on 16/1/22.
//  Copyright © 2016年 dcc. All rights reserved.
//

#import "MainTabBarController.h"
#import "JobViewController.h"
#import "RewardViewController.h"
#import "InviteViewController.h"
#import "MyViewController.h"
#import "AHeader.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建视图控制器
    [self createViewControllers];
    [self createItems];
    // Do any additional setup after loading the view from its nib.
}

static MainTabBarController * mainTabBarController = nil;

+(MainTabBarController *)shareMainTabBarController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mainTabBarController = [[MainTabBarController alloc]init];
        
    });
    return mainTabBarController;

}

#pragma mark - createItems
- (void)createItems{
    NSArray *titleArr = @[@"任务",@"奖金",@"邀请",@"我的"];
    NSArray *selectImageArr = @[@"job_s",@"money_s",@"invite_s",@"my_s"];
    //未选择状态图片名字数组
    NSArray *unSelectImageArr =@[@"job_u",@"money_u",@"invite_u",@"my_u"];
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        item.title = titleArr[i];

        [item setTitlePositionAdjustment:UIOffsetMake(0,-3 )];
        
        
        UIImage *selectImage = [[UIImage imageNamed:selectImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImage:selectImage];
        
        
        UIImage *unSelectImage = [[UIImage imageNamed:unSelectImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImage:unSelectImage];
        
    }

    self.tabBar.tintColor=COLOR_NAV;
    [self.tabBar setBackgroundColor:[UIColor grayColor]];
    
    self.tabBar.barTintColor =[UIColor whiteColor];
    self.tabBar.translucent = false;
      //[self.navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, 2)];
}


#pragma mark - createViewControllers
- (void)createViewControllers{
    
    
    
    JobViewController *vc1 = [[JobViewController alloc] init];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
    nav1.navigationBarHidden = YES;
 
    
    
    RewardViewController *vc2 = [[RewardViewController alloc] init];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:vc2];
    nav2.navigationBarHidden = YES;
    
    
    InviteViewController *vc3 = [[InviteViewController alloc] init];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:vc3];
    nav3.navigationBarHidden = YES;
  
    MyViewController *vc4 = [[MyViewController alloc] init];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:vc4];
    nav4.navigationBarHidden = YES;
    
    NSArray *ncArr = @[nav1,nav2,nav3,nav4];
    self.viewControllers = ncArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
