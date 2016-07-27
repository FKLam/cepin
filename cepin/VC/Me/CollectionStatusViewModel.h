//
//  CollectionStatusViewModel.h
//  cepin
//
//  Created by ceping on 14-11-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "CollectionStatusDTO.h"

@interface CPWProfileState : JSONModel
@property (nonatomic, strong) NSNumber *Apply;
@property (nonatomic, strong) NSDictionary *Exam;
@property (nonatomic, strong) NSDictionary *Message;
@property (nonatomic, assign) BOOL HaveRecommend;
@end

@class CollectionStatusDTO;

@interface CollectionStatusViewModel : BaseRVMViewModel
{
    NSTimer *timer;
}

@property(nonatomic,strong)CollectionStatusDTO *dataModel;
@property (nonatomic, strong) id unExamCode;
@property(nonatomic,assign)NSInteger count;
@property (nonatomic, strong) CPWProfileState *profileState;

-(void)run;
-(void)timeRun;
-(void)reStart;
- (void)getUnOperationCount;
@end
