//
//  BlueLab.m
//  XiGuaPai
//
//  Created by 董冲冲 on 16/4/20.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "BlueLab.h"
#import "AHeader.h"
@implementation BlueLab
//zheshigeceshi

//ni
-(instancetype)init
{
    self=[super init];
    
    if (self)
    {
        
    }
    return self;
}


-(void)setText:(NSString *)text
{
    [super setText:text];
    
    NSArray *fontArr=[self.font.description componentsSeparatedByString:@";"];
    NSString *fontSize=[fontArr lastObject];
    NSString *font=[[fontSize substringFromIndex:12] substringToIndex:5];
    
    if (self.BlueStr)
    {
        NSRange range = [text rangeOfString:self.BlueStr];
        NSInteger length=[text length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_RBG(51, 51, 51) range:NSMakeRange(0,range.location+1)];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_NAV range:NSMakeRange(range.location,range.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_RBG(51, 51, 51) range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
        if (self.size)
        {
            if (self.blackSize)
            {
                
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.blackSize floatValue]] range:NSMakeRange(0,range.location+1)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.size floatValue]] range:NSMakeRange(range.location,range.length)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.blackSize floatValue]] range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
            }else
            {
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.size floatValue]] range:NSMakeRange(0,range.location+1)];
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.size floatValue]] range:NSMakeRange(range.location,range.length)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[self.size floatValue]] range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
            }
            
        }else
        {
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[font floatValue]] range:NSMakeRange(0,range.location+1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[font floatValue]] range:NSMakeRange(range.location,range.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:[font floatValue]] range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
        }
        self.attributedText = str;
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
