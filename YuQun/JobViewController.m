//
//  JobViewController.m
//  YunQunText
//
//  Created by 董冲冲 on 16/6/28.
//  Copyright © 2016年 董冲冲. All rights reserved.

#import "JobViewController.h"
#import "TagSegement.h"
#import "AHeader.h"
#import "CellForJob.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "AFNetworkingManager.h"
#import "Model.h"
#import "HWAlertView.h"
#import "LogInViewController.h"
#import "JobdetailViewController.h"
#import "MJRefresh.h"
#import "FailView.h"
#import "UIView+MJ.h"
@interface JobViewController ()<UITableViewDelegate,UITableViewDataSource,TagSegementDelegate,JobdetailViewControllerDelegate>
{
    UITableView * _tableView;
    NSArray * infoTypeArr;
    NSMutableArray * allJobInfoArr;
    TagSegement *segement;
    NSInteger tagSegIndex;
    NSInteger isAtPage;
     FailView *failView;
}
@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isAtPage=1;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeUI) name:@"UserHasLogIn" object:nil];
    allJobInfoArr=[NSMutableArray arrayWithCapacity:0];
    infoTypeArr = [NSArray arrayWithObjects:@"MoreUnAcceptTask",@"MoreAcceptTask",@"MoreWaitCheckTask",@"MoreFinlishTask",@"MoreFailedTask", nil];
    self.title = @"任务";

    self.view.backgroundColor=COLOR_BACK;
    self.automaticallyAdjustsScrollViewInsets=NO;
//    [self makeUI];
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    if (user.Tel.length>0)
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"remLog"])
        {
            [AFNetworkingManager userLoginWithTel:user.Tel Pas:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"] succeed:^(id complate) {
                
                //                HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"登录成功"];
                //                [alert show];
                
                [self makeUI];
            } Failed:^(id error) {
                LogInViewController * loginVC = [[LogInViewController alloc]init];
                UINavigationController * loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                
                //        [self.navigationController pushViewController:loginVC animated:YES];
                
                [self presentViewController:loginNav animated:NO completion:nil];
                HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"登陆失败"];
                [alert show];
                
            }];
        }else
        {
            LogInViewController * loginVC = [[LogInViewController alloc]init];
            UINavigationController * loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            
            //        [self.navigationController pushViewController:loginVC animated:YES];
            
            [self presentViewController:loginNav animated:NO completion:nil];
        }
        
    }else
    {
        LogInViewController * loginVC = [[LogInViewController alloc]init];
        UINavigationController * loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        
        //        [self.navigationController pushViewController:loginVC animated:YES];
        
        [self presentViewController:loginNav animated:NO completion:nil];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI
{
    isAtPage=1;
    if (!segement)
    {
        segement=[[TagSegement alloc]initWithSelectIndex:0 with:@[@"可接任务",@"进行中",@"审核中",@"已完成",@"任务失败"] WithFrame:CGRectMake(20, 74,SCREEN_SIZE.width-40, 30)];
        segement.delegate=self;
        [self.view addSubview:segement];
    }
    
    tagSegIndex=0;
    [segement segementDidChooseAtIndex:tagSegIndex];
    
    if (!_tableView)
    {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64+ 50, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 49 - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=COLOR_BACK;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    
    [allJobInfoArr removeAllObjects];
    [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
    [self shangLa];
    [self xiaLaShuaXin];
}

-(void)xiaLaShuaXin
{
    _tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isAtPage=1;
       
        [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
    }];
}

-(void)shangLa
{
    
   
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isAtPage++;
       
        [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
    }];
    // 设置了底部inset
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
    
    
}


-(void)GetCanAcceptTaskListWithType:(NSString *)type withPage:(NSInteger )page
{
 
    
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager getJobInfoWithUserID:user.UID page:[NSString stringWithFormat:@"%ld",page] type:type succeed:^(id complate) {
        
        if ([_tableView.mj_footer isRefreshing])
        {
            
        }else
        {
            [allJobInfoArr removeAllObjects];
        }
        
        if (tagSegIndex==0)
        {
            for (NSDictionary * dic in complate) {
                
                JobInfo * jobModel =[[JobInfo alloc]init];
                [jobModel setValuesForKeysWithDictionary:dic];
                [allJobInfoArr addObject:jobModel];
            }
        }else
        {
            for (NSDictionary * dic in complate) {
                
                YijieRenWu * jobModel =[[YijieRenWu alloc]init];
                [jobModel setValuesForKeysWithDictionary:dic];
                [allJobInfoArr addObject:jobModel];
            }
        }
        
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
        [self failViewHidden];
    } Failed:^(id error) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
       
        if ([error isEqualToString:@"暂无数据"]) {
            
            [self failViewShow];
        }
        
        if (![error isEqualToString:@"暂无数据"]) {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:error];
            [alert show];
        }
    }];
}

-(void)failViewShow
{
    if (!failView)
    {
        failView=[[FailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, _tableView.height)];
      
        [_tableView addSubview:failView];
    }
}

-(void)failViewHidden
{
    [failView removeFromSuperview];
    failView=nil;
}


-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if (tagSegIndex == 1) {
            UIView * backV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20)];
            
            backV.backgroundColor = COLOR_RBG(243, 243, 243);
            
            UILabel *promotLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 13)];
            
            promotLab.textAlignment=NSTextAlignmentCenter;
            promotLab.textColor=COLOR_ORANGE;
            promotLab.font=[UIFont systemFontOfSize:13];
            promotLab.text=@"点击任务即可上传完成截图";
            
            [backV addSubview:promotLab];
            return backV;
        }
    }
    
    
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allJobInfoArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_SIZE.width tableView:_tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tagSegIndex==1)
    {
        if (section==0)
        {
           return 20; 
        }
        
    }
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    CellForJob *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CellForJob" owner:self options:nil] lastObject];
    }
    
    if (tagSegIndex==0)
    {
        JobInfo *jobModel = [allJobInfoArr objectAtIndex:indexPath.section];
        [cell configUIWithModel:jobModel WithSegementIndex:tagSegIndex withYijieModel:nil];
    }else
    {
        YijieRenWu *model=[allJobInfoArr objectAtIndex:indexPath.section];
        JobInfo *jobModel =[[JobInfo alloc]init];
        [jobModel setValuesForKeysWithDictionary:model.TaskInfo];
        [cell configUIWithModel:jobModel WithSegementIndex:tagSegIndex withYijieModel:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    JobdetailViewController * detailVC =[[JobdetailViewController alloc]initWithTitle:nil leftButton:@"image/back" rightButton:nil];
    if (tagSegIndex==0)
    {
        JobInfo *jobModel = [allJobInfoArr objectAtIndex:indexPath.section];
        detailVC.taskID =[NSString stringWithFormat:@"%@",jobModel.TID] ;
    }else
    {
        detailVC.yijiejobM = [allJobInfoArr objectAtIndex:indexPath.section];
        YijieRenWu *model=[allJobInfoArr objectAtIndex:indexPath.section];
        JobInfo *jobModel =[[JobInfo alloc]init];
        [jobModel setValuesForKeysWithDictionary:model.TaskInfo];
        detailVC.taskID = [jobModel.TID stringValue];
    }
    
    detailVC.jobType = tagSegIndex;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES ];
    self.hidesBottomBarWhenPushed = NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)tagSegmentView:(TagSegement *)segmentView didChooseAtIndex:(NSInteger)index
{
    [self failViewHidden];
    tagSegIndex=index;
    [allJobInfoArr removeAllObjects];
    [_tableView reloadData];
//    _tableView.contentOffset=CGPointMake(0, 0);
    isAtPage=1;
    [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
}


-(void)qiangdang
{
    [allJobInfoArr removeAllObjects];
    [_tableView reloadData];
    isAtPage=1;
    [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
}

-(void)uploadImg
{
    [allJobInfoArr removeAllObjects];
    [_tableView reloadData];
    isAtPage=1;
    [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
}

-(void)fangqirenwu
{
    [allJobInfoArr removeAllObjects];
    [_tableView reloadData];
    isAtPage=1;
    [self GetCanAcceptTaskListWithType:infoTypeArr[tagSegIndex] withPage:isAtPage];
}

- (IBAction)myBtn:(id)sender {
    self.tabBarController.selectedIndex=3;
}
@end
