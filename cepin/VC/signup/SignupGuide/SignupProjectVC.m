//
//  SignupProjectVC.m
//  cepin
//
//  Created by dujincai on 15/7/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SignupProjectVC.h"
#import "SigbupProjectVM.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeAddMoreCell.h"
#import "ResumeEditCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "ResumeCompanyIndustryVC.h"
#import "ResumeCompanyNatureVC.h"
#import "ResumeCompanyDescribeVC.h"
#import "ResumeCompanyJobNameVC.h"
#import "ResumeCompanyAddressVC.h"
#import "ResumeCompanyRankingVC.h"
#import "ResumeCompanyScaleVC.h"
#import "NSDate-Utilities.h"
#import "ResumeIsAbroadCell.h"
#import "TBAppDelegate.h"
#import "NSString+Extension.h"

@interface SignupProjectVC ()<UITextFieldDelegate,ResumeThridTimeViewDelegate>
@property(nonatomic)BOOL addMore;
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)SigbupProjectVM *viewModel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UIButton *skipButton;

@end

@implementation SignupProjectVC
- (instancetype)initWithResumeId:(NSString*)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[SigbupProjectVM alloc] initWithResumeid:resumeId];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:@"work_experience_launch"];
    
    self.title = @"工作/实习经历";
//    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, IS_IPHONE_5?300:250) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 77.0f;
    
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(20, self.tableView.viewHeight + self.tableView.viewY + 10, 280, (IS_IPHONE_5?40:48));
    [self.nextButton setTitle:@"完成,马上发现好工作" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 8;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.titleLabel.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
    self.nextButton.backgroundColor = RGBCOLOR(248, 142, 76);
    [self.view addSubview:self.nextButton];
    
    [self.nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //统计下一步
        [MobClick event:@"practical_not_perfect_next"];
        [self.viewModel addWork];
//        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
//        [delegate ChangeToMainTwo];
    }];
    
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake((kScreenWidth - 60)/2, self.nextButton.viewHeight + self.nextButton.viewY + 10, 60, IS_IPHONE_5?26:30);
    self.skipButton.titleLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
    [self.skipButton setTitle:@"跳过填写" forState:UIControlStateNormal];
    self.skipButton.backgroundColor = [UIColor clearColor];
    [self.skipButton setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateNormal];
    self.skipButton.viewWidth = [NSString caculateTextSize:self.skipButton.titleLabel].width;
    [self.view addSubview:self.skipButton];
    [self.skipButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //统计跳过
        [MobClick event:@"practical_not_perfect_skip"];
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate ChangeToMainTwo];
    }];
    
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
//          [self alertWithMessage:@"操作成功"];
            TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return IS_IPHONE_5?18:21;
    }
    return IS_IPHONE_5?40:48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if (indexPath.row == 3) {
        ResumeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeEditCell class])];
        if (cell == nil) {
            cell = [[ResumeEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeEditCell class])];
        }
        cell.titleLabel.text = @"公司名称";
        cell.infoText.placeholder = @"请输入公司名称";
        cell.infoText.delegate = self;
        cell.infoText.text = self.viewModel.workData.Company;
        [[cell.infoText rac_textSignal] subscribeNext:^(NSString *text) {
            self.viewModel.workData.Company = text;
        }];
        return cell;
    }
    if(indexPath.row == 8){
        ResumeIsAbroadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeIsAbroadCell class])];
        if (cell == nil) {
            cell = [[ResumeIsAbroadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeIsAbroadCell class])];
        }
        
        if (self.viewModel.workData.IsAbroad == 1) {
            [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_radio"] forState:UIControlStateNormal];
        }else
        {
            [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
        }
        
        [cell.buttonImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.viewModel.workData.IsAbroad == 1) {
                [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
                
                self.viewModel.workData.IsAbroad = @"0";
            }else{
                [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_radio"] forState:UIControlStateNormal];
                
                self.viewModel.workData.IsAbroad = @"1";
            }
        }];
        return cell;
    }else{
        ResumeArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeArrowCell class])];
        if (cell == nil) {
            cell = [[ResumeArrowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeArrowCell class])];
        }
        switch (indexPath.row) {
            case 1:
            {
                cell.titleLabel.text = @"开始时间";
                cell.infoText.placeholder = @"请选择开始时间";
                cell.infoText.text = [NSDate cepinYMDFromString:self.viewModel.workData.StartDate];
                

            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"结束时间";
                cell.infoText.placeholder = @"请选择结束时间";
                if (self.viewModel.workData.EndDate && ![self.viewModel.workData.EndDate isEqualToString:@""]) {
                    cell.infoText.text = [NSDate cepinYMDFromString:self.viewModel.workData.EndDate];
                }
                else
                {
                    cell.infoText.text = @"至今";
                }
                
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"行业类型";
                cell.infoText.placeholder = @"请选择行业";
                cell.infoText.text = self.viewModel.workData.Industry;
            }
                break;
            case 5:
            {
                cell.titleLabel.text = @"公司性质";
                cell.infoText.placeholder = @"请选择公司性质";
                cell.infoText.text = self.viewModel.workData.Nature;
            }
                break;
            case 6:
            {
                cell.titleLabel.text = @"职位名称";
                cell.infoText.placeholder = @"请选择职位名称";
                cell.infoText.text = self.viewModel.workData.JobFunction;
            }
                break;
            case 7:
            {
                cell.titleLabel.text = @"工作职责";
                cell.infoText.placeholder = @"未填写";
                if (self.viewModel.workData.Content && ![self.viewModel.workData.Content isEqualToString:@""]) {
                    cell.infoText.text = @"已添加";
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    switch (indexPath.row) {
        case 1:
        {
            [self displayTimeView:indexPath.row];
        }
            break;
        case 2:
        {
            [self displayTimeView:indexPath.row];
        }
            break;
        case 4:
        {
            ResumeCompanyIndustryVC *vc = [[ResumeCompanyIndustryVC alloc]initWithWorkModel:self.viewModel.workData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            ResumeCompanyNatureVC *vc = [[ResumeCompanyNatureVC alloc]initWithWorkModel:self.viewModel.workData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            ResumeCompanyJobNameVC *vc = [[ResumeCompanyJobNameVC alloc]initWithWorkModel:self.viewModel.workData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            ResumeCompanyDescribeVC *vc = [[ResumeCompanyDescribeVC alloc]initWithWorkModel:self.viewModel.workData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}



-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.timeView)
    {
        self.timeView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
        self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.timeView.delegate = self;
        [self.view addSubview:self.timeView];
        self.timeView.tag = tag;
        
        [self resetYearMonth];
    }
    else
    {
        self.timeView.tag = tag;
        [self resetYearMonth];
        self.timeView.hidden = NO;
    }
}

-(void)resetYearMonth
{
    NSString *str = nil;
    if (self.timeView.tag == 1)
    {
        if (!self.viewModel.workData.StartDate || [self.viewModel.workData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            
            return;
        }
        
        str = [NSDate cepinYMDFromString:self.viewModel.workData.StartDate];
    }
    else
    {
        if (!self.viewModel.workData.EndDate || [self.viewModel.workData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            
            return;
        }
        
        str = [NSDate cepinYMDFromString:self.viewModel.workData.EndDate];
    }
    
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}

-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 2)
    {
        self.viewModel.workData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    else
    {
        self.viewModel.workData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    [self.tableView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
    return YES;
}


@end
