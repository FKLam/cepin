//
//  CPProjectExperienceTimeView.h
//  cepin
//
//  Created by ceping on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"
@protocol CPProjectExperienceTimeViewDelegate <NSObject>
@optional
- (void)clickCancelButton;
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month;
@end
@interface CPProjectExperienceTimeView : UIView<MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>
{
    UILabel *chooseTimme;
    UIView *dataTimeView;
    MXSCycleScrollView *yearScrollView;
    MXSCycleScrollView *monthScrollView;
    NSMutableArray *yearsArray;
    NSMutableArray *monthsArray;
}
@property(nonatomic,strong)id<CPProjectExperienceTimeViewDelegate> delegate;
@property(nonatomic,strong)UIButton *maskButton;
@property(nonatomic,strong)UIView *whith;
@property(nonatomic,assign)NSUInteger year;
@property(nonatomic,assign)NSUInteger month;
@property(nonatomic,assign)NSUInteger maxYear;
-(void)setCurrentYearAndMonth:(int)year month:(int)month;
@end
