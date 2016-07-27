//
//  CPHomeHotRecruitHeaderView.h
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPWHomeHotMoreButton.h"
@class CPHomeHotRecruitHeaderView;
@protocol CPHomeHotRecruitHeaderViewDelegate <NSObject>
@optional
- (void)homeHotRcruitHeaderView:(CPHomeHotRecruitHeaderView *)homeHotRcruitHeaderView clickedMoreButton:(CPWHomeHotMoreButton *)moreButton;
@end
@interface CPHomeHotRecruitHeaderView : UIView
@property (nonatomic, weak) id<CPHomeHotRecruitHeaderViewDelegate> homeHotRecruitHeaderViewDelegate;
@property (nonatomic, strong) CPWHomeHotMoreButton *moreButton;
@end
