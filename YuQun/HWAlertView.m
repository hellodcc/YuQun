//
//  HWAlertView.m
//  TianTianLianCheS
//
//  Created by chehuiMAC on 15/8/5.
//  Copyright (c) 2015年 何威. All rights reserved.
//

#import "HWAlertView.h"
#import "AHeader.h"

@implementation HWAlertView
{
    UIView * backView;
}

-(id)initWithTitle:(NSString *)aTitle
{
    self = [super init];
    if (self)
    {
//        //灰色蒙版
//        CALayer *  grayCover = [[CALayer alloc]init];
//        grayCover.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
//        grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:.7f] CGColor];
//        [self.layer addSublayer:grayCover];
        backView = [[UIView alloc]init];
        UILabel * contentLab = [[UILabel alloc]init];
        //
        CGSize aSize = [self sizeWithText:aTitle];
        
        if (aSize.height < 30) {
            backView.frame =CGRectMake((SCREEN_SIZE.width-aSize.width)/2 -10, SCREEN_SIZE.height/2 - 20, aSize.width+20, 40);
            contentLab.frame =CGRectMake(10, 10, aSize.width, 20);
        }
        else
        {
            backView.frame = CGRectMake(20, SCREEN_SIZE.height/2 - aSize.height/2 - 10, SCREEN_SIZE.width - 40, aSize.height + 20);
            contentLab.frame = CGRectMake(10, 10, SCREEN_SIZE.width - 60, aSize.height);
        }
        backView.backgroundColor = [UIColor blackColor];
        backView.clipsToBounds = YES;
        backView.layer.cornerRadius = 20;
        
        [self addSubview:backView];
        contentLab.font = [UIFont systemFontOfSize:16];
        contentLab.numberOfLines = 0;
        contentLab.lineBreakMode = NSLineBreakByCharWrapping;
//        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.textColor = [UIColor whiteColor];
        contentLab.text = aTitle;
        [backView addSubview:contentLab];
        backView.alpha = 0;
        
        
    }
    return self;
}

-(void)show
{
    UIWindow * keyWindow = [UIApplication sharedApplication ].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:1.5f animations:^{
        
        backView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self dismiss];
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:1.5f animations:^{
        
        backView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
//计算长宽
-(CGSize)sizeWithText:(NSString *)aText
{
  CGSize aSize = [aText boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|
                  NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil].size;
    return aSize;
}

@end
