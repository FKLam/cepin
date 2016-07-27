//
//  DynamicSystemVC.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol DynamicSystemVCDelegate <NSObject>
@optional
- (void)dynamicSystemVCNotify;
@end
@interface DynamicSystemVC : BaseTableViewController
@property (nonatomic, weak) id<DynamicSystemVCDelegate> dynamicSystemDelegate;
- (instancetype)initWithOpetion:(NSNumber *)opetion;
@end
