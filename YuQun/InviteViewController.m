//
//  InviteViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "InviteViewController.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#import "QuestionView.h"
#import "InviteListCell.h"
#import "XuXian.h"
#import "Model.h"
#import "AFNetworkingManager.h"
#import "MJRefresh.h"
#import "HWAlertView.h"
#import "RecommendViewController.h"
#import "WXApi.h"
@interface InviteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *inviteArr;
    UIView *umView;
    UIView *umBackView;
    NSInteger page;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UILabel *biaozhuOne;
@property (weak, nonatomic) IBOutlet UILabel *biaozhuTwo;
@property (weak, nonatomic) IBOutlet UILabel *inviteNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteMoneyNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteMoneyLab;
@property (weak, nonatomic) IBOutlet UITableView *inviteTv;
@property (weak, nonatomic) IBOutlet UILabel *noInviteLab;
@property (weak, nonatomic) IBOutlet UIView *diView;

@property (weak, nonatomic) IBOutlet UIButton *inviteQueBtn;
@end

@implementation InviteViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.bgScrollerView.contentOffset=CGPointMake(0, 0);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUser) name:@"UserHasLogIn" object:nil];
    inviteArr=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=COLOR_BACK;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.inviteTv.delegate=self;
    self.inviteTv.dataSource=self;
    self.inviteTv.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
 
    UIView *xiaLaView=[[UIView alloc]initWithFrame:CGRectMake(0, -2*SCREEN_SIZE.height, SCREEN_SIZE.width,2*SCREEN_SIZE.height-50 )];
    xiaLaView.backgroundColor=COLOR_RBG(35, 95, 162);;
    [self.bgScrollerView addSubview:xiaLaView];
  
    [self xiaLaShuaXin];
    [self shangLa];
    [self makeUI];
    [self getInviteDataWithCurPage:1];
    // Do any additional setup after loading the view from its nib.
}
//-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//    return YES;
//}
-(void)changeUser
{
    page=1;
    [inviteArr removeAllObjects];
    [self getInviteDataWithCurPage:page];
}
-(void)getInviteDataWithCurPage:(NSInteger )curPage
{
    NSString *curpageStr=[NSString stringWithFormat:@"%ld",curPage];
    NSLog(@"%@",curpageStr);
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    [AFNetworkingManager GetUserDirectAgentsSummaryListWithUserID:user.UID curPage:curpageStr pageSize:@"30" succeed:^(id complate) {
        

        if ([[[complate objectAtIndex:0] objectForKey:@"flowlist"] count]==0) {
            
            if ([curpageStr integerValue]>1)
            {

                HWAlertView *alert=[[HWAlertView alloc]initWithTitle:@"没有更多了"];
                [alert show];
                page--;
            }
            
            YaoQingModel *model=[[YaoQingModel alloc]init];
            [model setValuesForKeysWithDictionary:[complate objectAtIndex:0]];
            [self refreshUIWithModel:model];
            
        }else
        {
            YaoQingModel *model=[[YaoQingModel alloc]init];
            [model setValuesForKeysWithDictionary:[complate objectAtIndex:0]];
            [self refreshUIWithModel:model];
            
        }
        
        
        
        [self.bgScrollerView.mj_footer endRefreshing];
        [self.bgScrollerView.mj_header endRefreshing];
    } Failed:^(id error) {
        HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
        page--;
        [alert show];
        [self.bgScrollerView.mj_footer endRefreshing];
        [self.bgScrollerView.mj_header endRefreshing];
    }];
}

-(void)refreshUIWithModel:(YaoQingModel *)model
{
    self.inviteNumLab.text=model.myyaoqingnum;
    self.inviteMoneyNumLab.text=[NSString stringWithFormat:@"￥%@",model.totalmoney];
    
    
    NSArray *arr=model.flowlist;
 
    for (NSDictionary *dic in arr)
    {
        YaoQingListModel *yaoQingListModel=[[YaoQingListModel alloc]init];
        [yaoQingListModel setValuesForKeysWithDictionary:dic];
        [inviteArr addObject:yaoQingListModel];
        
    }
    [self makeUI];
    
}
-(void)makeUI
{
    
    
    CGSize size=[self.titleImg .image size];
    CGFloat biLi=size.width/size.height;
    self.titleImg.height=SCREEN_SIZE.width/biLi;
    self.titleImg.y=self.titleView.height;
    
    
//    self.inviteQueBtn.y=self.titleImg.height+self.titleImg.y-30;
    
    self.inviteQueBtn.layer.masksToBounds=YES;
    self.inviteQueBtn.layer.cornerRadius=self.inviteQueBtn.height/2;
    
    self.diView.y=self.titleImg.height+self.titleImg.y;
    
    self.inviteBtn.y=self.diView.height+self.diView.y+20;
    self.inviteBtn.layer.masksToBounds=YES;
    self.inviteBtn.layer.cornerRadius=self.inviteBtn.height/2;

    
    self.biaozhuOne.y=self.inviteBtn.y+self.inviteBtn.height+10;
    self.biaozhuTwo.y=self.biaozhuOne.y+self.biaozhuOne.height;
    
    
    self.inviteNumLab.frame=CGRectMake(0, self.biaozhuTwo.y+self.biaozhuTwo.height+30, SCREEN_SIZE.width/2, 20);
    self.inviteMoneyNumLab.frame=CGRectMake(SCREEN_SIZE.width/2, self.biaozhuTwo.y+self.biaozhuTwo.height+30, SCREEN_SIZE.width/2, 20);
    
    self.inviteLab.frame=CGRectMake(0, self.inviteNumLab.y+self.inviteNumLab.height+5, SCREEN_SIZE.width/2, 20);
    self.inviteMoneyLab.frame=CGRectMake(SCREEN_SIZE.width/2, self.inviteMoneyNumLab.y+self.inviteMoneyNumLab.height+5, SCREEN_SIZE.width/2, 20);
    
    UIView *shuView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2, self.inviteNumLab.y,0.5, self.inviteNumLab.height+self.inviteLab.height)];
    shuView.backgroundColor=COLOR_TEXTWHITE;
    [self.bgScrollerView addSubview:shuView];
    
    
    
   
    UILabel *label=[[UILabel alloc]init];
    label.text=@"我邀请的朋友";
    label.textColor=COLOR_TEXTWHITE;
    label.font=[UIFont systemFontOfSize:14];
    CGFloat width=[self widthForText:label.text Font:14];
    label.frame=CGRectMake((SCREEN_SIZE.width-width)/2,self.inviteMoneyLab.y+self.inviteMoneyLab.height+20, width, 20);
    [self.bgScrollerView addSubview:label];
    
    XuXian *zuoLine=[[XuXian alloc]initWithFrame:CGRectMake(10, label.y+label.height/2, (SCREEN_SIZE.width-width-40)/2, 0.5)];
    //zuoLine.backgroundColor=[UIColor grayColor];
    [self.bgScrollerView addSubview:zuoLine];
    
    XuXian *youLine=[[XuXian alloc]initWithFrame:CGRectMake(label.x+label.width+10, label.y+label.height/2, (SCREEN_SIZE.width-width-40)/2, 0.5)];
   // youLine.backgroundColor=[UIColor grayColor];
    [self.bgScrollerView addSubview:youLine];

    
    
    self.inviteTv.frame=CGRectMake(0, label.y+label.height+10, SCREEN_SIZE.width, [inviteArr count]*44);
    [self.inviteTv reloadData];
    if ([inviteArr count]==0)
    {
        self.noInviteLab.hidden=NO;
        self.noInviteLab.y=self.inviteTv.y;
        self.bgScrollerView.contentSize=CGSizeMake(0, self.self.noInviteLab.y+self.noInviteLab.height+10);
    }else
    {
        self.noInviteLab.hidden=YES;
        self.bgScrollerView.contentSize=CGSizeMake(0, self.inviteTv.y+self.inviteTv.height);
    }
    
    
}


#pragma mark-下拉刷新
-(void)xiaLaShuaXin
{
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [inviteArr removeAllObjects];
        [self getInviteDataWithCurPage:page];
    }];
    
    self.bgScrollerView.mj_header=header;
    self.bgScrollerView.mj_header.backgroundColor=COLOR_RBG(35, 95, 162);
    header.arrowView.image=[UIImage imageNamed:@"xiaLa"];
//    header.loadingView.color=COLOR_RBG(122, 159, 196);
    header.stateLabel.textColor = COLOR_RBG(122, 159, 196);
    header.lastUpdatedTimeLabel.textColor = COLOR_RBG(122, 159, 196);
    
    
    
   
    
}
-(void)shangLa
{
    
  __weak __typeof(self) weakSelf = self;
    weakSelf.bgScrollerView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self getInviteDataWithCurPage:page];
        
    }];
    // 设置了底部inset
    self.bgScrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.bgScrollerView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [inviteArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    InviteListCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"InviteListCell" owner:self options:nil] lastObject];
    if (cell==nil) {
        cell=[[InviteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
  
    YaoQingListModel *model=[inviteArr objectAtIndex:indexPath.row];
    
    cell.inviteNameLab.text=[NSString stringWithFormat:@"%@**(%@)",[model.Name substringToIndex:1],[NSString stringWithFormat:@"%@*****%@",[model.Tel substringToIndex:3],[model.Tel substringFromIndex:8]]];
    
    
    cell.inviteTimeLab.text=model.RegDate;
    
    cell.inviteMoneyLab.redStr=[NSString stringWithFormat:@"￥%@",model.BounsMoney];
    cell.inviteMoneyLab.size=@"15";
    cell.inviteMoneyLab.blackSize=@"15";
    cell.inviteMoneyLab.text=[NSString stringWithFormat:@"Ta的奖金：￥%@",model.BounsMoney];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUMSocialUI{
    if (umView == nil) {
        umBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_SIZE.width, SCREEN_SIZE.height)];
        umBackView.userInteractionEnabled=YES;
        umBackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        [self.tabBarController.view addSubview:umBackView];
        
        umView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 120)];
        umView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0.5)];
        lineView.backgroundColor=COLOR_TEXTWHITE;
        [umView addSubview:lineView];
        
        
        
        [umBackView addSubview:umView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, SCREEN_SIZE.width, 20)];
        label.text = @"分享到微信";
        label.textColor=[UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [umView addSubview:label];
        
        //创建两个button 一个是朋友圈，一个是微信好友
        //        NSArray *arrTitle = @[@"好友",@"朋友圈"];
        for (int i = 0; i < 2; i++) {
            UIButton *sBut = [UIButton buttonWithType:UIButtonTypeCustom];
            UILabel *label=[[UILabel alloc]init];
            label.font=[UIFont systemFontOfSize:12];
            label.textColor=[UIColor blackColor];
            label.textAlignment=NSTextAlignmentCenter;
            
            
            //            [sBut setTitle:arrTitle[i] forState:UIControlStateNormal];
            if (i==0)
            {
                
                sBut.frame = CGRectMake(SCREEN_SIZE.width/2-20-64, 36, 64, 64);
                
                [sBut setBackgroundImage:[UIImage imageNamed:@"wxhy"] forState:UIControlStateNormal];
                label.frame=CGRectMake(SCREEN_SIZE.width/2-20-64, 100, 64, 20);
                label.text=@"好友";
            }
            if(i==1)
            {
                sBut.frame = CGRectMake(SCREEN_SIZE.width/2+20, 36, 64, 64);
                [sBut setBackgroundImage:[UIImage imageNamed:@"pyq"] forState:UIControlStateNormal];
                label.frame=CGRectMake(SCREEN_SIZE.width/2+20, 100, 64, 20);
                label.text=@"朋友圈";
            }
            
            //            sBut.layer.masksToBounds = YES;
            //            sBut.layer.cornerRadius = 10.0f;
            sBut.tag = 900 + i;
            [sBut addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
            [umView addSubview:sBut];
            [umView addSubview:label];
        }
        [UIView animateWithDuration:0.5 animations:^{
            umView.frame = CGRectMake(0, SCREEN_SIZE.height- 120, SCREEN_SIZE.width, 120);
        }];
        
    }
    
    [self createTapGesture];
}

-(void)createTapGesture
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    [umBackView addGestureRecognizer:tapGesture];
}



-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (umView.frame.origin.y<SCREEN_SIZE.height)
    {
        [UIView animateWithDuration:0.5 animations:^{
            umView.frame = CGRectMake(0, SCREEN_SIZE.height+ 120, SCREEN_SIZE.width, 120);
            umView=nil;
            umBackView.alpha=0;
            [umBackView removeFromSuperview];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}




- (void)shareBtn:(UIButton *)sender {
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    //0 = 好友列表 1 = 朋友圈 2 = 收藏
    if (sender.tag==900)
    {
        sendReq.scene = 0;
    }else
    {
        sendReq.scene = 1;
    }
    
    
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = [NSString stringWithFormat:@"你的朋友%@先生，邀请您一起来赚外快：）",[user.Name substringToIndex:1]];//分享标题
    urlMessage.description = @"鱼群诚邀您来注册，轻松赚外快";//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"LOGO_Public"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl =[NSString stringWithFormat:@"http://partner.17yuqun.com/myinvite-%@.html",user.UID];//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)inviteQueBtn:(id)sender {
    QuestionView *questionV=[[QuestionView alloc]initWithTitle:@"邀请朋友问答"];
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:questionV];
    
}
- (IBAction)inviteBtn:(id)sender {

    [self createUMSocialUI];
}

-(CGFloat)widthForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    
    return textSize.width;
}

@end
