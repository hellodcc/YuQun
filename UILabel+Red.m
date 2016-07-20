//
//  UILabel+Red.m
//  鱼群
//
//  Created by 董冲冲 on 16/4/5.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "UILabel+Red.h"

@implementation UILabel (Red)
//显示小红点

- (void)showBadgeWithBadgeNum:(NSString *)num
{
    //移除之前的小红点
    [self removeBadge];
    
    //新建小红点
    UILabel *numLab=[[UILabel alloc]init];
    numLab.text=num;
    numLab.backgroundColor=[UIColor redColor];
    numLab.layer.masksToBounds=YES;
    numLab.layer.cornerRadius = ([self widthForText:@"1" Font:11]+10)/2;//圆形
    numLab.font=[UIFont systemFontOfSize:11];
    numLab.textColor=[UIColor whiteColor];
    numLab.textAlignment=NSTextAlignmentCenter;
    
    CGRect btnFrame = self.frame;
    
    //确定小红点的位置
    float percentX =0.9;
    CGFloat x = ceilf(percentX * btnFrame.size.width);
    CGFloat y = ceilf(0.1 * btnFrame.size.height);
    numLab.frame = CGRectMake(x, -y, [self widthForText:num Font:11]+10, [self widthForText:@"1" Font:11]+10);//圆形大小为10
    
    [self addSubview:numLab];

}
- (void)showBadge{
    //移除之前的小红点
    [self removeBadge];
    
    //新建小红点

    UIView *badgeView = [[UIView alloc]init];
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect btnFrame = self.frame;
    
    //确定小红点的位置
    float percentX =0.9;
    CGFloat x = ceilf(percentX * btnFrame.size.width);
    CGFloat y = ceilf(0.1 * btnFrame.size.height);
    badgeView.frame = CGRectMake(x, -y, 10, 10);//圆形大小为10
    
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadge{
    //移除小红点
    [self removeBadge];
}

//移除小红点
- (void)removeBadge{
    //按照tag值进行移除
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(CGFloat)widthForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.width;
}
@end
