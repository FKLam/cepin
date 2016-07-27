//
//  BaseFilterViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-28.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseTableViewController.h"


extern NSString *const FilterDictionaryName;
extern NSString *const FilterDictionaryValue;

@class BaseFilterViewController;

@protocol BaseFilterViewControllerDelegate <NSObject>

-(void)selectedName:(NSString *)name value:(int64_t)Id index:(NSInteger)index viewController:(BaseFilterViewController *)vc;

@end


@protocol BaseFilterViewControllerOutputDelegate <NSObject>

-(void)didFinishSetTheFilter:(id)filterVC;

@end


@interface BaseFilterViewController : BaseTableViewController

@property(nonatomic,weak)UIViewController<BaseFilterViewControllerDelegate> *delegate;
@property(weak,nonatomic)id<BaseFilterViewControllerOutputDelegate>outputDelegate;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSString *currentName;
@property(nonatomic,assign)int64_t currentID;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(UIViewController<BaseFilterViewControllerDelegate> *)value index:(NSInteger)index dictionary:(NSDictionary *)dic;

-(void)setupTableView;

-(void)saveFitlerData:(id)sender;
@end
