//
//  QuestionView.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "QuestionView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#define ZUOYOU_MIN 30
#define SHANGXIA_MIN 50
#import "AFNetworkingManager.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
@implementation QuestionView

{
    NSMutableArray *questionArr;
    UIScrollView *bgScrellView;
}
-(id)initWithTitle:(NSString *)aTitle
{
    if(self = [super init])
    {
        
        questionArr=[NSMutableArray arrayWithCapacity:0];
        self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        //灰色蒙版
        CALayer *  grayCover = [[CALayer alloc]init];
        grayCover.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor];
        [self.layer addSublayer:grayCover];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(30, 80, SCREEN_SIZE.width-60, SCREEN_SIZE.height-160)];
        bgView.backgroundColor=COLOR_BACK;
        bgView.layer.masksToBounds=YES;
        bgView.layer.cornerRadius=3;
        [self addSubview:bgView];
        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 30)];
        titleLab.text=@"邀请朋友问答";
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=[UIColor blackColor];
        [bgView addSubview:titleLab];
        
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=CGRectMake(bgView.width-titleLab.height, 0, titleLab.height, titleLab.height);
        [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:closeBtn];
        bgScrellView.backgroundColor=[UIColor whiteColor];
        
        
        bgScrellView=[[UIScrollView alloc]init];
        bgScrellView.backgroundColor=COLOR_BACK;
        bgScrellView.frame=CGRectMake(0, titleLab.height, bgView.width, bgView.height-titleLab.height-10);
        
        [bgView addSubview:bgScrellView];
        
        
        [self loadData];
     
        
        
    }
    return self;
}

-(void)makeUI
{
    CGFloat Y=0;
    for (AnswerModel *model in questionArr)
    {
        
        UILabel *questionLab=[[UILabel alloc]initWithFrame:CGRectMake(8, Y, bgScrellView.width-16, [self heightForText:model.Queation Font:13])];
        questionLab.text=model.Queation;
        questionLab.numberOfLines=0;
        questionLab.lineBreakMode=NSLineBreakByCharWrapping;
        questionLab.textAlignment=NSTextAlignmentLeft;
        questionLab.font=[UIFont boldSystemFontOfSize:13];
        questionLab.textColor=[UIColor blackColor];
        [bgScrellView addSubview:questionLab];
        
        
        UILabel *answerLab=[[UILabel alloc]initWithFrame:CGRectMake(8, questionLab.height+questionLab.y+10, bgScrellView.width-16, [self heightForText:model.Answer Font:12])];
       
        answerLab.numberOfLines=0;
        answerLab.lineBreakMode=NSLineBreakByCharWrapping;
        answerLab.text=model.Answer;
        answerLab.textAlignment=NSTextAlignmentLeft;
        answerLab.font=[UIFont systemFontOfSize:12];
        answerLab.textColor=[UIColor grayColor];
        [bgScrellView addSubview:answerLab];
        
        
        
        Y=answerLab.height+answerLab.y+10;
        if (model.img.length>0)
        {
            UIImageView *stepImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, answerLab.height+answerLab.y,answerLab.width,400 )];
            [stepImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
//            CGFloat hig=[stepImage.image size].height;
//            stepImage.height=hig;
            [bgScrellView addSubview:stepImage];
            Y=stepImage.height+stepImage.y+10;
        }
        
        
        
    }
    bgScrellView.contentSize=CGSizeMake(0, Y);
}
-(void)loadData
{
    [AFNetworkingManager getConstAnswerYaoqingSucceed:^(id complate) {
        [questionArr removeAllObjects];
        for (NSDictionary  *dic in complate)
        {
            AnswerModel *model=[[AnswerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [questionArr addObject:model];
            
        }
        [self makeUI];
        
    } Failed:^(id error) {
        
    }];
}

-(void)closeBtnClick:(UIButton *)btn
{
    [self dismiss];
}
-(void)dismiss
{
    [self removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//计算文字高度
-(CGFloat)heightForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(bgScrellView.width-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.height;
}

@end
