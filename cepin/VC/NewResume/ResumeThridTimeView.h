//
//  ResumeThridTimeView.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@protocol ResumeThridTimeViewDelegate <NSObject>

@optional
- (void)clickCancelButton;
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month;
@end
@interface ResumeThridTimeView : UIView<MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>
{
    UILabel *chooseTimme;
    UIView *dataTimeView;
    MXSCycleScrollView *yearScrollView;
    MXSCycleScrollView *monthScrollView;
    NSMutableArray *yearsArray;
    NSMutableArray *monthsArray;
}
@property(nonatomic,strong)id<ResumeThridTimeViewDelegate> delegate;
@property(nonatomic,strong)UIButton *maskButton;
@property(nonatomic,strong)UIView *whith;
@property(nonatomic,assign)NSUInteger year;
@property(nonatomic,assign)NSUInteger month;
@property(nonatomic,assign)NSUInteger maxYear;
-(void)setCurrentYearAndMonth:(int)year month:(int)month;
@end
