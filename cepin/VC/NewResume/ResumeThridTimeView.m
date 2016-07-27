//
//  ResumeThridTimeView.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@implementation ResumeThridTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.maskButton = [[UIButton alloc]initWithFrame:self.bounds];
        self.maskButton.backgroundColor = [UIColor blackColor];
        self.maskButton.alpha = 0.75;
        [self addSubview:self.maskButton];
        @weakify(self)
        [self.maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(clickCancelButton)]) {
                [self.delegate clickCancelButton];
            }
        }];
        CGFloat whithH = ( 144 * 4 + 5 * 2 + 2 ) / CP_GLOBALSCALE;
        self.whith = [[UIView alloc]initWithFrame:CGRectMake(140 / CP_GLOBALSCALE, (kScreenHeight - whithH) / 2.0, self.viewWidth - 140 * 2 / CP_GLOBALSCALE, whithH)];
        self.whith.backgroundColor = [UIColor whiteColor];
        self.whith.center = CGPointMake(self.viewCenterX, self.viewCenterY);
        [self.whith.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [self.whith.layer setMasksToBounds:YES];
        [self addSubview:self.whith];
        yearsArray = [[NSMutableArray alloc]init];
        monthsArray = [[NSMutableArray alloc]init];
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        self.maxYear = strYear.intValue + 25;
        for (int i = 1960; i <= self.maxYear; i++)
        {
            [yearsArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for (int i = 1; i < 13; i++)
        {
            [monthsArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        //时间选择
        dataTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, -15.0, self.whith.viewWidth, ( 144 * 3 + 5 * 2 ) / CP_GLOBALSCALE)];
        [self.whith addSubview:dataTimeView];
        //底部取消 确定按钮
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, whithH - 144 / CP_GLOBALSCALE, (self.whith.viewWidth - 2 / CP_GLOBALSCALE ) / 2.0, 144 / CP_GLOBALSCALE)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [self.whith addSubview:cancelButton];
        UIButton *ensureButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + 2 / CP_GLOBALSCALE, cancelButton.viewY, cancelButton.viewWidth, cancelButton.viewHeight)];
        [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        [ensureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [ensureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [self.whith addSubview:ensureButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.hidden = YES;
            if ([self.delegate respondsToSelector:@selector(clickCancelButton)]) {
                [self.delegate clickCancelButton];
            }
        }];
        [ensureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.hidden = YES;
            if ([self.delegate respondsToSelector:@selector(clickEnsureButton:month:)]) {
                [self.delegate clickEnsureButton:self.year month:self.month];
            }
        }];
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, cancelButton.viewY - 2 / CP_GLOBALSCALE, self.whith.viewWidth, 2 / CP_GLOBALSCALE)];
        [horLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.whith addSubview:horLine];
        UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), cancelButton.viewY, 2 / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        [verLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.whith addSubview:verLine];
        //设置年月
        [self setYearScrollView];
        [self setMonthScrollView];
        int width = 200 / CP_GLOBALSCALE;
        int offset = 100 / CP_GLOBALSCALE;
        int height = 5 / CP_GLOBALSCALE;
        //lineView
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(offset, 144 / CP_GLOBALSCALE, width, height)];
        line1.backgroundColor = [UIColor colorWithHexString:@"288add"];
        [self.whith addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(offset, 144 / CP_GLOBALSCALE * 2 + 5 / CP_GLOBALSCALE, width, height)];
        line2.backgroundColor = [UIColor colorWithHexString:@"288add"];
        [self.whith addSubview:line2];
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(self.whith.viewWidth - width - 100 / CP_GLOBALSCALE, line1.viewY, width, height)];
        line3.backgroundColor = [UIColor colorWithHexString:@"288add"];
        [self.whith addSubview:line3];
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(self.whith.viewWidth - width - 100 / CP_GLOBALSCALE, line2.viewY, width, height)];
        line4.backgroundColor = [UIColor colorWithHexString:@"288add"];
        [self.whith addSubview:line4];
    }
    return self;
}
//设置年滚动视图
- (void)setYearScrollView
{
    yearScrollView  = [[MXSCycleScrollView alloc]initWithFrame:CGRectMake(100 / CP_GLOBALSCALE, 0, 200 / CP_GLOBALSCALE, dataTimeView.viewHeight)];
    yearScrollView.datasource = self;
    yearScrollView.delegate = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [dataTimeView addSubview:yearScrollView];
}
//设置月滚动视图
- (void)setMonthScrollView
{
    monthScrollView = [[MXSCycleScrollView alloc]initWithFrame:CGRectMake(self.whith.viewWidth - 200 / CP_GLOBALSCALE - 100 / CP_GLOBALSCALE, 0, 200 / CP_GLOBALSCALE, dataTimeView.viewHeight)];
    monthScrollView.datasource = self;
    monthScrollView.delegate = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [dataTimeView addSubview:monthScrollView];
}
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMM"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [oneLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [twoLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [currentLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
}
- (void)resetAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [oneLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber + 1];
    [twoLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [twoLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber + 2];
    [currentLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [currentLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
}
#pragma mark - MXSCycleScrollViewDatasource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView)
    {
        return yearsArray.count;
    }
    else if (scrollView == monthScrollView)
    {
        return monthsArray.count;
    }
    return 0;
}
- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView*)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, (scrollView.bounds.size.height - 5 * 2 / CP_GLOBALSCALE ) / 3 )];
    if (scrollView == yearScrollView)
    {
        l.text = [NSString stringWithFormat:@"%@",[yearsArray objectAtIndex:index]];
    }
    else if (scrollView == monthScrollView)
    {
        l.text = [NSString stringWithFormat:@"%@",[monthsArray objectAtIndex:index]];
    }
    l.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    [l setTextColor:[UIColor colorWithHexString:@"404040"]];
    return l;
}
#pragma mark - MXSCycleScrollViewDelegate
- (void)didClickPage:(MXSCycleScrollView *)csView atIndex:(NSInteger)index
{
}
- (void)scrollviewDidChangeNumber
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:2];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:2];
    self.year = yearLabel.text.intValue;
    self.month = monthLabel.text.intValue;
}
-(void)setCurrentYearAndMonth:(int)year month:(int)month
{
    NSInteger curpage = 0;
    if ( month == 1 )
    {
        curpage = monthsArray.count - 1;
    }
    else if( month == 2 )
    {
        curpage = monthsArray.count - 12;
    }
    else
    {
        curpage = month - 2;
    }
    self.month = month;
    [monthScrollView setCurrentSelectPage:curpage];
    [monthScrollView reloadData];
    if ( monthScrollView )
        [self resetAfterScrollShowView:monthScrollView andCurrentPage:1];
    self.year = year;
    if ( year == 1960 )
    {
        curpage = yearsArray.count - 2;
    }
    else if( year == 1961 )
    {
        curpage = yearsArray.count - 1;
    }
    else
    {
        curpage = year - 1960 - 1;
    }
    [yearScrollView setCurrentSelectPage:curpage];
    [yearScrollView reloadData];
    if ( yearScrollView )
        [self resetAfterScrollShowView:yearScrollView andCurrentPage:1];
}
@end