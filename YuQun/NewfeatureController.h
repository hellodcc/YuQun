//
//  NewfeatureController.h
//  车惠
//
//  Created by dcc on 16/1/6.
//  Copyright © 2016年 dcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewfeatureControllerDelegate<NSObject>
-(void)endNewfeature;
@end

@interface NewfeatureController : UIViewController
@property (nonatomic ,assign)id<NewfeatureControllerDelegate>delagete;
@property (weak, nonatomic) IBOutlet UIScrollView *newfeatureSV;
@end
