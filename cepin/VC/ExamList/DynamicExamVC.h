//
//  DynamicExamVC.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum {
    examOne,
    examTwo
}examType;
@interface DynamicExamVC : BaseTableViewController
@property(nonatomic)examType type;

-(instancetype)initWithType:(examType)type;
- (void)outSideOpenExam;
@end
