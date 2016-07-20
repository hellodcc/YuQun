//
//  CellForJob.h
//  YuQun
//
//  Created by chehuiMAC on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "LabTagView.h"
@interface CellForJob : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *checkLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

@property (weak, nonatomic) IBOutlet UIImageView *ImgV;
@property (weak, nonatomic) IBOutlet UILabel *moneyOne;
@property (weak, nonatomic) IBOutlet UILabel *moneyTwo;
@property (weak, nonatomic) IBOutlet UILabel *moneyThree;
@property (weak, nonatomic) IBOutlet UILabel *lastLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)configUIWithModel:(JobInfo *)jobModel WithSegementIndex:(NSInteger)index withYijieModel:(YijieRenWu *)yiJIeModel;

@end
