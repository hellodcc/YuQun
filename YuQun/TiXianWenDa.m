//
//  TiXianWenDa.m
//  YuQun
//
//  Created by chehuiMAC on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "TiXianWenDa.h"
#import "AHeader.h"
#import "UIView+MJ.h"
@implementation TiXianWenDa
{
    NSArray * infoArr;
}

-(id)initWithInfo:(NSArray *)aInfo
{
    self = [super init];
    if (self)
    {
        infoArr = aInfo;
        self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        //
        CALayer * layer =[[CALayer alloc]init];
        layer.frame = self.frame;
        layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
        [self.layer addSublayer:layer];
        
        
        UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(30, 90, SCREEN_SIZE.width - 60, SCREEN_SIZE.height - 90 - 300*SCREEN_SIZE.width/667)];
        backV.backgroundColor =COLOR_BACK;
        backV.layer.masksToBounds=YES;
        backV.layer.cornerRadius=3;
        [self addSubview:backV];
        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, backV.width, 30)];
        titleLab.text=@"奖金提现问答";
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [backV addSubview:titleLab];
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(backV.frame.size.width -30, 0, 30 , 30);
        
        btn.tintColor =[UIColor grayColor];
        [btn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backV addSubview:btn];
        
        if (!_tableView) {
            _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 30, backV.frame.size.width, backV.frame.size.height - 30) style:UITableViewStylePlain];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [backV addSubview:_tableView];
        
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     NSDictionary * aDic =[infoArr objectAtIndex:indexPath.row];
    CGSize titleSize =[self sizeForText:[aDic objectForKey:@"Queation"] Width: SCREEN_SIZE.width - 80 Height:MAXFLOAT Font:15];
    
    CGSize contextSize =[self sizeForText:[aDic objectForKey:@"Answer"] Width: SCREEN_SIZE.width - 80 Height:MAXFLOAT Font:15];
    
    
    UILabel * titleLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_SIZE.width - 80, titleSize.height)];
    titleLab.text =[aDic objectForKey:@"Queation"];
    titleLab.font =[UIFont systemFontOfSize:15];
    titleLab.numberOfLines = 0;
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:titleLab];
    
    
    UILabel * contextLab =[[UILabel alloc]initWithFrame:CGRectMake(10, titleLab.frame.size.height + 15, SCREEN_SIZE.width - 80, contextSize.height)];
    contextLab.text =[aDic objectForKey:@"Answer"];
    contextLab.font =[UIFont systemFontOfSize:15];
    contextLab.textColor =[UIColor lightGrayColor];
    contextLab.numberOfLines = 0;
    contextLab.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:contextLab];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * aDic =[infoArr objectAtIndex:indexPath.row];
    CGSize titleSize =[self sizeForText:[aDic objectForKey:@"Queation"] Width: SCREEN_SIZE.width - 80 Height:MAXFLOAT Font:15];
    
    CGSize contextSize =[self sizeForText:[aDic objectForKey:@"Answer"] Width: SCREEN_SIZE.width - 80 Height:MAXFLOAT Font:15];
    
    return titleSize.height + contextSize.height + 15;
    
    
}
#pragma mark - 计算文本高度

-(CGSize)sizeForText:(NSString *)text Width:(CGFloat)aWidth Height:(CGFloat)aHeight Font:(NSInteger)aFont
{
    NSStringDrawingOptions option =NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:aFont] forKey:NSFontAttributeName];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(aWidth, aHeight)
                                     options:option
                                  attributes:attributes
                                     context:nil];
    
    return rect.size;
}
#pragma mark - UITableViewDelegate

-(void)btnClick:(UIButton *)sender
{
    [self removeFromSuperview];
}

-(void)show
{
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
