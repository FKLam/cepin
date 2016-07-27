//
//  SignupGuideResumeVM.m
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SignupGuideResumeVM.h"
#import "RTNetworking+Resume.h"
#import "BaseCodeDTO.h"
#import "NSString+WeiResume.h"
#import "HttpUploadImage.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface SignupGuideResumeVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation SignupGuideResumeVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.resumeNameModel = [ResumeNameModel new];
        self.jobStatusArray = [BaseCode JobStatus];
        BaseCode *state = self.jobStatusArray[0];
        self.resumeNameModel.JobStatus = [NSString stringWithFormat:@"%@",state.CodeKey];
    }
    return self;
}
-(NSString*)genderString
{
    if (self.resumeNameModel.Gender.intValue == 1) {
        return @"男";
    }else if(self.resumeNameModel.Gender.intValue == 2){
        return @"女";
    }else{
        return @"";
    }
}
- (BOOL)request
{
    NSString *error;
    if (![self.resumeNameModel.ResumeName CheckResumeName:&error])
    {
        [self showShordMessage:error];
        return NO;
    }
    if (![self.resumeNameModel.ChineseName CheckResumeChineseName:&error])
    {
        [self showShordMessage:error];
        return NO;
    }
    if (![self.resumeNameModel.Email CheckResumeEmail:&error])
    {
        [self showShordMessage:error];
        return NO;
    }
    if (![self.resumeNameModel.Mobile CheckResumePhone:&error])
    {
        [self showShordMessage:error];
        return NO;
    }
    if ( ![self.resumeNameModel.IdCardNumber checkIdentityCard:&error] )
    {
        [self showShordMessage:error];
        return NO;
    }
    if ([self.resumeNameModel.Birthday isEqualToString:@""] || !self.resumeNameModel.Birthday)
    {
        [self showShordMessage:@"出生日期不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.Region isEqualToString:@""] || !self.resumeNameModel.Region)
    {
        [self showShordMessage:@"居住地不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.WorkYear isEqualToString:@""] || !self.resumeNameModel.WorkYear)
    {
        [self showShordMessage:@"工作年限不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.JobStatus isEqualToString:@""] || !self.resumeNameModel.JobStatus)
    {
        [self showShordMessage:@"求职状态不能为空"];
        return NO;
    }
    if ( self.resumeNameModel.ResumeType.intValue == 1 )
    {
        if ( !self.resumeNameModel.Introduces || 0 == [self.resumeNameModel.Introduces length] )
        {
            [self showShordMessage:@"一句话优势不能为空"];
            return NO;
        }
    }
    if ( self.resumeNameModel.ResumeType.intValue == 2 )
    {
        if ([self.resumeNameModel.Nation isEqualToString:@""] || !self.resumeNameModel.Nation)
        {
            [self showShordMessage:@"民族不能为空"];
            return NO;
        }
        if ([self.resumeNameModel.GraduateDate isEqualToString:@""] || !self.resumeNameModel.GraduateDate)
        {
            [self showShordMessage:@"毕业时间不能为空"];
            return NO;
        }
        if ([self.resumeNameModel.Politics isEqualToString:@""] || !self.resumeNameModel.Politics)
        {
            [self showShordMessage:@"政治面貌不能为空"];
            return NO;
        }
        if (nil == self.resumeNameModel.Height || self.resumeNameModel.Height.intValue == 0)
        {
            [self showShordMessage:@"身高不能为空"];
            return NO;
        }
        else
        {
            if ( 4 < [[self.resumeNameModel.Height stringValue] length] )
            {
                [self showShordMessage:@"请输入有效身高"];
                return NO;;
            }
        }
        if (nil == self.resumeNameModel.Weight || self.resumeNameModel.Weight.intValue == 0)
        {
            [self showShordMessage:@"体重不能为空"];
            return NO;
        }
        else
        {
            if ( 4 < [[self.resumeNameModel.Weight stringValue] length] )
            {
                [self showShordMessage:@"请输入有效体重"];
                return NO;;
            }
        }
        if (nil == self.resumeNameModel.HealthType || self.resumeNameModel.HealthType.intValue == 0)
        {
            [self showShordMessage:@"健康状态不能为空"];
            return NO;
        }
        if (nil == self.resumeNameModel.NativeCity || [self.resumeNameModel.NativeCity isEqualToString:@""] )
        {
            [self showShordMessage:@"籍贯城市不能为空"];
            return NO;
        }
    }
    if( self.resumeNameModel.IsSendCustomer && 1 == [self.resumeNameModel.IsSendCustomer intValue] )
    {
        self.resumeNameModel.IsSendCustomer = @"true";
    }
    else
    {
        self.resumeNameModel.IsSendCustomer = @"false";
    }
    return YES;
}
- (void)saveThridEditionResume
{
    if (![self request])
    {
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [[MemoryCacheData shareInstance] userId];
    NSString *tokenId = [[MemoryCacheData shareInstance] userTokenId];
    RACSignal *signal = nil;
    if ( self.resumeNameModel.ResumeType.intValue == 1 )
    {
        signal = [[RTNetworking shareInstance] addThridRessumeWith:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus ResumeType:[NSString stringWithFormat:@"%@",self.resumeNameModel.ResumeType] Introduces:self.resumeNameModel.Introduces idCardNumber:self.resumeNameModel.IdCardNumber];
    }
    else
    {
        signal = [[RTNetworking shareInstance] addThridRessumeWithSchoolResume:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus ResumeType:[NSString stringWithFormat:@"%@",self.resumeNameModel.ResumeType] Weight:[NSString stringWithFormat:@"%@",self.resumeNameModel.Weight] HealthType:[NSString stringWithFormat:@"%@",self.resumeNameModel.HealthType] Height:[NSString stringWithFormat:@"%@",self.resumeNameModel.Height] Nation:self.resumeNameModel.Nation NativeCity:self.resumeNameModel.NativeCity GraduateDate:self.resumeNameModel.GraduateDate Politics:self.resumeNameModel.Politics NativeCityKey:self.resumeNameModel.NativeCityKey PoliticsKey:[NSString stringWithFormat:@"%@",self.resumeNameModel.PoliticsKey] Health:[NSString stringWithFormat:@"%@",self.resumeNameModel.Health] idCardNumber:self.resumeNameModel.IdCardNumber];
    }
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple)
    {
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.resumeNameModel.ResumeId = [dic resultObject];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
    } error:^(NSError *error)
    {
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
        self.stateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)uploadResumeHeadImageWithImage:(UIImage *)image
{
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [HttpUploadImage uploadResumeImage:@{@"tokenId":strUserTocken,@"userId":strUser,@"file":image} success:^(id responseObject) {
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultSucess])
        {
            self.updateImageStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                [self showShordMessage:NetWorkError];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
            }
            self.updateImageStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } failure:^(id responseObject) {
        if (load)
        {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
    }];
}
- (void)checkEmailAvailabel
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance] checkIsExistEmail:self.resumeNameModel.Email tokenID:strUserTocken userID:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple)
     {
         @strongify(self);
         NSDictionary *dic = (NSDictionary *)tuple.second;
         if ([dic resultSucess])
         {
             self.availabelEmail = [dic resultObject];
             self.checkAvailabelEmail = [RTHUDModel hudWithCode:HUDCodeSucess];
         }
         else
         {
             if ([dic isMustAutoLogin])
             {
                 self.checkAvailabelEmail = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                 [self showShordMessage:NetWorkError];
             }
             else
             {
                 [self showShordMessage:[dic resultErrorMessage]];
                 self.checkAvailabelEmail = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
             }
         }
     } error:^(NSError *error)
     {
         @strongify(self);
         [self showShordMessage:NetWorkError];
         self.checkAvailabelEmail = [NSError errorWithErrorMessage:NetWorkError];
     }];
}
- (void)sendBindEmailInfo
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance] sendBindEmail:self.resumeNameModel.Email tokenID:strUserTocken userID:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple)
     {
         @strongify(self);
         NSDictionary *dic = (NSDictionary *)tuple.second;
         if ([dic resultSucess])
         {
             self.sendBindEmailMessage = [dic resultMessage];
             self.sendBindEmail = [RTHUDModel hudWithCode:HUDCodeSucess];
         }
         else
         {
             if ([dic isMustAutoLogin])
             {
                 self.sendBindEmail = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                 [self showShordMessage:NetWorkError];
             }
             else
             {
                 [self showShordMessage:[dic resultErrorMessage]];
                 self.sendBindEmail = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
             }
         }
     } error:^(NSError *error)
     {
         @strongify(self);
         [self showShordMessage:NetWorkError];
         self.sendBindEmail = [NSError errorWithErrorMessage:NetWorkError];
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