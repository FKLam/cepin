//
//  DynamicVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//  此类添加一个注册融云消息的函数。当收到对话消息时更新数据库，添加一个企业对话的轮询。当收到企业对话的时候，更新数据表并发送通知
//  添加一个系统消息的轮巡，当收到系统消息的时候做一些处理，其他轮询，探索界面加一个轮巡，主页面添加一个轮巡，所有轮巡就这样加完了
//  当收到登入成功时，启动计时器，开启融云
//  当收到登出时，关闭计时器，并关闭融云

#import "DynamicVM.h"
#import "RTNetworking+DynamicState.h"
#import "RCMessageContent.h"
#import "RCTextMessage.h"
#include "RCClientDelegate.h"
#import "RCIMClient.h"
#import "NSDate-Utilities.h"
#import "RTNetworking+Banner.h"

@implementation DynamicVM

-(instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOver:) name:@"LoginOver" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RongYunReturn:) name:@"RongYunReturn" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOver:) name:@"LoginOut" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOver:) name:@"RegisterOver" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOver:) name:@"ChangeSystemBooking" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOver:) name:@"SendResume" object:nil];
        
        [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
        
        self.page = 1;
        NSString *userId = [[MemoryCacheData shareInstance]userId];
        if (!userId)
        {
            userId = @"NoUserLogin";
        }
        
        NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:userId];
        if (array.count <= 0)
        {
            [DynamicNewModel createDefualtDataWithUserId:userId];
            array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:userId];
        }
        
        [self.datas addObjectsFromArray:array];
        
        self.bannerModel = [BannerModel bannerModelFromName:@"CepinBannerTwo"];
        if (self.bannerModel)
        {
            self.bannerImage = [RTPictureHelper localfileFromFileName:@"CepinBannerTwo"];
        }
    }
    return self;
}

-(void)LoginOver:(NSNotification*)notify
{
    NSString *urerId = @"NoUserLogin";
    if ([MemoryCacheData shareInstance].isLogin)
    {
        urerId = [[MemoryCacheData shareInstance]userId];
    }

    NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:urerId];
    if (array.count <= 0)
    {
        [DynamicNewModel createDefualtDataWithUserId:urerId];
        array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:urerId];
    }
    
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:array];

    self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    
    if (timer && [MemoryCacheData shareInstance].isLogin)
    {
        [timer fire];
    }
    else
    {
        timer = [NSTimer timerWithTimeInterval:kStartLoadDataTimeOut target:self selector:@selector(TimeRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }
}

-(void)RongYunReturn:(NSNotification*)notify
{
    RCMessage *message = [[notify userInfo]objectForKey:@"RongYunReturn"];
    [self didReceivedMessage:message left:0];
}

-(void)TimeRun
{
    if ([MemoryCacheData shareInstance].isLogin)
    {
        [self getCompanyTalk];
    }
    [self getDynamicCount];
}


-(void)toTop
{
    NSString *userId = [[MemoryCacheData shareInstance]userId];
    if (!userId)
    {
        userId = @"NoUserLogin";
    }
    NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:userId];
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:array];
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
}

-(void)getCompanyTalk
{
    NSString *strUser = @"";
    NSString *strTocken = @"";
    if ([MemoryCacheData shareInstance].isLogin)
    {
        strUser = [[MemoryCacheData shareInstance]userId];
        strTocken = [[MemoryCacheData shareInstance]userTokenId];
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]getDynamicStateCompanyMessageListWithTokenId:strTocken userId:strUser];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [self didReceiveCompanyTalk:[dic resultObject]];
        }
        else
        {
            //这个地方要修改一下
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

-(void)getDynamicCount
{
    NSString *strUser = @"";
    NSString *strTocken = @"";
    if ([MemoryCacheData shareInstance].isLogin)
    {
        strUser = [[MemoryCacheData shareInstance]userId];
        strTocken = [[MemoryCacheData shareInstance]userTokenId];
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]getDynamicStateCountWithUUID:UUID_KEY tokenId:strTocken userId:strUser];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [self didReceiveDynamic:[dic resultObject]];
        }
        else
        {
            //这个地方要修改一下
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeReflashSucess];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

//处理融云的数据
-(void)didReceivedMessage:(RCMessage*)message left:(int)left
{
    BOOL isSendFromMe = NO;
    DynamicNewModel *model = [DynamicNewModel new];
    model.messageId = [NSNumber numberWithLong:message.messageId];
    if ([message.objectName isEqualToString:@"RC:TxtMsg"])
    {
        model.message = ((RCTextMessage*)message.content).content;
    }
    else if([message.objectName isEqualToString:@"RC:ImgMsg"])
    {
        model.message = @"图片";
    }
    else
    {
        model.message = @"语音";
    }
    
    model.FromUserId = [[MemoryCacheData shareInstance]userId];
    
    if (message.messageDirection == MessageDirection_SEND)
    {
        model.ToUserId = message.targetId;
        isSendFromMe = YES;
    }
    else
    {
        model.ToUserId = message.senderUserId;
    }
    
    model.CreateTime = [NSDate dateWithTimeIntervalSince1970: message.sentTime/1000];
    model.id = @"2";
    model.isTop = @(0);
    model.type = @(DynamicModelChatType);
    model.UnReadCount = @(left);
    
    self.userInfoVM = [[UserInfoVM alloc]initWithTypeAndFriendId:UserInfoOtherType friendId:[model.ToUserId stringByReplacingOccurrencesOfString:@"-" withString:@""]];

    @weakify(self);
    [RACObserve(self.userInfoVM, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        if ([stateCode isKindOfClass:[RTHUDModel class]])
        {
            RTHUDModel *hud = (RTHUDModel *)stateCode;
            if (hud.hudCode == HUDCodeSucess)
            {
                if (self.userInfoVM.data)
                {
                    model.name = self.userInfoVM.data.UserName;
                    model.image  = self.userInfoVM.data.PhotoUrl;
                }
                if ([DynamicNewModel SaveWithDynamicModel:model isSendFromMe:isSendFromMe])
                {
                    NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:[[MemoryCacheData shareInstance]userId]];
                    if (array.count <= 0)
                    {
                        [DynamicNewModel createDefualtDataWithUserId:[[MemoryCacheData shareInstance]userId]];
                        array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:[[MemoryCacheData shareInstance]userId]];
                    }
                    
                    [self.datas removeAllObjects];
                    [self.datas addObjectsFromArray:array];
                    self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                    //弹出本地推送
                }
                else
                {
                    
                }
            }
        }
    }];
    
    [self.userInfoVM otherUserInfo];
}



//处理企业对话的数据
-(void)didReceiveCompanyTalk:(NSArray*)companyTalkList
{
    BOOL isHasChange = NO;
    for (int i = 0; i < companyTalkList.count; i++)
    {
        DynamicCompanyTalkInModelDTO *companyTalkModel = [DynamicCompanyTalkInModelDTO beanFromDictionary:companyTalkList[i]];
        DynamicNewModel *model = [DynamicNewModel new];
        model.ToUserId = companyTalkModel.CustomerId;
        model.name = companyTalkModel.CompanyName;
        model.image = companyTalkModel.Logo;
        model.message = companyTalkModel.Content;
        model.FromUserId = [[MemoryCacheData shareInstance]userId];
        model.CreateTime = [NSDate dateyyyyMMddHHmmssFromString:[companyTalkModel.CreateDate substringToIndex:companyTalkModel.CreateDate.length - 4]];
        model.id = @"2";
        model.isTop = @(0);
        model.type = @(DynamicModelCompanyChatType);
        model.UnReadCount = [NSNumber numberWithInt:1];
        if ([DynamicNewModel SaveWithDynamicModel:model isSendFromMe:NO])
        {
            isHasChange = YES;
        }
    }
    if (isHasChange)
    {
        NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:[[MemoryCacheData shareInstance]userId]];
        if (array.count <= 0)
        {
            [DynamicNewModel createDefualtDataWithUserId:[[MemoryCacheData shareInstance]userId]];
            array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:[[MemoryCacheData shareInstance]userId]];
        }
        
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:array];
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    }
}

//传过来的是一个数据列表
-(void)didReceiveDynamic:(NSArray*)dynamicList
{
    BOOL isUpdate = NO;
    
    NSString *urerId = @"NoUserLogin";
    if ([MemoryCacheData shareInstance].isLogin)
    {
        urerId = [[MemoryCacheData shareInstance]userId];
    }
    
    for (int i = 0; i < dynamicList.count; i++)
    {
        DynamicRecvModelDTO *dynamicModel = [DynamicRecvModelDTO beanFromDictionary:[dynamicList objectAtIndex:i]];
        DynamicNewModel *model = [DynamicNewModel new];
        model.id = @"1";
        model.message = dynamicModel.Message;
        model.type = [NSNumber numberWithInt:dynamicModel.Type.intValue + 1];
        model.FromUserId = urerId;
        model.UnReadCount = dynamicModel.Count;
        model.CreateTime = [NSDate dateyyyyMMddHHmmssFromString:dynamicModel.CreateDate];
        
        /*if (!model.CreateTime || [model.CreateTime isKindOfClass:[NSNull class]] || !model.message || [model.message isKindOfClass:[NSNull class]])
        {
            model.CreateTime = nil;
        }*/
        
        if (!model.message || [model.message isKindOfClass:[NSNull class]])
        {
            if (model.type.intValue == 1)
            {
                model.message = @"马上设置工作订阅,为您推送职位动态";
            }
            else if(model.type.intValue == 2)
            {
                model.message = @"设置宣讲会订阅,接收最新消息";
            }
            else
            {
                model.message = @"";
            }
        }
        
        if (!model.CreateTime || [model.CreateTime isKindOfClass:[NSNull class]])
        {
            
        }
        
        
        BOOL tm = [DynamicNewModel SaveWithDynamicModel:model isSendFromMe:NO];
        if (tm)
        {
            isUpdate = YES;
        }
    }
    
    if (isUpdate)
    {
        NSMutableArray *array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:urerId];
        if (array.count <= 0)
        {
            [DynamicNewModel createDefualtDataWithUserId:urerId];
            array = [DynamicNewModel DynamicWithPageAndUserId:self.page userId:urerId];
        }
        
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:array];
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    }
}

-(void)getBanner
{
    RACSignal *signal = [[RTNetworking shareInstance]getBanner:2];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic objectForKey:@"Data"];
            self.bannerModel = [BannerModel bannerWithDic:array[0] name:@"CepinBannerTwo"];
            
            //将URL当中的中文转码
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.bannerModel.ImgUrl,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
           
            [RTPictureHelper saveImageWithBlock:encodedString name:@"CepinBannerTwo" success:^(UIImage *image) {
                self.bannerImage = image;
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            } failure:^(id responseObject) {
            }];
        }
        else
        {
            [RTPictureHelper deleteImage:@"CepinBannerTwo"];
            self.bannerImage = nil;
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
    } error:^(NSError *error){
    }];
}



@end
