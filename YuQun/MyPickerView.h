//
//  MyPickerView.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyPickerViewDelegate<NSObject>
-(void)myPickerViewdidSelectRowTitle:(NSString *)title withIndex:(NSInteger )index;
@end
@interface MyPickerView : UIView
- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)data;
@property(nonatomic,assign)id<MyPickerViewDelegate>delegate;
@end
