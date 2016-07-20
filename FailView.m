//
//  FailView.m
//  XiGuaPai
//
//  Created by 董冲冲 on 16/6/2.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "FailView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
@implementation FailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=COLOR_BACK;
        
        UIImageView * imgV =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 70, 20, 140, 140)];
        imgV.image =[UIImage imageNamed:@"no-data"];
        [self addSubview:imgV];
        
        UILabel * alable =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 80, 170, 160, 20)];
        alable.text = @"暂无相关任务";
        alable.font =[UIFont systemFontOfSize:15];
        alable.textColor = COLOR_RBG(200, 200, 200);
        alable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:alable];

//        UILabel *failLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, frame.size.width, 20)];
//        failLab.text=@"数据加载失败";
//        failLab.textColor=COLOR_RBG(50, 50, 50);
//        failLab.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:failLab];
//        
//        
//        UILabel *desLab=[[UILabel alloc]initWithFrame:CGRectMake(0, failLab.height+failLab.y+10, frame.size.width, 20)];
//        desLab.text=@"请确保网络正常,点击重新加载";
//        desLab.textColor=COLOR_RBG(50, 50, 50);
//        desLab.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:desLab];
//        
//        
//        UIButton *reBtn=[UIButton buttonWithType:UIButtonTypeSystem];
//        [reBtn setTitle:@"重新刷新" forState:UIControlStateNormal];
//        [reBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [reBtn setBackgroundColor:COLOR_NAV];
//        reBtn.frame=CGRectMake(( frame.size.width-100)/2, desLab.y+desLab.height+20, 100, 30);
//        [reBtn addTarget:self action:@selector(rebtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        reBtn.layer.masksToBounds=YES;
//        reBtn.layer.cornerRadius=5;
//        [self addSubview:reBtn];
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
