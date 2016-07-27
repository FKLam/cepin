//
//  AddLanguageVC.m
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddLanguageVC.h"
#import "AddLanguageVM.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "CategoryVC.h"
#import "SpeakVC.h"
#import "WriteVC.h"
#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
@interface AddLanguageVC ()
@property(nonatomic,strong)AddLanguageVM *viewModel;
@end

@implementation AddLanguageVC
- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddLanguageVM alloc] initWithResumeid:resumeId];
        self.viewModel.showMessageVC = self;
        self.viewModel.langData.Speaking = @"良好";
        self.viewModel.langData.Writing = @"良好";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加语言能力";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel addLanguage];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    [cell.inputTextField setTag:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"语言类别" placeholder:@"请选择"];
            cell.inputTextField.text = self.viewModel.langData.Name;
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"听说能力" placeholder:@"请选择"];
            cell.inputTextField.text = self.viewModel.langData.Speaking;
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 2:
        {
            [cell configCellLeftString:@"读写能力" placeholder:@"请选择"];
            cell.inputTextField.text = self.viewModel.langData.Writing;
            [cell resetSeparatorLineShowAll:YES];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            CategoryVC *vc = [[CategoryVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            SpeakVC *vc = [[SpeakVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            WriteVC *vc = [[WriteVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
