//
//  ForgetPassViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#import "ShuRuXianZhi.h"
#import "HWAlertView.h"
#import "AFNetworkingManager.h"
@interface ForgetPassViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UITextField *commentTextField;
    NSInteger miao;
    NSTimer * btnTimer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;

@property (weak, nonatomic) IBOutlet UIView *telBgView;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIView *passBgView;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIView *sureBgView;
@property (weak, nonatomic) IBOutlet UITextField *sureText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;



@end

@implementation ForgetPassViewController
-(void)dealloc
{
    if (btnTimer) {
        [btnTimer invalidate];
        btnTimer = nil;
    }
    miao = 59;
}
- (void)viewDidLoad {
    miao=59;
    [super viewDidLoad];
    //监听键盘显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    // 监听键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)makeUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.bgScrollerView.delegate=self;
    self.telText.delegate=self;
    self.codeText.delegate=self;
    self.passText.delegate=self;
    self.sureText.delegate=self;
    
    self.telBgView.layer.masksToBounds=YES;
    self.telBgView.layer.cornerRadius=22.5;
    self.telBgView.layer.borderWidth=0.5;
    self.telBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.codeBgView.layer.masksToBounds=YES;
    self.codeBgView.layer.cornerRadius=22.5;
    self.codeBgView.layer.borderWidth=0.5;
    self.codeBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.passBgView.layer.masksToBounds=YES;
    self.passBgView.layer.cornerRadius=22.5;
    self.passBgView.layer.borderWidth=0.5;
    self.passBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    self.sureBgView.layer.masksToBounds=YES;
    self.sureBgView.layer.cornerRadius=22.5;
    self.sureBgView.layer.borderWidth=0.5;
    self.sureBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=22.5;
    
    self.codeBtn.layer.masksToBounds=YES;
    self.codeBtn.layer.cornerRadius=15;
    
    if (self.backBtn.y+self.backBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.backBtn.y+self.backBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height-63);
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

- (void)keyboardWillHide:(NSNotification *)not
{
    // 取到通知携带的数据
    NSDictionary *userInfo = not.userInfo;
    if (self.backBtn.y+self.backBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.backBtn.y+self.backBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height-63);
    }
    NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keybordWillShow:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    
    NSInteger keyBoardHight=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.backBtn.y+self.backBtn.height+10+keyBoardHight);
    
    NSLog(@"%@",NSStringFromCGPoint(self.bgScrollerView.contentOffset));
    NSLog(@"%@",NSStringFromCGRect([commentTextField superview].frame));
    if (self.bgScrollerView.contentOffset.y<[commentTextField superview].y)
    {
        if ([commentTextField superview].y>self.bgScrollerView.contentSize.height-self.bgScrollerView.height-10) {
            
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, self.bgScrollerView.contentSize.height-self.bgScrollerView.height);
                
            }];
            
        }else
        {
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, [commentTextField superview].y);
                
            }];
        }
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];

    return YES;
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
    }else if (textField==self.codeText)
    {
        if (range.location < 4) {
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    commentTextField=textField;
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
- (IBAction)nextBtn:(id)sender {
    
    if ([self.telText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入用户名"];
        [message show];
    }else if ([self.codeText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入密码"];
        [message show];
        
    }else if ([self.passText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入确认密码"];
        [message show];
        
    }else if ([self.sureText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入手机号"];
        [message show];
        
    }else if(self.passText.text !=self.sureText.text)
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"两次密码不一致"];
        [message show];
    }else
    {
        
        
        self.nextBtn.enabled=NO;
        [AFNetworkingManager userForgetPWDWithTel:self.telText.text SMSCode:self.codeText.text pwd:self.passText.text succeed:^(id complate) {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"修改成功"];
            [alert show];
            
            self.nextBtn.enabled=YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } Failed:^(id error) {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
            [alert show];
            self.nextBtn.enabled=YES;
        }];
//        
//        [AFNetworkingManager userRegisterWithUserStyle:self.userStyleBtn.titleLabel.text userName:self.userNameText.text pas:self.miMaText.text userTel:self.userTelText.text code:self.yanZhengMaText.text userCity:@"南京" Succeed:^(id complate) {
//            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"注册成功"];
//            [alert show];
//            [self userLogin];
//        } Failed:^(id error) {
//            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
//            [alert show];
//            self.nextBtn.enabled=YES;
//            
//        }];
    }

}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)codeBtn:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self.telText.text isEqualToString:@""]) {
        
        HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"手机号不能为空"];
        [alert show];
    }
    else if(![ShuRuXianZhi matchingTel:self.telText.text])
    {
        HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请输入正确的手机号"];
        [alert show];
    }else
    {
        self.codeBtn.userInteractionEnabled = NO;
        self.codeBtn.backgroundColor = [UIColor grayColor];
        [self.codeBtn setTitle:@"60秒" forState:UIControlStateNormal];
        btnTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tiaoMiao) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:btnTimer forMode:NSDefaultRunLoopMode];
        
        
        //获取验证码
        [AFNetworkingManager getCodeWithTel:self.telText.text  succeed:^(id complate) {
            
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"发送成功"];
            [alert show];
            
        } Failed:^(id error) {
            
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
            [alert show];
            
        }];
        
    }

    
}

-(void)tiaoMiao
{
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)miao ]forState:UIControlStateNormal];
    //判断是否超过60s
    if (miao == 0) {
        self.codeBtn.userInteractionEnabled = YES;
        self.codeBtn.backgroundColor = COLOR_NAV;
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        [btnTimer invalidate];
        btnTimer = nil;
        miao = 59;
    }
    else
    {
        miao-= 1;
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

@end
