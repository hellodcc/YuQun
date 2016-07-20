//
//  XuXian.m
//  CheNiuNiu
//
//  Created by dcc on 16/1/20.
//  Copyright © 2016年 何威. All rights reserved.
//

#import "XuXian.h"
#import "AHeader.h"
@implementation XuXian

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=COLOR_BACK;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, COLOR_TEXTWHITE.CGColor);
    CGFloat lengths[] = {1,20};
    CGContextSetLineDash(context, 0, lengths,1);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    
}

@end
