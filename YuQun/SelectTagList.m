//
//  SelectTagList.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "SelectTagList.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#define SPACE_WIETH 8
#define SPACE_HEIGHT 5
#import "Model.h"
@implementation SelectTagList
{
     NSArray     *textArray;
    CGRect    sizeFit;
    NSInteger  tagFont;
}
- (instancetype)initWithFrame:(CGRect)frame withFont:(NSInteger )font
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        tagFont=font;
        self.height=400;
        
    }
    return self;
}
- (void)setAllTags:(NSArray *)allTagArr withSelectArr:(NSArray *)selectArr
{
     textArray = [[NSArray alloc] initWithArray:allTagArr];
    sizeFit = CGRectMake(SPACE_WIETH, SPACE_HEIGHT, 0, 0);

    for (int i=0; i<[allTagArr count]; i++)
    {
        userTagsModel *model=[allTagArr objectAtIndex:i];
        
        NSString *tagStr=model.Name;
        CGFloat width=[self widthForText:tagStr Font:tagFont];
        CGFloat height=[self heightForText:tagStr Font:tagFont];

        if (sizeFit.origin.x+width+SPACE_WIETH>self.width)
        {
            sizeFit.origin.y+=height+SPACE_HEIGHT;
            sizeFit.size.height+=height+SPACE_HEIGHT;
            sizeFit.origin.x=SPACE_WIETH;
        }
        UIButton *tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectMake(sizeFit.origin.x, sizeFit.origin.y, width, height);
        tagBtn.tag=100+i;
        sizeFit.origin.x+=width+SPACE_WIETH;
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:tagFont];
        tagBtn.layer.masksToBounds=YES;
        tagBtn.layer.cornerRadius=height/2;
        
        [tagBtn setTitle:tagStr forState:UIControlStateNormal];
        [tagBtn setTitle:tagStr forState:UIControlStateSelected];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [tagBtn setTitleColor:COLOR_NAV forState:UIControlStateNormal];
        
        for (NSString *selectTagStr in selectArr)
        {
            if ([selectTagStr isEqual:tagStr])
            {
                tagBtn.backgroundColor=COLOR_NAV;
                tagBtn.selected=YES;
                tagBtn.layer.borderWidth=0.5;
                tagBtn.layer.borderColor=COLOR_NAV.CGColor;
                break;

            }else
            {
                tagBtn.backgroundColor=[UIColor whiteColor];
                tagBtn.selected=NO;
                tagBtn.layer.borderWidth=0.5;
                tagBtn.layer.borderColor=COLOR_NAV.CGColor;
            }
        }
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagBtn];
        if (i==[allTagArr count]-1)
        {
            sizeFit.size.height+=height+SPACE_HEIGHT;
        }
        
    }
    
}


-(void)tagBtnClick:(UIButton *)tagBtn
{
    if (tagBtn.selected==YES)
    {
      
        tagBtn.backgroundColor=[UIColor whiteColor];
        tagBtn.selected=NO;
        tagBtn.layer.borderWidth=0.5;
        tagBtn.layer.borderColor=COLOR_NAV.CGColor;
    }else
    {
        tagBtn.backgroundColor=COLOR_NAV;
        tagBtn.selected=YES;
        tagBtn.layer.borderWidth=0.5;
        tagBtn.layer.borderColor=COLOR_NAV.CGColor;
    }
    
}

-(NSMutableArray *)allSelectTag
{
    NSMutableArray *allSlectTag=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<[textArray count]; i++)
    {
        UIButton *btn1=(id )[self viewWithTag:100+i];
        
        if (btn1.selected==YES)
        {
            [allSlectTag addObject:[textArray objectAtIndex:i]];
        }
    }
    return allSlectTag;
}
-(CGFloat)SelectTagListHeight
{
    return sizeFit.size.height;
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
    
    return textSize.width+10;
}

//计算文字高度
-(CGFloat)heightForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.height+5;
}

@end


