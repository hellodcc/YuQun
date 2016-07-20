//
//  LogInViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "ShuRuXianZhi.h"
#import "AFNetworkingManager.h"
#import "HWAlertView.h"
#import "ForgetPassViewController.h"
#import "ImproveRegViewController.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "Model.h"
#import "MBProgressHUD.h"
#import "MainTabBarController.h"
#import <CoreLocation/CoreLocation.h>
@interface LogInViewController ()<UIScrollViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD *progressHUD;
    //定位的管理对象
    CLLocationManager *_manager;
    UITextField *commentTextField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *telBgView;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UIView *passBgView;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIButton *remBtn;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    if (KYX_IS_IPHONE4S||KYX_IS_IPHONE5)
    {
        //监听键盘显示的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
        
        // 监听键盘隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    }
    
    
    [self makeUI];
    [self Location];
    // Do any additional setup after loading the view from its nib.
}


- (void)keyboardWillHide:(NSNotification *)not
{
    // 取到通知携带的数据
    NSDictionary *userInfo = not.userInfo;
    if (self.regBtn.y+self.regBtn.height>SCREEN_SIZE.height)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.regBtn.y+self.regBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height+1);
    }
    
    NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    [self loginBtn:nil];
    return YES;
}

- (void)keybordWillShow:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    
    NSInteger keyBoardHight=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.regBtn.y+self.regBtn.height+10+keyBoardHight);
    
    NSLog(@"%@",NSStringFromCGPoint(self.bgScrollerView.contentOffset));
    NSLog(@"%@",NSStringFromCGRect([commentTextField superview].frame));
    if (self.bgScrollerView.contentOffset.y<[commentTextField superview].y)
    {
        if ([commentTextField superview].y>self.bgScrollerView.contentSize.height-self.bgScrollerView.height-10) {
            
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, self.bgScrollerView.contentSize.height-self.bgScrollerView.height-29);
                
            }];
            
        }else
        {
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, [commentTextField superview].y);
                
            }];
        }
        
    }
    
}


-(void)makeUI
{
    //UserLogin *user=[UserLogin shareUserWithData:nil];
    
    self.bgScrollerView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.telBgView.layer.masksToBounds=YES;
    self.telBgView.layer.cornerRadius=22.5;
    self.telBgView.layer.borderWidth=0.5;
    self.telBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.passBgView.layer.masksToBounds=YES;
    self.passBgView.layer.cornerRadius=22.5;
    self.passBgView.layer.borderWidth=0.5;
    self.passBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.remBtn.layer.masksToBounds=YES;
    self.remBtn.layer.cornerRadius=5;
    self.remBtn.layer.borderWidth=0.5;
    self.remBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.remBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    
     NSString *tel=[[NSUserDefaults standardUserDefaults]objectForKey:@"tel"];
    if (tel.length>0)
    {
        self.telText.text=tel;
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"remLog"])
    {
        self.remBtn.selected=YES;
       
    }else
    {
        self.remBtn.selected=NO;
    
    }
    
    self.loginBtn.layer.masksToBounds=YES;
    self.loginBtn.layer.cornerRadius=22.5;
    
    self.telText.delegate=self;
    self.passText.delegate=self;
    
    
    if (self.regBtn.y+self.regBtn.height>SCREEN_SIZE.height)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.regBtn.y+self.regBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height+1);
    }
    
    [self createTapGesture];
}

- (void)createTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.bgScrollerView addGestureRecognizer:tapGesture];
    
}
-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    commentTextField=textField;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.telText)
    {
        if (range.location < 11) {
            return YES;
        }
        else
        {
            return NO;
        }
    }else
    {
        return YES;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginBtn:(id)sender {
    
    if ([self.telText.text isEqualToString:@""]) {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入手机号码"];
        [message show];
        
    }
    else if (![ShuRuXianZhi matchingTel:self.telText.text])
    {
        HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请输入正确的手机号"];
        [alert show];
    }else if ([self.passText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入登录密码"];
        [message show];
    }else
    {
        
        self.loginBtn.enabled=NO;
        progressHUD = [MBProgressHUD showHUDAddedTo:self.bgScrollerView animated:YES];
        progressHUD.labelText=@"正在努力登录...";
        
        [AFNetworkingManager userLoginWithTel:self.telText.text Pas:self.passText.text succeed:^(id complate) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [progressHUD hide:YES];
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"登陆成功"];
            [alert show];
            self.loginBtn.enabled=YES;
            
            MainTabBarController *mainTabBarController=[MainTabBarController shareMainTabBarController];
            
            mainTabBarController.selectedIndex=0;
            
            NSNotification *not = [[NSNotification alloc] initWithName:@"UserHasLogIn" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:not];
        } Failed:^(id error) {
            [progressHUD hide:YES];
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
            [alert show];
            self.loginBtn.enabled=YES;
        }];

    }
}
- (IBAction)forgetPassBtn:(id)sender {
    ForgetPassViewController *forgetPassVc=[[ForgetPassViewController alloc]initWithTitle:@"忘记密码" leftButton:@"image/back" rightButton:nil];
    [self.navigationController pushViewController:forgetPassVc animated:YES];
}


- (IBAction)regBtn:(id)sender {
    RegisterViewController *registerVc=[[RegisterViewController alloc]initWithTitle:@"注册" leftButton:@"image/back" rightButton:nil];
    [self.navigationController pushViewController:registerVc animated:YES];
//    ImproveRegViewController *improveRegVc=[[ImproveRegViewController alloc]initWithTitle:@"完善资料" leftButton:@"image/back" rightButton:nil];
//    [self.navigationController pushViewController:improveRegVc animated:YES];
}
- (IBAction)remBtn:(id)sender {
    UIButton *btn=sender;
    if (btn.selected==NO)
    {
        btn.selected=YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"remLog"];
    }else
    {
        btn.selected=NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"remLog"];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}




#pragma mark-定位时调用
-(void)Location
{
    //创建管理类对象
    _manager = [[CLLocationManager alloc] init];
    _manager.distanceFilter = 50;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.delegate =self;
    
    
    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager requestWhenInUseAuthorization];
    }
    if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_manager requestAlwaysAuthorization];
    }
    //开始定位
    [_manager startUpdatingLocation];
    //    [_manager startUpdatingHeading];
}

#pragma mark - CLLocationManager代理
//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
}

//定位成功时调用
//iOS6之后的方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        CLLocation *loc = [locations lastObject];
        
        CLLocationCoordinate2D coor = loc.coordinate;
        
        CLGeocoder *geoCoder= [[CLGeocoder alloc] init];
        
        CLLocation *lc = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
        
        
        [geoCoder reverseGeocodeLocation:lc completionHandler:^(NSArray *placemarks, NSError *error) {
            
            
            for (CLPlacemark *placeMark in placemarks)
            {
                NSDictionary *addressDic=placeMark.addressDictionary;
                
                NSString *city=[addressDic objectForKey:@"City"];
                
                NSMutableString *city1=[NSMutableString stringWithString:city];
                [city1 deleteCharactersInRange:NSMakeRange([city length]-1, 1)];
                
                NSLog(@"%@",city1);
                
                [[NSUserDefaults standardUserDefaults]setObject:city1 forKey:@"LocationCity"];
                [_manager stopUpdatingLocation];
            }
            
        }];
    }
    
}

@end
