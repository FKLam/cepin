//
//  JobSearchResultVC.h
//  cepin
//
//  Created by dujincai on 15/5/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RegionDTO.h"

/**
 *添加搜索筛选的监听
 *
 */
@protocol filterChangeDeleger <NSObject>

//城市切换
-(void)cityselect:(Region *)cityRegion selectBtn:(UIButton *)selectBtn;
//薪酬切换
-(void)salarySelect:(NSString *)salary selectBtn:(UIButton *)selectBtn;
//工作年限切换
-(void)workSelect:(NSString *)workYear selectBtn:(UIButton *)selectBtn;
//更多筛选监听
-(void)moreSure;

@end

@interface JobSearchResultVC : BaseTableViewController
@property(nonatomic,strong)NSString *defaultSearchText;
- (instancetype)initWithKeyWord:(NSString *)keyWord;
- (instancetype)initWithCity:(NSString *)city patchCode:(NSString *)code;
- (instancetype)initWithKeyWord:(NSString *)keyWord city:(NSString *)city JobFunction:(NSString *)JobFunction
Salary:(NSString *)Salary PositionType:(NSString *)PositionType EmployType:(NSString *)EmployType WorkYear:(NSString *)WorkYear
 Degree:(NSString *)Degree;

@end
