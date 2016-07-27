//
//  SchoolResumeNameVC.m
//  cepin
//
//  Created by dujincai on 15/11/13.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "SchoolResumeNameVC.h"
#import "ResumeArrowCell.h"
#import "ResumeAddMoreCell.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeNameHeadCell.h"
#import "FullResumeMenuView.h"
#import "AllResumeDataModel.h"
#import "FullResumeVC.h"
#import "ResumeNameVM.h"
#import "AddResumeVC.h"
#import "AddResumeTagVC.h"
#import "AddExpectJobVC.h"
#import "AddJobStatusVC.h"
#import "ResumeJobExperienceVC.h"
#import "AddEducationVC.h"
#import "AddProjectVC.h"
#import "AddLanguangeVC.h"
#import "AddPracticeVC.h"
#import "AddTrainVC.h"
#import "AddOtherInfomationVC.h"
#import "AddDescriptionVC.h"
#import "ResumeNameModel.h"
#import "BaseCodeDTO.h"
#import "TBTextUnit.h"
#import "FullResumeVC.h"
#import "ResumeNameTagCell.h"

@interface SchoolResumeNameVC ()<FullResumeMenuViewDelegate,UIAlertViewDelegate>
@property(nonatomic)BOOL addMore;
@property(nonatomic,retain)FullResumeMenuView *fullMenuView;
@property(nonatomic,strong)ResumeNameVM *viewModel;
@property(nonatomic,strong)ResumeNameModel *resumeModel;
@end

@implementation SchoolResumeNameVC

- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[ResumeNameVM alloc]initWithResumeId:resumeId];
    }
    return self;
}

- (instancetype)initWithResumeModel:(ResumeNameModel *)resumeModel
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[ResumeNameVM alloc]initWithResumeId:resumeModel.ResumeId];
        self.resumeModel = resumeModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getResumeInfo];
    self.title = self.viewModel.resumeNameModel.ResumeName;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = self.viewModel.resumeNameModel.ResumeName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[self addNavicationObjectWithType:NavcationBarObjectTypeMore] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.fullMenuView startApper];
    }];
    
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.fullMenuView = [[FullResumeMenuView alloc]initWithFrame:self.view.bounds];
    self.fullMenuView.hidden = YES;
    self.fullMenuView.delegate = self;
    [self.view addSubview:self.fullMenuView];
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork)
        {
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
    
    [RACObserve(self.viewModel,deleteStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getResumeInfo];
}
-(void)didFullResumeMenuTouch:(int)index
{
    switch (index)
    {
        case 0:
        {
            FullResumeVC *vc = [[FullResumeVC alloc]initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [self.viewModel toTop];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewModel deleteResume];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        return IS_IPHONE_5?18:21;
    }
    if (indexPath.row == 1) {
        return 100;
    }if (indexPath.row == 3) {
        int height = [ResumeNameTagCell computerTextWidth:self.viewModel.resumeNameModel.Keywords];
        return height;
    }
    return IS_IPHONE_5?40:48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.addMore) {
        return 9;
    }else{
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.resumeModel) {
    //        self.viewModel.resumeNameModel = self.resumeModel;
    //    }
    
    if (indexPath.row== 0 || indexPath.row == 2 || indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        ResumeNameHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeNameHeadCell class])];
        if (cell == nil) {
            cell = [[ResumeNameHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeNameHeadCell class])];
        }
        if (self.viewModel.resumeNameModel) {
            [cell configModel:self.viewModel.resumeNameModel];
            
        }
        
        return cell;
    }
    if (indexPath.row == 8) {
        ResumeAddMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeAddMoreCell class])];
        if (cell == nil) {
            cell = [[ResumeAddMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeAddMoreCell class])];
        }
        if (self.addMore) {
            cell.backgroundColor = [UIColor whiteColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell.addButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.addMore = !self.addMore;
            [self.tableView reloadData];
        }];
        return cell;
    }
    
    if (indexPath.row == 3)
    {
        ResumeNameTagCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeNameTagCell class])];
        if (cell == nil) {
            cell = [[ResumeNameTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeNameTagCell class])];
        }
        [cell createTagWith:self.viewModel.resumeNameModel.Keywords];
        
        return cell;
    }
    
    else{
        ResumeArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeArrowCell class])];
        if (cell == nil) {
            cell = [[ResumeArrowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeArrowCell class])];
        }
        switch (indexPath.row) {
            case 5:
            {
                cell.titleLabel.text = @"期望工作";
                cell.infoText.placeholder = @"请输入期望工作";
                
                NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:self.viewModel.resumeNameModel.ExpectCity];
                NSString *address = [TBTextUnit allRegionCitiesWithRegions:array];
                NSString *type = nil;
                if ([self.viewModel.resumeNameModel.ExpectEmployType isEqualToString:@"1"]) {
                    type = @"全职";
                }else if([self.viewModel.resumeNameModel.ExpectEmployType isEqualToString:@"4"])
                {
                    type = @"实习";
                }else
                {
                    type = @"";
                }
                
                NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:self.viewModel.resumeNameModel.ExpectJobFunction];
                cell.infoText.text = [TBTextUnit ResumeDetail:address nature:type job:[TBTextUnit baseCodeNameWithBaseCodes:arrarCode] salary:self.viewModel.resumeNameModel.ExpectSalary];
                cell.infoText.textColor = [UIColor blackColor];
                
            }
                break;
            case 6:
            {
                cell.titleLabel.text = @"工作/实习经历";
                cell.infoText.placeholder = @"请完善";
                if (self.viewModel.resumeNameModel.WorkList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 7:
            {
                cell.titleLabel.text = @"教育经历";
                cell.infoText.placeholder = @"未完善";
                if (self.addMore) {
                    cell.line.hidden = NO;
                }else{
                    cell.line.hidden = YES;
                }
                
                if (self.viewModel.resumeNameModel.EducationList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                    
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 9:
            {
                cell.titleLabel.text = @"项目经验";
                cell.infoText.placeholder = @"请完善项目经验";
                if (self.viewModel.resumeNameModel.ProjectList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 10:
            {
                cell.titleLabel.text = @"语言及技能";
                cell.infoText.placeholder = @"请完善语言及技能";
                if (self.viewModel.resumeNameModel.LanguageList.count > 0 || self.viewModel.resumeNameModel.SkillList.count > 0 || self.viewModel.resumeNameModel.CredentialList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 11:
            {
                cell.titleLabel.text = @"实践经历";
                cell.infoText.placeholder = @"请完善实践经历";
                if (self.viewModel.resumeNameModel.PracticeList.count > 0 || self.viewModel.resumeNameModel.AwardsList.count > 0 || self.viewModel.resumeNameModel.StudentLeadersList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 12:
            {
                cell.titleLabel.text = @"培训经历";
                cell.infoText.placeholder = @"请完善培训经历";
                if (self.viewModel.resumeNameModel.TrainingList.count > 0) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 13:
            {
                cell.titleLabel.text = @"附加信息";
                cell.infoText.placeholder = @"请完善附加信息";
                if (self.viewModel.resumeNameModel.AdditionInfo && ![self.viewModel.resumeNameModel.AdditionInfo isEqualToString:@""]) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                }
                else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
                }
            }
                break;
            case 14:
            {
                cell.titleLabel.text = @"自我描述";
                cell.infoText.placeholder = @"请完善自我描述";
                if (self.viewModel.resumeNameModel.UserRemark && ![self.viewModel.resumeNameModel.UserRemark isEqualToString:@""]) {
                    cell.infoText.text = @"已完善";
                    cell.infoText.textColor = [UIColor blackColor];
                } else
                {
                    cell.infoText.text = @"请完善";
                    cell.infoText.textColor = RGBCOLOR(100, 201, 194);
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
    switch (indexPath.row) {
        case 1:
        {
            AddResumeVC *vc = [[AddResumeVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            AddResumeTagVC *vc = [[AddResumeTagVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            AddExpectJobVC *vc = [[AddExpectJobVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //        case 6:
            //        {
            //            AddJobStatusVC *vc = [[AddJobStatusVC alloc]initWithModel:self.viewModel.resumeNameModel];
            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            //            break;
        case 6:
        {
            ResumeJobExperienceVC *vc = [[ResumeJobExperienceVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            AddEducationVC *vc = [[AddEducationVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            AddProjectVC *vc = [[AddProjectVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            AddLanguangeVC *vc = [[AddLanguangeVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            AddPracticeVC *vc = [[AddPracticeVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            AddTrainVC *vc = [[AddTrainVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            AddOtherInfomationVC *vc = [[AddOtherInfomationVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            AddDescriptionVC *vc = [[AddDescriptionVC alloc]initWithModelId:self.viewModel.resumeNameModel.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}


@end
