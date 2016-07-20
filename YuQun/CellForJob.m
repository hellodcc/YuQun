//
//  CellForJob.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "CellForJob.h"
#import "AHeader.h"
#import "UIView+SDAutoLayout.h"

#import "UIView+MJ.h"
@implementation CellForJob

- (void)awakeFromNib {
    self.lastLab.textColor = [UIColor grayColor];
    self.timeLab.textColor =[UIColor grayColor];
    self.lineView.frame = CGRectMake(SCREEN_SIZE.width/11*5, 30, 1, 30);
   
}

-(void)configUIWithModel:(JobInfo *)jobModel WithSegementIndex:(NSInteger)index withYijieModel:(YijieRenWu *)yiJIeModel
{
    if ([jobModel.taskIsnew isEqualToString:@"0"])
    {
        self.ImgV.hidden=YES;
    }
    else
    {
        self.ImgV.hidden=NO;
    }
    if (index==3)
    {
        self.stateImg.hidden=NO;
        self.stateImg.image=[UIImage imageNamed:@"icon_ok350"];
    }else if(index==4)
    {
        self.stateImg.hidden=NO;
        self.stateImg.image=[UIImage imageNamed:@"icon_fail350"];
    }
    
    self.moneyTwo.text = jobModel.PriceStr;
    self.lastLab.text =[NSString stringWithFormat:@"剩余任务量：%ld",[jobModel.TaskPersonLimit integerValue] - [jobModel.TaskAcceptNum integerValue]];
    self.titleLab.text = jobModel.Title;
    self.timeLab.text =[NSString stringWithFormat:@"预计%@可完成任务",jobModel.ExpectedToTakeTimeStr];
    NSMutableArray *tagsArr=[NSMutableArray arrayWithArray: [jobModel.TagsString componentsSeparatedByString:@","]];

    [tagsArr removeLastObject];
    
    UIView *contentView = self.contentView;
    
    self.ImgV.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .widthIs(25)
    .heightIs(25);
    
    self.stateImg.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .widthIs(60)
    .heightIs(60);
    
    self.moneyOne.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 26)
    .widthIs(15)
    .heightIs(20);
    
    self.moneyTwo.sd_layout
    .leftSpaceToView(self.moneyOne, 0)
    .topSpaceToView(self.contentView, 24)
    .heightIs(20);
    [self.moneyTwo setSingleLineAutoResizeWithMaxWidth:SCREEN_SIZE.width];
    
    self.moneyThree.sd_layout
    .leftSpaceToView(self.moneyTwo, 0)
    .topSpaceToView(contentView, 26)
    .widthIs(30)
    .heightIs(20);
    
    self.lastLab.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(self.contentView, 50)
    .rightSpaceToView(self.lineView,20)
    .heightIs(20);
    
    self.titleLab.sd_layout
    .leftSpaceToView(self.lineView, 20)
    .topSpaceToView(contentView, 8)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);
    
    self.timeLab.sd_layout
    .leftSpaceToView(self.lineView, 20)
    .topSpaceToView(self.titleLab, 6)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);

    if ([tagsArr count]!=0)
    {
        LabTagView *tagView=[[LabTagView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width/11*6-40, 0) withFont:13];
        [tagView setAllTags:tagsArr];
        [self.contentView addSubview:tagView];
        
        tagView.sd_layout
        .leftSpaceToView(self.lineView, 20)
        .topSpaceToView(self.timeLab, 8)
        .rightSpaceToView(contentView,20)
        .heightIs(tagView.height);
        if (index==2)
        {
            self.checkLab.hidden=NO;
            self.checkLab.sd_layout
            .leftSpaceToView(contentView, 0)
            .topSpaceToView(tagView, 8)
            .rightSpaceToView(contentView,0)
            .heightIs(15);
            self.checkLab.text=[NSString stringWithFormat:@"上传时间：%@预计24H审核完",yiJIeModel.OrderFinlishDate];
            [self setupAutoHeightWithBottomView:self.checkLab bottomMargin:0];
        }else
        {
            [self setupAutoHeightWithBottomViewsArray:@[self.lastLab,tagView] bottomMargin:8];
        }
        
        
    }else
    {
        if (index==2)
        {
            if (self.timeLab.y+self.timeLab.height>self.lastLab.y+self.lastLab.height)
            {
                self.checkLab.hidden=NO;
                self.checkLab.sd_layout
                .leftSpaceToView(contentView, 0)
                .topSpaceToView(self.timeLab, 8)
                .rightSpaceToView(contentView,0)
                .heightIs(15);

            }else
            {
                self.checkLab.hidden=NO;
                self.checkLab.sd_layout
                .leftSpaceToView(contentView, 0)
                .topSpaceToView(self.lastLab, 8)
                .rightSpaceToView(contentView,0)
                .heightIs(15);
            }
            self.checkLab.text=[NSString stringWithFormat:@"上传时间：%@预计24H审核完",yiJIeModel.OrderFinlishDate];
            [self setupAutoHeightWithBottomView:self.checkLab bottomMargin:0];
        }else
        {
            [self setupAutoHeightWithBottomViewsArray:@[self.lastLab,self.timeLab] bottomMargin:8];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
