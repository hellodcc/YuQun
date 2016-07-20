//
//  BtnCell.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "BtnCell.h"
#import "UIView+MJ.h"
#import "AHeader.h"
@implementation BtnCell

- (void)awakeFromNib {
    UIView *linView=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, SCREEN_SIZE.width, 1)];
    linView.backgroundColor=COLOR_BACK;
    [self.contentView addSubview:linView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
