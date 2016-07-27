//
//  CertifierVC.h
//  cepin
//
//  Created by dujincai on 15/11/16.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface CertifierVC : BaseTableViewController
@property(nonatomic,strong)WorkListDateModel *model;
- (instancetype)initWithModel:(WorkListDateModel*)model;

@end
