//
//  RecommendViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/17.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "RecommendViewController.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "Model.h"
#import "OrangeLab.h"
#import "AFNetworkingManager.h"
#import "WXApi.h"
@interface RecommendViewController ()
{
    UIView *umView;
    UIView *umBackView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *recommendLab;
@property (weak, nonatomic) IBOutlet OrangeLab *hasPersonLab;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *advImg;
@property (weak, nonatomic) IBOutlet UILabel *banQunLab;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    
    UIView *xiaLaView=[[UIView alloc]initWithFrame:CGRectMake(0, -2*SCREEN_SIZE.height, SCREEN_SIZE.width,2*SCREEN_SIZE.height )];
    xiaLaView.backgroundColor=COLOR_NAV;
    [self.bgScrollerView addSubview:xiaLaView];
    
    [self makeUI];
    [self getAllCount];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
    
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    self.iconImage.layer.masksToBounds=YES;
    self.iconImage.layer.cornerRadius=self.iconImage.width/2;
    
    if ([[NSString stringWithFormat:@"%@",user.Gender] isEqualToString:@"1"])
    {
        self.recommendLab.text=[NSString stringWithFormat:@"你的朋友%@先生，邀请您一起来赚外快：）",[user.Name substringToIndex:1]];
       
    }else
    {
        self.recommendLab.text=[NSString stringWithFormat:@"你的朋友%@女士，邀请您一起来赚外快：）",[user.Name substringToIndex:1]];
    }
    
    
    
    self.recommendBtn.layer.masksToBounds=YES;
    self.recommendBtn.layer.cornerRadius=self.recommendBtn.height/2;
  
    
   //UIImage *adv=[UIImage imageNamed:@"myinviteintro"];
    
    CGSize imageSize=[self.advImg.image size];
    CGFloat bili=imageSize.width/imageSize.height;
    
    self.advImg.width=SCREEN_SIZE.width;
    self.advImg.height=self.advImg.width/bili;
    
    self.banQunLab.y=self.advImg.height+self.advImg.y;
    
    self.bgScrollerView.contentSize=CGSizeMake(0, self.banQunLab.height+self.banQunLab.y+10);
}

-(void)getAllCount
{
    [AFNetworkingManager getAllCountsucceed:^(id complate) {
        NSDictionary *dic=[complate objectAtIndex:0];
        NSString *allcount=[dic objectForKey:@"allcount"];
        
        self.hasPersonLab.orangeSr=allcount;
        self.hasPersonLab.size=@"15";
        self.hasPersonLab.blackSize=@"15";
        self.hasPersonLab.text=[NSString stringWithFormat:@"鱼群中已有%@条小鱼在赚外快",allcount];
    } Failed:^(id error) {
        
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

- (IBAction)recommendBtn:(id)sender {
    [self createUMSocialUI];
//    if ([WXApi isWXAppInstalled]) {
//        //构造SendAuthReq结构体
//        SendAuthReq* req =[[SendAuthReq alloc ] init ];
//        req.scope = @"snsapi_userinfo" ;
//        req.state = @"123" ;
//        //第三方向微信终端发送一个SendAuthReq消息结构
//        [WXApi sendReq:req];
//    }
//    else {
//        
//    }
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
    webObj.webpageUrl = @"http://partner.17yuqun.com/myinvite-796.html";//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

@end
