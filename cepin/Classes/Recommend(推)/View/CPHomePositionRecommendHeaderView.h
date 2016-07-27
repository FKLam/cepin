//
//  CPHomePositionRecommendHeaderView.h
//  cepin
//
//  Created by ceping on 16/3/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPHomeRecommendButton.h"
@class CPHomePositionRecommendHeaderView;
@protocol CPHomePositionRecommendHeaderViewDelegate <NSObject>
@optional
- (void)homePositionRecommendHeaderView:(CPHomePositionRecommendHeaderView *)homePositionRecommendHeaderView clickedMoreButton:(CPHomeRecommendButton *)moreButton;
@end
@interface CPHomePositionRecommendHeaderView : UIView
@property (nonatomic, weak) id<CPHomePositionRecommendHeaderViewDelegate> homePositionRecommendHeaderViewDelegate;
@property (nonatomic, strong) CPHomeRecommendButton *moreButton;
@end
