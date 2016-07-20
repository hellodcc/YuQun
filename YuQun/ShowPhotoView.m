//
//  ShowPhotoView.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/30.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ShowPhotoView.h"
#import "UIImageView+WebCache.h"
#import "AHeader.h"

@implementation ShowPhotoView
{
    UIScrollView * _scrollView;
}

-(id)initWithImages:(NSArray *)aImgArr Type:(NSInteger)aType atIndex:(NSInteger)aIndex
{
    self =[super init];
    
    
    if (self)
    {
        self.frame = CGRectMake(0, 0,SCREEN_SIZE.width , SCREEN_SIZE.height);
        self.backgroundColor =[UIColor blackColor];
        self.clipsToBounds = YES;
        
        if (!_scrollView) {
            _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, SCREEN_SIZE.height - 40)];
        }
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        for (int i =0; i< [aImgArr count]; i++)
        {
            UIImageView * imgView =[[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
            
            if (aType == 4)
            {
                NSString * aStr =aImgArr[i];
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:aStr] placeholderImage:[UIImage imageNamed:@"myinviteintro"]];
                
            }
            else
            {
                imgView.image =aImgArr[i];
            }
            
            UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSmall:)];
            [_scrollView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imgView];
        }
        
        _scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width* [aImgArr count]+1, SCREEN_SIZE.height-40);
        _scrollView.contentOffset = CGPointMake(SCREEN_SIZE.width * aIndex, 0);
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)show
{
    UIWindow * mainWindow =[UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self];
    

}

-(void)dismiss
{
    self.alpha = 0;
    [self removeFromSuperview];
}

-(void)clickSmall:(id)sender
{
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
