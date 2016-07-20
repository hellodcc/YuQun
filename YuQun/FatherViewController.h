//
//  FatherViewController.h
//  TonightQunar
//
//  Created by chehuiMAC on 15/3/5.
//  Copyright (c) 2015年 何威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherViewController : UIViewController
{
    UIView *_navView;
    UILabel *_titleLab;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}
@property (retain, nonatomic)UIView *navView;
@property (retain, nonatomic)UILabel *titleLab;
@property (retain, nonatomic)UIButton *leftBtn;
@property (retain, nonatomic)UIButton *rightBtn;

-(id)initWithTitle:(NSString *)aTitle leftButton:(NSString *)aLeftBtn rightButton:(NSString *)aRightBtn;
-(void)leftBtnClick:(id)sender;
-(void)rightBtnClick:(id)sender;

@end
