//
//  NoCopyTextField.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/16.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "NoCopyTextField.h"

@implementation NoCopyTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([UIMenuController sharedMenuController]) {

        [UIMenuController sharedMenuController].menuVisible = NO;

    }
    return NO;
}

@end
