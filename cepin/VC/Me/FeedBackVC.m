//
//  FeedBackVC.m
//  cepin
//
//  Created by dujincai on 15/11/6.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "FeedBackVC.h"
#import "RTNetworking+User.h"
#import "NSDictionary+NetworkBean.h"
@interface FeedBackVC ()<UITextViewDelegate>

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor =[[RTAPPUIHelper shareInstance]backgroundColor];
    
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, self.view.viewWidth, 40)];
    self.accountLabel.text = @"联系邮箱/手机号(选填)";
    self.accountLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.accountLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    [self.view addSubview:self.accountLabel];
    
    UIView *acountTextView = [[UIView alloc]initWithFrame:CGRectMake(0, self.accountLabel.viewY+self.accountLabel.viewHeight, self.view.viewWidth, 40)];
    acountTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:acountTextView];
    
    self.accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.view.viewWidth-20, 30)];
    self.accountTextField.backgroundColor = [UIColor whiteColor];
    self.accountTextField.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.accountTextField.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    [acountTextView addSubview:self.accountTextField];
    [[self.accountTextField rac_textSignal] subscribeNext:^(NSString *text) {
        self.emailOrPhone = text;
        
    }];
    
    self.adviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, acountTextView.viewY+acountTextView.viewHeight, self.view.viewWidth, 40)];
    self.adviceLabel.text = @"你的建议(500字以内)";
    self.adviceLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.adviceLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    [self.view addSubview:self.adviceLabel];
    
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.adviceLabel.viewY+self.adviceLabel.viewHeight,self.view.viewWidth, 150)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    self.adviceTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5,self.view.viewWidth-20, 140)];
    self.adviceTextView.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.adviceTextView.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.adviceTextView.backgroundColor = [UIColor whiteColor];
    self.adviceTextView.delegate = self;
    [contentView addSubview:self.adviceTextView];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(20, contentView.viewHeight + contentView.viewY + 20, 280, (IS_IPHONE_5?40:48));
    [nextButton setTitle:@"确认" forState:UIControlStateNormal];
    UIImage *normalBackgroundImage = [UIImage buttonImageWithColor:RGBCOLOR(248, 142, 76)
                                                      cornerRadius:4
                                                       shadowColor:RGBCOLOR(248, 142, 76)
                                                      shadowInsets:UIEdgeInsetsMake(0, 0, 1, 0)];
    
    UIImage *highlightedBackgroundImage = [UIImage buttonImageWithColor:[[RTAPPUIHelper shareInstance]subTitleColor]
                                                           cornerRadius:4
                                                            shadowColor:[UIColor clearColor]
                                                           shadowInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    
    [nextButton setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [nextButton setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
//    nextButton.layer.cornerRadius = 6;
    nextButton.layer.masksToBounds = YES;
    nextButton.titleLabel.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
//    nextButton.backgroundColor = RGBCOLOR(248, 142, 76);
    [self.view addSubview:nextButton];
    
    [nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.adviceTextView resignFirstResponder];
        [self sendAdvice];
    }];
    
}


-(void)sendAdvice{
    
    if (![@"" isEqualToString:self.adviceTextView.text]) {
        if (500<self.adviceTextView.text.length) {
            [OMGToast showWithText:@"意见反馈内容字数不能超过500"];
            return;
        }
    }else{
        [OMGToast showWithText:@"意见反馈内容不能为空"];
        return;
    }
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [@"iOS" stringByAppendingString:currentVersion];
   RACSignal *request =  [[RTNetworking shareInstance] feedbackWithMobileOrEmail:self.emailOrPhone contentText:self.adviceTextView.text version:currentVersion];
    
    TBLoading *load = [TBLoading new];
    [load start];
    
    @weakify(self)
    [request subscribeNext:^(RACTuple *tuple) {
        if (load) {
            [load stop];
        }
        @strongify(self)
        NSDictionary *dic = tuple.second;
        
        if ([dic resultSucess]) {
           
            [OMGToast showWithText:@"内容已发送，感谢你的反馈。" bottomOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            
        }
    }error:^(NSError *error) {
        if (load)
        {
            [load stop];
        }
        
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
       
        
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
      return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.accountTextField resignFirstResponder];
    [self.adviceTextView resignFirstResponder];
}



@end
