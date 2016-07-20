//
//  redLab.m
//  车惠
//
//  Created by dcc on 16/1/21.
//  Copyright © 2016年 dcc. All rights reserved.
//

#import "redLab.h"
#import "AHeader.h"
@implementation redLab

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
    if (self.redStr)
    {
        NSRange range = [text rangeOfString:self.redStr];
        NSInteger length=[text length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_RBG(51, 51, 51) range:NSMakeRange(0,range.location+1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location,range.length)];
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
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11.0] range:NSMakeRange(0,range.location+1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11.0] range:NSMakeRange(range.location,range.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11.0] range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
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
