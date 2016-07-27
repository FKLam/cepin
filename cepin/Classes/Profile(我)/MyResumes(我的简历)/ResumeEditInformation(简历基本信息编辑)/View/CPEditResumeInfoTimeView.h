//
//  CPEditResumeInfoTimeView.h
//  cepin
//
//  Created by ceping on 16/2/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"
@protocol CPEditResumeInfoTimeViewDelegate <NSObject>

@optional
- (void)clickCancelButton;
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month;
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
@end
@interface CPEditResumeInfoTimeView : UIView<MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>
{
    UILabel *chooseTimme;
    UIView *dataTimeView;
    MXSCycleScrollView *yearScrollView;
    MXSCycleScrollView *monthScrollView;
    MXSCycleScrollView *dayScrollView;
    NSMutableArray *yearsArray;
    NSMutableArray *monthsArray;
    NSMutableArray *daysArray;
}
@property(nonatomic,strong)id<CPEditResumeInfoTimeViewDelegate> delegate;
@property(nonatomic,strong)UIButton *maskButton;
@property(nonatomic,strong)UIView *whith;
@property(nonatomic,assign)NSUInteger year;
@property(nonatomic,assign)NSUInteger month;
@property(nonatomic,assign)NSUInteger maxYear;
@property (nonatomic, assign) NSUInteger minYear;
@property(nonatomic,assign)NSUInteger day;
//-(void)setCurrentYearAndMonth:(int)year month:(int)month;
-(void)setCurrentYearAndMonth:(int)year month:(int)month day:(int)day;
@end
