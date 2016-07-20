//
//  MyPickerView.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "MyPickerView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
@interface MyPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *pickData;
}
@end
@implementation MyPickerView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        pickData=data;
        [self makePickerView];
    }
    return self;
}
-(void)makePickerView
{
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.width, 180)];
    pickerView.tag=110;
    pickerView.backgroundColor=COLOR_BACK;
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [self addSubview:pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickData objectAtIndex:row];
}


// 返回视图视图中指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}


//返回指定列的行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate myPickerViewdidSelectRowTitle:[pickData objectAtIndex:row] withIndex:row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
