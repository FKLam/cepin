//
//  EditProjectVM.m
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditProjectVM.h"
#import "RTNetworking+Resume.h"
#import "TBtextUnit.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface EditProjectVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation EditProjectVM
- (instancetype)initWithWork:(ProjectListDataModel*)model
{
    self = [super init];
    if (self) {
        self.projectData = [ProjectListDataModel new];
        self.projectData = model;
        self.projectId = model.Id;
        self.resumeId = model.ResumeId;
    }
    return self;
}
- (BOOL)valiURL:(NSString *)url
{
    NSError *error = NULL;
    NSString *regexString = @"(^http://)*([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if ( !result )
        return NO;
    else
        return YES;
}
- (BOOL)request
{
    if (!self.projectData.StartDate || [self.projectData.StartDate isEqualToString:@""])
    {
        [self showShordMessage:@"请选择开始时间"];
        return NO;
    }
    if (!self.projectData.EndDate || [self.projectData.EndDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = [date stringMMFromDate];
        self.projectData.EndDate = [NSString stringWithFormat:@"%@-%@-1",strYear,strMonth];
        NSArray *beginArray = [self.projectData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.projectData.EndDate componentsSeparatedByString:@"-"];
        
        self.strBeginYear = [beginArray objectAtIndex:0];
        self.strEndYear = [endArray objectAtIndex:0];
        self.strBeginMonth = [beginArray objectAtIndex:1];
        self.strEndMonth = [endArray objectAtIndex:1];
        self.projectData.EndDate = @"";
    }else
    {
        NSArray *beginArray = [self.projectData.StartDate componentsSeparatedByString:@"-"];
        NSArray *endArray = [self.projectData.EndDate componentsSeparatedByString:@"-"];
        
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
    if ( [self.projectData.StartDate isEqualToString:self.projectData.EndDate] )
    {
        [self showShordMessage:@"结束时间不能等于开始时间"];
        return NO;
    }
    if (!self.projectData.Name || [self.projectData.Name isEqualToString:@""])
    {
        [self showShordMessage:@"请输入项目名称"];
        return NO;
    }
    if (!self.projectData.Duty || [self.projectData.Duty isEqualToString:@""])
    {
        [self showShordMessage:@"请输入你的职责"];
        return NO;
    }
    if (!self.projectData.Content || [self.projectData.Content isEqualToString:@""])
    {
        [self showShordMessage:@"请输入项目描述"];
        return NO;
    }
    if ( 0 < [self.projectData.ProjectLink length] )
    {
        if ( ![self valiURL:self.projectData.ProjectLink] )
        {
            [self showShordMessage:@"请输入有效的项目链接"];
            return NO;
        }
    }
    if ( !self.projectData.ProjectLink || [self.projectData.ProjectLink isEqualToString:@""] )
    {
        self.projectData.ProjectLink = @"";
    }
    if (!self.projectData.KeyanLevel || [self.projectData.KeyanLevel isEqualToString:@""]) {
        self.projectData.KeyanLevel = @"";
    }
    if (!self.projectData.Description || [self.projectData.Description isEqualToString:@""]) {
        self.projectData.Description = @"";
    }
    if ( [self.projectData.IsKeyuan intValue] == 1 )
        self.projectData.IsKeyuan = @"true";
    else
        self.projectData.IsKeyuan = @"false";
    return YES;
}
- (void)saveProject
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
    
    RACSignal *signal = [[RTNetworking shareInstance] saveThridProjectStartDate:self.projectData.StartDate userId:userId tokenId:TokenId EndDate:self.projectData.EndDate Duty:self.projectData.Duty Name:self.projectData.Name KeyanLevel:self.projectData.KeyanLevel Description:self.projectData.Description Content:self.projectData.Content ResumeId:self.projectData.ResumeId Id:self.projectData.Id ProjectLink:self.projectData.ProjectLink IsKeyuan:self.projectData.IsKeyuan];
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
            self.saveStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
//            [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.saveStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:NetWorkError];
            }
            else
            {
                
                if ( self.showMessageVC )
                    [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.saveStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        if ( self.showMessageVC )
            [self showShordMessage:NetWorkError];
        self.saveStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)getProjectInfo
{
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance]getThridResumeProjectListWithResumeId:self.resumeId Id:self.projectId userId:userId tokenId:TokenId];
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
            self.projectData = [ProjectListDataModel beanFromDictionary:[dic resultObject]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:NetWorkError];
            }
            else
            {
                if ( self.showMessageVC )
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
        if ( self.showMessageVC )
            [self showShordMessage:NetWorkError];
        self.stateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)showShordMessage:(NSString *)message
{
    if ( !self.showMessageVC )
        return;
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
