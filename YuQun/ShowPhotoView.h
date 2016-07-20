//
//  ShowPhotoView.h
//  YuQun
//
//  Created by chehuiMAC on 16/3/30.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoView : UIView<UIScrollViewDelegate>

-(id)initWithImages:(NSArray *)aImgArr Type:(NSInteger)aType atIndex:(NSInteger)aIndex;
-(void)show;

@end
