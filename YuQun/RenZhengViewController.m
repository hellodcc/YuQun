//
//  RenZhengViewController.m
//  鱼群
//
//  Created by 董冲冲 on 16/4/20.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "RenZhengViewController.h"
#import "AHeader.h"
#import "UIView+MJ.h"
#import "HWAlertView.h"
#import "ShuRuXianZhi.h"
#import "AFNetworkingManager.h"
#import "Model.h"
#import "MBProgressHUD.h"
#import "HWAlertView.h"
#import "UIButton+WebCache.h"
#import "BlueLab.h"
@interface RenZhengViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIButton *comBtn;
    UIImage *zhengImg;
    UIImage *fanImg;
    NSMutableArray *imgArr;
    MBProgressHUD * progressHUD;
}
@property (weak, nonatomic) IBOutlet BlueLab *reasonLab;
@property (weak, nonatomic) IBOutlet  BlueLab*rzResultLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *hintLab;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIView *numBgView;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhengBtn;
@property (weak, nonatomic) IBOutlet UIButton *fanBtn;

@end

@implementation RenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imgArr=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=COLOR_BACK;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.bgScrollerView.delegate=self;
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)makeUI
{
    
    self.nameBgView.layer.masksToBounds=YES;
    self.nameBgView.layer.cornerRadius=22.5;
    self.nameBgView.layer.borderWidth=0.5;
    self.nameBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.numBgView.layer.masksToBounds=YES;
    self.numBgView.layer.cornerRadius=22.5;
    self.numBgView.layer.borderWidth=0.5;
    self.numBgView.layer.borderColor=[UIColor blackColor].CGColor;
    
    CGSize imageSize=[[UIImage imageNamed:@"sfzf"] size];
    CGFloat bili=imageSize.width/imageSize.height;
    self.zhengBtn.frame=CGRectMake(20,self.titLab.y+self.titLab.height+10 , (SCREEN_SIZE.width-60)/2,((SCREEN_SIZE.width-60)/2)/bili );
    self.fanBtn.frame=CGRectMake(SCREEN_SIZE.width/2+10, self.zhengBtn.y, self.zhengBtn.width, self.zhengBtn.height);
    self.zhengBtn.layer.borderWidth=0.5;
    self.zhengBtn.layer.borderColor=COLOR_BACK.CGColor;
    self.fanBtn.layer.borderWidth=0.5;
    self.fanBtn.layer.borderColor=COLOR_BACK.CGColor;
    
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=22.5;
    
    
//    UserLogin *user=[UserLogin shareUserWithData:nil];
//    if ([[NSString stringWithFormat:@"%@",user.passAuthentication] isEqualToString:@"0"]) {
//        
//    }else
//    {
//        self.nextBtn.hidden=YES;
//    }
    if (self.model)
    {
        
        NSArray *arr=[self.model.Photo componentsSeparatedByString:@","];
        
//        NSLog(@"%@>>>>>>%@",arr[0],arr[1]);
        
        
        [self.zhengBtn sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:0]] forState:UIControlStateNormal];
        [self.fanBtn sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:1]] forState:UIControlStateNormal];
        
        self.titLab.text=@"我上传的身份证照片";
        self.nextBtn.hidden=YES;
        self.rzResultLab.hidden=NO;
        self.reasonLab.hidden=YES;
        self.nameText.text=self.model.RealName;
    
        if ([self.model.CertifyCode length]==18)
        {
           self.numText.text=[NSString stringWithFormat:@"%@************%@",[self.model.CertifyCode substringToIndex:3],[self.model.CertifyCode substringFromIndex:15]];
        }else
        {
            self.numText.text=[NSString stringWithFormat:@"%@*********%@",[self.model.CertifyCode substringToIndex:3],[self.model.CertifyCode substringFromIndex:12]];
        }
        
        self.nameText.enabled=NO;
        self.numText.enabled=NO;
        self.zhengBtn.userInteractionEnabled=NO;
        self.fanBtn.userInteractionEnabled=NO;
        self.rzResultLab.y=self.zhengBtn.y+self.zhengBtn.height+20;
        self.hintLab.y=self.rzResultLab.y+self.rzResultLab.height+10;
        
        if ([[NSString stringWithFormat:@"%@",self.model.AuthenticationState] isEqualToString:@"0"])
        {
            self.rzResultLab.BlueStr=@"认证中";
            self.rzResultLab.text=[NSString stringWithFormat:@"实名认证结果:认证中"];
        }else if ([[NSString stringWithFormat:@"%@",self.model.AuthenticationState] isEqualToString:@"1"])
        {
            self.rzResultLab.BlueStr=@"已认证";
            self.rzResultLab.text=[NSString stringWithFormat:@"实名认证结果:已认证"];
        }else if ([[NSString stringWithFormat:@"%@",self.model.AuthenticationState] isEqualToString:@"2"])
        {
           
            self.reasonLab.hidden=NO;
            self.nextBtn.hidden=NO;
            self.rzResultLab.BlueStr=@"已失败";
            self.rzResultLab.text=[NSString stringWithFormat:@"实名认证结果:已失败"];
            if (self.model.FailedReson)
            {
                self.reasonLab.BlueStr=self.model.FailedReson;
                self.reasonLab.text=[NSString stringWithFormat:@"失败原因:%@",self.model.FailedReson];
            }
         
            
            
            [self.nextBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            
    
            self.nextBtn.tag=200;
            self.reasonLab.y=self.rzResultLab.y+self.rzResultLab.height+10;
            
            self.nextBtn.y=self.reasonLab.y+self.reasonLab.height+20;
            
            self.hintLab.y=self.nextBtn.y+self.nextBtn.height+10;
            
        }

    }else
    {
        self.titLab.text=@"请上传身份证正反照";
        self.nextBtn.hidden=NO;
        self.rzResultLab.hidden=YES;
        self.reasonLab.hidden=YES;
        self.zhengBtn.userInteractionEnabled=YES;
        self.fanBtn.userInteractionEnabled=YES;
        self.nameText.enabled=YES;
        self.numText.enabled=YES;
        self.nextBtn.tag=100;
        self.nameText.text=@"";
        self.numText.text=@"";
        self.nextBtn.y=self.zhengBtn.y+self.zhengBtn.height+20;
        self.hintLab.y=self.nextBtn.y+self.nextBtn.height+10;
        [self.zhengBtn setImage:[UIImage imageNamed:@"sfzz"] forState:UIControlStateNormal];
        [self.fanBtn setImage:[UIImage imageNamed:@"sfzf"] forState:UIControlStateNormal];
        [self.nextBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        
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
- (IBAction)fanBtn:(id)sender {
    comBtn=sender;
    comBtn.tag=2;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView:self.navigationController.view];
}

- (IBAction)zhengBtn:(id)sender {
    comBtn=sender;
    comBtn.tag=1;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView:self.navigationController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //相机:先判断是否支持相机,然后询问用户是否同意使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //打开相机
                [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                HWAlertView *meaasge=[[HWAlertView alloc]initWithTitle:@"不能打开相机"];
                [meaasge show];
                
            }
            
        }
            break;
        case 1:
        {
            //相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else
            {
                HWAlertView *meaasge=[[HWAlertView alloc]initWithTitle:@"无法打开相册"];
                [meaasge show];
            }
        }
            break;
            
        default:
            break;
    }
}


-(void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    //创建图片选取器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    //设置选取器类型
    picker.sourceType = type;
    //编辑
    picker.allowsEditing = YES;
    //弹出
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (comBtn.tag==1)
    {
        zhengImg=info[UIImagePickerControllerEditedImage ];
    }else
    {
        fanImg=info[UIImagePickerControllerEditedImage ];
    }
    [comBtn setImage:info[UIImagePickerControllerEditedImage ] forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextBtn:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==100)
    {
        if (![ShuRuXianZhi matchingIDCard:self.numText.text])
        {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请输入正确的身份证号"];
            [alert show];
        }else if (!zhengImg)
        {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请上传身份证正面照"];
            [alert show];
        }else if (!fanImg)
        {
            HWAlertView * alert = [[HWAlertView alloc]initWithTitle:@"请上传身份证反面照"];
            [alert show];
        }else
        {
            progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHUD.labelText = @"图片上传中…";
            progressHUD.dimBackground = NO;
            [imgArr removeAllObjects];
            
            NSData * imgData1 = UIImageJPEGRepresentation(zhengImg, .3f);
            NSString * imgStr1 = [imgData1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSString *str1=[NSString stringWithFormat:@",%@",imgStr1];
            [imgArr addObject:str1];
            
            
            NSData * imgData2 = UIImageJPEGRepresentation(fanImg, .3f);
            NSString * imgStr2 = [imgData2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString *str2=[NSString stringWithFormat:@",%@",imgStr2];
            [imgArr addObject:str2];
            
            UserLogin *user=[UserLogin shareUserWithData:nil];
            [AFNetworkingManager guserRenZhengWithuid:user.UID name:self.nameText.text sfz:self.numText.text img:imgArr succeed:^(id complate) {
                
                [self userLogIn];
            } Failed:^(id error) {
                [progressHUD hide:YES];
                HWAlertView *message=[[HWAlertView alloc]initWithTitle:(NSString *)error];
                [message show];
            }];
        }

    }else
    {
 
        self.model=nil;
        [self makeUI];
    }
    
}

-(void)userLogIn
{
     UserLogin *user=[UserLogin shareUserWithData:nil];
    [AFNetworkingManager userLoginWithTel:user.Tel Pas:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass" ] succeed:^(id complate) {
        [progressHUD hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
        HWAlertView *message=[[HWAlertView alloc]initWithTitle:@"上传成功"];
        [message show];
        
    } Failed:^(id error) {
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
