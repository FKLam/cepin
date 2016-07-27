//
//  CategoryVC.h
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface CategoryVC : BaseTableViewController
@property(nonatomic,strong)LanguageDataModel *model;
- (instancetype)initWithEduModel:(LanguageDataModel*)model;
@end
