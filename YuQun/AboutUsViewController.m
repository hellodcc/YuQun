//
//  GongGaoCell.h
//  YuQun
//
//  Created by 董冲冲 on 16/3/25.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "AboutUsViewController.h"


#import "AHeader.h"
#import "UIView+MJ.h"
@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *banBenLab;


@property (weak, nonatomic) IBOutlet UILabel *aboutUs;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
    
    self.aboutUs.text=@"鱼群App是专门为鱼群手机用户量身打造的手机兼职赚钱众包平台。方便鱼群用户随时随地快速接单，进行任务交易。提供完整的接单、抢单、奖金提现、用户资料管理等鱼群平台全部功能。赶紧下载鱼群App体验新功能，开启手机赚钱之旅吧！";
    self.aboutUs.numberOfLines=0;
    self.aboutUs.lineBreakMode=NSLineBreakByCharWrapping;
    self.aboutUs.textAlignment=NSTextAlignmentLeft;
    
    self.aboutUs.frame=CGRectMake(8, 90, SCREEN_SIZE.width-16, [self heightForText:self.aboutUs.text Font:15]);
    
    self.banBenLab.frame=CGRectMake(0, self.aboutUs.height+self.aboutUs.y+30, SCREEN_SIZE.width, 20);
    NSDictionary *dic=[[NSBundle mainBundle]infoDictionary];
    NSString  *shaortVersion=[dic objectForKey:@"CFBundleShortVersionString"];
    self.banBenLab.text=[NSString stringWithFormat:@"鱼群V.%@",shaortVersion];
    
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height-63);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//计算文字高度
-(CGFloat)heightForText:(NSString *)aText Font:(NSInteger)aFont
{
    CGSize  textSize = [aText boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil].size;
    return textSize.height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
