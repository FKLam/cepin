//
//  FullLanguageCellView.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface FullLanguageCellView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ResumeNameModel *languageModel;
- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model CETDict:(NSDictionary *)dict;

@end
