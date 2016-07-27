//
//  RecommendVC.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RegionDTO.h"

/**
 *添加切换城市的监听
 *
 */
@protocol ChangeCityListener <NSObject>

-(void)changeCity:(Region *)cityRegion;

@end

@interface RecommendVC : BaseTableViewController
@property (nonatomic, assign) BOOL isTranslate;
- (void)comeFromeWithString:(NSString *)string;
- (void)comeFromeWithString:(NSString *)string notificationDict:(NSDictionary *)notificationDict;
@end
