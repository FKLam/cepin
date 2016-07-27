//
//  BaseTableViewModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "CPRecommendModelFrame.h"
#import "BaseBeanModel.h"
#import "JobSearchModel.h"
#import "DynamicExamModelDTO.h"
#import "SaveJobDTO.h"
#import "SaveCompanyModel.h"
#import "SendReumeModel.h"
#import "DynamicSystemModelDTO.h"


/** 猜你喜欢的数目 */
#define RECOMMEND_LIKENUMBERS 5

@implementation BaseTableViewModel

-(instancetype)init
{
    if (self = [super init]) {
        self.page = 1;
        self.size = 30;
        
        self.likePage = 1;
        self.likeSize = 5;
        _haveMoreNewData = NO;
    }
    return self;
}

- (NSMutableArray *)datas
{
    if( nil == _datas )
    {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)likeArray
{
    if( nil == _likeArray )
    {
        _likeArray = [NSMutableArray array];
    }
    return _likeArray;
}

-(void)reflashPage
{
    self.page = DefualtPage;
    
    //    self.stateCode = [RTHUDModel hudWithCode:HUDCodeDownloading];
    
    [self loadDataWithPage:self.page];
}


-(void)nextPage
{
    if (self.isLoading) {
        return;
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeLoadMore];
    self.page++;
    [self loadDataWithPage:self.page];
}


-(void)loadDataWithPage:(NSInteger)page
{
    
}

- (void)dealDataAndStateCodeWithPage:(NSInteger)page bean:(NSArray*)temp modelClass:(__unsafe_unretained Class)modelClass
{
    if (temp && ![temp isKindOfClass:[NSError class]]) {

#pragma mark - 修复下拉加载时数据减少的问题
//        if (page == 1)
//        {
//            [self.datas removeAllObjects];
//        }
        
#pragma mark - 修复下拉刷新加载重复数据的问题
        BOOL canAddToArray = YES;
        
        NSArray *tempArray = [CPRecommendModelFrame framesWithArray:temp modelClass:modelClass];
        
        // 推荐页
        if ( [JobSearchModel isSubclassOfClass:modelClass] )
        {
            JobSearchModel *tempObjectModel = nil;
        
            JobSearchModel *dataObjectModel = nil;
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                tempObjectModel = (JobSearchModel *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (JobSearchModel *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.PositionId isEqualToString:dataObjectModel.PositionId] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
                    if( !canAddToArray )
                        break;
                }
                
                if ( !canAddToArray )
                    break;
            }
            
        }
        // 测评产品
        else if ([DynamicExamModelDTO isSubclassOfClass:modelClass])
        {
            DynamicExamModelDTO *tempObjectModel = nil;
            
            DynamicExamModelDTO *dataObjectModel = nil;
            
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                tempObjectModel = (DynamicExamModelDTO *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (DynamicExamModelDTO *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.ProductId isEqualToString:dataObjectModel.ProductId] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
                    if( !canAddToArray )
                        break;
                }
                
                if ( !canAddToArray )
                    break;
            }
        }
        // 收藏的职位
        else if ( [SaveJobDTO isSubclassOfClass:modelClass] )
        {
            SaveJobDTO *tempObjectModel = nil;
            
            SaveJobDTO *dataObjectModel = nil;
            
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                tempObjectModel = (SaveJobDTO *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (SaveJobDTO *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.PositionId isEqualToString:dataObjectModel.PositionId] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
                    if( !canAddToArray )
                        break;
                }
                
                if ( !canAddToArray )
                    break;
            }
        }
        // 收藏的企业
        else if ( [SaveCompanyModel isSubclassOfClass:modelClass] )
        {
            SaveCompanyModel *tempObjectModel = nil;
            
            SaveCompanyModel *dataObjectModel = nil;
            
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                tempObjectModel = (SaveCompanyModel *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (SaveCompanyModel *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.CompanyName isEqualToString:dataObjectModel.CompanyName] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
                    if( !canAddToArray )
                        break;
                }
                
                if ( !canAddToArray )
                    break;
            }
        }
        // 已投递的简历
        else if ( [SendReumeModel isSubclassOfClass:modelClass] )
        {
            SendReumeModel *tempObjectModel = nil;
            
            SendReumeModel *dataObjectModel = nil;
            
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                
                tempObjectModel = (SendReumeModel *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (SendReumeModel *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.PositionId isEqualToString:dataObjectModel.PositionId] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
//                    if( !canAddToArray )
//                        break;
                }
                
//                if ( !canAddToArray )
//                    break;
                
                if ( canAddToArray )
                {
                    [self.datas addObject:tempObject];
                    
                }
                else
                    canAddToArray = YES;
            }
            
            canAddToArray = NO;
        }
        // 消息
        else if ( [DynamicSystemModelDTO isSubclassOfClass:modelClass] )
        {
            DynamicSystemModelDTO *tempObjectModel = nil;
            
            DynamicSystemModelDTO *dataObjectModel = nil;
            
            for ( CPRecommendModelFrame *tempObject in tempArray )
            {
                tempObjectModel = (DynamicSystemModelDTO *)tempObject.recommendModel;
                for ( CPRecommendModelFrame *dataObject in self.datas )
                {
                    dataObjectModel = (DynamicSystemModelDTO *)dataObject.recommendModel;
                    
                    if ( [tempObjectModel.MessageId isEqualToString:dataObjectModel.MessageId] )
                    {
                        canAddToArray = NO;
                        break;
                    }
                    
                    if( !canAddToArray )
                        break;
                }
                
                if ( !canAddToArray )
                    break;
            }
        }
        
        if ( canAddToArray )
            [self.datas addObjectsFromArray:tempArray];
        
        if (page == 1)
        {
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeReflashSucess];
        }
        else
        {
            self.stateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
        }
        
        return;
    }
    if (self.page > DefualtPage) {
        self.page--;
    }
    self.stateCode = [NSError errorWithErrorType:ErrorTypeLost];
}

// 处理猜你喜欢的数据
- (void)dealLikeDataWithPage:(NSInteger)page array:(NSArray *)array
{
    if ( [array count] == 0 )
        return;
    
    [self.likeArray removeAllObjects];
    
    [self.likeArray addObjectsFromArray:[CPRecommendModelFrame framesWithArray:array modelClass:[JobSearchModel class]]];
    
}

@end
