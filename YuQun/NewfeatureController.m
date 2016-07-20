
//
//  NewfeatureController.m
//  车惠
//
//  Created by dcc on 16/1/6.
//  Copyright © 2016年 dcc. All rights reserved.
//

#import "NewfeatureController.h"
#import "AHeader.h"
@interface NewfeatureController ()<UIScrollViewDelegate>
{
    UIImageView * _pageImage;
}
@end

@implementation NewfeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.newfeatureSV.bounces=NO;
    self.newfeatureSV.pagingEnabled=YES;
    self.newfeatureSV.delegate=self;
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    [self.delagete endNewfeature];
}
-(void)makeUI
{
    for (int i = 1; i< 4; i++)
    {
        NSString * imageStr;
        if (KYX_IS_IPHONE4S)
        {
            imageStr = [NSString stringWithFormat:@"%d",i];
        }else if (KYX_IS_IPHONE5)
        {
             imageStr = [NSString stringWithFormat:@"%d",i];
        }else if (KYX_IS_IPHONE6)
        {
             imageStr = [NSString stringWithFormat:@"%d",i];
            
        }else if (KYX_IS_IPHONE6PLUS)
        {
            imageStr = [NSString stringWithFormat:@"%d",i];
        }
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
        imageView.frame = CGRectMake(SCREEN_SIZE.width*(i-1), 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        [self.newfeatureSV addSubview:imageView];
    }
    
    self.newfeatureSV.contentSize=CGSizeMake(SCREEN_SIZE.width*3, 0);
//    if (!_pageImage) {
//        _pageImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dian1.png"]];
//        
//    }
    UIButton * liJiTiYanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [liJiTiYanBtn setImage:[UIImage imageNamed:@"liJitiYan.png"] forState:UIControlStateNormal];
    liJiTiYanBtn.frame = CGRectMake(SCREEN_SIZE.width/2*5 - 80*SCREEN_SIZE.width/375, 580*SCREEN_SIZE.height/667, 160*SCREEN_SIZE.width/375, 34*SCREEN_SIZE.height/667);
     [liJiTiYanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.newfeatureSV addSubview:liJiTiYanBtn];
    
//    _pageImage.frame = CGRectMake(SCREEN_SIZE.width/2 - 23*SCREEN_SIZE.width/375, SCREEN_SIZE.height - 50*SCREEN_SIZE.height/667, 46*SCREEN_SIZE.width/375, 7.5*SCREEN_SIZE.height/667);
//    [self.view addSubview:_pageImage];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    static NSInteger atImage = 1;
//    if (0<=scrollView.contentOffset.x&&scrollView.contentOffset.x<SCREEN_SIZE.width/2)
//    {
//        if (atImage !=1) {
//            atImage = 1;
//            [_pageImage setImage:[UIImage imageNamed:@"dian1.png"]];
//        }
//    }
//    else if (SCREEN_SIZE.width/2<=scrollView.contentOffset.x&&scrollView.contentOffset.x< SCREEN_SIZE.width/2*3)
//    {
//        if (atImage !=2) {
//            atImage = 2;
//            [_pageImage setImage:[UIImage imageNamed:@"dian2.png"]];
//        }
//    }
//    else if (SCREEN_SIZE.width/2*3<=scrollView.contentOffset.x&&scrollView.contentOffset.x< SCREEN_SIZE.width*2)
//    {
//        if (atImage !=3) {
//            atImage = 3;
//            [_pageImage setImage:[UIImage imageNamed:@"dian3.png"]];
//        }
//    }
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
