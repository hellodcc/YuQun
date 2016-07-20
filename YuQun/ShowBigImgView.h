//
//  ShowBigImgView.h
//  XiGuaPai
//
//  Created by chehuiMAC on 16/6/3.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBigImgView : UIView<UIScrollViewDelegate>

//@property(nonatomic,assign)NSInteger showAtIndex;

-(id)initWithImgArr:(NSArray *)aImgArr showIndex:(NSInteger)aIndex;
-(void)show;


@end
