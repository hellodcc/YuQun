//
//  LabTagView.m
//  鱼群
//
//  Created by 董冲冲 on 16/6/28.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "LabTagView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#define SPACE_WIETH 2
#define SPACE_HEIGHT 5
@implementation LabTagView
{
    NSInteger  tagFont;
    CGRect    sizeFit;
}

- (instancetype)initWithFrame:(CGRect)frame withFont:(NSInteger )font
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        tagFont=font;
        self.clipsToBounds=YES;
        
    }
    return self;
    
}

- (void)setAllTags:(NSArray *)allTagArr
{
    
    sizeFit = CGRectMake(0, 0, 0, 0);
    
    for (int i=0; i<[allTagArr count]; i++)
    {
        
        NSString *tagStr=[allTagArr objectAtIndex:i];
        CGFloat width=[self widthForText:tagStr Font:tagFont];
        CGFloat height=[self heightForText:tagStr Font:tagFont];
        
        //        if ([tagStr isEqualToString:@" "])
        //        {
        //            break;
        //        }
        
        if (sizeFit.origin.x+width+SPACE_WIETH>self.width)
        {
            sizeFit.origin.y+=height+SPACE_HEIGHT;
            sizeFit.size.height+=height+SPACE_HEIGHT;
            sizeFit.origin.x=SPACE_WIETH;
        }
        
        
        UILabel *tagLab=[[UILabel alloc]initWithFrame:CGRectMake(sizeFit.origin.x, sizeFit.origin.y, width, height)];
        tagLab.textColor=COLOR_NAV;
        tagLab.layer.masksToBounds=YES;
        tagLab.layer.cornerRadius=height/2;
        tagLab.layer.borderWidth=1;
        tagLab.layer.borderColor=COLOR_NAV.CGColor;
        tagLab.textAlignment=NSTextAlignmentCenter;
        tagLab.text=tagStr;
        
        
        tagLab.font=[UIFont systemFontOfSize:tagFont];
        
        [self addSubview:tagLab];
        sizeFit.origin.x+=width+SPACE_WIETH;
        
        if (i==[allTagArr count]-1)
        {
            sizeFit.size.height+=height;
        }
        
    }
    
    self.height=sizeFit.size.height;
}


-(CGFloat)SelectTagListHeight
{
    return self.height;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(CGFloat)widthForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    
    return textSize.width+15;
}

//计算文字高度
-(CGFloat)heightForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.height+5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
