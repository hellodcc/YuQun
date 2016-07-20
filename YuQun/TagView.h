//
//  TagView.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TagViewDelegate<NSObject>
-(void)allTage:(NSMutableArray *)allTag;
@end
@interface TagView : UIView
- (instancetype)initWithFrame:(CGRect)frame WithSelectArr:(NSArray *)selectArr;
@property(nonatomic,assign)id<TagViewDelegate>delegat;
@end
