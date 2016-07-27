//
//  DynamicExamNotHomeVC.h
//  cepin
//
//  Created by dujincai on 16/3/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DynamicExamVC.h"

@interface DynamicExamNotHomeVC : BaseTableViewController

@property(nonatomic)examType type;
-(instancetype)initWithType:(examType)type;
- (instancetype)initWithType:(examType)type comeFromString:(NSString *)comeFromString;
- (void)outSideOpenExam;
@end
