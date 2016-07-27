//
//  DynamicVM.h
//  cepin
//
//  Created by Ricky Tang on 14-11-7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "DynamicNewModel.h"
#import "RCIM.h"
#import "DynamicRecvModelDTO.h"
#import "DynamicCompanyTalkInModelDTO.h"
#import "UserInfoVM.h"
#import "BannerModel.h"

@interface DynamicVM : BaseTableViewModel<RCIMReceiveMessageDelegate>
{
    NSTimer *timer;
}

@property(nonatomic,retain)UserInfoVM *userInfoVM;
@property(nonatomic,retain)BannerModel *bannerModel;
@property(nonatomic,retain)UIImage     *bannerImage;

-(void)getDynamicCount;
-(void)getCompanyTalk;
-(void)getBanner;
-(void)toTop;

@end
