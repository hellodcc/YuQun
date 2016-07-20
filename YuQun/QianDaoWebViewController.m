//
//  QianDaoWebViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/17.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "QianDaoWebViewController.h"
#import "Model.h"
#import "AFNetworkingManager.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "AHeader.h"
@interface QianDaoWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (weak, nonatomic) IBOutlet UIWebView *qianDaoWebView;

@end

@implementation QianDaoWebViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

    [_progressView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.qianDaoWebView addSubview:_progressView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.qianDaoWebView.frame=CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height-64);
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.qianDaoWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0,SCREEN_SIZE.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
//    self.qianDaoWebView.delegate=self;
    [self.qianDaoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)userLogIn
{
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    [AFNetworkingManager userLoginWithTel:user.Tel Pas:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"] succeed:^(id complate) {

    } Failed:^(id error) {
        
        
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString]isEqualToString:self.urlStr])
    {
        if (self.isFirst)
        {
            self.isFirst=NO;
        }else
        {
            [self userLogIn];
        }
    }
    
    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.qianDaoWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.qianDaoWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
