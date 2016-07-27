//
//  CPHomeRecommendHeaderView.h
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPHomeRecommendButton.h"

@class CPHomeRecommendHeaderView;
@protocol CPHomeRecommendHeaderViewDelegate <NSObject>
@optional
- (void)recommendView:(CPHomeRecommendHeaderView *)recommendView changeImageWithIndex:(NSUInteger)index;
@end

@interface CPHomeRecommendHeaderView : UIView
@property (nonatomic, strong) CPHomeRecommendButton *changeButton;
@property (nonatomic, weak) id<CPHomeRecommendHeaderViewDelegate> recommendHeaderViewDelegate;
@end
