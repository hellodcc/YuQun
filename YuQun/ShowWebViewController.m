//
//  ShowWebViewController.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/15.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ShowWebViewController.h"
#import "AHeader.h"
#import "Model.h"
#import "WXApi.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIImageView+WebCache.h"
@interface ShowWebViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@end

@implementation ShowWebViewController{
    UIView *umView;
    UIView *umBackView;
    UIWebView * webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *urlToSave;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [_progressView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [webView addSubview:_progressView];
    NSLog(@"%@",self.link);
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
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64)];
    webView.userInteractionEnabled=YES;
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [webView addGestureRecognizer:longPressed];
    [self.view addSubview:webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0,SCREEN_SIZE.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
}


- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    
    CGPoint touchPoint = [recognizer locationInView:webView];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    [self showImageOptions];
    
}

- (void)showImageOptions
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存储图像", nil];
    [sheet showInView:self.navigationController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self saveImageToDiskWithUrl:urlToSave];
        }
            break;
        
            
        default:
            break;
    }
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

-(void)rightBtnClick:(id)sender
{
    [self createUMSocialUI];
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
   
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
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
    urlMessage.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//分享标题
    
    NSMutableString * appConnect = [[NSMutableString alloc]
                             initWithContentsOfURL:[NSURL URLWithString:self.link]
                             encoding:NSUTF8StringEncoding
                             error:nil];
    
  
    if([self.link rangeOfString:@"http://mp.weixin.qq.com/s?"].location !=NSNotFound)//_roaldSearchText
    {
        urlMessage.description =[[[[appConnect componentsSeparatedByString:@"var msg_desc = \""] objectAtIndex:1] componentsSeparatedByString:@"\";"] objectAtIndex:0];//分享描述
        
        
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[appConnect componentsSeparatedByString:@"var msg_cdn_url = \""] objectAtIndex:1] componentsSeparatedByString:@"\";"] objectAtIndex:0]]]];
        UIImage *image1= [self image:image byScalingToSize:CGSizeMake(100, 100)];
        NSData *photo = UIImageJPEGRepresentation(image1, 0.01f);
        
        [urlMessage setThumbImage:[UIImage imageWithData:photo]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    }
    else
    {
       
         urlMessage.description =self.link;//分享描述
    }
    

    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = self.link;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}
@end
