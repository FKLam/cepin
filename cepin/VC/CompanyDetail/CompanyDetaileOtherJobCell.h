//
//  CompanyDetaileOtherJobCell.h
//  cepin
//
//  Created by dujincai on 15/5/27.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetaileOtherJobView.h"
#import "CompanyDetailModelDTO.h"
@interface CompanyDetaileOtherJobCell : UITableViewCell
@property(nonatomic,strong)UIView *viewCell;
@property(nonatomic,strong)CompanyDetaileOtherJobView *companyOtherJobView;


- (void)createOtherJobCellWith:(CompanyDetailModelDTO *)model positionIds:(NSMutableArray *)positionIds;
@end
