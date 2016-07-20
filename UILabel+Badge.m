//
//  UILabel+Badge.m
//  GouCheTong
//
//  Created by dcc on 15/10/30.
//  Copyright © 2015年 dcc. All rights reserved.
//

#import "UILabel+Badge.h"
#import "AHeader.h"
@implementation UILabel (Badge)
//显示小红点
- (void)showSFZBadge{
    //移除之前的小红点
    [self removeBadge];
    
    UIImageView *sfzImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sfz"]];
//    UILabel *lvLab=[[UILabel alloc]init];
//    lvLab.text=lv;
//    lvLab.backgroundColor=COLOR_CHENG;
//    lvLab.layer.masksToBounds=YES;
//    lvLab.layer.cornerRadius = 5;//圆形
//    lvLab.font=[UIFont systemFontOfSize:11];
//    lvLab.textColor=[UIColor whiteColor];
//    lvLab.textAlignment=NSTextAlignmentCenter;
    
    CGRect btnFrame = self.frame;
    
    //确定小红点的位置
    float percentX =1;
    CGFloat x = ceilf(percentX * btnFrame.size.width);
    CGFloat y = ceilf(0.5 * btnFrame.size.height);
    sfzImage.frame = CGRectMake(x, -y, 15, 15);
    [self addSubview:sfzImage];
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


-(CGFloat)widthForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    
    return textSize.width;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
