//
//  SubscriptionVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionJobVC.h"

#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"


#import "SubscriptionJobVM.h"
#import "JobFilterCell.h"
#import "UIViewController+NavicationUI.h"
#import "SubscriptionJobCell.h"

#import "JobSalaryVC.h"
#import "JobpropertyVC.h"
#import "JobWorkYearsVC.h"
#import "JobAddressVC.h"
#import "JobFunctionVC.h"
#import "PositionTypeVCViewController.h"
#import "AlertDialogView.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"

@interface SubscriptionJobVC ()<UIAlertViewDelegate>

@property(nonatomic,retain)SubscriptionJobVM *viewModel;
@property(nonatomic,retain)UIButton *clearButton;
@property(nonatomic,strong)SubscriptionJobModel *model;
@property(nonatomic,strong)AlertDialogView *alertView;

@end

@implementation SubscriptionJobVC

-(void)reloadData
{
   
}

-(void)clickedBackBtn:(id)sender
{
    if (![self.model.addresskey isEqualToString:@""]||![self.model.jobFunctionskey isEqualToString:@""]||![self.model.jobPropertyskey isEqualToString:@""]||![self.model.salarykey isEqualToString:@""]||![self.model.workYearkey isEqualToString:@""]||self.model.addresskey||self.model.salarykey||self.model.jobPropertyskey||self.model.jobFunctionskey||self.model.workYearkey) {
        
    }else{
        [self.viewModel.jobModel config];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(instancetype)initWithModel:(SubscriptionJobModel *)model
{
    if (self = [super init])
    {
        self.model = model;
        self.viewModel = [[SubscriptionJobVM alloc]initWithSubModel:model];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"筛选条件";
    
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    
    self.view.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 32.0 / 3.0, self.view.viewWidth, ( 144 * 7 + 84 * 2) / 3.0 ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
//    self.tableView.rowHeight = 77.0f;
    
//    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    
    FUILineButton *phoneButton = [[FUILineButton alloc] initWithFrame:CGRectMake( 40 / 3.0 , CGRectGetMaxY(self.tableView.frame) - 84 / 3.0 - 144.0 / 3.0, self.view.viewWidth - 40 / 3.0 * 2, 144.0 / 3.0)];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [phoneButton setTitle:@"清除选项" forState:UIControlStateNormal];
    [phoneButton setTitleColor:RGBCOLOR(76, 185, 172) forState:UIControlStateNormal];
    [self.view addSubview:phoneButton];
    [phoneButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if (self.alertView) {
            self.alertView.hidden = NO;
            [self.alertView Show];
        }else{
            self.alertView = [[AlertDialogView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, kScreenHeight) Title:@"提示" content:@"是否清除筛选条件"  selector:@selector(clearHit) target:self];
            [self.alertView Show];
            TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.window addSubview:self.alertView];
        }
       
    }];
    
    
    if (IsIOS7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];

}

-(void)clearHit{
    //统计
    [MobClick event:@"search_remove"];
    self.alertView.hidden = YES;
    [self.viewModel.jobModel config];
    if ([self.delegate respondsToSelector:@selector(popViewController)]) {
        [self.delegate popViewController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [self.viewModel.jobModel config];
        if ([self.delegate respondsToSelector:@selector(popViewController)]) {
            [self.delegate popViewController];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if ([self.delegate respondsToSelector:@selector(popViewController)]) {
            [self.delegate popViewController];
        }
        //统计
        [MobClick event:@"search_save"];

        //保存
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
////        return IS_IPHONE_5?18:22;
//        return 32.0 / 3.0;
//    }
//    else
//    {
////        return IS_IPHONE_5?40:44;
//        return 144.0 / 3.0;
//    }
    
    return 144.0 / 3.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscriptionJobCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubscriptionJobCell class])];
    if (cell == nil) {
        cell = [[SubscriptionJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SubscriptionJobCell class])];
    }
    cell.imageLogo.image = [UIImage imageNamed:self.viewModel.images[indexPath.row]];
    cell.titlelabel.text = self.viewModel.titles[indexPath.row];
    cell.placeholderField.placeholder = self.viewModel.placeholders[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.viewModel.jobModel.jobFunctions && [self.viewModel.jobModel.jobFunctions isEqualToString:@"所有职能"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.jobFunctions];

        }
            break;
        case 1:
        {
            if (self.viewModel.jobModel.address && [self.viewModel.jobModel.address isEqualToString:@"全国"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.address];
        }
            break;
        case 2:
        {
            if (self.viewModel.jobModel.salary && [self.viewModel.jobModel.salary isEqualToString:@"不限"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.salary];
        }
            break;
        case 3:
        {
            if (self.viewModel.jobModel.jobPropertys && [self.viewModel.jobModel.jobPropertys isEqualToString:@"不限"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.jobPropertys];
        }
            break;
        case 4:
        {
            if (self.viewModel.jobModel.workYear && [self.viewModel.jobModel.workYear isEqualToString:@"不限"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.workYear];
        }
            break;
        case 5:
        {
            if (self.viewModel.jobModel.positionType && [self.viewModel.jobModel.positionType isEqualToString:@"不限"]) {
                break;
            }
            [cell configureTextFieldText:self.viewModel.jobModel.positionType];
        }
            break;
        default:
            break;
    }
    
    [cell.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        switch (indexPath.row) {
            case 0:
            {
                //统计
                [MobClick event:@"function_type"];
                JobFunctionVC *vc = [[JobFunctionVC alloc] initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                //统计
                [MobClick event:@"working_place"];
                JobAddressVC *vc = [[JobAddressVC alloc]initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //统计
                [MobClick event:@"expected_salary"];
                JobSalaryVC *vc = [[JobSalaryVC alloc]initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                //统计
                [MobClick event:@"working_nature"];
                JobpropertyVC *vc = [[JobpropertyVC alloc]initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                //统计
                [MobClick event:@"working_year"];
                JobWorkYearsVC *vc = [[JobWorkYearsVC alloc]initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                //统计
                [MobClick event:@"recruitment_type"];
                PositionTypeVCViewController *vc = [[PositionTypeVCViewController alloc]initWithJobModel:self.viewModel.jobModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    return cell;
}


@end
