//
//  MyDataPicker.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "MyDataPicker.h"
#import "AHeader.h"
#import "UIView+MJ.h"
@implementation MyDataPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        //灰色蒙版
        CALayer *  grayCover = [[CALayer alloc]init];
        grayCover.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor];
        [self.layer addSublayer:grayCover];
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    UIView *dataBackView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width-200.0)/2.0, (self.height-150)/2, 200, 150)];
    dataBackView.backgroundColor=[UIColor blackColor];
    [self addSubview:dataBackView];
    
    UILabel *dataLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, dataBackView.width, 20)];
    dataLab.textColor=[UIColor whiteColor];
    [dataBackView addSubview:dataLab];
    
    UIDatePicker *dp = [[UIDatePicker alloc] init];
    dp.frame = CGRectMake(0,20,dataBackView.width , 180);
    dp.datePickerMode = UIDatePickerModeDate;
    [dataBackView addSubview:dp];
    
    UIButton *canBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [canBtn setTitle:@"确定" forState:UIControlStateNormal];
    canBtn.frame=CGRectMake(0, 180, dataBackView.width/2, 20);
    canBtn.backgroundColor=[UIColor blackColor];
    [dataBackView addSubview:canBtn];
    
    UIButton *noBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    noBtn.frame=CGRectMake(dataBackView.width/2, 180, dataBackView.width/2, 20);
    noBtn.backgroundColor=[UIColor blackColor];
    [dataBackView addSubview:noBtn];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
