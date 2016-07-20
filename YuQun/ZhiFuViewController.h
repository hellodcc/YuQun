//
//  ZhiFuViewController.h
//  YuQun
//
//  Created by chehuiMAC on 16/3/24.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiFuViewController : UIViewController

@property(nonatomic,retain)NSString * baozhengjin;

@property (weak, nonatomic) IBOutlet UIView *backTop;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyLab;
@property (weak, nonatomic) IBOutlet UIView *backChongZhi;
@property (weak, nonatomic) IBOutlet UITextField *jinErText;
@property (weak, nonatomic) IBOutlet UIButton *ChongZhiBtn;
- (IBAction)chongzhiBtnClick:(id)sender;

@end
