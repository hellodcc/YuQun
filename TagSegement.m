//
//  TagSegement.m
//  XiGuaPai
//
//  Created by 董冲冲 on 16/4/13.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "TagSegement.h"
#import "AHeader.h"
#import "UIView+MJ.h"

#define  Tag_Font 13
#define AnimateDuration 0.3
@implementation TagSegement

{

    NSInteger count;
    CGFloat width;

}
-(id)initWithSelectIndex:(NSInteger)selectIndex with:(NSArray *)titles WithFrame:(CGRect)frame;
{
    
    self = [super init];
    if (self) {
        self.frame =frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=frame.size.height/2;
        self.layer.borderWidth=1;
        self.layer.borderColor=COLOR_NAV.CGColor;
        self.clipsToBounds = YES;
        
        count=[titles count];
        width=frame.size.width/count;
        for (int i=0; i<[titles count]; i++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0+width*i, 0, width,frame.size.height );
            [button setTitle:titles[i] forState:UIControlStateNormal];
            
            [button setTitleColor:COLOR_NAV forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.titleLabel.font=[UIFont systemFontOfSize:Tag_Font];
            button.tag=100+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i==0)
            {
                button.selected=YES;
                [button setBackgroundColor:COLOR_NAV];
            }else
            {
                button.selected=NO;
                [button setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
    return self;
}


-(void)buttonClick:(UIButton *)sender
{
    
    for (int i=0;i<count; i++)
    {
        if (sender.tag==100+i)
        {
            [self.delegate tagSegmentView:self didChooseAtIndex:i];
            sender.selected=YES;
            [sender setBackgroundColor:COLOR_NAV];
        }else
        {
            UIButton *btn=(UIButton *)[self viewWithTag:100+i];
            btn.selected=NO;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

-(void)segementDidChooseAtIndex:(NSInteger)index
{
    for (int i=0;i<count; i++)
    {
        
        UIButton *btn=(UIButton *)[self viewWithTag:100+i];
        if (index==i)
        {
            btn.selected=YES;
            [btn setBackgroundColor:COLOR_NAV];
            
        }else
        {
            btn.selected=NO;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        

        
    }
    
    

    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGSize)sizeForText:(NSString *)text Width:(CGFloat)aWidth Height:(CGFloat)aHeight Font:(NSInteger)aFont
{
    NSStringDrawingOptions option =NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:aFont] forKey:NSFontAttributeName];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(aWidth, aHeight)
                                     options:option
                                  attributes:attributes
                                     context:nil];
    
    return rect.size;
}
@end
