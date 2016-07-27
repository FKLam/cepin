//
//  AllResumeVM.m
//  cepin
//
//  Created by ceping on 15-3-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AllResumeVM.h"
#import "RTNetworking+Resume.h"
#import "AllResumeDataModel.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface AllResumeVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation AllResumeVM
-(id)init
{
    if (self = [super init])
    {
        self.resumeModel = [ResumeNameModel new];
        self.datas = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)addThridResume
{
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *tokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance] addThridRessume:userId tokenId:tokenId];
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
            self.resumeId = [[dic resultObject]objectForKey:@"ResumeId"];
            self.AddStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.AddStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:NetWorkError];
            }
            else
            {
                if ( self.showMessageVC )
                    [self showShordMessage:[dic resultErrorMessage]];
                self.AddStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
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
        self.AddStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}



-(void)getAllResume
{
    self.load = [TBLoading new];
    [self.load start];
    NSString *tokenId = [[MemoryCacheData shareInstance] userTokenId];
    if (!tokenId) {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[[MemoryCacheData shareInstance] userId] ResumeType:[NSString stringWithFormat:@"%@",self.resumeModel.ResumeType]];
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
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                [self.datas removeAllObjects];
                [self.datas addObjectsFromArray:[dic resultObject]];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
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

-(void)toTop
{
    if( self.currentIndex == 0 ) return;
    TBLoading *load = [TBLoading new];
    [load start];
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.datas objectAtIndex:self.currentIndex]];
    RACSignal *signal = [[RTNetworking shareInstance]toTopWithResumeId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId resumeId:model.ResumeId];
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
            AllResumeDataModel *firstModel = [AllResumeDataModel beanFromDictionary:[self.datas objectAtIndex:0]];
            firstModel.Status = [NSNumber numberWithInt:0];
            
            model.Status = [NSNumber numberWithInt:1];
            
            [self.datas replaceObjectAtIndex:0 withObject:[model toDictionary]];
            [self.datas replaceObjectAtIndex:self.currentIndex withObject:[firstModel toDictionary]];
            
            self.toTopStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.toTopStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                    if ( self.showMessageVC )
                [self showShordMessage:NetWorkError];
            }
            else
            {
                if ( self.showMessageVC )
                    [self showShordMessage:[dic resultErrorMessage]];
                self.toTopStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
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
        self.toTopStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}

-(void)copyResume
{
    TBLoading *load = [TBLoading new];
    load.isCanTouchRemove = YES;
    [load start];
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.datas objectAtIndex:self.currentIndex]];
    RACSignal *signal = [[RTNetworking shareInstance] copyWithResumeId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId resumeId:model.ResumeId];
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
            self.cpresumeModel = [ResumeNameModel beanFromDictionary:[dic resultObject]];
            [self.datas addObject:self.cpresumeModel];
            self.cpStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.cpStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:NetWorkError];
            }
            else
            {
                self.cpStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:[dic resultErrorMessage]];
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
        self.cpStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}


-(void)deleteResume
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.datas objectAtIndex:self.currentIndex]];
    RACSignal *signal = [[RTNetworking shareInstance]deleteWithResumeId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId resumeId:model.ResumeId];
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
            [self.datas removeObjectAtIndex:self.currentIndex];
            
            self.deleteStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.deleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:NetWorkError];
            }
            else
            {
                self.deleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                if ( self.showMessageVC )
                    [self showShordMessage:[dic resultErrorMessage]];
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
        self.deleteStateCode = [NSError errorWithErrorMessage:NetWorkError];
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