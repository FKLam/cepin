//
//  JobDetailLabelCell.h
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "AOTag.h"

@interface JobDetailLabelCell : UITableViewCell
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)UIView *viewcell;
+ (int)companyHightWithString:(NSString*)str;

@end
