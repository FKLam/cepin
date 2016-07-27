//
//  SignupVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SignupVC : BaseTableViewController
@property(nonatomic,assign)BOOL isFirstPush;
@property(nonatomic,assign)int screenW;
- (instancetype)initWithComeFormString:(NSString *)comeFromString;
- (instancetype)initWithComeFormString:(NSString *)comeFromString notificationDict:(NSDictionary *)notificationDict;
@end
