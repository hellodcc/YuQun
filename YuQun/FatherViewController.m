//
//  FatherViewController.m
//  TonightQunar
//
//  Created by chehuiMAC on 15/3/5.
//  Copyright (c) 2015年 何威. All rights reserved.
//

#import "FatherViewController.h"
#import "AHeader.h"
@interface FatherViewController ()<UIGestureRecognizerDelegate>
{
    NSString * titleStr;
    NSString * leftBtnStr;
    NSString * rightBtnStr;
}

@end

@implementation FatherViewController

-(id)initWithTitle:(NSString *)aTitle leftButton:(NSString *)aLeftBtn rightButton:(NSString *)aRightBtn
{
    self = [super init];
    if (self) {
        if (aTitle) {
            titleStr = aTitle;
        }
        if (aLeftBtn) {
            leftBtnStr = aLeftBtn;
        }
        if (aRightBtn) {
            rightBtnStr = aRightBtn;
        }
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
  
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //判断是否为第一个view
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = COLOR_BACK;
    self.navigationController.navigationBarHidden = YES;
    if (!_navView)
    {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64)];
    }
    _navView.backgroundColor = COLOR_NAV;
    [self.view addSubview:_navView];
    //
    if (titleStr)
    {
        if (!_titleLab) {
            _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 80, 27, 160, 30)];
        }
        _titleLab.text = titleStr;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:21];
        [_navView addSubview:_titleLab];
    }
    //
    if (leftBtnStr)
    {
        if (!_leftBtn) {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.titleLabel.textColor = [UIColor whiteColor];
            _leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSArray * strArr = [leftBtnStr componentsSeparatedByString:@"/"];
        NSString * str = [strArr objectAtIndex:0];
        if ([str isEqualToString:@"image"])
        {
            [_leftBtn setImage:[UIImage imageNamed:[strArr objectAtIndex:1]] forState:UIControlStateNormal];
            _leftBtn.frame = CGRectMake(8, 22, 40, 40);
        }
        else
        {
            [_leftBtn setTitle:[strArr objectAtIndex:1] forState:UIControlStateNormal];
            CGRect rect = [_leftBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|
                           NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil] context:nil];
            
            _leftBtn.frame = CGRectMake(8, 22, rect.size.width, 40);
        }
        [_navView addSubview:_leftBtn];
    }
    //
    if (rightBtnStr)
    {
        if (!_rightBtn) {
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        _rightBtn.frame = CGRectMake(SCREEN_SIZE.width - 48, 22, 40, 40);
        NSArray * strArr = [rightBtnStr componentsSeparatedByString:@"/"];
        NSString * str = [strArr objectAtIndex:0];
        if ([str isEqualToString:@"image"])
        {
            [_rightBtn setImage:[UIImage imageNamed:[strArr objectAtIndex:1]] forState:UIControlStateNormal];
            _rightBtn.frame = CGRectMake(SCREEN_SIZE.width - 48, 22, 40, 40);
        }
        else
        {
            [_rightBtn setTitle:[strArr objectAtIndex:1] forState:UIControlStateNormal];
            CGRect rect = [_rightBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|
                           NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil] context:nil];
            _rightBtn.frame = CGRectMake(SCREEN_SIZE.width - 8- rect.size.width, 22, rect.size.width, 40);
        }
        [_navView addSubview:_rightBtn];
    }
}


-(void)leftBtnClick:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClick:(id)sender
{
    
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
