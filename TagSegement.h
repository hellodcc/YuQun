//
//  TagSegement.h
//  XiGuaPai
//
//  Created by 董冲冲 on 16/4/13.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagSegementDelegate;

@interface TagSegement : UIView

@property (nonatomic, assign)id <TagSegementDelegate> delegate;
-(id)initWithSelectIndex:(NSInteger)selectIndex with:(NSArray *)titles WithFrame:(CGRect)frame;

-(void)segementDidChooseAtIndex:(NSInteger)index;
@end


@protocol TagSegementDelegate <NSObject>

-(void)tagSegmentView:(TagSegement *)segmentView didChooseAtIndex:(NSInteger)index;

@end