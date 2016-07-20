//
//  InviteListCell.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/9.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redLab.h"
@interface InviteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inviteNameLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteTimeLab;
@property (weak, nonatomic) IBOutlet redLab *inviteMoneyLab;

@end
