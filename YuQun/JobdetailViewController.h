//
//  JobdetailViewController.h
//  YuQun
//
//  Created by chehuiMAC on 16/3/14.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "FatherViewController.h"
#import "Model.h"

@protocol JobdetailViewControllerDelegate <NSObject>

-(void)qiangdang;
-(void)uploadImg;
-(void)fangqirenwu;

@end


@interface JobdetailViewController : FatherViewController

@property(nonatomic,retain)NSString * taskID;
@property(nonatomic,assign)NSInteger jobType;
@property(nonatomic,retain)YijieRenWu * yijiejobM;
@property(nonatomic,assign)id<JobdetailViewControllerDelegate>delegate;

@end
