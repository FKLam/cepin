//
//  CPBindExistAccountController.h
//  cepin
//
//  Created by ceping on 16/3/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserLoginDTO.h"
@interface CPBindExistAccountController : BaseTableViewController
- (void)configeWithUserData:(UserLoginDTO *)userData;
- (instancetype)initWithComeFromString:(NSString *)comeFromString;
- (instancetype)initWithComeFromString:(NSString *)comeFromString notificationDict:(NSDictionary *)notificationDict;
@end
