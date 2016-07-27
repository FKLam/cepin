//
//  DynamicBannerCell.h
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
#import "EScrollerView.h"
@protocol DynamicBannerCellDelegate <NSObject>

- (void)didPushWith:(NSInteger)pageIndex;

@end

@interface DynamicBannerCell : UITableViewCell<EScrollerViewDelegate>
@property(nonatomic,strong)EScrollerView *scrollView;
@property(nonatomic,retain)UIImageView *bannerImage;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)id<DynamicBannerCellDelegate>delegate;
- (void)createScrollViewWith:(NSMutableArray*)imageDatas;

@end
