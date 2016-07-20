//
//  CellForreward.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "CellForreward.h"
#import "AHeader.h"

@implementation CellForreward

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLab.frame = CGRectMake(8, 5,SCREEN_SIZE.width - 100, 20) ;
    
    self.timeLab.frame = CGRectMake(8, 25,SCREEN_SIZE.width - 100, 20) ;
   // self.timeLab.textColor =[UIColor lightGrayColor];
    self.timeLab.font =[UIFont systemFontOfSize:12];
    
    
    self.moneyLab.frame = CGRectMake(SCREEN_SIZE.width - 120, 11, 110, 20);
    self.moneyLab.textAlignment = NSTextAlignmentRight;
    self.moneyLab.textColor =COLOR_Red;
    self.moneyLab.font = [UIFont systemFontOfSize:14];
    
    UIView * lineV =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_SIZE.width, 1.0f)];
    self.lineV.frame =CGRectMake(0, self.frame.size.height - 1, SCREEN_SIZE.width, 1);
    self.lineV.backgroundColor =COLOR_BACK;
    [self.contentView addSubview:lineV];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
