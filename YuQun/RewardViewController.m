//
//  RewardViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "RewardViewController.h"
#import "AHeader.h"
#import "CellForreward.h"
#import "XuXian.h"
#import "AFNetworkingManager.h"
#import "Model.h"
#import "TiXianWenDa.h"
#import "HWAlertView.h"
#import "WXApi.h"
#import "UIView+MJ.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
@interface RewardViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    
    NSMutableArray * jiangjinliushuiArr;
    UILabel * moneyLab;
    UILabel * leijiLab;
    UITextField * jinerText;
    NSInteger page;
    NSString * yuE;
     MBProgressHUD * progressHUD;
    
}

@end

@implementation RewardViewController


-(void)viewWillAppear:(BOOL)animated
{
    _tableView.contentOffset=CGPointMake(0, 0);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view from its nib.
    page=1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_BACK;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUser) name:@"UserHasLogIn" object:nil];
    
    jiangjinliushuiArr =[NSMutableArray arrayWithCapacity:0];
    
    
    if (!_tableView)
    {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height  - 49) style:UITableViewStyleGrouped];
    }
    
    _tableView.backgroundColor=COLOR_BACK;
    _tableView.dataSource = self;
    _tableView.delegate  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CellForreward" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = [self viewForTable];
    
    UIView *xiaLaView=[[UIView alloc]initWithFrame:CGRectMake(0, -2*SCREEN_SIZE.height, SCREEN_SIZE.width,2*SCREEN_SIZE.height-50 )];
    xiaLaView.backgroundColor=COLOR_NAV;
    [_tableView addSubview:xiaLaView];
    
     [self getJiangjin];
    [self loadRewaedDataWithPage:page];

    [self xiaLaShuaXin];
    [self shangLa];
    [self createTapGesture];
}


- (void)createTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tapGesture];
    
}
-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
    }];
}

-(void)xiaLaShuaXin
{


      MJRefreshNormalHeader*header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
         page=1;
         [self loadRewaedDataWithPage:page];
         [self getJiangjin];
     }];

    _tableView.mj_header=header;
    _tableView.mj_header.backgroundColor=COLOR_NAV;
    
    header.arrowView.image=[UIImage imageNamed:@"xiaLa"];
//    header.loadingView.color=COLOR_RBG(122, 159, 196);
    header.stateLabel.textColor = COLOR_RBG(122, 159, 196);
    header.lastUpdatedTimeLabel.textColor = COLOR_RBG(122, 159, 196);
    
}
-(void)shangLa
{
    
   
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadRewaedDataWithPage:page];
        
    }];
    
    
//    // 设置了底部inset
   _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    // 忽略掉底部inset
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
    
    
}


-(void)getJiangjin
{
    UserLogin *aUser=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager getJiangjinWithUserID:aUser.UID succeed:^(id complate) {
        
        moneyLab.text =[NSString stringWithFormat:@"￥%@",[complate[0] objectForKey:@"myMoney"]];
        leijiLab.text = [NSString stringWithFormat:@"昨日奖金￥%@   累积奖金￥%@",[complate[0] objectForKey:@"yesterdayMoney"],[complate[0] objectForKey:@"leiJiMoney"]];
        
        yuE =[complate[0] objectForKey:@"myMoney"];
        
    } Failed:^(id error) {
        
        NSLog(@">>>>>>>>%@",error);
        
    }];

}

-(void)changeUser
{
    [self getJiangjin];
    page=1;
    [jiangjinliushuiArr removeAllObjects];
    [self loadRewaedDataWithPage:page];
}
-(void)loadRewaedDataWithPage:(NSInteger)curePage
{
    UserLogin *aUser=[UserLogin shareUserWithData:nil];
    NSString *pag=[NSString stringWithFormat:@"%ld",curePage];
    [AFNetworkingManager getjiangjinliushuiWithpageSize:@"20" curPage:pag userID:aUser.UID succeed:^(id complate) {
        
        if (curePage==1)
        {
            [jiangjinliushuiArr removeAllObjects];
        }
        for (NSDictionary * dic in complate)
        {
            JiangjinLiushui * jiangliM =[[JiangjinLiushui alloc]init];
            [jiangliM setValuesForKeysWithDictionary:dic];
            [jiangjinliushuiArr addObject:jiangliM];
        }
        
        [_tableView reloadData];
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
//        _tableView.mj_footer.hidden = YES;
    } Failed:^(id error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        page--;

        HWAlertView *alert=[[HWAlertView alloc]initWithTitle:(NSString *)error];
        [alert show];
    }];

}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForreward * cell =(CellForreward *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    JiangjinLiushui * aModel =[jiangjinliushuiArr objectAtIndex:indexPath.row];
    
    
    cell.titleLab.text = aModel.TaskTitle;
    cell.timeLab.text = aModel.OccurredDate;
    
    
    if ([aModel.FundsType integerValue] == 3||[aModel.FundsType integerValue] == 4||[aModel.FundsType integerValue] == 7)
    {
        cell.moneyLab.text = [NSString stringWithFormat:@"-￥%@",aModel.AmountMoneyStr ];
        cell.moneyLab.textColor=COLOR_RBG(57, 138, 83);
    }
    else
    {
        cell.moneyLab.text = [NSString stringWithFormat:@"+￥%@",aModel.AmountMoneyStr];
        cell.moneyLab.textColor=[UIColor redColor];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jiangjinliushuiArr count];
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   
//}

-(void)yiwenBtnClick:(UIButton *)sender
{
    [AFNetworkingManager gettixianwendasucceed:^(id complate) {
        
        TiXianWenDa * wendaV =[[TiXianWenDa alloc]initWithInfo:complate];
        [wendaV show];
        
    } Failed:^(id error) {
        
        NSLog(@">>>>>>>%@",error);
        
    }];
}

-(void)tixianBtnClick:(UIButton *)sender
{
    
    
    
    //    //构造SendAuthReq结构体
    //    SendAuthReq* req =[[SendAuthReq alloc ]init];
    //    req.scope = @"snsapi_userinfo" ;
    //    req.state = @"123" ;
    //    //第三方向微信终端发送一个SendAuthReq消息结构
    //    [WXApi sendReq:req];
    //    return;
    
    
    
    NSString *phoneRegex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    BOOL isValid = [predicate evaluateWithObject:jinerText.text];
    UserLogin * aUser =[UserLogin shareUserWithData:nil];
    if ([aUser.WeiXinID length] > 0)
    {
        if ([jinerText.text floatValue] < 0||!isValid)
        {
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"请输入正确的提现金额！"];
            [alert show];
        }
        else if ([jinerText.text floatValue] > [yuE floatValue])
        {
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"提现金额不能超过当前账户余额！"];
            [alert show];
        }
        else
        {
            NSLog(@"tixian");
            //风火轮
            progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           
            progressHUD.dimBackground = NO;
            
            [AFNetworkingManager tixianWithUserID:aUser.UID userTel:aUser.Tel weixinid:aUser.WeiXinID money:jinerText.text succeed:^(id complate)
             {
                 [progressHUD hide:YES];
                 //刷新页面
                 page=1;
                 [jiangjinliushuiArr removeAllObjects];
                 [self loadRewaedDataWithPage:page];
                 [self getJiangjin];
                 
                 HWAlertView *mess=[[HWAlertView alloc]initWithTitle:@"恭喜你，提现成功！"];
                 [mess show];
                 jinerText.text=@"";
                 
             } Failed:^(id error) {
                 
                 [progressHUD hide:YES];
                 HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
                 [alert show];
             }];
            
        }
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"您尚未关注鱼群公众号！" message:@"用户提现需要关注鱼群公众号。进入微信关注公众账号：鱼客之家。第一次提现请在微信公众账号内进行，请按照提示给出的步骤进行提现，否则您可能无法提现。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 7000;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag != 7000)
//    {
//        if (buttonIndex == 1)
//        {
////            if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi])
////            {
////                //构造SendAuthReq结构体
////                SendAuthReq* req =[[SendAuthReq alloc ]init];
////                req.scope = @"snsapi_userinfo" ;
////                req.state = @"123" ;
////                //第三方向微信终端发送一个SendAuthReq消息结构
////                [WXApi sendReq:req];
////            }
//            else
//            {
//                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"调起微信登录失败！" message:@"您尚未安装微信或您当前的微信版本不支持该功能！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        }
//    }
    
}
#pragma mark -


-(UIView *)viewForTable
{
    UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 480)];
    backV.backgroundColor = COLOR_BACK;
    
    UIView * topV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 230)];
    topV.backgroundColor =COLOR_LAN;
    [backV addSubview:topV];
    
    UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(8, 60, SCREEN_SIZE.width - 16, 30)];
    titleLab.text = @"我的奖金";
    titleLab.font =[UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor =[UIColor whiteColor];
    [topV addSubview:titleLab];
    
    moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(8, 100, SCREEN_SIZE.width - 16, 40)];
    moneyLab.text = @"￥0.00";
    moneyLab.font =[UIFont boldSystemFontOfSize:40];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.textColor =[UIColor whiteColor];
    [topV addSubview:moneyLab];
    
    
    leijiLab =[[UILabel alloc]initWithFrame:CGRectMake(8, 140, SCREEN_SIZE.width - 16, 40)];
    leijiLab.text = [NSString stringWithFormat:@"昨日奖金￥%@   累积奖金￥%@",@"0.00",@"0.00"];
    leijiLab.font =[UIFont systemFontOfSize:14];
    leijiLab.textAlignment = NSTextAlignmentCenter;
    leijiLab.textColor =COLOR_RBG(122, 159, 196);
    [topV addSubview:leijiLab];
    
    
    UIButton * yiwenBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    yiwenBtn.frame = CGRectMake(SCREEN_SIZE.width - 88, topV.frame.size.height - 30, 80, 18);
    yiwenBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    [yiwenBtn setTitle:@"提现问答" forState:UIControlStateNormal];
    //    yiwenBtn.titleLabel.textColor =COLOR_LAN;// COLOR_RBG(10, 106, 165);
    
    [yiwenBtn setTitleColor:COLOR_LAN forState:UIControlStateNormal];
    yiwenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    yiwenBtn.backgroundColor =COLOR_RBG(122, 159, 196);
    yiwenBtn.clipsToBounds = YES;
    yiwenBtn.layer.cornerRadius = 9;
    [yiwenBtn addTarget:self action:@selector(yiwenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:yiwenBtn];
    
    UIView * footV =[[UIView alloc]initWithFrame:CGRectMake(0, 230, SCREEN_SIZE.width, backV.frame.size.height - topV.frame.size.height)];
    footV.backgroundColor =COLOR_BACK;
    [backV addSubview:footV];
    
    UILabel * tishiLab =[[UILabel alloc]initWithFrame:CGRectMake(8, 20, SCREEN_SIZE.width - 16, 20)];
    tishiLab.text = @"提现奖金将汇入到您的奖金账户";
    tishiLab.font =[UIFont systemFontOfSize:13];
    tishiLab.textColor = COLOR_LAN;
    tishiLab.textAlignment = NSTextAlignmentCenter;
    [footV addSubview:tishiLab];
    
    UIView *moneyV =[[UIView alloc]initWithFrame:CGRectMake(25, 60, SCREEN_SIZE.width - 50, 45)];
    moneyV.backgroundColor =[UIColor whiteColor];
    moneyV.clipsToBounds = YES;
    moneyV.layer.cornerRadius = 22.5;
    moneyV.layer.borderColor =[UIColor lightGrayColor].CGColor;
    moneyV.layer.borderWidth = 1;
    
    [footV addSubview:moneyV];
    
    UILabel * jinerLab =[[UILabel alloc]initWithFrame:CGRectMake(20, 12.5, 80, 20)];
    jinerLab.textColor = COLOR_TEXTWHITE;
    jinerLab.text = @"提现金额：";
    jinerLab.font =[UIFont systemFontOfSize:15];
    [moneyV addSubview:jinerLab];
    
    if (!jinerText) {
         jinerText =[[UITextField alloc]initWithFrame:CGRectMake(100, 10, SCREEN_SIZE.width - 108, 25)];
    }
    jinerText.placeholder = @"0.00";
    jinerText.font =[UIFont systemFontOfSize:33];
    jinerText.tintColor = COLOR_CHENG;
    [jinerText setValue:COLOR_CHENG
             forKeyPath:@"_placeholderLabel.textColor"];
    jinerText.textColor=COLOR_CHENG;
    jinerText.delegate=self;
    jinerText.keyboardType = UIKeyboardTypeNumberPad;
    [moneyV addSubview:jinerText];
    
    UIButton * tixianBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    tixianBtn.frame = CGRectMake(25, 120, SCREEN_SIZE.width - 50, 45);
    tixianBtn.backgroundColor =COLOR_CHENG;
    [tixianBtn setTitle:@"立即提现" forState:UIControlStateNormal];
    [tixianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tixianBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    tixianBtn.clipsToBounds = YES;
    tixianBtn.layer.cornerRadius = 22.5;
    [tixianBtn addTarget:self action:@selector(tixianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:tixianBtn];
    
    
    UILabel *zhuYiLab=[[UILabel alloc]initWithFrame:CGRectMake(0, tixianBtn.y+10+tixianBtn.height, SCREEN_SIZE.width, 20)];
    zhuYiLab.text=@"注意：提现请提整数，小数会导致提现失败";
    zhuYiLab.textAlignment=NSTextAlignmentCenter;
    zhuYiLab.textColor=COLOR_ORANGE;
    zhuYiLab.font=[UIFont systemFontOfSize:13];
    [footV addSubview:zhuYiLab];
    
    UILabel * liushuiLab =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 50, 220, 100, 20)];
    liushuiLab.textAlignment =NSTextAlignmentCenter;
    liushuiLab.text = @"我的奖金流水";
    liushuiLab.textColor =[UIColor lightGrayColor];
    liushuiLab.font =[UIFont systemFontOfSize:15];
    [footV addSubview:liushuiLab];
    
    XuXian * xunxianOne =[[XuXian alloc]initWithFrame:CGRectMake(0, liushuiLab.frame.origin.y + liushuiLab.frame.size.height/2, SCREEN_SIZE.width/2 - 60, 1.0f)];
   // xunxianOne.backgroundColor =[UIColor grayColor];
    [footV addSubview:xunxianOne];
    
    
    XuXian * xunxianTwo =[[XuXian alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 + 60, liushuiLab.frame.origin.y + liushuiLab.frame.size.height/2, SCREEN_SIZE.width/2 - 60, 1.0f)];
 //   xunxianTwo.backgroundColor =[UIColor grayColor];
    [footV addSubview:xunxianTwo];
    
    
    return backV;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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




-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
