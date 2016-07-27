//
//  AddressChooseVC.h
//  cepin
//
//  Created by ceping on 15-3-19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface AddressChooseVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *model;
-(instancetype)initWithModel:(ResumeNameModel*)model isJG:(BOOL)isJG;

@end
