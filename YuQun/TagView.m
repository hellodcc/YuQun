//
//  TagView.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "TagView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "DWTagList.h"
#import "SelectTagList.h"
#import "AFNetworkingManager.h"
#import "Model.h"
@interface TagView ()
@end
@implementation TagView
{
    UIView *bgView;
    UILabel *titleLab;
    SelectTagList *selectTagList;
    NSMutableArray *userTagArr;
    NSArray *selectArray;
}
- (instancetype)initWithFrame:(CGRect)frame WithSelectArr:(NSArray *)selectArr
{
    self = [super initWithFrame:frame];
    if (self) {
        userTagArr=[NSMutableArray arrayWithCapacity:0];
        self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        //灰色蒙版
        CALayer *  grayCover = [[CALayer alloc]init];
        grayCover.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor];
        [self.layer addSublayer:grayCover];
        selectArray=selectArr;
        [self makeUI];
        [self getTypeOfUserTags];
    
//        [self makeUI];

        
    }
    return self;
}
-(void)getTypeOfUserTags
{
    [AFNetworkingManager getTypeOfUserTagssucceed:^(id complate) {
        NSArray *arr=complate;
        [userTagArr removeAllObjects];
        for (NSDictionary *dic in arr)
        {
            userTagsModel *model=[[userTagsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [userTagArr addObject:model];
        }
        [self changUI];
    } Failed:^(id error) {
        
    }];
}
-(void)makeUI
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width-300.0)/2.0, (self.height-280)/2, 300, 280)];
    bgView.backgroundColor=COLOR_BACK;
    [self addSubview:bgView];
    
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=5;
    
   titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 30)];
    titleLab.text=@"编辑个人标签";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:12];
    titleLab.textColor=[UIColor blackColor];
    [bgView addSubview:titleLab];
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(bgView.width-titleLab.height, 0, titleLab.height, titleLab.height);
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];    
}


-(void)changUI
{
    UIView *tagBgView=[[UIView alloc]initWithFrame:CGRectMake(0, titleLab.height, bgView.width, bgView.height-titleLab.height)];
    tagBgView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:tagBgView];
    
    
    UILabel *tagTitLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 8, bgView.width, 20)];
    tagTitLab.text=@"设置正确的标签便于您接到更多优质服务";
    tagTitLab.textAlignment=NSTextAlignmentCenter;
    tagTitLab.font=[UIFont systemFontOfSize:12];
    tagTitLab.textColor=[UIColor orangeColor];
    [tagBgView addSubview:tagTitLab];
    
    selectTagList=[[SelectTagList alloc]initWithFrame:CGRectMake(10,tagTitLab.y+tagTitLab.height+5, tagBgView.width-20, 200) withFont:15];
    [selectTagList setAllTags:userTagArr withSelectArr:selectArray];
    [tagBgView addSubview:selectTagList];
    selectTagList.height=[selectTagList  SelectTagListHeight];
    
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"保存标签" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame=CGRectMake(20, selectTagList.height+selectTagList.y+20 , tagBgView.width-40 ,30);
    nextBtn.layer.masksToBounds=YES;
    nextBtn.backgroundColor=[UIColor orangeColor];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=nextBtn.height/2;
    [tagBgView addSubview:nextBtn];
    
    bgView.y=(SCREEN_SIZE.height-titleLab.height-nextBtn.y-nextBtn.height-10)/2;
    bgView.height=titleLab.height+nextBtn.y+nextBtn.height+10;
    tagBgView.height=nextBtn.y+nextBtn.height+10;
}
-(void)nextBtnClick:(UIButton *)btn
{
    
    [self.delegat allTage:[selectTagList allSelectTag]];
    [self dismiss];
}
-(void)closeBtnClick:(UIButton *)btn
{
    [self dismiss];
}
-(void)dismiss
{
    [self removeFromSuperview];
}
-(void)allSelectTag:(NSArray *)allSelectTag
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
