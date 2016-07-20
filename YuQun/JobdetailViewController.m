//
//  JobdetailViewController.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/14.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "JobdetailViewController.h"
#import "AHeader.h"
#import "AFNetworkingManager.h"
#import "HWAlertView.h"
#import "ShowWebViewController.h"
#import "WXApi.h"
#import "UIView+MJ.h"
#import "ImageCell.h"
#import "TZImagePickerController.h"
#import "ImageViewController.h"
#import "Baozhengjinshuoming.h"
#import "ZhiFuViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ShowPhotoView.h"
#import "MBProgressHUD.h"
#import "RenZhengViewController.h"


@interface JobdetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,ImageViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UITableView * _tableView;
    JobInfo * _jobModel;
    
    YijieRenWu * _yijierenwuM;
    
    UIWebView * _WebView;
    
    UILabel *daojishiTwo;
    
    NSTimer * timer;
    
    UIView * bbbbV ;
    
    UIButton *imgChooseBtn;
    
    NSInteger typeAndCount;
    
    NSString * orderID;
    
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    
    NSString * _jobState;
    
    NSArray * _jietuArr;
    
    MBProgressHUD * progressHUD;
    
//    UILabel * titleLabel;
    RenZhengInfoModel *zhengInfoModel;

    NSString *urlToSave;
}

@end

@implementation JobdetailViewController


-(void)dealloc
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
}


-(void)loadData
{
    if (_jobType == 0)
    {
        //风火轮
        progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    progressHUD.labelText = @"正在生成订单，请耐心等待";
        progressHUD.dimBackground = NO;
        
        
        UserLogin * aUser =[UserLogin shareUserWithData:nil];
        
        [AFNetworkingManager getJobDetailWithTaskID:_taskID UserID:aUser.UID succeed:^(id complate) {
            if (!_jobModel) {
                _jobModel =[[JobInfo alloc]init];
            }
            [_jobModel setValuesForKeysWithDictionary:complate[0][0]];
            _jobState =[complate objectAtIndex:1];
            
            UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
            backV.backgroundColor =COLOR_LAN;
            
            _WebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
   
            _WebView.scrollView.scrollEnabled = NO;
            [_WebView loadHTMLString:[NSString stringWithFormat:@"%@<body>%@</body>",@"<head><meta http-equiv=\"Content-Type\" content=\"textml; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\" /><meta name=\"MobileOptimized\" content=\"240\" /><meta name=\"format-detection\" content=\"telephone=no\" /><style>img {width: 100%;height: inherit;}</style></head>",_jobModel.Content] baseURL:nil];
            _WebView.userInteractionEnabled = YES;
            _WebView.delegate = self;
            
            UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            longPressed.delegate=self;
            [_WebView addGestureRecognizer:longPressed];
            [backV addSubview:_WebView];
            
            [self.view addSubview:backV];
        } Failed:^(id error) {
            [progressHUD hide:YES];
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
            [alert show];
        }];
    }
    else
    {
        //风火轮
        progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    progressHUD.labelText = @"正在生成订单，请耐心等待";
        progressHUD.dimBackground = NO;
        
        [AFNetworkingManager getMyJobDetailWithOrderID:[_yijiejobM.OID stringValue] succeed:^(id complate) {
            
            if (!_jobModel) {
                _jobModel =[[JobInfo alloc]init];
            }
            [_jobModel setValuesForKeysWithDictionary:[complate[0] objectForKey:@"TaskInfo"]];
            
            if (!_yijierenwuM) {
                _yijierenwuM =[[YijieRenWu alloc]init];
            }
            [_yijierenwuM setValuesForKeysWithDictionary:complate[0]];
            
            UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
            backV.backgroundColor =COLOR_LAN;
            
            _WebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
     
            _WebView.scrollView.scrollEnabled = NO;
            [_WebView loadHTMLString:[NSString stringWithFormat:@"%@<body>%@</body>",@"<head><meta http-equiv=\"Content-Type\" content=\"textml; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\" /><meta name=\"MobileOptimized\" content=\"240\" /><meta name=\"format-detection\" content=\"telephone=no\" /><style>img {width: 100%;height: inherit;}</style></head>",_jobModel.Content] baseURL:nil];
            _WebView.userInteractionEnabled = YES;
            _WebView.delegate = self;
            UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            [_WebView addGestureRecognizer:longPressed];
            [backV addSubview:_WebView];
            
            [self.view addSubview:backV];
            
        } Failed:^(id error) {
            
            [progressHUD hide:YES];
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
            [alert show];
            
        }];
    }

}

- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    
    CGPoint touchPoint = [recognizer locationInView:_WebView];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    urlToSave = [_WebView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    [self showImageOptions];
    
}

- (void)showImageOptions
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存储图像",@"转发朋友圈", nil];
    sheet.tag=1234;
    [sheet showInView:self.navigationController.view];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
    }else{
        
    }
}



-(void)lianjieBtnCLick:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    ShowWebViewController * showVC =[[ShowWebViewController alloc]initWithTitle:@"" leftButton:@"image/back" rightButton:@"text/分享"];
    showVC.link = _jobModel.Link;
    [self.navigationController pushViewController:showVC animated:YES];
}

#pragma mark  - UITableViewDataSource

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_SIZE.width - 30, 20)];
        titleLab.text = @"完成标准";
//        titleLab.textColor =COLOR_RBG(28, 94, 191);
        titleLab.textColor = COLOR_LAN;
        titleLab.font =[UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
        
        CGSize size =[self sizeForText:_jobModel.FinlishStandard Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        
        UILabel * detailLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_SIZE.width - 30, size.height)];
        detailLab.font =[UIFont systemFontOfSize:15];
        detailLab.text =_jobModel.FinlishStandard;
        detailLab.numberOfLines =0;
        detailLab.lineBreakMode = NSLineBreakByWordWrapping;
        
        [cell.contentView addSubview:detailLab];
    }
    else if ([_jobModel.DepositStr length] > 0&&_tableView.numberOfSections == indexPath.section +1&&[_jobModel.DepositStr intValue] > 0)
    {
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_SIZE.width - 30, 20)];
        titleLab.text = @"任务保证金";
        titleLab.textColor =COLOR_LAN;
        titleLab.font =[UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
        
        CGSize size =[self sizeForText:[NSString stringWithFormat:@"￥%@",_jobModel.DepositStr] Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:17];
        
        
        UILabel * detailLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 40, 185, size.height)];
        detailLab.font =[UIFont systemFontOfSize:15];
        detailLab.text =@"接本单任务需要支付保证金:";
        
        [cell.contentView addSubview:detailLab];
        
        UILabel * moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(detailLab.frame.origin.x + detailLab.frame.size.width, detailLab.frame.origin.y, size.width, size.height)];
        moneyLab.text = [NSString stringWithFormat:@"￥%@",_jobModel.DepositStr];
        
        moneyLab.textColor  = COLOR_CHENG;
        [cell.contentView addSubview:moneyLab];
        
        
        UIButton * baozhengjinBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        baozhengjinBtn.frame = CGRectMake(SCREEN_SIZE.width - 118, 0, 110, 30);
        
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:@"任务保证金说明"];
                NSRange contentRange = {0,[content length]};
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                [content addAttribute:NSStrokeColorAttributeName value:[UIColor lightGrayColor] range:contentRange];
        
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:contentRange];
        
//        baozhengjinBtn.titleLabel.attributedText = content;
        [baozhengjinBtn setAttributedTitle:content forState:UIControlStateNormal];
        [baozhengjinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        baozhengjinBtn.titleLabel.textColor =[UIColor lightGrayColor];
//        [baozhengjinBtn seta];
        [baozhengjinBtn addTarget:self action:@selector(baozhengjinshuomingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        baozhengjinBtn.backgroundColor =[UIColor redColor];
        [cell.contentView addSubview:baozhengjinBtn];
        
    }
    
    else if (indexPath.section == 1 &&[_jobModel.Link length]>0)
    {
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_SIZE.width - 30, 20)];
        titleLab.text = @"任务链接";
        titleLab.textColor =COLOR_LAN;
        titleLab.font =[UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
        
        CGSize size =[self sizeForText:_jobModel.Link Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        UILabel * detailLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 30, SCREEN_SIZE.width - 30, size.height)];

        detailLab.font =[UIFont systemFontOfSize:15];
        detailLab.text = _jobModel.Link;
        detailLab.textColor = COLOR_LAN;
        detailLab.numberOfLines = 0;
        detailLab.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.contentView addSubview:detailLab];
        
        UIButton * lianjieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lianjieBtn.frame = detailLab.frame;
        [lianjieBtn addTarget:self action:@selector(lianjieBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:lianjieBtn];
    }
    else if (_jobType == 3)
    {
        UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_SIZE.width - 30, 20)];
        titleLab.text = @"审核的反馈";
        titleLab.textColor =COLOR_LAN;
        titleLab.font =[UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
        
        CGSize size =[self sizeForText:_yijierenwuM.OrderBack Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];

        UILabel * detailLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_SIZE.width - 30, size.height)];
        detailLab.font =[UIFont systemFontOfSize:15];
        detailLab.text =_yijierenwuM.OrderBack;
        
        [cell.contentView addSubview:detailLab];
     
    }
    else if (_jobType == 4)
    {
        UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_SIZE.width - 30, 20)];
        titleLab.text = @"失败的原因";
        titleLab.textColor =COLOR_LAN;
        titleLab.font =[UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
        
        CGSize size =[self sizeForText:_yijierenwuM.OrderBack Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        
        UILabel * detailLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_SIZE.width - 30, size.height)];
        detailLab.font =[UIFont systemFontOfSize:15];
        detailLab.text =_yijierenwuM.OrderBack;
        
        [cell.contentView addSubview:detailLab];
        
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    
    if ([_jobModel.Link length] > 0)
    {
        count+=1;
    }
    
    if (_jobType == 3||_jobType == 4)
    {
        count +=1;
    }
    
    if ([_jobModel.DepositStr length] > 0&&[_jobModel.DepositStr intValue]> 0)
    {
        count +=1;
    }
    
    return count;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CGSize size =[self sizeForText:_jobModel.FinlishStandard Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        
        return 40+ size.height+ 10;
    }
    else if(indexPath.section == 1&&[_jobModel.Link length]>0)
    {
        CGSize size =[self sizeForText:_jobModel.Link Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        
        
        return 40+ size.height+ 10;
    }
    else if(_jobType == 3||_jobType == 4)
    {
        CGSize size =[self sizeForText:_yijierenwuM.OrderBack Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        return 30+ size.height+ 20;
    }
    else if ([_jobModel.DepositStr length] > 0&&_tableView.numberOfSections == indexPath.section +1)
    {
        CGSize size =[self sizeForText:_jobModel.DepositStr Width:SCREEN_SIZE.width - 30 Height:MAXFLOAT Font:15];
        return 30+ size.height+ 20;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView * )viewForTableViewFooter
{
    UIView * backV =[[UIView alloc]init];
    backV.backgroundColor =COLOR_BACK;
    
    
    CGSize sizeOne =[self sizeForText:@"有" Width:SCREEN_SIZE.width Height:20 Font:15];
    CGSize renOne =[self sizeForText:[_jobModel.TaskAcceptNum stringValue] Width:SCREEN_SIZE.width Height:20 Font:15];
    NSInteger shengyuCount =[_jobModel.TaskPersonLimit integerValue] -[_jobModel.TaskAcceptNum integerValue];
    
    CGSize renTwo =[self sizeForText:[NSString stringWithFormat:@"%ld",shengyuCount] Width:SCREEN_SIZE.width Height:20 Font:15];
    
    UILabel * labOne =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - sizeOne.width*9/2 - renOne.width/2 -renTwo.width/2 , 15, sizeOne.width*2, 20)];
    labOne.text = @"已有";
    labOne.textColor = [UIColor lightGrayColor];
    labOne.font =[UIFont systemFontOfSize:15];
    [backV addSubview:labOne];
    
    UILabel * labTwo =[[UILabel alloc]initWithFrame:CGRectMake(labOne.frame.size.width + labOne.frame.origin.x, 15, renOne.width+sizeOne.width, 20)];
    labTwo.text =[NSString stringWithFormat:@"%@人",[_jobModel.TaskAcceptNum stringValue]];
    labTwo.textColor = COLOR_CHENG;
    labTwo.font =[UIFont systemFontOfSize:15];
    [backV addSubview:labTwo];
    
    UILabel * labThree =[[UILabel alloc]initWithFrame:CGRectMake(labTwo.frame.size.width + labTwo.frame.origin.x, 15, sizeOne.width*5, 20)];
    labThree.text =@"接单，还剩";
    labThree.textColor = [UIColor lightGrayColor];
    labThree.font =[UIFont systemFontOfSize:15];
    [backV addSubview:labThree];
    
    UILabel * labFour =[[UILabel alloc]initWithFrame:CGRectMake(labThree.frame.size.width + labThree.frame.origin.x, 15, renTwo.width, 20)];
    labFour.text =[NSString stringWithFormat:@"%ld",shengyuCount];
    labFour.textColor = COLOR_CHENG;
    labFour.font =[UIFont systemFontOfSize:15];
    [backV addSubview:labFour];
    
    UILabel * labFive =[[UILabel alloc]initWithFrame:CGRectMake(labFour.frame.size.width + labFour.frame.origin.x, 15, sizeOne.width, 20)];
    labFive.font =[UIFont systemFontOfSize:15];
    labFive.text =@"单";
    labFive.textColor = [UIColor lightGrayColor];
    
    [backV addSubview:labFive];
    
    switch (_jobType) {
        case 0:{
            //
            
            UserLogin * aUser =[UserLogin shareUserWithData:nil];
            if ([_jobModel.AuthLimit integerValue] == 1&&[aUser.passAuthentication integerValue] != 1)
            {
                backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 250);
                labOne.frame = CGRectMake(SCREEN_SIZE.width/2 - sizeOne.width*9/2 - renOne.width/2 -renTwo.width/2 , 75, sizeOne.width*2, 20);
                labTwo.frame = CGRectMake(labOne.frame.size.width + labOne.frame.origin.x, 75, renOne.width+sizeOne.width, 20);
                labThree.frame = CGRectMake(labTwo.frame.size.width + labTwo.frame.origin.x, 75, sizeOne.width*5, 20);
                labFour.frame = CGRectMake(labThree.frame.size.width + labThree.frame.origin.x, 75, renTwo.width, 20);
                labFive.frame = CGRectMake(labFour.frame.size.width + labFour.frame.origin.x, 75, sizeOne.width, 20);
                //去实名认证
                UIView * shimingBackV =[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_SIZE.width, 50)];
                shimingBackV.backgroundColor =COLOR_RBG(211, 255, 147);
                [backV addSubview:shimingBackV];
                CGSize shimingsize =[self sizeForText:@"此任务为实名任务，" Width:SCREEN_SIZE.width Height:20 Font:13];
                CGSize shimingsizeT =[self sizeForText:@"点击这里进行实名认证" Width:SCREEN_SIZE.width Height:20 Font:13];
                UILabel * shimingLab =[[UILabel alloc]init];
                shimingLab.frame = CGRectMake((SCREEN_SIZE.width- shimingsize.width-shimingsizeT.width)/2, 15, shimingsize.width, 20);
                
                shimingLab.textColor =COLOR_RBG(100, 166, 0);
                shimingLab.text =@"此任务为实名任务，";
                shimingLab.font =[UIFont systemFontOfSize:13];
                [shimingBackV addSubview:shimingLab];
                //
                UIButton * shimingBtn =[UIButton buttonWithType:UIButtonTypeSystem];
                shimingBtn.frame = CGRectMake(shimingLab.frame.size.width+ shimingLab.frame.origin.x, 10, shimingsizeT.width, 30);
                
                NSMutableAttributedString * str =[[NSMutableAttributedString alloc]initWithString:@"点击这里进行实名认证"];
                NSRange range ={0,[str length]};
                
                [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                shimingBtn.titleLabel.font =[UIFont systemFontOfSize:13];
                [shimingBtn setTitleColor:COLOR_RBG(100, 166, 0) forState:UIControlStateNormal];
                
                [shimingBtn setAttributedTitle:str forState:UIControlStateNormal];
                [shimingBackV addSubview:shimingBtn];
                [shimingBtn setTintColor:COLOR_RBG(100, 166, 0)];
                [shimingBtn addTarget:self action:@selector(goshimingrenzheng:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
               backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 190);
            }
            UIButton * jiedanBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            jiedanBtn.frame = CGRectMake(30, labOne.frame.origin.y + 30, SCREEN_SIZE.width - 60, 44);
            jiedanBtn.clipsToBounds =YES;
            jiedanBtn.layer.cornerRadius = 22;
            [jiedanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backV addSubview:jiedanBtn];
            //
            UIButton * liuchengBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            liuchengBtn.frame = CGRectMake(SCREEN_SIZE.width/2 - 75, jiedanBtn.frame.origin.y + jiedanBtn.frame.size.height + 20, 150, 30) ;
            [liuchengBtn setTintColor:COLOR_LAN];
            [liuchengBtn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
            [liuchengBtn setTitle:@"任务接单流程说明" forState:UIControlStateNormal];
            [liuchengBtn addTarget:self action:@selector(liuchengBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            jiedanBtn.titleLabel.font =[UIFont systemFontOfSize:17];
            [backV addSubview:liuchengBtn];
            //
            if ([_jobState isEqualToString:@"1"]) {
                [jiedanBtn setTitle:@"当前等级不够，此单不能抢" forState:UIControlStateNormal];
                jiedanBtn.userInteractionEnabled = NO;
                jiedanBtn.backgroundColor = COLOR_RBG(204, 204, 204);
            }
            else if ([_jobState isEqualToString:@"2"])
            {
                [jiedanBtn setTitle:@"当前订单已抢完" forState:UIControlStateNormal];
                jiedanBtn.userInteractionEnabled = NO;
                jiedanBtn.backgroundColor = COLOR_RBG(204, 204, 204);
            }
            else if ([_jobState isEqualToString:@"3"])
            {
                [jiedanBtn setTitle:@"荣誉值为零，此单不能抢" forState:UIControlStateNormal];
                jiedanBtn.userInteractionEnabled = NO;
                jiedanBtn.backgroundColor = COLOR_RBG(204, 204, 204);
            }
            else if ([_jobState isEqualToString:@"4"])
            {
                [jiedanBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
                [jiedanBtn addTarget:self action:@selector(jiedanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                jiedanBtn.backgroundColor = COLOR_CHENG;
            }
        }
            break;
        case 1
            :
        {
            if ([_selectedPhotos count]> 0)
            {
                CGFloat aWidth =SCREEN_SIZE.width/4 - 25;
                CGFloat aHeight = aWidth* SCREEN_SIZE.height/SCREEN_SIZE.width;
                backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 230+ aHeight);
                
                
                
                UILabel * tishiOne =[[UILabel alloc]initWithFrame:CGRectMake(8, 45, SCREEN_SIZE.width - 16, 20)];
                tishiOne.text = @"已上传任务完成截图，等待审核…";
                tishiOne.textAlignment = NSTextAlignmentCenter;
                [backV addSubview:tishiOne];
                
                UILabel * tishiTwo =[[UILabel alloc]initWithFrame:CGRectMake(25, 80, SCREEN_SIZE.width - 50, 40)];
                tishiTwo.textAlignment =NSTextAlignmentCenter;
                tishiTwo.text = @"任务完成审核中";
                tishiTwo.backgroundColor =COLOR_LAN;
                tishiTwo.clipsToBounds = YES;
                tishiTwo.layer.cornerRadius = 20;
                tishiTwo.textColor =[UIColor whiteColor];
                tishiTwo.font =[UIFont systemFontOfSize:20];
                [backV addSubview:tishiTwo];
                
                UIButton * liuchengBtn =[UIButton buttonWithType:UIButtonTypeSystem];
                liuchengBtn.frame = CGRectMake(SCREEN_SIZE.width/2 - 75, 130, 150, 30) ;
                [liuchengBtn setTintColor:COLOR_LAN];
                [liuchengBtn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
                [liuchengBtn setTitle:@"任务接单流程说明" forState:UIControlStateNormal];
                [liuchengBtn addTarget:self action:@selector(liuchengBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backV addSubview:liuchengBtn];
                
                for (int i=0; i<[_selectedPhotos count]; i++)
                {
                    UIButton * imgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    
                    
                    imgBtn.frame =CGRectMake( (SCREEN_SIZE.width-(aWidth*[_selectedPhotos count]+20*([_selectedPhotos count]-1)))/2+(aWidth + 20)*i, 170, aWidth, aHeight);
                    
                    [imgBtn setImage:_selectedPhotos[i] forState:UIControlStateNormal];
                    imgBtn.tag = 4000+i;
                    [imgBtn addTarget:self action:@selector(chakajietu:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [backV addSubview:imgBtn];
                    
                }
                _jietuArr = [NSArray arrayWithArray:_selectedPhotos];
            }
            else
            {
               backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 190);
                UILabel * tishiOne =[[UILabel alloc]initWithFrame:CGRectMake(8, 45, SCREEN_SIZE.width - 16, 20)];
                tishiOne.text = @"已接单，任务进行中…";
                tishiOne.textAlignment = NSTextAlignmentCenter;
                [backV addSubview:tishiOne];
                
                UIButton * canncleJobBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                canncleJobBtn.frame = CGRectMake(SCREEN_SIZE.width/2- 60, 75, 120, 30);
                [canncleJobBtn setTitle:@"放弃任务" forState:UIControlStateNormal];
                canncleJobBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                [canncleJobBtn setTitleColor:COLOR_LAN forState:UIControlStateNormal];
                [canncleJobBtn addTarget:self action:@selector(fangqirenwuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backV addSubview:canncleJobBtn];
                
                UILabel * tishiTwo =[[UILabel alloc]initWithFrame:CGRectMake(8, 115, SCREEN_SIZE.width - 16, 20)];
                tishiTwo.text = @"友情提示：放弃任务将不扣除荣誉值";
                tishiTwo.textAlignment = NSTextAlignmentCenter;
                tishiTwo.font =[UIFont systemFontOfSize:15];
                tishiTwo.textColor = [UIColor lightGrayColor];
                [backV addSubview:tishiTwo];
            }
            
        }
            break;
        case 2
            :
        {
            backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 190);
            UILabel * tishiOne =[[UILabel alloc]initWithFrame:CGRectMake(8, 45, SCREEN_SIZE.width - 16, 20)];
            tishiOne.text = @"已上传任务完成截图，等待审核…";
            tishiOne.textAlignment = NSTextAlignmentCenter;
            [backV addSubview:tishiOne];
            
            UILabel * tishiTwo =[[UILabel alloc]initWithFrame:CGRectMake(25, 80, SCREEN_SIZE.width - 50, 40)];
            tishiTwo.textAlignment =NSTextAlignmentCenter;
            tishiTwo.text = @"任务完成审核中";
            tishiTwo.backgroundColor =COLOR_LAN;
            tishiTwo.clipsToBounds = YES;
            tishiTwo.layer.cornerRadius = 20;
            tishiTwo.textColor =[UIColor whiteColor];
            tishiTwo.font =[UIFont systemFontOfSize:20];
            [backV addSubview:tishiTwo];
            
            UIButton * liuchengBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            liuchengBtn.frame = CGRectMake(SCREEN_SIZE.width/2 - 75, 130, 150, 30) ;
            [liuchengBtn setTintColor:COLOR_LAN];
            [liuchengBtn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
            [liuchengBtn setTitle:@"任务接单流程说明" forState:UIControlStateNormal];
            [liuchengBtn addTarget:self action:@selector(liuchengBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backV addSubview:liuchengBtn];
            
        }
            break;
        case 3
            :
        {
            backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 50);
        }
            break;
        case 4:
        {
#pragma mark - 任务失败，显示截图
            NSLog(@"%@",_yijierenwuM.OrderBackPic );
            NSArray * jietuArr =[_yijierenwuM.OrderBackPic componentsSeparatedByString:@","];
            
            if (![jietuArr[0]  isEqualToString:@""]) {
                
                CGFloat aWidth =(SCREEN_SIZE.width-100)/4 ;
                CGFloat aHeight = aWidth* SCREEN_SIZE.height/SCREEN_SIZE.width;
                backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 140+ aHeight);
                NSMutableArray *imgStrArr=[NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<[jietuArr count]; i++)
                {
                    UIButton * imgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                   
                    imgBtn.frame =CGRectMake( (SCREEN_SIZE.width-(aWidth*[jietuArr count]+20*([jietuArr count]-1)))/2+(aWidth + 20)*i, 70, aWidth, aHeight);
                    
                    NSArray * strArr =[jietuArr[i] componentsSeparatedByString:@"\\"];
                    
                    
                    NSString * aStr =strArr[0];
                    
                    for (int j=1; j<[strArr count]; j++)
                    {
                        aStr =[NSString stringWithFormat:@"%@/%@",aStr,strArr[j]];
                    }
                    [imgStrArr addObject:aStr];
             
                    [imgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:aStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"myinviteintro"]];
                    imgBtn.tag = 4000+i;
                    [imgBtn addTarget:self action:@selector(chakajietu:) forControlEvents:UIControlEventTouchUpInside];
                    [backV addSubview:imgBtn];
                }
                _jietuArr =[NSArray arrayWithArray:imgStrArr];

            }
            else
            {
                backV.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 100);
            }
        }break;
        default:
            break;
    }
    return backV;
    
}

#pragma mark - 放弃任务
-(void)fangqirenwuBtnClick:(UIButton *)sender
{
    UIView * backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    CALayer * layer =[[CALayer alloc]init];
    layer.frame = backView.frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    [backView.layer addSublayer:layer];
    
    UIView * bVC =[[UIView alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/2 -70, SCREEN_SIZE.width - 40, 140)];
    bVC.backgroundColor =[UIColor whiteColor];
    bVC.clipsToBounds = YES;
    bVC.layer.cornerRadius = CORNERRADIUS;
    
    [backView addSubview:bVC];
    
    UIView * bTop =[[UIView alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/2 - 70, SCREEN_SIZE.width - 40, 40)];
    bTop.backgroundColor =COLOR_BACK;
    bTop.clipsToBounds = YES;
    bTop.layer.cornerRadius = CORNERRADIUS;
    [backView addSubview:bTop];

    UIButton * cancleBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn setTintColor:[UIColor grayColor]];
    [cancleBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(SCREEN_SIZE.width - 40 - 30, 5, 30, 30);
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bTop addSubview:cancleBtn];
    
    UILabel * titleOne =[[UILabel alloc]initWithFrame:CGRectMake(8, 45,bVC.frame.size.width- 16, 20)];
    titleOne.text = @"友情提示：放弃任务将不扣除荣誉值";
    titleOne.font =[UIFont systemFontOfSize:13];
    titleOne.textAlignment = NSTextAlignmentCenter;
    titleOne.textColor =[UIColor lightGrayColor];
    [bVC addSubview:titleOne];
    
    //
    
    CGFloat aWidth =(SCREEN_SIZE.width - 120)/2.0;
    
    UIButton * quedingBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    quedingBtn.frame = CGRectMake(30, 85, aWidth, 30);
    quedingBtn.backgroundColor =COLOR_CHENG;
    quedingBtn.clipsToBounds = YES;
    quedingBtn.layer.cornerRadius = 15;
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn addTarget:self action:@selector(fangqirenwuTwo:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:quedingBtn];
    
    
    UIButton * quxiaoBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    quxiaoBtn.frame = CGRectMake(SCREEN_SIZE.width/2- 10, 85, aWidth, 30);
    //    quxiaoBtn.backgroundColor =COLOR_CHENG;
    quxiaoBtn.clipsToBounds = YES;
    quxiaoBtn.layer.cornerRadius = 15;
    quxiaoBtn.layer.borderColor = COLOR_CHENG.CGColor;
    quxiaoBtn.layer.borderWidth = 1.0f;
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:COLOR_CHENG forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:quxiaoBtn];
    
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
}
-(void)fangqirenwuTwo:(UIButton *)sender
{
    [sender.superview.superview removeFromSuperview];
    
    [AFNetworkingManager cancleJobWiorderID:[_yijierenwuM.OID stringValue]succeed:^(id complate) {
        
        if ([self.delegate respondsToSelector:@selector(fangqirenwu)]) {
            
            [_delegate fangqirenwu];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } Failed:^(id error)
    {
        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
        [alert show];
    }];
    
    
    [sender.superview.superview removeFromSuperview];
}

#pragma mark - 流程
-(void)liuchengBtnClick:(UIButton *)sender
{
    
    UIView * backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    //
    CALayer * layer =[[CALayer alloc]init];
    layer.frame = backView.frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    [backView.layer addSublayer:layer];
    
    
    UIView * bbV =[[UIView alloc]initWithFrame:CGRectMake(30, 80, SCREEN_SIZE.width - 60, SCREEN_SIZE.height - 170)];
    
    bbV.backgroundColor =[UIColor whiteColor];
    bbV.clipsToBounds = YES;
    bbV.layer.cornerRadius = CORNERRADIUS;
    [backView addSubview:bbV];
    
    UIView * bVC =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 60, 30)];
    bVC.backgroundColor =COLOR_BACK;
    
    [bbV addSubview:bVC];
    UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width /2 - 90, 5, 120, 20)];
    titleLab.text = @"任务接单流程说明";
    titleLab.font =[UIFont systemFontOfSize:13];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bVC addSubview:titleLab];
    
    
    UIButton * cancleBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn setTintColor:[UIColor grayColor]];
    [cancleBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(SCREEN_SIZE.width - 60 - 30, 0, 30, 30);
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bbV addSubview:cancleBtn];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_SIZE.width - 60, SCREEN_SIZE.height - 200)];
    
    [bbV addSubview:scrollView];
    
    UIImageView * imgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 60, 645*(SCREEN_SIZE.width - 60)/489)];
    imgV.image =[UIImage imageNamed:@"taskout"];
    [scrollView addSubview:imgV];
    
    scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width - 60, 645*(SCREEN_SIZE.width - 60)/489);
    
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
    
}

-(void)cancleBtnClick:(UIButton *)cancleBtn
{
    [cancleBtn.superview.superview removeFromSuperview];
}

-(void)jiedanBtnClick:(UIButton *)sender
{
    UIView * backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    CALayer * layer =[[CALayer alloc]init];
    layer.frame = backView.frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    [backView.layer addSublayer:layer];
    
    UIView * bVC =[[UIView alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/2 -70, SCREEN_SIZE.width - 40, 140)];
    bVC.backgroundColor =[UIColor whiteColor];
    bVC.clipsToBounds = YES;
    bVC.layer.cornerRadius = CORNERRADIUS;
    
    
    [backView addSubview:bVC];
    
    UIView * bTop =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 40, 40)];
    bTop.backgroundColor =COLOR_BACK;
    [bVC addSubview:bTop];
    

    UIButton * cancleBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn setTintColor:[UIColor grayColor]];
    [cancleBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(SCREEN_SIZE.width - 40 - 30, 5, 30, 30);
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:cancleBtn];
    
    CGSize  tishiOne =[self sizeForText:@"友情提示：如果任务未完成将会扣除" Width:MAXFLOAT Height:20 Font:13];
    CGSize  tishiTwo =[self sizeForText:_jobModel.releasePoint Width:MAXFLOAT Height:20 Font:13];
    CGSize  tishiThree =[self sizeForText:@"点荣誉值" Width:MAXFLOAT Height:20 Font:13];
    
    UILabel * titleOne =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width /2 -(tishiOne.width + tishiTwo.width + tishiThree.width)/2 - 20, 45, tishiOne.width, 20)];
    titleOne.text = @"友情提示：如果任务未完成将会扣除";
    titleOne.font =[UIFont systemFontOfSize:13];
    titleOne.textAlignment = NSTextAlignmentCenter;
    titleOne.textColor =[UIColor lightGrayColor];
    [bVC addSubview:titleOne];
    
    
    UILabel * titleTwo =[[UILabel alloc]initWithFrame:CGRectMake(titleOne.frame.origin.x +tishiOne.width, 45, tishiTwo.width, 20)];
    titleTwo.text = _jobModel.releasePoint;
    titleTwo.font =[UIFont systemFontOfSize:13];
    titleTwo.textAlignment = NSTextAlignmentCenter;
    titleTwo.textColor =COLOR_CHENG;
    [bVC addSubview:titleTwo];
    
    UILabel * titleThree =[[UILabel alloc]initWithFrame:CGRectMake(titleTwo.frame.origin.x +titleTwo.frame.size.width, 45, tishiThree.width, 20)];
    titleThree.text = @"点荣誉值";
    titleThree.font =[UIFont systemFontOfSize:13];
    titleThree.textAlignment = NSTextAlignmentCenter;
    titleThree.textColor =[UIColor lightGrayColor];
    [bVC addSubview:titleThree];
    
    //
    
    CGFloat aWidth =(SCREEN_SIZE.width - 120)/2.0;
    
    UIButton * quedingBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    quedingBtn.frame = CGRectMake(30, 85, aWidth, 30);
    quedingBtn.backgroundColor =COLOR_CHENG;
    quedingBtn.clipsToBounds = YES;
    quedingBtn.layer.cornerRadius = 15;
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn addTarget:self action:@selector(quedingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:quedingBtn];
    
    
    UIButton * quxiaoBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    quxiaoBtn.frame = CGRectMake(SCREEN_SIZE.width/2- 10, 85, aWidth, 30);
//    quxiaoBtn.backgroundColor =COLOR_CHENG;
    quxiaoBtn.clipsToBounds = YES;
    quxiaoBtn.layer.cornerRadius = 15;
    quxiaoBtn.layer.borderColor = COLOR_CHENG.CGColor;
    quxiaoBtn.layer.borderWidth = 1.0f;
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:COLOR_CHENG forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:quxiaoBtn];
    
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];

}

-(void)quedingBtnClick:(UIButton *)sender
{
    UserLogin * aUser =[UserLogin shareUserWithData:nil];
    [sender.superview.superview removeFromSuperview];
    
    
        [AFNetworkingManager acceptJobWithuserID:aUser.UID tid:[_jobModel.TID stringValue] curIP:@"117.89.18.128" succeed:^(id complate) {
            
//#warning 测试****************************************
//            self.hidesBottomBarWhenPushed = YES;
//            
//            ZhiFuViewController * zhifuVC =[[ZhiFuViewController alloc]init];
//            [self.navigationController pushViewController:zhifuVC animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
            orderID = complate;
            if ([self.delegate respondsToSelector:@selector(qiangdang)]) {
                
                [_delegate qiangdang];
            }
            [self qiangdanzhihou];
    
        } Failed:^(id error) {
            
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
            
            NSLog(@"%@",error);
            
            [alert show];
            
            if ([error isEqualToString:@"您当前的余额不够，请先充值后在做任务！"])
            {
                self.hidesBottomBarWhenPushed = YES;
                
                ZhiFuViewController * zhifuVC =[[ZhiFuViewController alloc]init];
                [self.navigationController pushViewController:zhifuVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }];
}

#pragma mark - 抢单之后
-(void)qiangdanzhihou
{
    UIView * backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    CALayer * layer =[[CALayer alloc]init];
    layer.frame = backView.frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    [backView.layer addSublayer:layer];
    
    
    UIView * bVC =[[UIView alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/2 -70, SCREEN_SIZE.width - 40, 140)];
    bVC.backgroundColor =[UIColor whiteColor];
    bVC.clipsToBounds = YES;
    bVC.layer.cornerRadius = CORNERRADIUS;
    [backView addSubview:bVC];
    
    CGSize ts =[self sizeForText:@"恭喜您，接单成功" Width:MAXFLOAT Height:20 Font:17];
    
    UIImageView * img =[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width -ts.width-70)/2, 20, 30, 30)];
    img.image =[UIImage imageNamed:@"icon_right"];
    [bVC addSubview:img];
    
    UILabel * lab =[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width -ts.width-70)/2+ 30, 30, ts.width, 20)];
    lab.text = @"恭喜您，接单成功";
    lab.textColor =[UIColor lightGrayColor];
    [bVC addSubview:lab];
    
    UIButton * renwuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    renwuBtn.frame=  CGRectMake(30, 80, SCREEN_SIZE.width/2 - 60, 40);
    [renwuBtn setTitle:@"去做任务" forState:UIControlStateNormal];
    renwuBtn.clipsToBounds = YES;
    renwuBtn.tag = 4004;
    renwuBtn.layer.cornerRadius = 20;
    renwuBtn.layer.borderColor = COLOR_CHENG.CGColor;
    renwuBtn.layer.borderWidth = 1.0f;
    [renwuBtn setTitleColor:COLOR_CHENG forState:UIControlStateNormal];
    [renwuBtn addTarget:self action:@selector(renwuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:renwuBtn];
    
    UIButton * fanhuiBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=  CGRectMake(SCREEN_SIZE.width/2 -10, 80, SCREEN_SIZE.width/2 - 60, 40);
    [fanhuiBtn setTitle:@"返回列表" forState:UIControlStateNormal];
    [fanhuiBtn setTitleColor:COLOR_CHENG forState:UIControlStateNormal];
    fanhuiBtn.clipsToBounds = YES;
    fanhuiBtn.tag = 4005;
    fanhuiBtn.layer.cornerRadius = 20;
    fanhuiBtn.layer.borderColor = COLOR_CHENG.CGColor;
    fanhuiBtn.layer.borderWidth = 1.0f;
    [fanhuiBtn addTarget:self action:@selector(renwuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:fanhuiBtn];
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
}
-(void)renwuBtnClick:(UIButton *)sender
{
    if (sender.tag == 4004)
    {
      
        self.jobType = 1;
        [AFNetworkingManager getMyJobDetailWithOrderID:orderID succeed:^(id complate) {
            
            if (!_jobModel) {
                _jobModel =[[JobInfo alloc]init];
            }
            [_jobModel setValuesForKeysWithDictionary:[complate[0] objectForKey:@"TaskInfo"]];
            
            if (!_yijierenwuM) {
                _yijierenwuM =[[YijieRenWu alloc]init];
            }
            [_yijierenwuM setValuesForKeysWithDictionary:complate[0]];
            
            UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
            backV.backgroundColor =COLOR_LAN;
            

            [_WebView loadHTMLString:[NSString stringWithFormat:@"%@<body>%@</body>",@"<head><meta http-equiv=\"Content-Type\" content=\"textml; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\" /><meta name=\"MobileOptimized\" content=\"240\" /><meta name=\"format-detection\" content=\"telephone=no\" /><style>img {width: 100%;height: inherit;}</style></head>",_jobModel.Content] baseURL:nil];
            [backV addSubview:_WebView];
            
            [self.view addSubview:backV];
            
            [sender.superview.superview removeFromSuperview];
            
        } Failed:^(id error) {
            
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
            [alert show];
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [sender.superview.superview removeFromSuperview];
    
    
}

#pragma mark -UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [progressHUD hide:YES];
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
    }
    _tableView.backgroundColor=COLOR_BACK;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.bounces = NO;
    _tableView.tag = 8000;
    _tableView.tableFooterView = [self viewForTableViewFooter];
    [self.view addSubview:_tableView];

    CGRect frame = webView.frame;

    frame.size.height = 1;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height;
    
    UIView * viewB =[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_SIZE.width , 230+ 40+webView.scrollView.contentSize.height)];
    viewB.backgroundColor =[UIColor whiteColor];
    //
    UIView * headerV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 230)];
    headerV.backgroundColor =COLOR_LAN;
    [viewB addSubview:headerV];
    //
    CGSize titleSize =[self sizeForText:_jobModel.Title Width:SCREEN_SIZE.width - 16 Height:MAXFLOAT Font:20];
    UILabel * contentLab =[[UILabel alloc]initWithFrame:CGRectMake(8, 20, SCREEN_SIZE.width - 16, titleSize.height)];
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.textColor =[UIColor whiteColor];
    contentLab.font =[UIFont systemFontOfSize:20];
    contentLab.text = _jobModel.Title;
    contentLab.numberOfLines = 0;
    contentLab.lineBreakMode = NSLineBreakByCharWrapping;
    [headerV addSubview:contentLab];

    
    CGSize  moneySize =[self sizeForText:[NSString stringWithFormat:@"￥%@",_jobModel.PriceStr] Width:SCREEN_SIZE.width Height:30 Font:44];
    UILabel * moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - moneySize.width/2 - 20, contentLab.frame.origin.y + contentLab.frame.size.height + 20, moneySize.width, 30)];
    
    moneyLab.text =[NSString stringWithFormat:@"￥%@",_jobModel.PriceStr];
    moneyLab.font =[UIFont boldSystemFontOfSize:42];
    
    moneyLab.textColor =[UIColor whiteColor];
    
    [headerV addSubview:moneyLab];
    
    UILabel * moneyTwo =[[UILabel alloc]initWithFrame:CGRectMake(moneyLab.frame.origin.x + moneyLab.frame.size.width, moneyLab.frame.origin.y+3, 40, 30)];
    moneyTwo.text =@"/单";
    moneyTwo.font =[UIFont boldSystemFontOfSize:24];
    moneyTwo.textColor =[UIColor whiteColor];
    [headerV addSubview:moneyTwo];
    
    UILabel * timeLab =[[UILabel alloc]initWithFrame:CGRectMake(8, moneyLab.frame.size.height + moneyLab.frame.origin.y + 20, SCREEN_SIZE.width - 16, 20)];
    timeLab.textColor =COLOR_RBG(125, 161, 198);
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font =[UIFont systemFontOfSize:16];
    timeLab.text = [NSString stringWithFormat:@"预计%@可完成任务",_jobModel.ExpectedToTakeTimeStr];
    
    [headerV addSubview:timeLab];
    //
    UILabel *jiezhiOne =[[UILabel alloc ] initWithFrame:CGRectMake(8, headerV.frame.size.height - 50, SCREEN_SIZE.width/2 - 8, 20)];
    jiezhiOne.text = @"接单截止日期";
    jiezhiOne.textColor = COLOR_RBG(125, 161, 198);
    jiezhiOne.font =[UIFont systemFontOfSize:13];
    [headerV addSubview:jiezhiOne];
    //
    NSString * endDate =[NSString stringWithFormat:@"%@年%@月%@日",[_jobModel.FinlishDate substringWithRange:NSMakeRange(0, 4)],[_jobModel.FinlishDate substringWithRange:NSMakeRange(5, 2)],[_jobModel.FinlishDate substringWithRange:NSMakeRange(8, 2)]];

    UILabel *jiezhiTwo =[[UILabel alloc ] initWithFrame:CGRectMake(8, headerV.frame.size.height - 30, SCREEN_SIZE.width/2 - 8, 20)];
    jiezhiTwo.text = endDate;
    jiezhiTwo.textColor = [UIColor whiteColor];
    jiezhiTwo.font =[UIFont systemFontOfSize:13];
    [headerV addSubview:jiezhiTwo];
    //
    UILabel *daojishiOne =[[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_SIZE.width/2, headerV.frame.size.height - 50, SCREEN_SIZE.width/2-8, 20)];
    daojishiOne.text = @"接单倒计时";
    daojishiOne.textAlignment = NSTextAlignmentRight;
    daojishiOne.textColor = COLOR_RBG(125, 161, 198);
    daojishiOne.font =[UIFont systemFontOfSize:13];
    [headerV addSubview:daojishiOne];
    //
    if (!daojishiTwo)
    {
        daojishiTwo =[[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_SIZE.width/2, headerV.frame.size.height - 30, SCREEN_SIZE.width/2 - 8, 20)];
    }
    daojishiTwo.textAlignment = NSTextAlignmentRight;
    daojishiTwo.text = _jobModel.TaskFinlishDateLimit;
    daojishiTwo.textColor = [UIColor whiteColor];
    daojishiTwo.font =[UIFont systemFontOfSize:13];
    [headerV addSubview:daojishiTwo];
    //倒计时
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
    
    //
    UIView * jiangeV =[[UIView alloc]initWithFrame:CGRectMake(0, 230, SCREEN_SIZE.width, 10)];
    jiangeV.backgroundColor = COLOR_RBG(239, 239, 239);
    [viewB addSubview:jiangeV];
    
    UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 250, SCREEN_SIZE.width - 30, 20)];
    titleLab.text = @"任务详情";
//    titleLab.textColor =COLOR_RBG(28, 94, 191);
    titleLab.textColor = COLOR_LAN;
    
    
    titleLab.font =[UIFont boldSystemFontOfSize:17];
    [viewB addSubview:titleLab];
    //
     NSLog(@"%@",NSStringFromCGSize(webView.scrollView.contentSize));
 
    webView.frame=CGRectMake(8, titleLab.frame.origin.y + 20, SCREEN_SIZE.width-16, webView.scrollView.contentSize.height);

    [viewB addSubview:webView];
   
    _tableView.tableHeaderView = viewB;
    switch (_jobType) {
        case 0
            :
        {
            
        }
            break;
        case 1
            :
        {
            UIButton * shangchuanBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            shangchuanBtn.frame = CGRectMake(0, SCREEN_SIZE.height - 55, SCREEN_SIZE.width, 55);
            shangchuanBtn.backgroundColor =COLOR_CHENG;
            [shangchuanBtn setImage:[UIImage imageNamed:@"update"] forState:UIControlStateNormal];
            [shangchuanBtn setTintColor:[UIColor whiteColor]];
            shangchuanBtn.tag = 100000;
            [shangchuanBtn setTitle:@"完成任务上传截图" forState:UIControlStateNormal];
            [shangchuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            shangchuanBtn.titleLabel.font =[UIFont systemFontOfSize:18];
            [shangchuanBtn addTarget:self action:@selector(shangchuanjietuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shangchuanBtn];
        }
            break;
        case 2
            :
        {
            
        }
            break;
        case 3
            :
        {
            UIImageView * wanchengImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_ok350"]];
            wanchengImg.frame = CGRectMake(SCREEN_SIZE.width -  155, 200, 120, 120);
            wanchengImg.alpha = 0.5f;
            [_tableView addSubview:wanchengImg];
            
        }
            break;
        case 4
            :
        {
            UIImageView * wanchengImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_fail350"]];
            wanchengImg.frame = CGRectMake(SCREEN_SIZE.width -  155, 200, 120, 120);
            wanchengImg.alpha = 0.5f;
            
            [_tableView addSubview:wanchengImg];
            
            UIButton * shangchuanBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            shangchuanBtn.frame = CGRectMake(0, SCREEN_SIZE.height - 55, SCREEN_SIZE.width, 55);
//            shangchuanBtn.clipsToBounds = YES;
//            shangchuanBtn.layer.cornerRadius = 20;
            shangchuanBtn.backgroundColor =COLOR_CHENG;
            [shangchuanBtn setImage:[UIImage imageNamed:@"update"] forState:UIControlStateNormal];
            [shangchuanBtn setTintColor:[UIColor whiteColor]];
            [shangchuanBtn setTitle:@"继续上传截图" forState:UIControlStateNormal];
            [shangchuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            shangchuanBtn.titleLabel.font =[UIFont systemFontOfSize:18];
            [shangchuanBtn addTarget:self action:@selector(shangchuanjietuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shangchuanBtn];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 拉到一半，加标题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 8000&&scrollView.contentOffset.y > 300)
    {
        if (!_titleLab) {
            _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 80, 27, 160, 30)];
            _titleLab.text = @"任务详情";
            _titleLab.textColor = [UIColor whiteColor];
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _titleLab.font = [UIFont boldSystemFontOfSize:21];
            [_navView addSubview:_titleLab];
        }
        
        
    }
    else if (scrollView.tag == 8000&&scrollView.contentOffset.y <= 300)
    {
        if (_titleLab) {
            [_titleLab removeFromSuperview];
            _titleLab = nil;
        }
    }
}


#pragma mark - 计算文本高度

-(CGSize)sizeForText:(NSString *)text Width:(CGFloat)aWidth Height:(CGFloat)aHeight Font:(NSInteger)aFont
{
    NSStringDrawingOptions option =NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:aFont] forKey:NSFontAttributeName];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(aWidth, aHeight)
                                     options:option
                                  attributes:attributes
                                     context:nil];
    
    return rect.size;
}

//倒计时
-(void)daoJiShi
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    [formater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate* beginDate = nil;
    if ([_jobModel.FinlishDate length] < 13)
    {
        beginDate = [formater dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",_jobModel.FinlishDate]];
    }
    else
    {
        beginDate = [formater dateFromString:_jobModel.FinlishDate];
    }
    NSDate * nowDate =[NSDate date];
    NSTimeInterval  interval =[beginDate timeIntervalSinceDate:nowDate];

    if (interval > 0) // 未结束
    {

        NSInteger tbt =  fabs(interval);

        if (interval < 60)//小于一分钟
        {
            daojishiTwo.text = [NSString stringWithFormat:@"距离结束还剩：0天00小时00分%ld秒",(long)tbt];
        }
        else if(interval < 3600) //小于一小时
        {
            NSInteger fen =tbt/60;
            NSInteger miao = tbt%60;
            daojishiTwo.text = [NSString stringWithFormat:@"0天0小时%ld分%ld秒",(long)fen,miao];
        }
        else if (interval < 86400)//小于一天
        {
            NSInteger shi = tbt/3600;
            NSInteger fen = (tbt%3600)/60;
            NSInteger miao = tbt%60;
            daojishiTwo.text = [NSString stringWithFormat:@"0天%ld小时%ld分%ld秒",(long)shi,(long)fen,miao];

        }
        else //大于一天
        {
            NSInteger tian = tbt/86400;
            NSInteger shi = (tbt%86400)/3600;
            NSInteger fen  =((tbt%86400)%3600)/60;
            NSInteger miao = tbt%60;
            daojishiTwo.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒",(long)tian,(long)shi,(long)fen,miao];
        }
    }
    else // 活动已结束
    {
        daojishiTwo.text = @"任务已结束";
        [timer invalidate];
        timer = nil;
    }

}

#pragma mark - 上传截图
-(void)shangchuanjietuBtnClick:(UIButton *)sender
{
 

        bbbbV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];

    
    [self.view addSubview:bbbbV];
//    self.frame = ;
    //
    CALayer * layer =[[CALayer alloc]init];
    layer.frame = bbbbV.frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    [bbbbV.layer addSublayer:layer];
    
    
    UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(20, SCREEN_SIZE.height/2 - 70, SCREEN_SIZE.width - 40, 140)];
    backV.tag = 9000;
    backV.backgroundColor =[UIColor whiteColor];
    
    backV.clipsToBounds = YES;
    backV.layer.cornerRadius = CORNERRADIUS;
    [bbbbV addSubview:backV];
    
    UIView * bVC =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 40, 30)];
    bVC.backgroundColor =COLOR_BACK;
    [backV addSubview:bVC];
    
    UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bVC.width, bVC.height)];
    titleLab.text = @"完成任务，上传截图";
    titleLab.font =[UIFont systemFontOfSize:13];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bVC addSubview:titleLab];
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(bVC.width-titleLab.height, 0, titleLab.height, titleLab.height);
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bVC addSubview:closeBtn];

    [_selectedPhotos removeAllObjects];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 16;
    _itemWH = (backV.width - 5 * _margin )/4;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, titleLab.y+titleLab.height+10, backV.width - 2 * _margin, _itemWH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
//    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    [backV addSubview:_collectionView];
    
    
    UIButton * shangchuanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    shangchuanBtn.frame = CGRectMake(30, _collectionView.y+_collectionView.height+20, SCREEN_SIZE.width - 100, 30);
    [shangchuanBtn setTitle:@"开始上传" forState:UIControlStateNormal];
    [shangchuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shangchuanBtn.backgroundColor =COLOR_CHENG;
    shangchuanBtn.clipsToBounds = YES;
    shangchuanBtn.layer.cornerRadius = 15;
    [shangchuanBtn addTarget:self action:@selector(shangchuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:shangchuanBtn];
    
    backV.height=20+shangchuanBtn.height+shangchuanBtn.y;
    
    
}

-(void)closeBtnClick:(UIButton *)btn
{
    [self dismiss];
}
-(void)dismiss
{
    [bbbbV removeFromSuperview];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_selectedPhotos count]==4)
    {
        return _selectedPhotos.count;
    }else
    {
        return _selectedPhotos.count+1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
  
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"adddd"];
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
        [sheet showInView:self.view];
    }else
    {
        self.hidesBottomBarWhenPushed=YES;
        ImageViewController *imageVc=[[ImageViewController alloc]initWithTitle:@" " leftButton:@"image/back" rightButton:@"text/删除"];
        imageVc.images=_selectedPhotos;
        imageVc.row=indexPath.row;
        imageVc.delegate=self;
        [self.navigationController pushViewController:imageVc animated:YES];
        
    }
}
-(void)imageDelectWithRow:(NSInteger)row
{
    [_selectedPhotos removeObjectAtIndex:row];
    [_collectionView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1234)
    {
        switch (buttonIndex) {
            case 0:
            {
                [self saveImageToDiskWithUrl:urlToSave];
            }
                 break;
            case 1:
            {
                WXMediaMessage *urlMessage = [WXMediaMessage message];
                WXImageObject *obj=[WXImageObject object];
                 UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]]];
                 NSData *imageData = UIImageJPEGRepresentation(image, 0.01f);

                obj.imageData=imageData;

                urlMessage.mediaObject=obj;
                
                SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
                sendReq.bText = NO;
                sendReq.message = urlMessage;
                sendReq.scene = 1;
                [WXApi sendReq:sendReq];
            }

                break;
                
                
            default:
                break;
        }
    }else
    {
        switch (buttonIndex) {
            case 0:
            {
                //相机:先判断是否支持相机,然后询问用户是否同意使用
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    //打开相机
                    [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
                }
            }
                break;
            case 1:
            {
                //相册
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    [self pickPhotoButtonClick:nil];
                }
                
            }
                break;
                
            default:
                break;
        }
 
    }
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender
{
    
    NSInteger count=4-[_selectedPhotos count];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    imagePickerVc.allowPickingOriginalPhoto=NO;
    imagePickerVc.oKButtonTitleColorNormal=COLOR_LAN;
    imagePickerVc.oKButtonTitleColorDisabled=COLOR_LAN;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets){
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {

}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_selectedPhotos addObjectsFromArray:photos];
    [_collectionView reloadData];

}

#pragma mark - 上传截图成功

-(void)shangchuanBtnClick:(UIButton *)sender
{
    NSMutableArray * arr =[NSMutableArray array];
    for (UIImage *image in _selectedPhotos)
    {
        if (image)
        {
            NSData * imgData = UIImageJPEGRepresentation(image, .3f);
            NSString * imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [arr addObject:imgStr];
        }
    }
    if ([arr count]> 0)
    {
        //风火轮
        progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.labelText = @"图片上传中…";
        progressHUD.dimBackground = NO;
        
        UserLogin * aUser =[UserLogin shareUserWithData:nil];
        [AFNetworkingManager uploadJobimgWithImgs:arr OID:[_yijierenwuM.OID stringValue] UID:aUser.UID TID:[_jobModel.TID stringValue] orderstate:@"2" succeed:^(id complate) {
            [progressHUD hide:YES];
            
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"图片上传成功！"];
            [alert show];
            
            [sender.superview.superview removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(uploadImg)])
            {
                
                [_delegate uploadImg];
            }
            
            UIButton * but =[self.view viewWithTag:100000];
            if (but) {
                [but removeFromSuperview];
            }
            
//            self.jobType = 2;
            _tableView.tableFooterView = [self viewForTableViewFooter];
            
            
            
            
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        } Failed:^(id error) {
            
            [progressHUD hide:YES];
            HWAlertView * alert =[[HWAlertView alloc]initWithTitle:error];
            [alert show];
        }];
    }
    else
    {
        HWAlertView * alert =[[HWAlertView alloc]initWithTitle:@"必须上传至少一张图片"];
        [alert show];
    }
    
}

-(void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    //创建图片选取器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    //设置选取器类型
    picker.sourceType = type;
    //编辑
    picker.allowsEditing = YES;
    //弹出
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *uploadImg = info[UIImagePickerControllerEditedImage];
    [_selectedPhotos addObject:uploadImg];
    [_collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnClick:(UIButton *)sender
{
    [sender.superview.superview.superview removeFromSuperview];
}

-(void)baozhengjinshuomingBtnClick:(UIButton *)sender
{
    [AFNetworkingManager getBaozhengjinwendasucceed:^(id complate) {
        Baozhengjinshuoming * baozhen =[[Baozhengjinshuoming alloc]initWithInfo:complate];
        [baozhen show];
        
    } Failed:^(id error) {
        
    }];
}
#pragma mark - 查看截图
-(void)chakajietu:(UIButton *)sender
{
    NSLog(@"%@",_jietuArr[0]);
    
    ShowPhotoView * showV =[[ShowPhotoView alloc]initWithImages:_jietuArr Type:_jobType atIndex:sender.tag - 4000];
    [showV show];
    
}
#pragma mark - 去实名认证
-(void)goshimingrenzheng:(UIButton *)sender
{
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
        
    } Failed:^(id error) {
        [progressHUD hide:YES];
        if ([error isEqualToString:@"没有认证记录"])
        {
            
            
            [progressHUD hide:YES];
            
            self.hidesBottomBarWhenPushed=YES;
            RenZhengViewController *rzVc=[[RenZhengViewController alloc]initWithTitle:@"实名认证" leftButton:@"image/back" rightButton:nil];
            rzVc.model=nil;
            [self.navigationController pushViewController:rzVc animated:YES];
        }
        //        HWAlertView *message=[[HWAlertView alloc]initWithTitle:(NSString *)error];
        //
        //        [message show];
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

@end
