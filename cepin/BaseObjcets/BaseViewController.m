//
//  BaseViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Resize.h"
#import "RTNetworking.h"
#import "UIView+Create.h"
#import "RTHUDModel.h"
#import "BaseRVMViewModel.h"


NSString *const NotificationMineDetailPageUpdate = @"NotificationMineDetailPageUpdate";

@interface BaseViewController ()

@end

@implementation BaseViewController

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithObject:(id)object
{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    self.networkImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.viewWidth - 280/3.0)/2 , 336/3.0+64, 280/3.0, 280/3.0)];
    self.networkImage.image = [UIImage imageNamed:@"null_exam_linkbroken"];
    self.networkImage.hidden = YES;
    [self.view addSubview:self.networkImage];
    
    self.networkLabel = [[UILabel alloc]initWithFrame:CGRectMake(40/3.0, self.networkImage.viewY + self.networkImage.viewHeight + 84/3.0, self.view.viewWidth-80/3.0, 60)];
    self.networkLabel.text = @"当前网络不可用，请检查网络设置";
    self.networkLabel.font = [UIFont systemFontOfSize:48 / 3.0] ;
    self.networkLabel.textColor = [UIColor colorWithHexString:@"404040"];
    self.networkLabel.textAlignment = NSTextAlignmentCenter;
    self.networkLabel.hidden = YES;
    self.networkLabel.numberOfLines = 0;
    self.networkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.networkLabel];
    self.networkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.networkButton.frame = CGRectMake((self.view.viewWidth)/2-330/3.0/2.0, self.networkLabel.viewHeight + self.networkLabel.viewY + 60/3.0, 330/3.0, 120/3.0);
    [self.networkButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.networkButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.networkButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.networkButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.networkButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
    [self.networkButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.networkButton.layer setCornerRadius:10 / 3.0];
    [self.networkButton.layer setMasksToBounds:YES];
    [self.networkButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
    [self.networkButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.networkButton addTarget:self action:@selector(clickNetWorkButton) forControlEvents:UIControlEventTouchUpInside];
    self.networkButton.hidden = YES;
    [self.view addSubview:self.networkButton];
}
- (void)clickNetWorkButton
{
    
}
- (void)noNetwork
{
    
}
-(void)alertWithMessage:(NSString *)msg
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alerView show];
}
-(void)alertCancelWithMessage:(NSString *)msg
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        _userDefaults = nil;
        self.activityView = nil;
    }
}

-(void)memoryRelease
{
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (UIDeviceOrientationIsPortrait(toInterfaceOrientation));
}
-(void)setupCancelTextFieldFocusTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTextFieldFocusTapRecognizer:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}
-(void)cancelTextFieldFocusTapRecognizer:(UIGestureRecognizer *)recognizer{}

- (NSInteger)requestStateWithStateCode:(id)stateCode
{
    if ([stateCode isKindOfClass:[RTHUDModel class]])
    {
        RTHUDModel *model = (RTHUDModel *)stateCode;
        return model.hudCode;
    }
    else if([stateCode isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)stateCode;
        return error.code;
    }
    return 0;
}
@end
