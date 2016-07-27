//
//  CollectionStatusViewModel.h
//  cepin
//
//  Created by ceping on 14-11-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "CollectionStatusDTO.h"
@class CollectionStatusDTO;

@interface CollectionStatusViewModel : BaseRVMViewModel
{
    NSTimer *timer;
}

@property(nonatomic,strong)CollectionStatusDTO *dataModel;

-(void)run;
-(void)timeRun;
-(void)reStart;

@end
