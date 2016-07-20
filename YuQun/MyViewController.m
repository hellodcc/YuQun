//
//  MyViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "MyViewController.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#import "BtnCell.h"
#import "UILabel+Badge.h"
#import "ContactViewController.h"
#import "LogInViewController.h"
#import "ChangeDataViewController.h"
#import "ChangePassViewController.h"
#import "Model.h"
#import "LogInViewController.h"
#import "AFNetworkingManager.h"
#import "UIImageView+WebCache.h"
#import "QianDaoWebViewController.h"
#import "GongGaoViewController.h"
#import "BigImage.h"
#import "UILabel+Red.h"
#import "AboutUsViewController.h"
#import "RenZhengViewController.h"
#import "MBProgressHUD.h"
#import "HWAlertView.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *btnArr;
    NSArray *imgArr;
    NSDictionary *lvDic;
    RenZhengInfoModel *zhengInfoModel;
    MBProgressHUD * progressHUD;
}
@property (weak, nonatomic) IBOutlet UIButton *realRZBtn;
@property (weak, nonatomic) IBOutlet UILabel *xYLab;
@property (weak, nonatomic) IBOutlet UIButton *sfzBtn;
@property (weak, nonatomic) IBOutlet UILabel *lvBiLiLab;
@property (weak, nonatomic) IBOutlet UILabel *lvLab;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UITableView *btnTv;
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *registerIPLab;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.bgScrollerView.contentOffset=CGPointMake(0, 0);
    [super viewWillAppear:animated];

    [self makeUI];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_BACK;
    self.bgScrollerView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    btnArr=@[@"消息公告",@"我的奖金",@"每日签到",@"修改资料",@"修改密码",@"联系客服",@"关于我们"];
    imgArr=@[@"gonggao",@"icon_money",@"data",@"changinfo",@"pass",@"contact",@"my"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
   
    UIView *xiaLaView=[[UIView alloc]initWithFrame:CGRectMake(0, -2*SCREEN_SIZE.height, SCREEN_SIZE.width,2*SCREEN_SIZE.height )];
    xiaLaView.backgroundColor=COLOR_NAV;
    [self.bgScrollerView addSubview:xiaLaView];
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.cornerRadius=self.iconImg.width/2;
    
    if (user.UserHeadPic.length>0)
    {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:user.UserHeadPic]];
    }else
    {
        
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",user.Gender]);
    if ([[NSString stringWithFormat:@"%@",user.Gender] isEqualToString:@"1"])
    {
        self.nameLab.text=[NSString stringWithFormat:@"%@先生",[user.Name substringToIndex:1]];
    }else
    {
        self.nameLab.text=[NSString stringWithFormat:@"%@女士",[user.Name substringToIndex:1]];
    }
//    
//    [self.nameLab showBadgeWithLV:[NSString stringWithFormat:@"lv%@",user.UserLevel]];
    
    self.realRZBtn.layer.masksToBounds=YES;
    self.realRZBtn.layer.cornerRadius=5;
  
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.nameLab addGestureRecognizer:tapGesture];
    
    if ([[NSString stringWithFormat:@"%@",user.passAuthentication] isEqualToString:@"1"])
    {
        
        self.realRZBtn.hidden=YES;
    
        self.nameLab.userInteractionEnabled=YES;
        self.nameLab.y=self.iconImg.y+self.iconImg.height+35;
        
        self.sfzBtn.hidden=NO;
        self.sfzBtn.frame=CGRectMake(self.nameLab.x+self.nameLab.size.width,self.nameLab.y -0.5 * self.nameLab.size.height, 15, 15);
        
    }else if ([[NSString stringWithFormat:@"%@",user.passAuthentication] isEqualToString:@"2"])
    {
        self.nameLab.y=self.iconImg.y+self.iconImg.height+18;
        self.nameLab.userInteractionEnabled=NO;
        self.realRZBtn.hidden=NO;
        [self.realRZBtn setTitle:@"正在认证中" forState:UIControlStateNormal];
        self.sfzBtn.hidden=YES;
    }
    else
    {
    
        self.nameLab.y=self.iconImg.y+self.iconImg.height+18;
        self.nameLab.userInteractionEnabled=NO;
        self.realRZBtn.hidden=NO;
       [self.realRZBtn setTitle:@"进行实名认证" forState:UIControlStateNormal];
        self.sfzBtn.hidden=YES;
    }
    
    
    self.xYLab.x=self.progressBgView.x-45;
    self.lvLab.x=self.progressBgView.x+self.progressBgView.width+5;
    self.progressBgView.layer.masksToBounds=YES;
    self.progressBgView.layer.cornerRadius=self.progressBgView.height/2;
    
    self.progressView.layer.masksToBounds=YES;
    self.progressView.layer.cornerRadius=self.progressView.height/2;
    
    self.progressView.width=0;
    self.lvLab.text=[NSString stringWithFormat:@"LV%@",user.UserLevel];
    
    
//    NSArray *lvArr=[lvDic objectForKey:[NSString stringWithFormat:@"%@",user.UserLevel]];
//    NSString *lvMaxStr=[lvArr objectAtIndex:1];

    NSInteger lvMaxPoint=0;
    if ([[NSString stringWithFormat:@"%@",user.UserLevel] isEqualToString:@"1"])
    {
        lvMaxPoint=2000;
    }else if ([[NSString stringWithFormat:@"%@",user.UserLevel] isEqualToString:@"2"])
    {
        lvMaxPoint=4000;
    }else if ([[NSString stringWithFormat:@"%@",user.UserLevel] isEqualToString:@"3"])
    {
        lvMaxPoint=7000;
    }else if ([[NSString stringWithFormat:@"%@",user.UserLevel] isEqualToString:@"4"])
    {
        lvMaxPoint=11000;
    }else if ([[NSString stringWithFormat:@"%@",user.UserLevel] isEqualToString:@"5"])
    {
        lvMaxPoint=16000;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        if (lvMaxPoint>0)
        {
           float bili=[user.Points floatValue]/ lvMaxPoint ;
             self.progressView.width=(self.progressBgView.width-4)*bili;
        }
        
       
    }];
    
    self.lvBiLiLab.text=[NSString stringWithFormat:@"%@/%ld",user.Points,lvMaxPoint];
    
    self.telLab.text=[NSString stringWithFormat:@"绑定手机：%@*****%@",[user.Tel substringToIndex:3],[user.Tel substringFromIndex:8]];
    
    self.btnTv.x=0 ;
    self.btnTv.y=self.titleBgView.height+20;
    self.btnTv.width=SCREEN_SIZE.width;
    self.btnTv.height=44*[btnArr count];
    self.btnTv.delegate=self;
    self.btnTv.dataSource=self;
    self.btnTv.scrollEnabled=NO;
    self.btnTv.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.btnTv reloadData];
    
    self.registerTimeLab.y=self.btnTv.y+self.btnTv.height+10;
    self.registerTimeLab.text=[NSString stringWithFormat:@"注册时间：%@",user.RegDate];
    self.registerIPLab.y=self.btnTv.y+self.btnTv.height+10;
    self.registerIPLab.text=[NSString stringWithFormat:@"注册IP：%@",user.RegIP];
    
    self.exitBtn.y=self.btnTv.y+self.btnTv.height+50;
    
    
    if (self.exitBtn.y+self.exitBtn.height>SCREEN_SIZE.height-49)
    {
        self.bgScrollerView.contentSize=CGSizeMake(0, self.exitBtn.y+self.exitBtn.height+10);
    }else
    {
       self.bgScrollerView.contentSize=CGSizeMake(0, SCREEN_SIZE.height-48);
    }
    
//    [self createTapGesture];
}


-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self loadRenZhengInfo];
}

//- (void)createTapGesture
//{
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    tapGesture.numberOfTouchesRequired = 1;
//    tapGesture.cancelsTouchesInView = NO;
//    self.iconImg.userInteractionEnabled=YES;
//    [self.iconImg addGestureRecognizer:tapGesture];
//    
//}
//-(void)tapGesture:(UITapGestureRecognizer *)tap
//{
//    [BigImage showImage:self.iconImg];
//}


-(void)getOptions
{
    [AFNetworkingManager GetOptionsSucceed:^(id complate) {
        
        NSArray *arr=complate;
        for (NSDictionary *dic in arr)
        {
            OptionsModel *model=[[OptionsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            lvDic=model.LvDefine;
        }
        
        [self makeUI];
    } Failed:^(id error) {
        
    }];
}
-(void)GetUserBaseInfo
{
    UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager GetUserBaseInfoWithUserID:user.UID tel:user.Tel Succeed:^(id complate) {
        
        
    } Failed:^(id error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [btnArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UserLogin *user=[UserLogin shareUserWithData:nil];
    BtnCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"BtnCell" owner:self options:nil] lastObject];
    cell.moneyLab.hidden=YES;
    if (cell==nil) {
        cell=[[BtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row==0)
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"HasGongGao"])
        {
             [cell.cellTitleLab showBadge];
        }
       
    }
    if (indexPath.row==1)
    {
        cell.moneyLab.hidden=NO;
        cell.moneyLab.text=[NSString stringWithFormat:@"￥%@",user.MoneyCanWithdrawals];
    }
    cell.cellTitleLab.text=[btnArr objectAtIndex:indexPath.row];
    cell.cellLog.image=[UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserLogin *user=[UserLogin shareUserWithData:nil];
    if (indexPath.row==0)
    {
        self.hidesBottomBarWhenPushed=YES;
        GongGaoViewController *gongGaoVc=[[GongGaoViewController alloc]initWithTitle:@"消息公告" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:gongGaoVc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HasGongGao"];
//        BtnCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//        [cell.cellTitleLab hideBadge];
        
    }
    if (indexPath.row==1)
    {
        self.tabBarController.selectedIndex=1;
    }
    if (indexPath.row==2)
    {
        self.hidesBottomBarWhenPushed=YES;
        QianDaoWebViewController *qoanDaoVc=[[QianDaoWebViewController alloc]initWithTitle:@"每日签到" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:qoanDaoVc animated:YES];
        qoanDaoVc.urlStr=[NSString stringWithFormat:@"http://partner.17yuqun.com/qiandaoForApp.aspx?uid=%@",user.UID];
        qoanDaoVc.isFirst=YES;
        self.hidesBottomBarWhenPushed=NO;
    }
    if (indexPath.row==3)
    {
        self.hidesBottomBarWhenPushed=YES;
        ChangeDataViewController *changeDataVc=[[ChangeDataViewController alloc]initWithTitle:@"修改资料" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:changeDataVc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (indexPath.row==4)
    {
        self.hidesBottomBarWhenPushed=YES;
        ChangePassViewController *changPass=[[ChangePassViewController alloc]initWithTitle:@"修改密码" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:changPass animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (indexPath.row==5)
    {
        self.hidesBottomBarWhenPushed=YES;
        ContactViewController *contactVc=[[ContactViewController alloc]initWithTitle:@"联系客服" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:contactVc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (indexPath.row==6)
    {
        self.hidesBottomBarWhenPushed=YES;
         AboutUsViewController*aboutUsVC=[[AboutUsViewController alloc]initWithTitle:@"关于我们" leftButton:@"image/back" rightButton:nil];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
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
- (IBAction)exitBtn:(id)sender {
    
    
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]< 9.0)
    {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:nil message:@"您将退出此次登陆，是否确认？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确定退出", nil];
        [alert show];
    }
    else
    {
        UIAlertController * alert =[UIAlertController alertControllerWithTitle:nil message:@"您将退出此次登陆，是否确认？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAC =[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:cancleAC];
        
        
        UIAlertAction * certainAC =[UIAlertAction  actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self killUser];
            
        }];
        [alert addAction:certainAC];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

}


-(void)killUser
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"YuQunData.plist"];
    //删除
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    //
    [UserLogin killUser];
    
    LogInViewController * loginVC = [[LogInViewController alloc]init];
    UINavigationController * loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:NO completion:nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self killUser];
    }
}
- (IBAction)realRZbtn:(id)sender {
    [self loadRenZhengInfo];
}

-(void)loadRenZhengInfo
{
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    progressHUD.labelText = @"";
    progressHUD.dimBackground = NO;
    UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager getRenZhengInfoWithuuid:user.UID succeed:^(id complate) {
       
       
        zhengInfoModel=[[RenZhengInfoModel alloc]init];
        [zhengInfoModel setValuesForKeysWithDictionary:[complate objectAtIndex:0]];
        [progressHUD hide:YES];
        
        self.hidesBottomBarWhenPushed=YES;
        RenZhengViewController *rzVc=[[RenZhengViewController alloc]initWithTitle:@"实名认证" leftButton:@"image/back" rightButton:nil];
        rzVc.model=zhengInfoModel;
        [self.navigationController pushViewController:rzVc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
    } Failed:^(id error) {
        [progressHUD hide:YES];
        if ([error isEqualToString:@"没有认证记录"])
        {
            
           
            [progressHUD hide:YES];
            
            self.hidesBottomBarWhenPushed=YES;
            RenZhengViewController *rzVc=[[RenZhengViewController alloc]initWithTitle:@"实名认证" leftButton:@"image/back" rightButton:nil];
            rzVc.model=nil;
            [self.navigationController pushViewController:rzVc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
//        HWAlertView *message=[[HWAlertView alloc]initWithTitle:(NSString *)error];
//        
//        [message show];
    }];
}
- (IBAction)sfzBtn:(id)sender {
    [self loadRenZhengInfo];
}
@end
