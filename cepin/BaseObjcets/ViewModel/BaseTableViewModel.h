//
//  BaseTableViewModel.h
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface BaseTableViewModel : BaseRVMViewModel

@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger size;
@property (nonatomic, assign) NSInteger likeSize;
@property (nonatomic, assign) NSInteger likePage;
@property (nonatomic, assign, getter=isHaveMoreNewData) BOOL haveMoreNewData;

@property(nonatomic,assign)BOOL isLoading;
/** 存放猜你喜欢数据的数组 */
@property (nonatomic, strong) NSMutableArray *likeArray;

-(void)reflashPage;

-(void)nextPage;

-(void)loadDataWithPage:(NSInteger)page;

//专门处理请求得到的结果及stateCode
- (void)dealDataAndStateCodeWithPage:(NSInteger)page bean:(NSArray*)temp modelClass:(__unsafe_unretained Class)modelClass;

/** 
 *  处理猜你喜欢的数据
 *
 *  @param  page    页码
 *  @param  array   待处理的数据
 */
- (void)dealLikeDataWithPage:(NSInteger)page array:(NSArray *)array;
@end
