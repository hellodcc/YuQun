//
//  LabTagView.h
//  鱼群
//
//  Created by 董冲冲 on 16/6/28.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabTagView : UIView
- (instancetype)initWithFrame:(CGRect)frame withFont:(NSInteger )font;
- (void)setAllTags:(NSArray *)allTagArr ;
-(CGFloat)SelectTagListHeight;
@end
