//
//  BaseTableViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-26.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableObject.h"
#import "RTAPPUIHelper.h"

@interface BaseTableViewController ()<UIScrollViewDelegate>
{
    BOOL _isTableViewModify;
}
@end

@implementation BaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.tableView = nil;
    }
}

-(void)createNoHeadImageTable
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.tableView];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, (self.view.viewHeight)- 49.0 * 2.0 - 150 / 3.0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
}
- (void)createProfileTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, (self.view.viewHeight) - 150 / 3.0 - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
}
- (void)createPositionTestTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.view.viewWidth, (self.view.viewHeight) - 150 / 3.0 - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)setupDropDownScrollView
{
    // 下拉刷新table
    
    __weak BaseTableViewController *vc = self;
    
    // LFK修改使用MJRefresh刷新控件
    // 上拉刷新 MJRefreshBackNormalFooter MJRefreshAutoNormalFooter
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [vc updateTable];
    }];
}
-(void)setupRefleshScrollView
{
    // 下拉刷新table
    
    __weak BaseTableViewController *vc = self;
    
    // LFK修改使用MJRefresh刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [vc refleshTable];
    }];
}

-(void)removeReflashScrollView
{
    [self.tableView removeReflashWithAction];
    [self.tableView removeInfiniteAction];
}
-(void)refleshTable
{
    [self startRefleshAnimation];
    [self stopUpdateAnimation];
}
-(void)updateTable
{
    [self startUpdateAnimation];
}
-(void)stopRefleshAnimation
{
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // LFK修改使用MJRefresh刷新控件
        [weakSelf.tableView.mj_header endRefreshing];
        
    });
}
-(void)startRefleshAnimation
{
    // LFK修改使用MJRefresh刷新控件
    [self.tableView.mj_header beginRefreshing];
}
-(void)stopUpdateAnimation
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.tableView.mj_footer endRefreshing];
    });
}
-(void)startUpdateAnimation
{
//    [self.tableView.mj_footer beginRefreshing];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
@end
