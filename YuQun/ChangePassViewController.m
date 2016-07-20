//
//  ChangePassViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ChangePassViewController.h"
#import "AHeader.h"
#import "Model.h"
#import "UIView+MJ.h"
#import "HWAlertView.h"
#import "AFNetworkingManager.h"

@interface ChangePassViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UITextField *oldPassText;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@property (weak, nonatomic) IBOutlet UITextField *surePassText;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_BACK;
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
    self.bgScrollerView.delegate=self;
    self.oldPassText.delegate=self;
    self.passText.delegate=self;
    self.surePassText.delegate=self;
    UserLogin *user=[UserLogin shareUserWithData:nil];
    self.telLab.text=[NSString stringWithFormat:@"%@*****%@",[user.Tel substringToIndex:3],[user.Tel substringFromIndex:8]];
    
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=22.5;
    
    if (self.nextBtn.y+self.nextBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10);
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
    NSString *pass=[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"];
    
    if ([self.oldPassText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输原密码"];
        [message show];
    }
    else if (![self.oldPassText.text isEqualToString:pass])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"原密码错误"];
        [message show];
        
    }else if ([self.passText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输新密码"];
        [message show];
        
    }
    else if (![self.surePassText.text isEqualToString:self.passText.text])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输入确认密码"];
        [message show];
        
    }else if ([self.surePassText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"两次密码不一致"];
        [message show];
        
    }else
    {
        
        UserLogin *user=[UserLogin shareUserWithData:nil];
        [AFNetworkingManager userChangePasWithUserID:user.UID pwd:self.passText.text succeed:^(id complate) {
            
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"修改成功"];
            [alert show];
             [self.navigationController popToRootViewControllerAnimated:YES];
            
        } Failed:^(id error) {
            
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
            [alert show];
        }];
        
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
