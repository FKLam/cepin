//
//  ExamReportVC.h
//  cepin
//
//  Created by dujincai on 15/6/9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol ExamReportVCDelegate <NSObject>
@optional
- (void)examReportVCNotify;
@end
@interface ExamReportVC : BaseTableViewController
@property (nonatomic, weak) id<ExamReportVCDelegate> examReportVCDelegate;
@end
