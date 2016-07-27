//
//  AddPracticeListVM.m
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddPracticeListVM.h"
#import "RTNetworking+Resume.h"
#import "TBtextUnit.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface AddPracticeListVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation AddPracticeListVM

- (instancetype)initWithResumeid:(NSString *)resumeid
{
    self = [super init];
    if (self) {
        self.pracData = [PracticeListDataModel new];
        
        self.resumeId = resumeid;
    }
    return self;
}

- (BOOL)request
{
    
    if (!self.pracData.StartDate || [self.pracData.StartDate isEqualToString:@""])
    {
        [self showShordMessage:@"请选择开始时间" ];
        return NO;
    }
    if (!self.pracData.EndDate || [self.pracData.EndDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = [date stringMMFromDate];
        self.pracData.EndDate = [NSString stringWithFormat:@"%@-%@-1",strYear,strMonth];
        NSArray *beginArray = [self.pracData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.pracData.EndDate componentsSeparatedByString:@"-"];
        
        self.strBeginYear = [beginArray objectAtIndex:0];
        self.strEndYear = [endArray objectAtIndex:0];
        self.strBeginMonth = [beginArray objectAtIndex:1];
        self.strEndMonth = [endArray objectAtIndex:1];
        self.pracData.EndDate = @"";
    }else
    {
        NSArray *beginArray = [self.pracData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.pracData.EndDate componentsSeparatedByString:@"-"];
        
        self.strBeginYear = [beginArray objectAtIndex:0];
        self.strEndYear = [endArray objectAtIndex:0];
        self.strBeginMonth = [beginArray objectAtIndex:1];
        self.strEndMonth = [endArray objectAtIndex:1];
    }
    if ( self.strBeginYear.intValue >  self.strEndYear.intValue || ( self.strBeginYear.intValue ==  self.strEndYear.intValue &&  self.strBeginMonth.intValue >  self.strEndMonth.intValue))
    {
        [self showShordMessage:@"开始时间不能大于结束时间"];
        return NO;
    }
    
    if (!self.pracData.Name || [self.pracData.Name isEqualToString:@""])
    {
        [self showShordMessage:@"请输入实践名称"];
        return NO;
    }
    if (!self.pracData.Title || [self.pracData.Title isEqualToString:@""])
    {
        [self showShordMessage:@"请输入职务名称"];
        return NO;
    }
    if (!self.pracData.Content || [self.pracData.Content isEqualToString:@""])
    {
        [self showShordMessage:@"请输入实践描述"];
        return NO;
    }
    return YES;
}
- (void)addPractice
{
    if (![self request]) {
        return;
    }
    
    TBLoading *load = [TBLoading new];
    [load start];
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    //    if (!self.workData.Salary || [self.workData.Salary isEqualToString:@""]) {
    //        self.workData.Salary = @"";
    //    }
    
    RACSignal *signal = [[RTNetworking shareInstance]addThridPracticeStartDate:self.pracData.StartDate userId:userId tokenId:TokenId EndDate:self.pracData.EndDate Title:self.pracData.Title Name:self.pracData.Name Content:self.pracData.Content ResumeId:self.resumeId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
//            [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [self showShordMessage:NetWorkError];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
        self.stateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)showShordMessage:(NSString *)message
{
    self.existAccountTipsView = [self shortMessageTipsView:message];
    [[UIApplication sharedApplication].keyWindow addSubview:self.existAccountTipsView];
}
#pragma mark - getter method
- (UIView *)shortMessageTipsView:(NSString *)message
{
    if ( !_existAccountTipsView )
    {
        _existAccountTipsView = [[UIView alloc] initWithFrame:self.showMessageVC.view.bounds];
        [_existAccountTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
        CGFloat H = ( 84 + 60 + 84 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        NSString *str = message;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        H += strSize.height;
        if ( strSize.height > ( 48 + 24 + 24 ) / CP_GLOBALSCALE )
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
        else
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
        attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_existAccountTipsView addSubview:tipsView];
        self.tipsView = tipsView;
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [titleLabel setText:@"提示"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
        }];
        CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [contentLabel setVerticalAlignment:VerticalAlignmentTop];
        [contentLabel setNumberOfLines:0];
        self.contentLabel = contentLabel;
        [contentLabel setAttributedText:attStr];
        [tipsView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
            make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_existAccountTipsView setHidden:YES];
            [_existAccountTipsView removeFromSuperview];
            _existAccountTipsView = nil;
        }];
    }
    return _existAccountTipsView;
}
@end
