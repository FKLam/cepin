//
//  BannerVC.h
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
@class BannerVC;
@protocol BannerDelegate <NSObject>
- (void)jumpAdvertisement;
- (void)cancelAutoLogin:(NSString*)url;
- (void)bannerVC:(BannerVC *)bannerVC isFinishTime:(BOOL)isFinishTime;
@end
@interface BannerVC : BaseTableViewController
@property(nonatomic,assign)id<BannerDelegate>delegate;
@property(nonatomic,strong)UIButton *jumpButton;
@property(nonatomic,strong)UILabel *timeLabel;
@end
