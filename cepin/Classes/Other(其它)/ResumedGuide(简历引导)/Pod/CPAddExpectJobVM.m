//
//  CPAddExpectJobVM.m
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPAddExpectJobVM.h"
#import "RTNetworking+Resume.h"
#import "BaseCodeDTO.h"
#import "RegionDTO.h"
#import "TBTextUnit.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPAddExpectJobVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation CPAddExpectJobVM
- (instancetype)initWithResumeModel:(ResumeNameModel*)model
{
    self = [super init];
    if (self) {
        self.resumeNameModel = model;
        self.jobstates = [BaseCode employType];
        if(!self.resumeNameModel.ExpectEmployType){
            self.resumeNameModel.ExpectEmployType = @"1";
        }
    }
    return self;
}
- (BOOL)request
{
    if (!self.resumeNameModel.ExpectCity || [self.resumeNameModel.ExpectCity isEqualToString:@""]) {
        [self showShordMessage:@"期望城市不能为空"];
        return NO;
    }
    if (!self.resumeNameModel.ExpectEmployType || [self.resumeNameModel.ExpectEmployType isEqualToString:@""]) {
        [self showShordMessage:@"工作性质不能为空"];
        return NO;
    }
    if (!self.resumeNameModel.ExpectJobFunction || [self.resumeNameModel.ExpectJobFunction isEqualToString:@""]) {
        [self showShordMessage:@"职能列表不能为空"];
        return NO;
    }
    
    if (!self.resumeNameModel.ExpectSalary || [self.resumeNameModel.ExpectSalary isEqualToString:@""]) {
        [self showShordMessage:@"期望薪酬不能为空"];
        return NO;
    }
    
    if (self.resumeNameModel.ResumeType.intValue==2) {
        if (!self.resumeNameModel.AvailableType || [self.resumeNameModel.AvailableType isEqualToString:@""]) {
            [self showShordMessage:@"到岗时间不能为空"];
            return NO;
        }
        if (nil == self.resumeNameModel.IsAllowDistribution) {
            [self showShordMessage:@"服从分配不能为空"];
            return NO;
        }
    }
    return YES;
}
- (void)saveExpectJob
{
    if (![self request]) {
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal  = nil;
    if ( self.resumeNameModel.ResumeType.intValue == 1 )
    {
        signal = [[RTNetworking shareInstance] saveThridExpectJobWithResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:TokenId ExpectCity:self.resumeNameModel.ExpectCity ExpectIndustry:self.resumeNameModel.ExpectJobFunction ExpectEmployType:self.resumeNameModel.ExpectEmployType ExpectSalary:self.resumeNameModel.ExpectSalary];
    }
    else
    {
        NSString *IsAllowDistribution = @"";
        if( self.resumeNameModel.IsAllowDistribution.intValue == 1 )
        {
            IsAllowDistribution = @"true";
        }
        else if( self.resumeNameModel.IsAllowDistribution.intValue == 0 )
        {
            IsAllowDistribution = @"false";
        }
        signal = [[RTNetworking shareInstance] saveThridExpectJobWithResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:TokenId ExpectCity:self.resumeNameModel.ExpectCity ExpectIndustry:self.resumeNameModel.ExpectJobFunction ExpectEmployType:self.resumeNameModel.ExpectEmployType ExpectSalary:self.resumeNameModel.ExpectSalary AvailableType:self.resumeNameModel.AvailableType IsAllowDistribution:IsAllowDistribution];
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
            self.addExpectJob = [RTHUDModel hudWithCode:HUDCodeSucess];
            //            [OMGToast showWithText:NetWorkOprationSuccess topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
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