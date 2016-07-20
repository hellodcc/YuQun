//
//  ImageViewController.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/23.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "FatherViewController.h"

@protocol ImageViewControllerDelegate<NSObject>
-(void)imageDelectWithRow:(NSInteger)row;

@end

@interface ImageViewController : FatherViewController
@property (nonatomic,retain)NSMutableArray *images;
@property (nonatomic,assign)NSInteger row;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;

@property (nonatomic ,assign) id<ImageViewControllerDelegate>delegate;
@end
