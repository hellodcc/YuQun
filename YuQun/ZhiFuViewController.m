//
//  ZhiFuViewController.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/24.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ZhiFuViewController.h"
#import "AHeader.h"
#import "AFNetworkingManager.h"
#import "Model.h"
#import "HWAlertView.h"
#import "MBProgressHUD.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface ZhiFuViewController ()
{
    MBProgressHUD * progressHUD;
}

@end

@implementation ZhiFuViewController


-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter  defaultCenter ] removeObserver:self name:@"weixinzhifu" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.backTop.backgroundColor = COLOR_LAN;
    
    self.backChongZhi.clipsToBounds = YES;
    self.backChongZhi.layer.cornerRadius = 25;
    self.backChongZhi.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backChongZhi.layer.borderWidth = 1.0f;
    self.backChongZhi.backgroundColor =[UIColor whiteColor];
    
    self.ChongZhiBtn.clipsToBounds = YES;
    self.ChongZhiBtn.layer.cornerRadius = 22;
    self.ChongZhiBtn.backgroundColor = COLOR_LAN;
    
    
    UserLogin * aUser =[UserLogin shareUserWithData:nil];
    
    [AFNetworkingManager getJiangjinWithUserID:aUser.UID succeed:^(id complate) {
        
        self.myMoneyLab.text = [NSString stringWithFormat:@"￥%@",[complate[0] objectForKey:@"myMoney"]];
        
        NSInteger myMoney = [[complate[0] objectForKey:@"myMoney"] integerValue];
        
        NSInteger chongzhijin = [self.baozhengjin integerValue]- myMoney;
        
        self.jinErText.text = [NSString stringWithFormat:@"%ld",chongzhijin];
        
        
    } Failed:^(id error) {
        
        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
        [alert show];
        
    }];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(zhifujieguo:) name:@"weixinzhifu" object:nil];
    
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chongzhiBtnClick:(id)sender
{
    
    NSString *phoneRegex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:_jinErText.text];
    if ([_jinErText.text floatValue] < 0||!isValid)
    {
        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"请输入正确的充值金额！"];
        [alert show];
    }
    else
    {
        if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi])
        {
            //风火轮
            progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHUD.labelText = @"正在生成订单，请耐心等待";
            progressHUD.dimBackground = NO;
            UserLogin * aUser =[UserLogin shareUserWithData:nil];
            
            [AFNetworkingManager chongzhiWithUserID:aUser.UID money:self.jinErText.text succeed:^(id complate)
             {
                 
                 [progressHUD hide:YES];
                 [self diaoQiWeiXinWithInfo:[complate objectAtIndex:0]];
                 
             } Failed:^(id error) {
                 
                 [progressHUD hide:YES];
                 HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
                 [alert show];
             }];
        }
        else
        {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"生成订单失败！" message:@"您尚未安装微信或您当前的微信版本不支持该功能！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

-(void)diaoQiWeiXinWithInfo:(NSDictionary *)aInfo
{
    NSMutableString *stamp  = [aInfo objectForKey:@"timestamp"];
    
    PayReq * req = [[PayReq alloc]init];
    
    //    req.openID  = [aInfo objectForKey:@"appid"];
    req.partnerId =[aInfo objectForKey:@"partnerid"];
    
    req.prepayId            = [aInfo objectForKey:@"prepayid"];
    req.nonceStr            = [aInfo objectForKey:@"nonce_str"];
    UInt32 timeStamp =[stamp intValue];
    req.timeStamp= timeStamp;
    req.package =  [aInfo objectForKey:@"package"];
    
    
    req.sign = [aInfo objectForKey:@"sign"];
    
    
    [WXApi sendReq:req];
}

//支付结果
-(void)zhifujieguo:(NSNotification *)sender
{
    NSString * errorCode =  [sender.userInfo objectForKey:@"errcode"];
    if ([errorCode isEqualToString:@"-2"])//用户取消交易
    {
        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"交易已取消"];
        [alert show];
    }
    else if([errorCode isEqualToString:@"-1"])//签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
    {

        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"支付发生异常，支付失败，请稍后重试"];
        [alert show];
        
    }
    else if([errorCode isEqualToString:@"0"])//支付成功
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
