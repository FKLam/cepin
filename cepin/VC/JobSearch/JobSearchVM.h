//
//  JobSearchVM.h
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"

#import "KeywordModel.h"
#import "SubscriptionJobModel.h"
#import "PositionIdModel.h"

@protocol  JobSearchVM
@end

@interface JobSearchVM : BaseTableViewModel
@property(nonatomic,strong)NSArray *keyTypeModels;
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSMutableArray *keywords;
@property(nonatomic,strong)id keywordStateCode;
@property(nonatomic,strong)SubscriptionJobModel *subModel;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic, strong)NSMutableArray *positionIdArray;

-(void)deleteAllKeywords;

- (void)sort;

-(void)deleteKeyWord:(NSString*)keyword;

- (void)allPositionId;
@end
