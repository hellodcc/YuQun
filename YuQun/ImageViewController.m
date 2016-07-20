//
//  ImageViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/23.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ImageViewController.h"
#import "AHeader.h"
#import "UIView+MJ.h"
@interface ImageViewController ()<UIScrollViewDelegate>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navView.backgroundColor=[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.7];
    self.view.backgroundColor=[UIColor blackColor];
    self.bgScrollerView.pagingEnabled=YES;
    self.bgScrollerView.delegate=self;
    for (int i=0; i<[self.images count]; i++)
    {
        UIImage *image=[self.images objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.tag=1500+i;
        imageView.image=image;
        CGSize imgSize=[image size];
        CGFloat bili=imgSize.width/imgSize.height;
        CGFloat y=((SCREEN_SIZE.height)-SCREEN_SIZE.width/bili)/2;
        if (y>0)
        {
            imageView.frame=CGRectMake(SCREEN_SIZE.width*i, y, SCREEN_SIZE.width, SCREEN_SIZE.width/bili);
        }else
        {
            imageView.frame=CGRectMake(SCREEN_SIZE.width*i, 0, SCREEN_SIZE.width, SCREEN_SIZE.width/bili);
        }
        [self.bgScrollerView addSubview:imageView];
    }
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width*[self.images count],0 );
    
    self.bgScrollerView.contentOffset=CGPointMake(self.row*SCREEN_SIZE.width,0 );
    
    self.titleLab.text=[NSString stringWithFormat:@"%ld/%ld",self.row+1,[self.images count]];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.bgScrollerView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

-(void)click:(UITapGestureRecognizer *)tap
{
    if (self.navView.y==0)
    {
       [UIView animateWithDuration:0.3 animations:^{
           self.navView.y=-64;
       }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.y=0;
        }];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.navView.y==0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.y=-64;
        }];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger count=scrollView.contentOffset.x/SCREEN_SIZE.width;
    self.titleLab.text=[NSString stringWithFormat:@"%ld/%ld",count+1,[self.images count]];
}

-(void)rightBtnClick:(id)sender
{
    [self.delegate imageDelectWithRow:self.bgScrollerView.contentOffset.x/SCREEN_SIZE.width];
    
    
    if ([self.images count]==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIImageView *imageView=[self.bgScrollerView viewWithTag:self.bgScrollerView.contentOffset.x/SCREEN_SIZE.width+1500];
        [imageView removeFromSuperview];
        
        for (int i=1; i<[self.images count]-self.bgScrollerView.contentOffset.x/SCREEN_SIZE.width+1; i++)
        {
            UIImageView *imageV=[self.bgScrollerView viewWithTag:self.bgScrollerView.contentOffset.x/SCREEN_SIZE.width+1500+i];
            imageV.x-=SCREEN_SIZE.width;
            imageV.tag--;
        }
        
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width*[self.images count],0 );
        NSInteger count=self.bgScrollerView.contentOffset.x/SCREEN_SIZE.width;
        self.titleLab.text=[NSString stringWithFormat:@"%ld/%ld",count+1,[self.images count]];
    }
    
}

-(void)refreshUI
{
    
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
