//
//  CPGuessYLPositionVM.m
//  cepin
//
//  Created by ceping on 16/3/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPGuessYLPositionVM.h"
#import "CPGuessYouLikePositionCacheReformer.h"
#import "RTNetworking+Position.h"
#import "JobSearchModel.h"
@interface CPGuessYLPositionVM ()
@property (nonatomic, assign) NSInteger offset;
@end
@implementation CPGuessYLPositionVM
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.offset = 0;
    }
    return self;
}
- (void)getAllGuessYLPosition
{
    if ( self.isLoading )
    {
        self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        return;
    }
    self.isLoading = YES;
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *city = @"";
//    if ( self.locationRegion && 0 < [self.locationRegion.RegionName length] )
//    {
//        if ( ![self.locationRegion.RegionName isEqualToString:@"全国"] )
//            city = self.locationRegion.PathCode;
//    }
    if ( self.locationRegion.PathCode )
        city = self.locationRegion.PathCode;
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    [self.visiabelGuessYLPositionArrayM removeAllObjects];
    [self.visiabelGuessYLPositionDictArrayM removeAllObjects];
    [self.allGuessYLPositionArrayM removeAllObjects];
    [self.allGuessYLPositionDictArrayM removeAllObjects];
    [CPGuessYouLikePositionCacheReformer clearup];
    if ( 0 == [strUser length] )
    {
        self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        return;
    }
    RACSignal *guessSignal = [[RTNetworking shareInstance] guessYouLikePositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30];
    [guessSignal subscribeNext:^(RACTuple *tuple)
    {
         NSDictionary *dict = (NSDictionary *)tuple.second;
         if([dict resultSucess] || ![[dict resultObject] isKindOfClass:[NSArray class]] )
         {
             NSArray *array = [dict resultObject];
             NSInteger countTemp = 0;
             if ( [array isKindOfClass:[NSArray class]] )
             {
                 [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[JobSearchModel class]];
                 countTemp = [array count];
             }
             if( countTemp > 0 ) // 匹配的职位数 >= 2
             {
                 if ( [array count] > 30 )
                 {
                     NSMutableArray *tempArray = [NSMutableArray array];
                     for ( NSInteger index = 0; index < 30; index++ )
                     {
                         [tempArray addObject:array[index]];
                         [self.allGuessYLPositionDictArrayM addObject:array[index]];
                     }
                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                 }
                 else
                 {
                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:array modelClass:[JobSearchModel class]]];
                     [self.allGuessYLPositionDictArrayM addObjectsFromArray:array];
                 }
                 if ( [array count] >= 10 )
                 {
                     for ( NSInteger index = 0; index < 10; index++ )
                     {
                         [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                         [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                     }
                 }
                 else
                 {
                     [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                     [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                 }
                 [self setupGuessCache];
                 self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
             }
             else // 补数据［定位城市＋关键字］关键字取 运营配置的职位诱惑关键字
             {
                 RACSignal *firstBackupData = [[RTNetworking shareInstance] getKeywordSearchPositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30 city:city];
                 [firstBackupData subscribeNext:^(RACTuple *firstTuple) {
                     NSDictionary *firstDict = (NSDictionary *)firstTuple.second;
                     if ( [firstDict resultSucess] )
                     {
                         NSArray *firstArray = [firstDict resultObject];
                         [self dealDataAndStateCodeWithPage:self.page bean:firstArray modelClass:[JobSearchModel class]];
                         if ( [firstArray count] >= 6 ) // 补数的职位数 >= 6
                         {
                             if ( [firstArray count] > 30 )
                             {
                                 NSMutableArray *tempArray = [NSMutableArray array];
                                 for ( NSInteger index = 0; index < 30; index++ )
                                 {
                                     [tempArray addObject:firstArray[index]];
                                     [self.allGuessYLPositionDictArrayM addObject:firstArray[index]];
                                 }
                                 [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                             }
                             else
                             {
                                 [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:array modelClass:[JobSearchModel class]]];
                                 [self.allGuessYLPositionDictArrayM addObjectsFromArray:array];
                             }
                             if ( [firstArray count] >= 10 )
                             {
                                 for ( NSInteger index = 0; index < 10; index++ )
                                 {
                                     [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                                     [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                                 }
                             }
                             else
                             {
                                 [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                                 [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                             }
                             [self setupGuessCache];
                             self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                         }
                     }
                     else // 补全国数据[全国 ＋ 关键字]关键字取 运营配置的职位诱惑关键字
                     {
                         RACSignal *secondBackupData = [[RTNetworking shareInstance] getKeywordSearchPositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30 city:@"全国"];
                         [secondBackupData subscribeNext:^(RACTuple *secondTuple) {
                             NSDictionary *secondDict = (NSDictionary *)secondTuple.second;
                             if ( [secondDict resultSucess] )
                             {
                                 NSMutableArray *secondArray = [secondDict resultObject];
                                 [self dealDataAndStateCodeWithPage:self.page bean:secondArray modelClass:[JobSearchModel class]];
                                 if ( [secondArray count] > 30 )
                                 {
                                     NSMutableArray *tempArray = [NSMutableArray array];
                                     for ( NSInteger index = 0; index < 30; index++ )
                                     {
                                         [tempArray addObject:secondArray[index]];
                                         [self.allGuessYLPositionDictArrayM addObject:secondArray[index]];
                                     }
                                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                                 }
                                 else
                                 {
                                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:secondArray modelClass:[JobSearchModel class]]];
                                     [self.allGuessYLPositionDictArrayM addObjectsFromArray:secondArray];
                                 }
                                 if ( [secondArray count] >= 10 )
                                 {
                                     for ( NSInteger index = 0; index < 10; index++ )
                                     {
                                         [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                                         [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                                     }
                                 }
                                 else
                                 {
                                     [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                                     [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                                 }
                                 [self setupGuessCache];
                                 self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                             }
                         }error:^(NSError *error)
                          {
                              [self noNetworkGetCache];
                          }];
                     }
                 }error:^(NSError *error)
                  {
                      [self noNetworkGetCache];
                  }];
             }
         }
         else
         {
             RACSignal *firstBackupData = [[RTNetworking shareInstance] getKeywordSearchPositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30 city:city];
             [firstBackupData subscribeNext:^(RACTuple *firstTuple) {
                 NSDictionary *firstDict = (NSDictionary *)firstTuple.second;
                 if ( [firstDict resultSucess] )
                 {
                     NSArray *firstArray = [firstDict resultObject];
                     [self dealDataAndStateCodeWithPage:self.page bean:firstArray modelClass:[JobSearchModel class]];
                     if ( [firstArray count] >= 6 ) // 补数的职位数 >= 6
                     {
                         if ( [firstArray count] > 30 )
                         {
                             NSMutableArray *tempArray = [NSMutableArray array];
                             for ( NSInteger index = 0; index < 30; index++ )
                             {
                                 [tempArray addObject:firstArray[index]];
                                 [self.allGuessYLPositionDictArrayM addObject:firstArray[index]];
                             }
                             [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                         }
                         else
                         {
                             [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:firstArray modelClass:[JobSearchModel class]]];
                             [self.allGuessYLPositionDictArrayM addObjectsFromArray:firstArray];
                         }
                         if ( [firstArray count] >= 10 )
                         {
                             for ( NSInteger index = 0; index < 10; index++ )
                             {
                                 [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                                 [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                             }
                         }
                         else
                         {
                             [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                             [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                         }
                         [self setupGuessCache];
                         self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                     }
                     else
                     {
                         RACSignal *secondBackupData = [[RTNetworking shareInstance] getKeywordSearchPositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30 city:@"全国"];
                         [secondBackupData subscribeNext:^(RACTuple *secondTuple) {
                             NSDictionary *secondDict = (NSDictionary *)secondTuple.second;
                             if ( [secondDict resultSucess] )
                             {
                                 NSArray *secondArray = [secondDict resultObject];
                                 [self dealDataAndStateCodeWithPage:self.page bean:secondArray modelClass:[JobSearchModel class]];
                                 if ( [secondArray count] > 30 )
                                 {
                                     NSMutableArray *tempArray = [NSMutableArray array];
                                     for ( NSInteger index = 0; index < 30; index++ )
                                     {
                                         [tempArray addObject:secondArray[index]];
                                         [self.allGuessYLPositionDictArrayM addObject:secondArray[index]];
                                     }
                                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                                 }
                                 else
                                 {
                                     [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:secondArray modelClass:[JobSearchModel class]]];
                                     [self.allGuessYLPositionDictArrayM addObjectsFromArray:secondArray];
                                 }
                                 if ( [secondArray count] >= 10 )
                                 {
                                     for ( NSInteger index = 0; index < 10; index++ )
                                     {
                                         [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                                         [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                                     }
                                 }
                                 else
                                 {
                                     [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                                     [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                                 }
                                 [self setupGuessCache];
                                 self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                             }
                         }error:^(NSError *error)
                          {
                              [self noNetworkGetCache];
                          }];
                     }
                 }
                 else // 补全国数据[全国 ＋ 关键字]关键字取 运营配置的职位诱惑关键字
                 {
                     RACSignal *secondBackupData = [[RTNetworking shareInstance] getKeywordSearchPositionListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30 city:@"全国"];
                     [secondBackupData subscribeNext:^(RACTuple *secondTuple) {
                         NSDictionary *secondDict = (NSDictionary *)secondTuple.second;
                         if ( [secondDict resultSucess] )
                         {
                             NSArray *secondArray = [secondDict resultObject];
                             [self dealDataAndStateCodeWithPage:self.page bean:secondArray modelClass:[JobSearchModel class]];
                             if ( [secondArray count] > 30 )
                             {
                                 NSMutableArray *tempArray = [NSMutableArray array];
                                 for ( NSInteger index = 0; index < 30; index++ )
                                 {
                                     [tempArray addObject:secondArray[index]];
                                     [self.allGuessYLPositionDictArrayM addObject:secondArray[index]];
                                 }
                                 [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:tempArray modelClass:[JobSearchModel class]]];
                             }
                             else
                             {
                                 [self.allGuessYLPositionArrayM addObjectsFromArray:[CPRecommendModelFrame framesWithArray:secondArray modelClass:[JobSearchModel class]]];
                                 [self.allGuessYLPositionDictArrayM addObjectsFromArray:secondArray];
                             }
                             if ( [secondArray count] >= 10 )
                             {
                                 for ( NSInteger index = 0; index < 10; index++ )
                                 {
                                     [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
                                     [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                                 }
                             }
                             else
                             {
                                 [self.visiabelGuessYLPositionArrayM addObjectsFromArray:self.allGuessYLPositionArrayM];
                                 [self.visiabelGuessYLPositionDictArrayM addObjectsFromArray:self.allGuessYLPositionDictArrayM];
                             }
                             [self setupGuessCache];
                             self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                         }
                     }error:^(NSError *error)
                      {
                          [self noNetworkGetCache];
                      }];
                 }
             }error:^(NSError *error)
              {
                  [self noNetworkGetCache];
              }];
         }
    }error:^(NSError *error)
     {
         [self noNetworkGetCache];
     }];
}
- (void)noNetworkGetCache
{
    if ( 0 == [self.allGuessYLPositionArrayM count] )
    {
        NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
        if ( !strUser )
            [CPGuessYouLikePositionCacheReformer clearup];
        NSArray *tempArray = [CPGuessYouLikePositionCacheReformer positionDictsWithParams:nil];
        [self dealDataAndStateCodeWithPage:self.page bean:tempArray modelClass:[JobSearchModel class]];
        [self.allGuessYLPositionArrayM addObjectsFromArray:self.datas];
        self.datas = nil;
        [self clickedMoreButton];
        self.guessYLStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    }
    else
    {
        self.guessYLStateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
    }
}
- (void)clickedMoreButton
{
    NSUInteger originCount = [self.allGuessYLPositionArrayM count];
    NSUInteger visibleCount = [self.visiabelGuessYLPositionArrayM count];
    NSInteger leaveCount = originCount - visibleCount;
    if ( 0 >= leaveCount )
        return;
    else if ( 10 < leaveCount )
    {
        for ( NSInteger index = visibleCount; index < visibleCount + 10; index++ )
        {
            [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
            if ( 0 < [self.datas count] )
            {
                [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                [self addCacheWithDictionary:self.allGuessYLPositionDictArrayM[index]];
            }
        }
    }
    else
    {
        for ( NSInteger index = visibleCount; index < originCount; index++ )
        {
            [self.visiabelGuessYLPositionArrayM addObject:self.allGuessYLPositionArrayM[index]];
            if ( 0 < [self.datas count] )
            {
                [self.visiabelGuessYLPositionDictArrayM addObject:self.allGuessYLPositionDictArrayM[index]];
                [self addCacheWithDictionary:self.allGuessYLPositionDictArrayM[index]];
            }
        }
    }
}
- (void)setupGuessCache
{
    [CPGuessYouLikePositionCacheReformer clearup];
    [self setGuessYouLikeCache];
}
- (void)setGuessYouLikeCache
{
    if ( [self.visiabelGuessYLPositionArrayM count] >= 30 )
        return;
    NSInteger count = [self.allGuessYLPositionArrayM count];
    NSInteger tempOffset = self.offset + 10;
    tempOffset = tempOffset > count ? count : tempOffset;
    for ( NSInteger index = self.offset; index < tempOffset; index++ )
    {
        [self addCacheWithDictionary:self.allGuessYLPositionDictArrayM[index]];
    }
    self.offset += 10;
}
- (void)addCacheWithDictionary:(NSDictionary *)dict
{
    NSInteger page = [self.visiabelGuessYLPositionArrayM count] / 10;
    CPGuessYouLikePositionParam *params = [[CPGuessYouLikePositionParam alloc] init];
    params.pageString = [NSString stringWithFormat:@"%ld", (long)page];
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    params.userid = strUser;
    [CPGuessYouLikePositionCacheReformer addGuessYouLikePositionDict:dict params:params];
}
- (NSMutableArray *)allGuessYLPositionDictArrayM
{
    if ( !_allGuessYLPositionDictArrayM )
    {
        _allGuessYLPositionDictArrayM = [NSMutableArray array];
    }
    return _allGuessYLPositionDictArrayM;
}
- (NSMutableArray *)visiabelGuessYLPositionDictArrayM
{
    if ( !_visiabelGuessYLPositionDictArrayM )
    {
        _visiabelGuessYLPositionDictArrayM = [NSMutableArray array];
    }
    return _visiabelGuessYLPositionDictArrayM;
}
- (NSMutableArray *)allGuessYLPositionArrayM
{
    if ( !_allGuessYLPositionArrayM )
    {
        _allGuessYLPositionArrayM = [NSMutableArray array];
    }
    return _allGuessYLPositionArrayM;
}
- (NSMutableArray *)visiabelGuessYLPositionArrayM
{
    if ( !_visiabelGuessYLPositionArrayM )
    {
        _visiabelGuessYLPositionArrayM = [NSMutableArray array];
    }
    return _visiabelGuessYLPositionArrayM;
}
- (Region *)locationRegion
{
    if ( !_locationRegion )
    {
        _locationRegion = [[Region alloc] init];
    }
    return _locationRegion;
}
@end
