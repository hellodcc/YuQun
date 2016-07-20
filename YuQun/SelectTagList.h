//
//  SelectTagList.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTagList : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame withFont:(NSInteger )font;
- (void)setAllTags:(NSArray *)allTagArr withSelectArr:(NSArray *)selectArr;
-(CGFloat)SelectTagListHeight;
-(NSMutableArray *)allSelectTag;
@end
