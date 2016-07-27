//
//  CPSearchFilterView.h
//  cepin
//
//  Created by kun on 16/1/10.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchResultVC.h"
#import "JobSearchVM.h"
@protocol CPSearchFilterDelegate <NSObject>
@optional
- (void)clickedMoreFilterButton;
- (void)clickedCityFilterButton;
- (void)removeCityView;
@end
/**
 *添加搜索热门城市筛选的监听
 *
 */
@protocol HotCityChangeDeleger <NSObject>
//城市切换
-(void)hotCitySelect:(Region *)cityRegion;
@end
@interface CPSearchFilterView : UIView
@property (nonatomic, weak) id<CPSearchFilterDelegate> searchFilterDelegate;
@property(nonatomic,weak) id<filterChangeDeleger> filterChangeDeleger;
- (instancetype)initWithFrame:(CGRect)frame model:(JobSearchVM *)model;
- (void)configTopButtonWithTitles:(NSArray *)titles;
- (void)configMenuWithAddress:(NSArray *)workAddress expectSalary:(NSArray *)expectSalary workYear:(NSArray *)workYear moreFilter:(NSArray *)moreFilter;
@end
