//
//  AddThridEditionResumeVM.m
//  cepin
//
//  Created by dujincai on 15/6/13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddThridEditionResumeVM.h"
#import "RTNetworking+Resume.h"
#import "HttpUploadImage.h"
#import "NSString+WeiResume.h"
#import "BaseCodeDTO.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface AddThridEditionResumeVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation AddThridEditionResumeVM
-(instancetype)initWithResumeModel:(ResumeNameModel *)model
{
    if (self = [super init])
    {
        self.resumeNameModel = model;
        self.jobStatusArray = [BaseCode JobStatus];
        [self.workYearkArrayM addObjectsFromArray:[BaseCode workYears]];
    }
    return self;
}
-(instancetype)initWithResumeModelId:(NSString *)modelId{
    if (self = [super init])
    {
        ResumeNameModel *model = [ResumeNameModel new];
        model.ResumeId = modelId;
        self.resumeNameModel = model;
        self.jobStatusArray = [BaseCode JobStatus];
        [self.workYearkArrayM addObjectsFromArray:[BaseCode workYears]];
    }
    return self;
}
-(NSString*)maritalString
{
    if ( self.resumeNameModel.Marital.intValue == 1 ) {
        return @"未婚";
    }
    else if ( self.resumeNameModel.Marital.intValue == 2 )
    {
        return @"已婚";
    }
    else
    {
        return @"";
    }
}
-(NSString*)genderString
{
    if (self.resumeNameModel.Gender.intValue == 1)
    {
        return @"男";
    }
    else if(self.resumeNameModel.Gender.intValue == 2)
    {
        return @"女";
    }
    else
    {
        return @"";
    }
}
- (void)getResumeInfo
{
    if([@"" isEqualToString:self.resumeNameModel.ResumeId]){
        return;
    }
    self.load = [TBLoading new];
    [self.load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance] getThridResumeDetailWithResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:TokenId];
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
            self.resumeNameModel = [ResumeNameModel beanFormDic:[dic resultObject]];
            self.resumeStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.resumeStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [self showShordMessage:NetWorkError];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
                self.resumeStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        
    }];
}
- (void)editBaseInfo:(NSString *)resumedId
{
    if ( !self.resumeName || 0 == [self.resumeName length] )
    {
        [self showShordMessage:@"请输入简历名称"];
        return;
    }
    self.load = [TBLoading new];
    [self.load start];
    NSString *userId = [[MemoryCacheData shareInstance]userId];
    NSString *tokenId = [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = nil;
    if( self.resumeNameModel.ResumeType.intValue == 2 )
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:resumedId resumeName:self.resumeName];
    }
    else
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:resumedId resumeName:self.resumeName];
        
    }
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
            self.changeResumeNameEditStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                [self showShordMessage:NetWorkError];
                self.changeResumeNameEditStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
                self.changeResumeNameEditStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (self.load)
        {
            [self.load stop];
        }
        [self showShordMessage:NetWorkError];
        self.changeResumeNameEditStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)saveBackEditBaseInfo:(NSString *)resumedId
{
    if ( !self.resumeName || 0 == [self.resumeName length] )
    {
        [self showShordMessage:@"请输入简历名称"];
        return;
    }
    NSString *userId = [[MemoryCacheData shareInstance] userId];
    NSString *tokenId = [[MemoryCacheData shareInstance] userTokenId];
    RACSignal *signal = nil;
    if( self.resumeNameModel.ResumeType.intValue == 2 )
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:resumedId resumeName:self.resumeName];
    }
    else
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:resumedId resumeName:self.resumeName];
        
    }
    TBLoading *load = [TBLoading new];
    [load start];
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
            self.changeResumeNameStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.changeResumeNameStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [self showShordMessage:NetWorkError];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
                self.changeResumeNameStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
        self.changeResumeNameStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)editResumeName
{
    if ( !self.resumeName || 0 == [self.resumeName length] )
    {
        [self showShordMessage:@"请输入简历名称"];
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [[MemoryCacheData shareInstance]userId];
    NSString *tokenId = [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = nil;
    if( self.resumeNameModel.ResumeType.intValue == 2 )
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:self.resumeNameModel.ResumeId resumeName:self.resumeName];
    }
    else
    {
        signal = [[RTNetworking shareInstance] editBaseInfoRessumeWithUserID:userId tokenId:tokenId resumeID:self.resumeNameModel.ResumeId resumeName:self.resumeName];
        
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
            //            [OMGToast showWithText:NetWorkOprationSuccess bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
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
    if ( !self.resumeNameModel.IdCardNumber || 0 == [self.resumeNameModel.IdCardNumber length] )
    {
        [self showShordMessage:@"请输入身份证"];
        return NO;
    }
    else if ( ![self.resumeNameModel.IdCardNumber checkIdentityCard:&error] )
    {
        [self showShordMessage:error];
        return NO;
    }
    if ([self.resumeNameModel.Birthday isEqualToString:@""] || !self.resumeNameModel.Birthday) {
        [self showShordMessage:@"出生日期不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.Region isEqualToString:@""] || !self.resumeNameModel.Region) {
        [self showShordMessage:@"居住地不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.WorkYear isEqualToString:@""] || !self.resumeNameModel.WorkYear) {
        [self showShordMessage:@"工作年限不能为空"];
        return NO;
    }
    if ([self.resumeNameModel.JobStatus isEqualToString:@""] || !self.resumeNameModel.JobStatus) {
        [self showShordMessage:@"请选择工作状态"];
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
    if (!self.resumeNameModel.Politics || [self.resumeNameModel.Politics isEqualToString:@""])
    {
       self.resumeNameModel.Politics = @"";
        self.resumeNameModel.PoliticsKey = @"";
    }
    if (!self.resumeNameModel.Hukou || [self.resumeNameModel.Hukou isEqualToString:@""])
    {
        self.resumeNameModel.Hukou = @"";
        self.resumeNameModel.HukouKey = @"";
    }
    if (!self.resumeNameModel.IdCardNumber || [self.resumeNameModel.IdCardNumber isEqualToString:@""]) {
        self.resumeNameModel.IdCardNumber = @"";
    }
    if (!self.resumeNameModel.GraduateDate || [self.resumeNameModel.GraduateDate isEqualToString:@""])
    {
        self.resumeNameModel.GraduateDate = @"";
    }
    if (self.resumeNameModel.Address.length > 200) {
        [self showShordMessage:@"通讯地址不能超过200个字符"];
        return NO;
    }
    if (!self.resumeNameModel.Address || [self.resumeNameModel.Address isEqualToString:@""]) {
        self.resumeNameModel.Address = @"";
    }
    if (!self.resumeNameModel.ResumeId || [self.resumeNameModel.ResumeId isEqualToString:@""]) {
        self.resumeNameModel.ResumeId = @"";
    }
    if (!self.resumeNameModel.QQ) {
        self.resumeNameModel.QQ = @"";
    }
    if (!self.resumeNameModel.Health) {
        self.resumeNameModel.Health = @"";
    }
    if (!self.resumeNameModel.EmergencyContactPhone) {
        self.resumeNameModel.EmergencyContactPhone = @"";
    }
    if (!self.resumeNameModel.EmergencyContact) {
        self.resumeNameModel.EmergencyContact = @"";
    }
    if (!self.resumeNameModel.ZipCode) {
        self.resumeNameModel.ZipCode = @"";
    }
     if( self.resumeNameModel.ResumeType.intValue == 2 )
     {
         //校招简历
         if (self.resumeNameModel.Nation == nil || [self.resumeNameModel.Nation isEqualToString:@""]) {
             [self showShordMessage:@"民族不能为空"];
             return NO;;
         }
         if (self.resumeNameModel.GraduateDate == nil || [self.resumeNameModel.GraduateDate isEqualToString:@""]) {
             [self showShordMessage:@"毕业时间不能为空"];
             return NO;
         }
         if (self.resumeNameModel.Weight == nil || self.resumeNameModel.Weight.intValue == 0) {
             [self showShordMessage:@"体重不能为空"];
             return NO;;
         }
         else
         {
             if ( 4 < [[self.resumeNameModel.Weight stringValue] length] )
             {
                 [self showShordMessage:@"请输入有效体重"];
                 return NO;;
             }
         }
         if (self.resumeNameModel.Height == nil || self.resumeNameModel.Height.intValue == 0) {
             [self showShordMessage:@"身高不能为空"];
             return NO;;
         }
         else
         {
             if ( 4 < [[self.resumeNameModel.Height stringValue] length] )
             {
                 [self showShordMessage:@"请输入有效身高"];
                 return NO;;
             }
         }
         if (self.resumeNameModel.HealthType == nil || self.resumeNameModel.HealthType.intValue == 0) {
             [self showShordMessage:@"健康状态不能为空"];
             return NO;;
         }
         if (self.resumeNameModel.NativeCity == nil || [self.resumeNameModel.NativeCity isEqualToString:@""]) {
             [self showShordMessage:@"籍贯不能为空"];
             return NO;;
         }
         if( self.resumeNameModel.HealthType.intValue == 1 || self.resumeNameModel.HealthType.intValue == 2 )
         {
            self.resumeNameModel.Health = @"";
         }
//         if (self.resumeNameModel.EmergencyContactPhone.length>0) {
//             NSString *phoneRegex = @"^1[3,4,5,7,8]{1}\\d{9}$";//验证手机
//             NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";//固话
//             
//             
//             NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//             NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
//             
//             if (([phoneTest1 evaluateWithObject:self.resumeNameModel.EmergencyContactPhone] == NO))
//             {
//                 [OMGToast showWithText:@"联系方式格式不正确" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
//                 return NO;
//             }
//         }
         if ( 0 < [self.resumeNameModel.QQ length] )
         {
             if (![self.resumeNameModel.QQ checkResumeQQ:&error])
             {
                 [self showShordMessage:error];
                 return NO;
             }
         }
         if ( 0 < [self.resumeNameModel.ZipCode length] )
         {
             if ( ![self.resumeNameModel.ZipCode checkResumeCode:&error] )
             {
                 [self showShordMessage:error];
                 return NO;
             }
         }
         if ( 0 < [self.resumeNameModel.EmergencyContactPhone length] )
         {
             if ( ![self.resumeNameModel.EmergencyContactPhone checkResumeContact:&error] )
             {
                 [self showShordMessage:error];
                 return NO;
             }
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
    if (![self request]) {
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [[MemoryCacheData shareInstance]userId];
    NSString *tokenId = [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = nil;
    if( self.resumeNameModel.ResumeType.intValue == 2 )
    {
              signal = [[RTNetworking shareInstance] addThridRessumeWith:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus Politics:self.resumeNameModel.Politics PoliticsKey:self.resumeNameModel.PoliticsKey Hukou:self.resumeNameModel.Hukou HukouKey:self.resumeNameModel.HukouKey IdCardNumber:self.resumeNameModel.IdCardNumber GraduateDate:self.resumeNameModel.GraduateDate Address:self.resumeNameModel.Address Marital:[NSString stringWithFormat:@"%@",self.resumeNameModel.Marital] QQ:self.resumeNameModel.QQ Nation:self.resumeNameModel.Nation Weight:[NSString stringWithFormat:@"%@",self.resumeNameModel.Weight] HealthType:[NSString stringWithFormat:@"%@",self.resumeNameModel.HealthType] Height:[NSString stringWithFormat:@"%@",self.resumeNameModel.Height] NativeCity:[NSString stringWithFormat:@"%@",self.resumeNameModel.NativeCity] NativeCityKey:[NSString stringWithFormat:@"%@",self.resumeNameModel.NativeCityKey] EmergencyContact:self.resumeNameModel.EmergencyContact EmergencyContactPhone:self.resumeNameModel.EmergencyContactPhone ZipCode:self.resumeNameModel.ZipCode Health:self.resumeNameModel.Health];
    }
    else
    {
        signal = [[RTNetworking shareInstance] addThridRessumeWith:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus Politics:self.resumeNameModel.Politics PoliticsKey:self.resumeNameModel.PoliticsKey Hukou:self.resumeNameModel.Hukou HukouKey:self.resumeNameModel.HukouKey IdCardNumber:self.resumeNameModel.IdCardNumber GraduateDate:self.resumeNameModel.GraduateDate Address:self.resumeNameModel.Address Marital:[NSString stringWithFormat:@"%@",self.resumeNameModel.Marital] Introduces:self.resumeNameModel.Introduces];
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
//resumetype （1表示为社招，2表示为校招）
-(void)creteResumeWithResume:(int)ResumeType
{
    self.resumeNameModel.ResumeType = [NSNumber numberWithInt:ResumeType];
    if (![self request]) {
        return;
    }
    NSString *userId = [[MemoryCacheData shareInstance]userId];
    NSString *tokenId = [[MemoryCacheData shareInstance]userTokenId];
    //编辑基本信息创建简历
    RACSignal *signal  = nil;
    if ( 1 == ResumeType )
    {
        //创建社招简历
        signal  = [[RTNetworking shareInstance] addThridRessumeWith:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus ResumeType:[NSString stringWithFormat:@"%@",self.resumeNameModel.ResumeType] Introduces:self.resumeNameModel.Introduces idCardNumber:self.resumeNameModel.IdCardNumber];
    }
    else
    {
       signal = [[RTNetworking shareInstance] addThridRessumeWithSchoolResume:self.resumeNameModel.ResumeName ChineseName:self.resumeNameModel.ChineseName Gender:[NSString stringWithFormat:@"%@",self.resumeNameModel.Gender] Email:self.resumeNameModel.Email Mobile:self.resumeNameModel.Mobile Birthday:self.resumeNameModel.Birthday Region:self.resumeNameModel.Region WorkYear:self.resumeNameModel.WorkYear IsSendCustomer:self.resumeNameModel.IsSendCustomer RegionCode:self.resumeNameModel.RegionCode WorkYearKey:self.resumeNameModel.WorkYearKey ResumeId:self.resumeNameModel.ResumeId userId:userId tokenId:tokenId JobStatus:self.resumeNameModel.JobStatus ResumeType:[NSString stringWithFormat:@"%@",self.resumeNameModel.ResumeType] Weight:[NSString stringWithFormat:@"%@",self.resumeNameModel.Weight] HealthType:[NSString stringWithFormat:@"%@",self.resumeNameModel.HealthType] Height:[NSString stringWithFormat:@"%@",self.resumeNameModel.Height] Nation:self.resumeNameModel.Nation NativeCity:self.resumeNameModel.NativeCity GraduateDate:self.resumeNameModel.GraduateDate Politics:self.resumeNameModel.Politics NativeCityKey:self.resumeNameModel.NativeCityKey PoliticsKey:[NSString stringWithFormat:@"%@",self.resumeNameModel.PoliticsKey] Health:[NSString stringWithFormat:@"%@",self.resumeNameModel.Health] idCardNumber:self.resumeNameModel.IdCardNumber];
    }
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        NSLog(@"result = %@",dic);
        if ([dic resultSucess])
        {
            self.resumeNameModel.ResumeId = [dic objectForKey:@"Data"];
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
//上传头像
-(void)uploadUserHeadImageWithImage:(UIImage *)imageLogo
{
    TBLoading *load = [TBLoading new];
    load.isWaitFor = YES;
    [load start];
    
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [HttpUploadImage uploadResumeImage:@{@"tokenId":strUserTocken,@"userId":strUser,@"file":imageLogo} success:^(id responseObject) {
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultSucess])
        {
            self.headImage.image = imageLogo;
            
            [self showShordMessage:[dic objectForKey:@"Message"]];
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
            //[OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
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
// 上传新简历头像
-(void)uploadCreateResumeHeadImageWithImage:(UIImage *)imageLogo
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    TBLoading *load = [TBLoading new];
    [load start];
    [HttpUploadImage uploadResumeImage:@{@"tokenId":strUserTocken,@"userId":strUser,@"file":imageLogo} success:^(id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultSucess])
        {
            self.headImage.image = imageLogo;
            self.updateImageStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.updateImageStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        [load stop];
    } failure:^(id responseObject) {
        [load stop];
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
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / 3.0]}];
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
- (NSMutableArray *)workYearkArrayM
{
    if ( !_workYearkArrayM )
    {
        _workYearkArrayM = [NSMutableArray array];
    }
    return _workYearkArrayM;
}
@end
