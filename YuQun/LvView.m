//
//  LvView.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "LvView.h"

@implementation LvView
-(instancetype)initWithLV:(NSString *)lv num:(NSInteger )num withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
//        UILabel *xinYongLab=[UILabel alloc]
       
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

@end
