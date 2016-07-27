//
//  AddressChooseHukouVC.h
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface AddressChooseHukouVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *model;
-(instancetype)initWithModel:(ResumeNameModel*)model;
@end
