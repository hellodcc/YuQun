//
//  RegisterViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#import "ShuRuXianZhi.h"
#import "HWAlertView.h"
#import "AFNetworkingManager.h"
#import "ImproveRegViewController.h"
#import "XieYiView.h"
@interface RegisterViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
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
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIView *passBgView;

@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIView *sureBgView;
@property (weak, nonatomic) IBOutlet UITextField *sureText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *gouBtn;
@property (weak, nonatomic) IBOutlet UIButton *xieYiBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation RegisterViewController

-(void)dealloc
{
    if (btnTimer) {
        [btnTimer invalidate];
        btnTimer = nil;
    }
    miao = 59;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    miao=59;
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
    
    self.nameBgView.layer.masksToBounds=YES;
    self.nameBgView.layer.cornerRadius=22.5;
    self.nameBgView.layer.borderWidth=0.5;
    self.nameBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.sureBgView.layer.masksToBounds=YES;
    self.sureBgView.layer.cornerRadius=22.5;
    self.sureBgView.layer.borderWidth=0.5;
    self.sureBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.selectBtn.layer.masksToBounds=YES;
    self.selectBtn.layer.cornerRadius=5;
    self.selectBtn.layer.borderWidth=0.5;
    self.selectBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.selectBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    self.selectBtn.selected=YES;
    
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
    
    self.telText.delegate=self;
    self.codeText.delegate=self;
    self.nameText.delegate=self;
    self.passText.delegate=self;
    self.sureText.delegate=self;
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
    
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10+keyBoardHight);
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        [AFNetworkingManager getCodeWithTel:self.telText.text succeed:^(id complate)
        {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"发送成功"];
            [alert show];

            
        } Failed:^(id error)
         {
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

- (IBAction)nextBtn:(id)sender {
    
    if (self.selectBtn.selected==NO)
    {
        self.nextBtn.enabled=YES;
        HWAlertView *alert=[[HWAlertView alloc]initWithTitle:@"请同意《鱼群用户协议》"];
        [alert show];
    }else
    {
        if ([self.telText.text isEqualToString:@""])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入手机号码"];
            [message show];
        }else if(![ShuRuXianZhi matchingTel:self.telText.text])
        {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请输入正确的手机号"];
            [alert show];
        }else if ([self.codeText.text isEqualToString:@""])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入手机验证码"];
            [message show];
            
        }else if ([self.nameText.text isEqualToString:@""])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入真实姓名"];
            [message show];
            
        }else if (self.nameText.text.length>9)
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"您输入的姓名过长"];
            [message show];
            
        }
        else if ([self.passText.text isEqualToString:@""])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入登录密码"];
            [message show];
            
        }else if ([self.sureText.text isEqualToString:@""])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入确认密码"];
            [message show];
            
        }
        else if (![self.sureText.text isEqualToString:self.passText.text])
        {
            HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"两次密码不一致"];
            [message show];
        }else
        {
            self.nextBtn.enabled=NO;
            ImproveRegViewController *improveRegVc=[[ImproveRegViewController alloc]initWithTitle:@"完善资料" leftButton:@"image/back" rightButton:nil];
            improveRegVc.userName=self.nameText.text;
            improveRegVc.userTel=self.telText.text;
            improveRegVc.userPWD=self.passText.text;
            improveRegVc.recommendedUserID=@"0";
            improveRegVc.SMSCode=self.codeText.text;
            [self.navigationController pushViewController:improveRegVc animated:YES];
            self.nextBtn.enabled=YES;
//            [AFNetworkingManager userRegisterWithUserName:self.nameText.text tel:self.telText.text PWD:self.passText.text recommendedUserID:@"0" SMSCode:self.codeText.text Succeed:^(id complate) {
//                self.hidesBottomBarWhenPushed=YES;
//                
//               
//                
//                self.nextBtn.enabled=YES;
//                
//            } Failed:^(id error) {
//                self.nextBtn.enabled=YES;
//                HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
//                [alert show];
//                
//                
//            }];
        }
 
    }
    
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectBtn:(id)sender {
    
    UIButton *btn=sender;
    if (btn.selected==NO)
    {
        btn.selected=YES;
    }else
    {
        btn.selected=NO;
    }
}
- (IBAction)gouBtn:(id)sender {
    
}
- (IBAction)xieYiBtn:(id)sender {
    XieYiView *xieYiView=[[XieYiView alloc]initWithTitle:@""];
    
    [self.view addSubview:xieYiView];
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
