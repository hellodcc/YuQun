//
//  Baozhengjinshuoming.h
//  YuQun
//
//  Created by chehuiMAC on 16/3/24.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Baozhengjinshuoming : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}


-(id)initWithInfo:(NSArray *)aInfo;

-(void)show;

@end
