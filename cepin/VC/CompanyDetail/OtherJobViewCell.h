//
//  OtherJobViewCell.h
//  cepin
//
//  Created by dujincai on 15/5/28.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetailModelDTO.h"
@interface OtherJobViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *companyName;
@property(nonatomic,strong)UILabel *salary;
@property(nonatomic,strong)UILabel *jobName;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,readwrite)BOOL isChecked;


- (void)createOtherJobCellWith:(CompanyPositionModel*)model;
@end
