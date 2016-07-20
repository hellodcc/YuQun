//
//  ChangeDataViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/10.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ChangeDataViewController.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "AHeader.h"
#import "MyPickerView.h"
#import "Model.h"
#import "DWTagList.h"
#import "MyDataPicker.h"
#import "TagView.h"
#import "AFNetworkingManager.h"
#import "HWAlertView.h"
#import "NoCopyTextField.h"
@interface ChangeDataViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MyPickerViewDelegate,DWTagListDelegate,DWTagViewDelegate,TagViewDelegate,UIScrollViewDelegate>
{
    UITextField *commentTextField;
    DWTagList *tagList;
    NSMutableArray *tagArr;
    NSMutableString *tagStr;
    
    NSMutableArray *cityArr;
    NSMutableArray *sexArr;
    NSMutableArray *jobArr;
    NSMutableArray *eduArr;
    NSMutableArray *revArr;
    
    NSString *cityId;
    NSString *sexId;
    NSString  *jobId;
    NSString *eduId;
    NSString *revId;
    NSString *dateStr;

}
@property (weak, nonatomic) IBOutlet UIView *tagBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *sexText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *timeText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *cityText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *jobText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *schoolText;
@property (weak, nonatomic) IBOutlet NoCopyTextField *moneyText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ChangeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tagArr =[NSMutableArray arrayWithCapacity:0];
    tagStr=[NSMutableString stringWithCapacity:0];
    cityArr=[NSMutableArray arrayWithCapacity:0];
    sexArr=[NSMutableArray arrayWithCapacity:0];
    jobArr=[NSMutableArray arrayWithCapacity:0];
    eduArr=[NSMutableArray arrayWithCapacity:0];
    revArr=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=COLOR_BACK;
    self.bgScrollerView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
 
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    NSArray *arr=user.Tags;
    for (int i=0; i<[arr count]; i++)
    {
        NSDictionary *dic=[arr objectAtIndex:i];
        userTagsModel *model=[[userTagsModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if (i!=([arr count]-1))
        {
            [tagStr appendFormat:@"%@,",model.ID];
        }else
        {
            [tagStr appendFormat:@"%@",model.ID];
        }
    }
    
    cityId=user.CityID;
    jobId=user.Job;
    eduId=user.Education;
    revId=user.Revenue;
    
    if ([[NSString stringWithFormat:@"%@",user.Gender]isEqualToString:@"1"])
    {
        sexId=@"男";
    }else
    {
        sexId=@"女";
    }
    //监听键盘显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    // 监听键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self getCityData];
    [self getEduData];
    [self getJobData];
    [self getRevData];
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}


-(void)makeUI
{
    self.nameText.delegate=self;
    self.sexText.delegate=self;
    self.timeText.delegate=self;
    self.cityText.delegate=self;
    self.jobText.delegate=self;
    self.schoolText.delegate=self;
    self.moneyText.delegate=self;
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    self.telLab.text=[NSString stringWithFormat:@"%@*****%@",[user.Tel substringToIndex:3],[user.Tel substringFromIndex:8]];
    self.nameText.text=user.Name;
    if ([[NSString stringWithFormat:@"%@",user.Gender] isEqualToString:@"1"])
    {
        self.sexText.text=@"男";
    }else
    {
        self.sexText.text=@"女";
    }
    self.timeText.text=user.Birthday;

    self.cityText.text=user.CityStr;
    self.jobText.text=user.JobStr;
    self.schoolText.text=user.RevStr;
    self.moneyText.text=user.EduStr;
    
    
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=22.5;
    
    tagList=[[DWTagList alloc]initWithFrame:CGRectMake(self.moneyText.x,11,SCREEN_SIZE.width-8-self.moneyText.x, 200)];
    tagList.tagDelegate=self;
    
    [tagArr removeAllObjects];
    
    for (NSDictionary *dic in user.Tags)
    {
        userTagsModel *model=[[userTagsModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [tagArr addObject:model.Name];
    }
    [tagArr addObject:@"+增加标签"];
    
  
    [tagList setTags:tagArr];
    [self.tagBackView addSubview:tagList];
    tagList.height=tagList.contentSize.height;
    self.tagBackView.height=tagList.contentSize.height+tagList.y+10;
    
    self.nextBtn.y=self.tagBackView.y+self.tagBackView.height+20;
    
    if (self.nextBtn.y+self.nextBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height-63);
    }

    
    
    [self createTapGesture];
}



- (void)createTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.bgScrollerView addGestureRecognizer:tapGesture];
    
}
-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
    }];
}

-(void)longPressGesture:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.cancelsTouchesInView = NO;
    [textField addGestureRecognizer:longPressGesture];


    commentTextField=textField;
    UIView *accessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 44)];
    accessoryView.backgroundColor=[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    textField.inputAccessoryView=accessoryView;
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(SCREEN_SIZE.width-10-50, 0, 50, 44);
    [rightButton setTitleColor:COLOR_NAV forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:rightButton];
    //添加键盘附属视图的分割线
    for (int i=0; i<2; i++)
    {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0+44*i, SCREEN_SIZE.width, 0.5)];
        lineView.backgroundColor=COLOR_TEXTWHITE;
        [accessoryView addSubview:lineView];
    }
    
    
    if (textField==self.cityText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (CitysModel *model in cityArr) {
            [arr addObject:[NSString stringWithFormat:@"%@/%@",model.FirstLetter,model.CityName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.sexText)
    {
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:@[@"男",@"女"]];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.jobText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (JobModel *model in jobArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.JobName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.schoolText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (EducationModel *model in eduArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.EducationName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.moneyText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (RevenueModel *model in revArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.RangeName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.timeText)
    {
        
        UIDatePicker *dp = [[UIDatePicker alloc] init];
        dp.backgroundColor=[UIColor whiteColor];
        dp.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 180);
        [dp addTarget:self action:@selector(dpValueChanged:) forControlEvents:UIControlEventValueChanged];
        dp.datePickerMode = UIDatePickerModeDate;
        textField.inputView=dp;
    }

}

- (void)dpValueChanged:(UIDatePicker *)dp
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString =  [formatter stringFromDate:dp.date];
    commentTextField.text=dateString;
}


-(void)rightButtonClick:(UIButton *)btn
{
    [self.view endEditing:YES];
}
- (void)keyboardWillHide:(NSNotification *)not
{
    // 取到通知携带的数据
    NSDictionary *userInfo = not.userInfo;
    if (self.nextBtn.y+self.nextBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height-63);
    }
    NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keybordWillShow:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    
    NSInteger keyBoardHight=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10+keyBoardHight);
    
   
    if (self.bgScrollerView.contentOffset.y<[commentTextField superview].y)
    {
        if ([commentTextField superview].y>self.bgScrollerView.contentSize.height-self.bgScrollerView.height-10) {
            
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, self.bgScrollerView.contentSize.height-self.bgScrollerView.height);
                
            }];
            
        }else
        {
            [UIWindow animateWithDuration:animationDuration animations:^{
                
                
                self.bgScrollerView.contentOffset=CGPointMake(0, [commentTextField superview].y);
                
            }];
        }
        
    }
    
}

-(void)getCityData
{
    [AFNetworkingManager GetCityssucceed:^(id complate) {
        NSArray *arr=complate;
        [cityArr removeAllObjects];
        for (NSDictionary *dic in arr)
        {
            CitysModel *model=[[CitysModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [cityArr addObject:model];
        }
        
    } Failed:^(id error) {
        
    }];
}
-(void)getJobData
{
    [AFNetworkingManager GetJobListsucceed:^(id complate) {
        NSArray *arr=complate;
        [jobArr removeAllObjects];
        for (NSDictionary *dic in arr)
        {
            JobModel *model=[[JobModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [jobArr addObject:model];
        }
        
        
    } Failed:^(id error) {
        
    }];
    
}
-(void)getEduData
{
    [AFNetworkingManager GetEducationListsucceed:^(id complate) {
        NSArray *arr=complate;
        [eduArr removeAllObjects];
        for (NSDictionary *dic in arr)
        {
            EducationModel *model=[[EducationModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [eduArr addObject:model];
        }
        
        
        
    } Failed:^(id error) {
        
    }];
}

-(void)getRevData
{
    [AFNetworkingManager GetRevenueListsucceed:^(id complate) {
        NSArray *arr=complate;
        [revArr removeAllObjects];
        for (NSDictionary *dic in arr)
        {
            RevenueModel *model=[[RevenueModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [revArr addObject:model];
        }
        
    } Failed:^(id error) {
        
    }];
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
- (IBAction)nextBtn:(id)sender {
    
    
        self.nextBtn.enabled=NO;
        
        
        NSLog(@"%@",tagStr);
        NSLog(@"%@",self.timeText.text);
        NSLog(@"%@",eduId);
        NSLog(@"%@",revId);
        NSLog(@"%@",cityId);
        NSLog(@"%@",jobId);
    
    UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager UpdateUserInfoWithNoImgWithTag:tagStr name:self.nameText.text gender:sexId birthday:self.timeText.text education:eduId revenue:revId tel:user.Tel cityId:cityId job:jobId Succeed:^(id complate) {
        self.nextBtn.enabled=YES;
        [self userLogIn];
    } Failed:^(id error) {
        HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
        [alert show];
        self.nextBtn.enabled=YES;
    }];
        
}

-(void)userLogIn
{
    UserLogin *user=[UserLogin shareUserWithData:nil];
    
    [AFNetworkingManager userLoginWithTel:user.Tel Pas:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"] succeed:^(id complate) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Failed:^(id error) {
        
    }];
}

-(void)myPickerViewdidSelectRowTitle:(NSString *)title withIndex:(NSInteger)index
{

    
    commentTextField.text=title;
    if (commentTextField==self.cityText)
    {
        CitysModel *model=[cityArr objectAtIndex:index];
        cityId=model.ID;
        
        
    }else if (commentTextField==self.sexText)
    {
        
        if (index==0)
        {
            sexId=@"男";
        }else
        {
            sexId=@"女";
        }
        
    }else if (commentTextField==self.moneyText)
    {
        RevenueModel *model=[revArr objectAtIndex:index];
        revId=model.ID;
        
        
        
    }else if (commentTextField==self.schoolText)
    {
        EducationModel *model=[eduArr objectAtIndex:index];
        eduId=model.ID;
        
        
        
    }else if (commentTextField==self.jobText)
    {
        JobModel *model=[jobArr objectAtIndex:index];
        jobId=model.ID;
        
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    if (tagIndex==[tagArr count]-1)
    {
        TagView *tagView=[[TagView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height-64) WithSelectArr:tagArr];
        tagView.delegat=self;
        [self.view addSubview:tagView];
    }
    
}

-(void)allTage:(NSArray *)allTag
{
    
    [tagArr removeAllObjects];
    tagStr=[NSMutableString stringWithCapacity:0];
    for (int i=0; i<[allTag count]; i++)
    {
        userTagsModel *model=[allTag objectAtIndex:i];
        [tagArr addObject:[NSString stringWithFormat:@"%@",model.Name]];
        if (i!=([allTag count]-1))
        {
            [tagStr appendFormat:@"%@,",model.ID];
        }else
        {
            [tagStr appendFormat:@"%@",model.ID];
        }
    }
  
    [tagArr addObject:@"+增加标签"];
    [tagList setTags:tagArr];
    
    tagList.height=tagList.contentSize.height;
    self.tagBackView.height=tagList.contentSize.height+tagList.y+10;
    
    self.nextBtn.y=self.tagBackView.y+self.tagBackView.height+20;
    
    if (self.nextBtn.y+self.nextBtn.height>SCREEN_SIZE.height-64)
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width, self.nextBtn.y+self.nextBtn.height+10);
    }else
    {
        self.bgScrollerView.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height-63);
    }
    

}
@end
