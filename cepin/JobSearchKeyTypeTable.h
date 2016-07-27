//
//  JobSearchKeyTypeTable.h
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
@class SearchKeyTypeModel;

@interface JobSearchKeyTypeTable : BaseTableViewController
@property(nonatomic,copy)void(^didSelected)(SearchKeyTypeModel *model);

-(instancetype)initWithKeyTypes:(NSArray *)types;

@end
