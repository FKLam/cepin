//
//  JobSearchResultCell.h
//  cepin
//
//  Created by dujincai on 15/5/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchModel.h"
@interface JobSearchResultCell : UITableViewCell

@property(nonatomic,strong)UILabel *position;
@property(nonatomic,strong)UILabel *company;
@property(nonatomic,strong)UILabel *salary;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,readwrite)BOOL isChecked;
- (void)configureModel:(JobSearchModel*)model;

@end
