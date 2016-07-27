//
//  PracticeAndAwardsVM.m
//  cepin
//
//  Created by dujincai on 15/7/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PracticeAndAwardsVM.h"
#import "RTNetworking+Resume.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface PracticeAndAwardsVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation PracticeAndAwardsVM
- (instancetype)initWithResumeId:(NSString*)resumeId
{
    self = [super init];
    if (self) {
        self.resumeModel = [ResumeNameModel new];
        self.resumeId = resumeId;
    }
    return self;
}

- (void)getResumeInfo
{
    self.load = [TBLoading new];
    [self.load start];
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    RACSignal *signal = [[RTNetworking shareInstance]getThridResumeDetailWithResumeId:self.resumeId userId:userId tokenId:TokenId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (self.load)
        {
            [self.load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.resumeModel = [ResumeNameModel beanFormDic:[dic resultObject]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
    }];
    
}
- (void)stop
{
    if (self.load)
    {
        [self.load stop];
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
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
