//
//  LoginVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
@interface LoginVC : BaseTableViewController
@property(nonatomic,assign)BOOL isFirstPush;
- (instancetype)initWithComeFromString:(NSString *)comeFromString;
- (instancetype)initWithComeFromString:(NSString *)comeFromString notificationDict:(NSDictionary *)notificationDict;
@end
