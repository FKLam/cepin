//
//  BaseTableViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-26.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabViewController.h"
#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "MobClick.h"
@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

- (void)createNoHeadImageTable;

- (void)createTableView;

- (void)createProfileTableView;


//在要使用refleshScrollView 的时候才使用下面的方法
-(void)setupRefleshScrollView;

-(void)setupDropDownScrollView;

-(void)removeReflashScrollView;

- (void)createPositionTestTableView;

// 下拉刷新table
-(void)refleshTable;
-(void)stopRefleshAnimation;
-(void)startRefleshAnimation;

// 到底更新table
-(void)updateTable;
-(void)stopUpdateAnimation;
-(void)startUpdateAnimation;

@end
