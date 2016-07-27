//
//  DynamicBannerCell.h
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
#import "BannerView.h"

@protocol DynamicBannerCellDelegate <NSObject>

- (void)didPushWith:(NSInteger)pageIndex;

@end

@interface DynamicBannerCell : UITableViewCell<BannerViewDelegate>


@property(nonatomic, strong)BannerView *bannerView;
@property(nonatomic,retain)UIImageView *bannerImage;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)id<DynamicBannerCellDelegate>delegate;

- (void)createScrollViewWith:(NSMutableArray*)imageDatas;

+(int)computyHith:(UIImage *)image;

@end
