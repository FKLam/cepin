//
//  ScoreRankVC.h
//  cepin
//
//  Created by dujincai on 15/11/4.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ScoreRankVC : BaseTableViewController
@property(nonatomic,strong)EducationListDateModel *model;

- (instancetype)initWithModel:(EducationListDateModel*)model;
@end
