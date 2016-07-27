//
//  RecommendVM.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "BannerModel.h"
#import "PositionIdModel.h"
@interface RecommendVM : BaseTableViewModel
@property (nonatomic, strong) id bannerStateCode;
@property (nonatomic, strong) id recommendStateCode;
@property (nonatomic, strong) id homeAutoLoginStateCode;
@property (nonatomic, strong) id updateVersionStateCode;
@property (nonatomic, strong) NSMutableArray *bannerDatas;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong) TBLoading *TBLoad;
@property (nonatomic, strong) NSMutableArray *positionIdArray;
@property (nonatomic, strong) NSMutableArray *visiabelRecommendPositionArrayM;
@property (nonatomic, strong) NSMutableArray *allRecommendPositionArrayM;
@property (nonatomic, strong) NSMutableArray *visiabelRecommendPositionDictArrayM;
@property (nonatomic, strong) NSMutableArray *allRecommendPositionDictArrayM;
@property (nonatomic, strong)NSString *cityCode;
@property (nonatomic, strong) NSDictionary *updateVersionDict;
@property (nonatomic, assign) BOOL isTranslate;
- (void)allPositionId;
-(void)getBanner;
- (void)clickedMoreButton;
- (void)HomeAutoLogin;
- (void)checkVersionUpdateFromeServer;
@end
