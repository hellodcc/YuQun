//
//  XieYiView.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/14.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "XieYiView.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "AFNetworkingManager.h"
#import "MBProgressHUD.h"
@implementation XieYiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIScrollView *bgScrellView;
    NSArray *xieYiArr;
     MBProgressHUD *progressHUD;
}
-(id)initWithTitle:(NSString *)aTitle
{
    if(self = [super init])
    {
        
        
        self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        //灰色蒙版
        CALayer *  grayCover = [[CALayer alloc]init];
        grayCover.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor];
        [self.layer addSublayer:grayCover];
        
        
        [self makeUI];
        [self loadXieYi];
        
       
           }
    return self;
}

-(void)makeUI
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width-300.0)/2.0, (self.height-500)/2, 300, 500)];
    bgView.backgroundColor=COLOR_NAV;
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=3;
    [self addSubview:bgView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 30)];
    titleLab.text=@"用户协议";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:15];
    titleLab.textColor=[UIColor whiteColor];
    [bgView addSubview:titleLab];
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(bgView.width-titleLab.height, 0, titleLab.height, titleLab.height);
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    
    
    bgScrellView=[[UIScrollView alloc]init];
    bgScrellView.backgroundColor=COLOR_BACK;
    bgScrellView.frame=CGRectMake(0, titleLab.height, bgView.width, bgView.height-titleLab.height);
    [bgView addSubview:bgScrellView];
    
    
}

-(void)changUI
{
    CGFloat Y=0;
    for (int i=0; i<[xieYiArr count]; i++)
    {
        NSDictionary *dataDic=[xieYiArr objectAtIndex:i];
        NSString *titleStr=[dataDic objectForKey:@"title"];
        NSArray *xieyiListArr=[dataDic objectForKey:@"xieyiList"];
        
        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(8, Y, bgScrellView.width-16, [self heightForText:titleStr Font:16])];
        titleLab.textAlignment=NSTextAlignmentLeft;;
        titleLab.numberOfLines=0;
        titleLab.text=titleStr;
        titleLab.font=[UIFont systemFontOfSize:16];
        titleLab.textColor=COLOR_RBG(122, 122, 122);
        //        titleLab.backgroundColor=[UIColor orangeColor];
        titleLab.lineBreakMode=NSLineBreakByCharWrapping;
        [bgScrellView addSubview:titleLab];
        
        Y+=[self heightForText:titleStr Font:16];
        
        for (int j=0; j<[xieyiListArr count]; j++)
        {
            NSDictionary *contenmtDic=[xieyiListArr objectAtIndex:j];
            NSArray *contenmtArr=[contenmtDic objectForKey:@"contenmt"];
            
            Y+=10;
            
            for (int k=0; k<[contenmtArr count]; k++)
            {
                NSDictionary *dic=[contenmtArr objectAtIndex:k];
                NSString *subtitle=[dic objectForKey:@"subtitle"];
                NSArray *detailArr=[dic objectForKey:@"detail"];
                UILabel *subTitleLab=[[UILabel alloc]initWithFrame:CGRectMake(8, Y, bgScrellView.width-16, [self heightForText:subtitle Font:15])];
                subTitleLab.textAlignment=NSTextAlignmentLeft;;
                subTitleLab.numberOfLines=0;
                subTitleLab.text=[NSString stringWithFormat:@"%d、%@,",j+1,subtitle];
                subTitleLab.font=[UIFont systemFontOfSize:15];
                subTitleLab.textColor=COLOR_RBG(122, 122, 122);
                //        titleLab.backgroundColor=[UIColor orangeColor];
                subTitleLab.lineBreakMode=NSLineBreakByCharWrapping;
                [bgScrellView addSubview:subTitleLab];
                Y+=[self heightForText:subtitle Font:15]+10;
                
                if ([[[detailArr objectAtIndex:0] allKeys] count]>0)
                {
                    NSArray *allKey=[[detailArr objectAtIndex:0] allKeys];
                    NSDictionary *detailDic=[detailArr objectAtIndex:0] ;
                    for (int l=0; l<[allKey count]; l++)
                    {
                        NSString *detailStr=[NSString stringWithFormat:@"%@",[detailDic objectForKey:[NSString stringWithFormat:@"%d",l+1]]];
                        UILabel *detailLab=[[UILabel alloc]initWithFrame:CGRectMake(32, Y, bgScrellView.width-40, [self heightForText:detailStr Font:15])];
                        detailLab.textAlignment=NSTextAlignmentLeft;;
                        detailLab.numberOfLines=0;
                        detailLab.text=detailStr;
                        detailLab.font=[UIFont systemFontOfSize:15];
                        detailLab.textColor=COLOR_RBG(122, 122, 122);
                        
                        detailLab.lineBreakMode=NSLineBreakByCharWrapping;
                        [bgScrellView addSubview:detailLab];
                        Y+=[self heightForText:detailStr Font:15]+5;
                    }
                }
                
            }
            
        }
    }
    bgScrellView.contentSize=CGSizeMake(0, Y);

}
-(void)closeBtnClick:(UIButton *)btn
{
    [self dismiss];
}
-(void)dismiss
{
    [self removeFromSuperview];
}
-(void)loadXieYi
{
    
    progressHUD = [MBProgressHUD showHUDAddedTo:bgScrellView animated:YES];
    progressHUD.color = [UIColor clearColor];
    progressHUD.dimBackground = NO;
    progressHUD.labelText=@"正在努力加载...";
    progressHUD.labelColor=COLOR_progressHUD;
    progressHUD.activityIndicatorColor=COLOR_progressHUD;
    [AFNetworkingManager getXieyiSucceed:^(id complate) {
        xieYiArr=complate;
        [self changUI];
        
        [progressHUD hide:YES];
    } Failed:^(id error) {
        [progressHUD hide:YES];
    }];
}

//计算文字高度
-(CGFloat)heightForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(bgScrellView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.height;
}
@end
