//
//  EducationListVM.m
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EducationListVM.h"
#import "RTNetworking+Resume.h"
#import "TBtextUnit.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface EducationListVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation EducationListVM
- (instancetype)initWithResumeid:(NSString *)resumeid
{
    self = [super init];
    if (self) {
        self.eduData = [EducationListDateModel new];
        self.resumeId = resumeid;
    }
    return self;
}
- (BOOL)request
{
    if (!self.eduData.StartDate || [self.eduData.StartDate isEqualToString:@""])
    {
        [self showShordMessage:@"请选择入学时间"];
        return NO;
    }
    if (!self.eduData.EndDate || [self.eduData.EndDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = [date stringMMFromDate];
        self.eduData.EndDate = [NSString stringWithFormat:@"%@-%@-1",strYear,strMonth];
        NSArray *beginArray = [self.eduData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.eduData.EndDate componentsSeparatedByString:@"-"];
        
        self.strBeginYear = [beginArray objectAtIndex:0];
        self.strEndYear = [endArray objectAtIndex:0];
        self.strBeginMonth = [beginArray objectAtIndex:1];
        self.strEndMonth = [endArray objectAtIndex:1];
        self.eduData.EndDate = @"";
    }else
    {
        NSArray *beginArray = [self.eduData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.eduData.EndDate componentsSeparatedByString:@"-"];
        
        self.strBeginYear = [beginArray objectAtIndex:0];
        self.strEndYear = [endArray objectAtIndex:0];
        self.strBeginMonth = [beginArray objectAtIndex:1];
        self.strEndMonth = [endArray objectAtIndex:1];
    }
    if ( self.strBeginYear.intValue >  self.strEndYear.intValue || ( self.strBeginYear.intValue ==  self.strEndYear.intValue &&  self.strBeginMonth.intValue >  self.strEndMonth.intValue))
    {
        [self showShordMessage:@"入学时间不能大于毕业时间"];
        return NO;
    }
    if (!self.eduData.School || [self.eduData.School isEqualToString:@""])
    {
        [self showShordMessage:@"请输入学校名称"];
        return NO;
    }
    if (!self.eduData.Major || [self.eduData.Major isEqualToString:@""])
    {
        [self showShordMessage:@"请输入专业名称"];
        return NO;
    }
    if (!self.eduData.Degree || [self.eduData.Degree isEqualToString:@""])
    {
        [self showShordMessage:@"请选择学历"];
        return NO;
    }
    if (!self.eduData.SchoolCode || [self.eduData.SchoolCode isEqualToString:@""]) {
        self.eduData.SchoolCode = @"";
    }
    if (self.resumeType.intValue == 2) {
        if (!self.eduData.ScoreRanking || [self.eduData.ScoreRanking isEqualToString:@""]) {
            [self showShordMessage:@"请选择成绩排名"];
            return NO;
        }
        if (!self.eduData.XueWei ||[self.eduData.XueWei isEqualToString:@""]) {
            [self showShordMessage:@"请选择学位"];
            return NO;
        }
        if ( !self.eduData.Description || [self.eduData.Description isEqualToString:@""] )
        {
            [self showShordMessage:@"请输入主修课程"];
            return NO;
        }
    }
    return YES;
}
- (void)addEdu
{
    if (![self request])
    {
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    //把主修课程设置为空
    if (!self.eduData.Description) {
         self.eduData.Description = @"";
    }
    RACSignal *signal = nil;
    if ( self.resumeType.intValue == 1 )
    {
        NSString *majorStr = [NSString stringWithFormat:@"%@", self.eduData.MajorKey];
        signal = [[RTNetworking shareInstance] addThridEducationStartDate:self.eduData.StartDate userId:userId tokenId:TokenId EndDate:self.eduData.EndDate SchoolCode:self.eduData.SchoolCode School:self.eduData.School Major:self.eduData.Major MajorKey:majorStr Degree:self.eduData.Degree DegreeKey:self.eduData.DegreeKey ResumeId:self.resumeId];
    }
    else
    {
        NSString *majorStr = [NSString stringWithFormat:@"%@", self.eduData.MajorKey];
        signal = [[RTNetworking shareInstance] addThridEducationStartDate:self.eduData.StartDate userId:userId tokenId:TokenId EndDate:self.eduData.EndDate SchoolCode:self.eduData.SchoolCode School:self.eduData.School Major:self.eduData.Major MajorKey:majorStr Degree:self.eduData.Degree DegreeKey:self.eduData.DegreeKey ResumeId:self.resumeId ScoreRanking:self.eduData.ScoreRanking Xuewei:self.eduData.XueWei Description:self.eduData.Description];
    }
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
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        [self showShordMessage:@"请选择入学时间"];
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
