//
//  OrangeLab.m
//  GouCheTong
//
//  Created by dcc on 15/10/29.
//  Copyright © 2015年 dcc. All rights reserved.
//

#import "OrangeLab.h"
#import "AHeader.h"
@implementation OrangeLab

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
    if (self.orangeSr)
    {
        NSRange range = [text rangeOfString:self.orangeSr];
        NSInteger length=[text length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_RBG(105, 115, 127) range:NSMakeRange(0,range.location+1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range.location,range.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_RBG(105, 115, 127) range:NSMakeRange(range.location+range.length,length-range.location-range.length)];
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
