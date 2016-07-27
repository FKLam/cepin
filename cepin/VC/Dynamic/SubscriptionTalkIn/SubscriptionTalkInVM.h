//
//  SubscriptionTalkInVM.h
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "SubscriptionTalkModelDTO.h"

@interface SubscriptionTalkInVM : BaseRVMViewModel

@property(nonatomic,retain)id DeleteStateCode;
@property(nonatomic,retain)id SaveStateCode;
@property(nonatomic,retain)NSString *schoolsString;

-(void)getSubscriptionTalkIn;
-(void)saveSubscription;
-(void)deleteSubscription;

@end
