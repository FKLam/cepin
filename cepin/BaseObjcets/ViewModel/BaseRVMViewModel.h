//
//  BaseRVMViewModel.h
//  letsgo
//
//  Created by Ricky Tang on 14-7-31.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RVMViewModel.h"
#import "RTHUDModel.h"
#import "NSDictionary+NetworkBean.h"

static NSInteger const DefualtPage = 1;

@interface BaseRVMViewModel : RVMViewModel
@property(nonatomic,strong)TBLoading *load;
@property (nonatomic, strong) id stateCode;
@property (nonatomic, strong) id resumeStateCode;
@property (nonatomic, strong) id showDone;
-(void)CheckErrorCode:(NSDictionary*)dic;

-(void)momeryRelease;

-(BOOL)CheckLoginOut;


@end
