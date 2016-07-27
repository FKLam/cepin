//
//  SendResumeVC.h
//  cepin
//  投递纪录
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol SendResumeVCDelegate <NSObject>
@optional
- (void)sendResumeVCNotify;
@end
@interface SendResumeVC : BaseTableViewController
@property (nonatomic, weak) id<SendResumeVCDelegate> sendResumeDelegate;
@end
