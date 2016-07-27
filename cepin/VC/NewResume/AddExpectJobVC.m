//
//  AddExpectJobVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddExpectJobVC.h"
#import "ExpectJobCell.h"
#import "UIViewController+NavicationUI.h"
#import "ExpectAddressVC.h"
#import "ResumeNameModel.h"
#import "AddExpectJobVM.h"
#import "ExpectSalaryVC.h"
#import "JobPropertyVC.h"
#import "ExpectFunctionVC.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
#import "ResumeTimeView.h"
#import "ResumeArrowCell.h"
#import "FuCongVC.h"
#import "CPCommon.h"
#import "CPTestEnsureArrowCell.h"
@interface AddExpectJobVC ()<UIAlertViewDelegate,ResumeTimeViewDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)AddExpectJobVM *viewModel;
@property(nonatomic,assign)bool isSocial;
@property(nonatomic,retain)ResumeTimeView *timeView;
@end
@implementation AddExpectJobVC

- (instancetype)initWithModel:(ResumeNameModel *)model isSocial:(Boolean)isSocial
{
    self = [super init];
    if (self)
    {
        self.isSocial =isSocial;
        if( isSocial )
        {
            self.titleArray = @[@"职能类别",@"期望城市",@"期望薪酬",@"工作性质"];
        }
        else
        {
            self.titleArray = @[@"职能类别",@"期望城市",@"期望薪酬",@"工作性质",@"到岗时间",@"服从分配"];
        }
        self.viewModel = [[AddExpectJobVM alloc] initWithResumeModel:model];
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        if ( (nil == self.viewModel.resumeNameModel.ExpectCity || [@"" isEqualToString:self.viewModel.resumeNameModel.ExpectCity]) && localtionCity && ![localtionCity isEqualToString:@""])
        {
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            if ( item )
            {
                self.viewModel.resumeNameModel.ExpectCity = item.PathCode;
            }
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"期望工作";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [MobClick event:@"expect_work_launch"];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
       //保存
        [self.viewModel saveExpectJob];
        
        [MobClick event:@"edit_expected_work"];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
            if ( [self.viewModel.resumeNameModel.Status intValue] != 1 ) // 如果不是默认简历就不用发送通知
                return;
            // 发送保存期望工作的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_EXPECTED_WORK object:nil userInfo:@{ CP_EXPECTED_WORK_SAVE : [NSNumber numberWithInteger:HUDCodeSucess] }];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
-(void)resetYearMonthDay
{
    if (!self.viewModel.resumeNameModel.AvailableType || [self.viewModel.resumeNameModel.AvailableType isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strdaty = [date stringyyyyMMddFromDate];
        NSArray *array = [strdaty componentsSeparatedByString:@"-"];
        NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue]];
        NSString *strMonth = [NSString stringWithFormat:@"%d",[array[1] intValue]];
        NSString *strDay = [NSString stringWithFormat:@"%d",[array[2] intValue]];;
        [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue day:strDay.intValue];
        return;
    }
    NSString *str = [NSDate cepinYearMonthDayFromString:self.viewModel.resumeNameModel.AvailableType];
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    NSString *day = [array objectAtIndex:2];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue day:day.intValue];
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self.viewModel.resumeNameModel.AvailableType = [NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)year,(unsigned long)month,(unsigned long)day];
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    [cell.inputTextField setTag:indexPath.row];
    NSString *leftTitleStr = self.titleArray[indexPath.row];
    switch ( indexPath.row )
    {
        case 0:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择职能类别"];
            NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:self.viewModel.resumeNameModel.ExpectJobFunction];
            cell.inputTextField.text = [TBTextUnit baseCodeNameWithBaseCodes:arrarCode];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择期望城市"];
            NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:self.viewModel.resumeNameModel.ExpectCity];
            if ( array.count > 0 )
            {
                cell.inputTextField.text = [TBTextUnit allRegionCitiesWithRegions:array];
            }
            else
            {
                self.viewModel.resumeNameModel.ExpectCity = @"";
                cell.inputTextField.text = @"";
            }
        }
            break;
        case 2:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择"];
            cell.inputTextField.text = self.viewModel.resumeNameModel.ExpectSalary;
            if ( !self.viewModel.resumeNameModel.ExpectSalary || 0 == [self.viewModel.resumeNameModel.ExpectSalary length] )
            {
                cell.inputTextField.text = @"5K-10K";
                self.viewModel.resumeNameModel.ExpectSalary = @"5K-10K";
            }
        }
            break;
        case 3:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择"];
            if ([self.viewModel.resumeNameModel.ExpectEmployType isEqualToString:@"1"]) {
                cell.inputTextField.text = @"全职";
            }else if([self.viewModel.resumeNameModel.ExpectEmployType isEqualToString:@"4"])
            {
                cell.inputTextField.text = @"实习";
            }else
            {
                cell.inputTextField.placeholder = @"请选择";
            }
        }
            break;
        case 4:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择"];
            cell.inputTextField.placeholder = @"请选择到岗时间";
            cell.inputTextField.text = [NSDate cepinYearMonthDayFromString:self.viewModel.resumeNameModel.AvailableType];
        }
            break;
        case 5:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请选择"];
            if( nil == self.viewModel.resumeNameModel.IsAllowDistribution )
            {
                cell.inputTextField.text = @"是";
                cell.inputTextField.placeholder = @"请选择是否服从分配";
                self.viewModel.resumeNameModel.IsAllowDistribution = @1;
            }
            else if(self.viewModel.resumeNameModel.IsAllowDistribution.intValue == 1 )
            {
                cell.inputTextField.text = @"是";
            }
            else if(self.viewModel.resumeNameModel.IsAllowDistribution.intValue == 0 )
            {
                cell.inputTextField.text = @"否";
            }
            else
            {
                cell.inputTextField.text = @"是";
                cell.inputTextField.placeholder = @"请选择是否服从分配";
                self.viewModel.resumeNameModel.IsAllowDistribution = @1;
            }
        }
            break;
               default:
            break;
    }
    if ( indexPath.row == [self.titleArray count] - 1 )
    {
        [cell resetSeparatorLineShowAll:YES];
    }
    else
    {
        [cell resetSeparatorLineShowAll:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            ExpectFunctionVC *vc = [[ExpectFunctionVC alloc] initWithResumeModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ExpectAddressVC *vc = [[ExpectAddressVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ExpectSalaryVC *vc = [[ExpectSalaryVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            JobPropertyVC *vc = [[JobPropertyVC alloc] initWithResumeModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            //到岗时间
            if (!self.timeView)
            {
                self.timeView = [[ResumeTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
                self.timeView.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
                [self resetYearMonthDay];
            }
            else
            {
                [self resetYearMonthDay];
                self.timeView.hidden = NO;
            }
        }
            break;
        case 5:
        {
            FuCongVC *vc = [[FuCongVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
