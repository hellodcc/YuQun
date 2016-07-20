//
//  ContactViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ContactViewController.h"
#import "Model.h"
#import "AFNetworkingManager.h"
@interface ContactViewController ()
{
    KeFuModel *model;
}
@property (weak, nonatomic) IBOutlet UILabel *keFuTel;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *weiXinLab;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadKeFu];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadKeFu
{
    [AFNetworkingManager getKefusucceed:^(id complate) {
        NSDictionary *dic=[complate lastObject];
        model=[[KeFuModel alloc]init];
        [model setValuesForKeysWithDictionary: dic];
        [self makeUI];
    } Failed:^(id error) {
        
    }];
}

-(void)makeUI
{
    
    self.timeLab.text=[NSString stringWithFormat:@"工作时间：%@",model.time];
    self.weiXinLab.text=[NSString stringWithFormat:@"微信客服：%@",model.weixin];
    self.keFuTel.text=[NSString stringWithFormat:@"客服电话:%@",model.kefuTel];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
