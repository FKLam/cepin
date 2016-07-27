//
//  SubscriptionTalkInVC.m
//  cepin
//  订阅宣检会
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionTalkInVC.h"
//#import "RTSubTitleCell.h"
#import "TBFilterDelegate.h"
#import "TalkInFilterModel.h"
#import "TBTextUnit.h"
#import "SchoolFilterVC.h"
#import "SubscriptionTalkInVM.h"
#import "JobFilterCell.h"

@interface SubscriptionTalkInVC ()

@property(nonatomic,retain)SubscriptionTalkInVM *viewModel;
@property(nonatomic,retain)UIButton *saveButton;

@end

@implementation SubscriptionTalkInVC

-(instancetype)init
{
    if(self = [super init])
    {
        self.viewModel = [SubscriptionTalkInVM new];
        return self;
    }
    return nil;
}

-(void)reloadData
{
    [self.viewModel deleteSubscription];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    
    if (IsIOS7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    
    UIImage *tmImage = nil;
    UIEdgeInsets inset = {.left=5,.right=5,.bottom=5,.top=5};
    
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.viewHeight-44-10, kScreenWidth - 20, 44)];
    //self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 7 * 44 + 10 + self.tableView.frame.origin.y, kScreenWidth - 20, 44)];
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton setTitle:@"保存设置" forState:UIControlStateNormal];
    //[self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //[self.saveButton setTitle:@"注册" forState:UIControlStateNormal];
    
    tmImage = UIIMAGE(@"btn_orang_normal");
    [self.saveButton setBackgroundImage:[tmImage resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
    tmImage = UIIMAGE(@"btn_orang_pressed");
    [self.saveButton setBackgroundImage:[tmImage resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];
    
    @weakify(self)
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel saveSubscription];
    }];
    
    [self.view addSubview:self.saveButton];
    
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
    
    [RACObserve(self.viewModel, SaveStateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
            //[[TalkInFilterModel shareInstance]saveObjectToDisk];
        }
    }];
    
    [RACObserve(self.viewModel, DeleteStateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
    
    [self.viewModel getSubscriptionTalkIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobFilterCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobFilterCell class])];
    if(cell==nil)
    {
        cell=[[JobFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobFilterCell class])];
    }
    
    [cell configureLableTitleText:@"高校"];
    [cell configureLableSubText:[TBTextUnit schoolNamesWithSchools:[[TalkInFilterModel shareInstance] schools]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolFilterVC *vc = [[SchoolFilterVC alloc] initWithFilterType:FilterTypeBokkingTalkInFilter];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
