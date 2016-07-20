//
//  ImproveRegViewController.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/11.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ImproveRegViewController.h"
#import "AFNetworkingManager.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "HWAlertView.h"
#import "MyPickerView.h"
#import "Model.h"
#import "DWTagList.h"
#import "TagView.h"
#import "NoCopyTextField.h"
@interface ImproveRegViewController ()<UIScrollViewDelegate,UITextFieldDelegate,MyPickerViewDelegate,DWTagListDelegate,DWTagViewDelegate,TagViewDelegate>
{
    UITextField *commentTextField;
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
    NSMutableString *tagStr;
    
    DWTagList *tagList;
    NSMutableArray *tagArr;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *cityBgView;
@property (weak, nonatomic) IBOutlet NoCopyTextField *cityText;
@property (weak, nonatomic) IBOutlet UIView *sexBgView;
@property (weak, nonatomic) IBOutlet NoCopyTextField *sexText;
@property (weak, nonatomic) IBOutlet UIView *brithBgView;
@property (weak, nonatomic) IBOutlet UILabel *tiShiLab;
@property (weak, nonatomic) IBOutlet NoCopyTextField *brithText;
@property (weak, nonatomic) IBOutlet UIView *jobBgView;
@property (weak, nonatomic) IBOutlet NoCopyTextField *jobText;
@property (weak, nonatomic) IBOutlet UIView *eduBgView;
@property (weak, nonatomic) IBOutlet NoCopyTextField *eduText;

@property (weak, nonatomic) IBOutlet UIView *revenueBgView;
@property (weak, nonatomic) IBOutlet NoCopyTextField *revenueText;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ImproveRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tagStr=[NSMutableString string];
    tagArr=[NSMutableArray arrayWithCapacity:0];
    cityArr=[NSMutableArray arrayWithCapacity:0];
    sexArr=[NSMutableArray arrayWithCapacity:0];
    jobArr=[NSMutableArray arrayWithCapacity:0];
    eduArr=[NSMutableArray arrayWithCapacity:0];
    revArr=[NSMutableArray arrayWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.bgScrollerView.delegate=self;
    self.cityText.delegate=self;
    self.sexText.delegate=self;
    self.brithText.delegate=self;
    self.jobText.delegate=self;
    self.eduText.delegate=self;
    self.revenueText.delegate=self;
    [self getCityData];
    [self getEduData];
    [self getJobData];
    [self getRevData];
    
    NSString *city=[[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
    if (city)
    {
        NSMutableString *str = [city mutableCopy];
        
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        //去除空格
        for (NSInteger i = [str length]; i> 0; i--) {
            str = [NSMutableString stringWithString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        NSString *cityP=[NSString stringWithFormat:@"%c/%@",[str characterAtIndex:0]-32,city];
        
        
        self.cityText.text=cityP;
    }

    [self makeUI];
    
    //监听键盘显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    // 监听键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    // Do any additional setup after loading the view from its nib.
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


-(void)makeUI
{
    
    self.cityBgView.layer.masksToBounds=YES;
    self.cityBgView.layer.cornerRadius=22.5;
    self.cityBgView.layer.borderWidth=0.5;
    self.cityBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.sexBgView.layer.masksToBounds=YES;
    self.sexBgView.layer.cornerRadius=22.5;
    self.sexBgView.layer.borderWidth=0.5;
    self.sexBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.brithBgView.layer.masksToBounds=YES;
    self.brithBgView.layer.cornerRadius=22.5;
    self.brithBgView.layer.borderWidth=0.5;
    self.brithBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.jobBgView.layer.masksToBounds=YES;
    self.jobBgView.layer.cornerRadius=22.5;
    self.jobBgView.layer.borderWidth=0.5;
    self.jobBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.eduBgView.layer.masksToBounds=YES;
    self.eduBgView.layer.cornerRadius=22.5;
    self.eduBgView.layer.borderWidth=0.5;
    self.eduBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.revenueBgView.layer.masksToBounds=YES;
    self.revenueBgView.layer.cornerRadius=22.5;
    self.revenueBgView.layer.borderWidth=0.5;
    self.revenueBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=22.5;
    
    
    if (!tagList)
    {
        tagList=[[DWTagList alloc]initWithFrame:CGRectMake(self.tagLab.x+self.tagLab.width+8,self.tagLab.y,SCREEN_SIZE.width-16-self.tagLab.x-self.tagLab.width, 200)];
    }
    
    tagList.tagDelegate=self;
    [tagArr addObject:@"+增加标签"];
    [tagList setTags:tagArr];
    
    [self.bgScrollerView addSubview:tagList];
    
    tagList.height=tagList.contentSize.height;
    
    self.tiShiLab.y=tagList.height+tagList.y+10;
    
    self.nextBtn.y= self.tiShiLab.height+ self.tiShiLab.y+10;

    
    
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
        
        for (CitysModel *model in cityArr)
        {
            if ([model.CityName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"] ])
            {
                cityId=model.ID;
            }
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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
    if (textField==self.eduText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (EducationModel *model in eduArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.EducationName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.revenueText)
    {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
        for (RevenueModel *model in revArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.RangeName]];
        }
        MyPickerView *myPickView=[[MyPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 180) withData:arr];
        myPickView.delegate=self;
        textField.inputView=myPickView;
    }
    if (textField==self.brithText)
    {
        
        UIDatePicker *dp = [[UIDatePicker alloc] init];
        dp.backgroundColor=COLOR_BACK;
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

    }else if (commentTextField==self.revenueText)
    {
        RevenueModel *model=[revArr objectAtIndex:index];
        revId=model.ID;


        
    }else if (commentTextField==self.eduText)
    {
        EducationModel *model=[eduArr objectAtIndex:index];
        eduId=model.ID;


        
    }else if (commentTextField==self.jobText)
    {
        JobModel *model=[jobArr objectAtIndex:index];
        jobId=model.ID;


        
    }
    
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
    
    if ([self.cityText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请选择您所在城市城市"];
        [message show];
    }else if ([self.sexText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输请选择性别"];
        [message show];
        
    }else if ([self.brithText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请输请选择您的生日"];
        [message show];
        
    }else if ([self.jobText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请选择您的职业"];
        [message show];
        
    }else if ([self.eduText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请选择您的学历"];
        [message show];
        
    }else if([self.revenueText.text isEqualToString:@""])
    {
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"请选择您的收入范围"];
        [message show];
    }else
    {
        
        self.nextBtn.enabled=NO;
        
        
//        NSLog(@"%@",tagStr);
//        NSLog(@"%@",self.brithText.text);
//        NSLog(@"%@",eduId);
//        NSLog(@"%@",revId);
//        NSLog(@"%@",cityId);
//        NSLog(@"%@",jobId);
        [AFNetworkingManager userRegisterWithUserName:self.userName tel:self.userTel PWD:self.userPWD recommendedUserID:self.recommendedUserID SMSCode:self.SMSCode Tag:tagStr gender:sexId birthday:self.brithText.text education:eduId revenue:revId cityId:cityId job:jobId OsType:@"IOS" Succeed:^(id complate) {
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"注册成功"];
            self.nextBtn.enabled=YES;
            [alert show];
        } Failed:^(id error) {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:(NSString *)error];
            [alert show];
            self.nextBtn.enabled=YES;
        }];

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

-(void)allTage:(NSMutableArray *)allTag
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
   
//    [tagArr addObjectsFromArray:tagArr];
    [self makeUI];
}
@end
