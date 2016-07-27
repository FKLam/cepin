//
//  FullTrainCellView.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface FullTrainCellView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ResumeNameModel *trainModel;
- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model;

@end
