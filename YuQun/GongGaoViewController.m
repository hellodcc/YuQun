//
//  GongGaoViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/25.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "GongGaoViewController.h"
#import "AFNetworkingManager.h"
#import "Model.h"
#import "GongGaoCell.h"
#import "QianDaoWebViewController.h"
#import "AHeader.h"
@interface GongGaoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *gongGaoArr;
}
@property (weak, nonatomic) IBOutlet UITableView *gongGaoTv;
@property (weak, nonatomic) IBOutlet UILabel *noGongGaoLab;

@end

@implementation GongGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_BACK;
    self.gongGaoTv.backgroundColor=COLOR_BACK;
    self.automaticallyAdjustsScrollViewInsets=NO;
    gongGaoArr=[NSMutableArray arrayWithCapacity:0];
    self.gongGaoTv.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
    self.noGongGaoLab.hidden=YES;
    self.gongGaoTv.delegate=self;
    self.gongGaoTv.dataSource=self;
}

-(void)loadData
{
    UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager getNotiByTelWithutel:user.Tel type:@"" succeed:^(id complate) {
        for (NSDictionary *dic in complate)
        {
            GongGaoModel *model=[[GongGaoModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [gongGaoArr addObject:model];
        }
        [self.gongGaoTv reloadData];
        
        
    } Failed:^(id error) {
        
        self.noGongGaoLab.hidden=NO;
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gongGaoArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    GongGaoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GongGaoCell" owner:self options:nil] lastObject];
    }
    GongGaoModel *model=[gongGaoArr objectAtIndex:indexPath.row];
    cell.titleLab.text=model.Notification;
    cell.timeLab.text=model.CreateTime;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GongGaoModel *model=[gongGaoArr objectAtIndex:indexPath.row];

        self.hidesBottomBarWhenPushed=YES;
        QianDaoWebViewController *WebVc=[[QianDaoWebViewController alloc]initWithTitle:@"消息详情" leftButton:@"image/back" rightButton:nil];
       WebVc.isFirst=YES;
        WebVc.urlStr=model.Content;
        [self.navigationController pushViewController:WebVc animated:YES];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
