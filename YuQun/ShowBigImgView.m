//
//  ShowBigImgView.m
//  XiGuaPai
//
//  Created by chehuiMAC on 16/6/3.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "ShowBigImgView.h"
#import "AHeader.h"
#import "UIImageView+WebCache.h"

@implementation ShowBigImgView
{
    UIScrollView * _scrollView;
    UILabel * pageLab;
}

-(id)initWithImgArr:(NSArray *)aImgArr showIndex:(NSInteger)aIndex
{
    self =[super init];
    if (self)
    {
        self.backgroundColor =COLOR_RBG(10, 10, 10);
        self.frame = CGRectMake(0, 0,SCREEN_SIZE.width , SCREEN_SIZE.height);
//        self.frame = CGRectMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height/2 - 20, 0, 0);
        
        UITapGestureRecognizer * aTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:aTap];
        if (!_scrollView)
        {
            _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, SCREEN_SIZE.height -40)];
        }
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width *aImgArr.count, SCREEN_SIZE.height- 40);
        //
        for (int i = 0; i<aImgArr.count; i++)
        {
            UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width * i, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
            backV.clipsToBounds =YES;
            //
            UIImageView * showImgV =[[UIImageView alloc]initWithFrame:backV.bounds];
            showImgV.clipsToBounds = YES;
            [showImgV sd_setImageWithURL:[NSURL URLWithString:aImgArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if ((image.size.width/image.size.height)>(SCREEN_SIZE.width/(SCREEN_SIZE.height-40)))//宽了
                {
                    showImgV.bounds = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.width*image.size.height/image.size.width);
                    
                }
                else//高了
                {
                    showImgV.bounds = CGRectMake(0, 0, (SCREEN_SIZE.height - 40)*image.size.width/image.size.height, SCREEN_SIZE.height - 40);
                }
                
                showImgV.center = CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height/2 - 20);
            }];
            [backV addSubview:showImgV];
            [_scrollView addSubview:backV];
            
        }
        
        _scrollView.pagingEnabled = YES;
//        _scrollView.clipsToBounds = YES;
        [self addSubview:_scrollView];
        
        _scrollView.contentOffset = CGPointMake(SCREEN_SIZE.width * aIndex, 0);
        if (!pageLab)
        {
            pageLab =[[UILabel alloc]initWithFrame:CGRectMake(16, 20, SCREEN_SIZE.width - 32, 20)];
        }
        pageLab.textColor =[UIColor whiteColor];
        pageLab.font =[UIFont systemFontOfSize:15];
        pageLab.text =[NSString stringWithFormat:@"%ld/%lu",(long)aIndex+1,(unsigned long)aImgArr.count];
        
        [self addSubview:pageLab];
        [self bringSubviewToFront:pageLab];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger showAt =scrollView.contentOffset.x/SCREEN_SIZE.width;
    pageLab.text =[NSString stringWithFormat:@"%ld/%0.f",(long)showAt+1,(unsigned long)scrollView.contentSize.width/SCREEN_SIZE.width];
    
}

-(void)show
{
    UIWindow * mainWindow =[UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.36 animations:^{
        
//        self.frame = CGRectMake(0, 0,SCREEN_SIZE.width , SCREEN_SIZE.height);
        self.alpha = 1;
        
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.36f animations:^{
        
//        self.frame = CGRectZero;
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
