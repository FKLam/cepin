//
//  CPTestEnsureInformationController.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestEnsureInformationController.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureSexCell.h"

@interface CPTestEnsureInformationController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UIView *contentFooterView;

@end

@implementation CPTestEnsureInformationController

#pragma mark - lift cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        [self setTitle:@"信息确认"];
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.contentTableView];
    self.contentTableView.tableFooterView = self.contentFooterView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置状态栏颜色
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20.0, kScreenWidth, 20.0)];
    [statusBarView setBackgroundColor:[UIColor colorWithHexString:@"206eb1" alpha:1.0]];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 2 == indexPath.row || 5 == indexPath.row )
    {
        CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
        
        NSString *leftStr = nil;
        NSString *placeholder = nil;
        
        if ( 2 == indexPath.row )
        {
            leftStr = @"出生年份";
            placeholder = @"请选择出生年份";
        }
        else
        {
            leftStr = @"学  历";
            placeholder = @"请选择最高学历";
        }
        
        [cell configCellLeftString:leftStr placeholder:placeholder];
        
        return cell;
    }
    else if ( 1 == indexPath.row)
    {
        CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
        return cell;
    }
    else
    {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        
        NSString *leftStr = nil;
        NSString *placeholder = nil;
        
        if ( 0 == indexPath.row )
        {
            leftStr = @"姓  名";
            placeholder = @"请输入姓名";
        }
        else if ( 3 == indexPath.row )
        {
            leftStr = @"学  校";
            placeholder = @"请填写学校";
        }
        else
        {
            leftStr = @"专  业";
            placeholder = @"请填写专业";
        }
        
        [cell configCellLeftString:leftStr placeholder:placeholder];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - events respond
- (void)clickedEnsureButton
{
    
}

#pragma mark - getter methods
- (UITableView *)contentTableView
{
    if ( !_contentTableView )
    {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32 / 3.0, kScreenWidth, kScreenHeight - 32 / 3.0) style:UITableViewStylePlain];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        [_contentTableView setRowHeight:144 / 3.0];
        [_contentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _contentTableView;
}
- (UIView *)contentFooterView
{
    if ( !_contentFooterView )
    {
        _contentFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (84 + 144 + 32) / 3.0)];
        [_contentFooterView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UIButton *ensureButton = [[UIButton alloc] initWithFrame:CGRectMake(40 / 3.0, 84 / 3.0, kScreenWidth - 40 / 3.0 * 2, 144 / 3.0)];
        [ensureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [ensureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [ensureButton.layer setCornerRadius:10 / 3.0];
        [ensureButton.layer setMasksToBounds:YES];
        [ensureButton setTitle:@"确认" forState:UIControlStateNormal];
        [ensureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [ensureButton addTarget:self action:@selector(clickedEnsureButton) forControlEvents:UIControlEventTouchUpInside];
        [_contentFooterView addSubview:ensureButton];
    }
    return _contentFooterView;
}
@end
