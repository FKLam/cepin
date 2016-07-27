//
//  DynamicNewModel.m
//  cepin
//
//  Created by ceping on 14-12-8.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicNewModel.h"
#import "DynamicCompanyChatModel.h"

@implementation DynamicNewModel

+(void)createDefualtDataWithUserId:(NSString*)userId
{
    DynamicNewModel *v1 = [DynamicNewModel new];
    v1.name = @"工作动态";
    v1.image = @"list_gz_icon";
    v1.message = @"马上设置工作订阅,为您推送职位动态";
    v1.type = @(DynamicModelJobType);
    v1.UnReadCount = @0;
    v1.FromUserId = userId;
    v1.sortNumber = @1;
    v1.isTop = @0;
    v1.id = @"1";
    v1.ToUserId = @"";
    v1.CreateTime = nil;
    [v1 save];
    
    DynamicNewModel *v2 = [DynamicNewModel new];
    v2.name = @"宣讲会";
    v2.image = @"list_xjh_icon";
    v2.message = @"设置宣讲会订阅,接收最新消息";
    v2.type = @(DynamicModelFairType);
    v2.UnReadCount = @0;
    v2.FromUserId = userId;
    v2.sortNumber = @2;
    v2.isTop = @0;
    v2.id = @"1";
    v2.ToUserId = @"";
    v2.CreateTime = nil;
    [v2 save];
    
    DynamicNewModel *v3 = [DynamicNewModel new];
    v3.name = @"系统信息";
    v3.image = @"list_yj_icon";
    v3.message = @"";
    v3.type = @(DynamicModelFairSystemType);
    v3.UnReadCount = @0;
    v3.FromUserId = userId;
    v3.sortNumber = @3;
    v3.isTop = @0;
    v3.id = @"1";
    v3.ToUserId = @"";
    v3.CreateTime = nil;
    [v3 save];
    
    DynamicNewModel *v4 = [DynamicNewModel new];
    v4.name = @"测评中心";
    v4.image = @"list_cp_icon";
    v4.message = @"";
    v4.type = @(DynamicModelExamType);
    v4.UnReadCount = @0;
    v4.FromUserId = userId;
    v4.sortNumber = @4;
    v4.isTop = @0;
    v4.id = @"1";
    v4.ToUserId = @"";
    v4.CreateTime = nil;
    [v4 save];
    
    /*DynamicNewModel *v5 = [DynamicNewModel new];
    v5.name = @"企业对话的公司名字";
    v5.message = @"";
    v5.type = @(DynamicModelCompanyChatType);
    v5.UnReadCount = @8;
    v5.FromUserId = userId;
    v5.isTop = @0;
    v5.id = @"2";
    v5.CreateTime = [NSDate date];
    v5.ToUserId = @"";
    [v5 save];
    
    DynamicNewModel *v6 = [DynamicNewModel new];
    v6.name = @"私人对话的名字";
    v6.message = @"";
    v6.type = @(DynamicModelChatType);
    v6.UnReadCount = @0;
    v6.FromUserId = userId;
    v6.isTop = @0;
    v6.id = @"2";
    v6.CreateTime = [NSDate date];
    v6.ToUserId = @"";
    [v6 save];*/
}

+(NSMutableArray *)DynamicWithPageAndUserId:(NSInteger)page userId:(NSString*)userId
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:[DynamicNewModel SearchTopWithUserId:userId]];
    [array addObjectsFromArray:[DynamicNewModel SearchDefualtWithUserId:userId]];
    [array addObjectsFromArray:[DynamicNewModel SearchOtherChatWithUserId:userId page:(int)page]];
    return array;
}

+(BOOL)SaveWithDynamicModel:(DynamicNewModel*)model isSendFromMe:(BOOL)isSendFromMe
{
    switch (model.type.intValue)
    {
        case DynamicModelJobType:
        case DynamicModelFairType:
        case DynamicModelFairSystemType:
        case DynamicModelExamType:
        {
            DynamicNewModel *tmp = [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"FromUserId = \"%@\" AND type = %d",model.FromUserId,model.type.intValue] order:nil][0];
            if (!model.CreateTime || !model.message)
            {
                tmp.message = model.message;
                tmp.CreateTime = model.CreateTime;
                tmp.UnReadCount = [NSNumber numberWithInt:0];
                [tmp update];
                return YES;
            }
            else
            {
                if ([model.message isEqualToString:tmp.message] && [model.CreateTime isEqualToDate:tmp.CreateTime])
                {
                    return NO;
                }
                tmp.message = model.message;
                tmp.CreateTime = model.CreateTime;
                //tmp.UnReadCount = [NSNumber numberWithInt:model.UnReadCount.intValue + tmp.UnReadCount.intValue];
                tmp.UnReadCount = model.UnReadCount;
                [tmp update];
                return YES;
            }
        }
            break;
        case DynamicModelCompanyChatType:
        {
            NSMutableArray *temp = [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"FromUserId = \"%@\" AND ToUserId = \"%@\" AND type = %d",model.FromUserId,model.ToUserId,model.type.intValue] order:nil];
            if (temp && temp.count > 0)
            {
                //找到数据库中有此聊天
                DynamicNewModel *d = temp[0];
                d.message = model.message;
                d.CreateTime = model.CreateTime;
                d.UnReadCount =  [NSNumber numberWithInt:d.UnReadCount.intValue + 1];
                d.image = model.image;
                d.name = model.name;
                [d update];
                
                //这个时候存储企业发送的消息
                [DynamicCompanyChatModel saveWithDynamicNewModel:d];
                return YES;
            }
            else
            {
                [model save];
                [DynamicCompanyChatModel saveWithDynamicNewModel:model];
                
                return YES;
            }
        }
            break;
        case DynamicModelChatType:
        {
            NSMutableArray *temp = [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"FromUserId = \"%@\" AND ToUserId = \"%@\" AND type = %d",model.FromUserId,model.ToUserId,model.type.intValue] order:nil];
            if (temp && temp.count > 0)
            {
                //找到数据库中有此聊天
                DynamicNewModel *d = temp[0];
                if ([model.messageId isEqualToNumber:d.messageId])
                {
                    //如果消息id相等的话，那么没必要更新
                    return NO;
                }
                //如果有改变，那么更新
                d.message = model.message;
                d.CreateTime = model.CreateTime;
                if (isSendFromMe)
                {
                    d.UnReadCount =  [NSNumber numberWithInt:0];
                }
                else
                {
                    d.UnReadCount =  [NSNumber numberWithInt:d.UnReadCount.intValue + 1];
                }
                d.image = model.image;
                d.name = model.name;
                d.messageId = model.messageId;
                [d update];
                
                
                //这个时候需要存储企业聊天消息，生成一个企业聊天记录数据，插入到企业聊天数据库中
                return YES;
            }
            [model save];
            return YES;
        }
            break;
            
        default:
            break;
    }
    return NO;
}

-(void)toTop
{
    DynamicNewModel *topModel = [DynamicNewModel SearchTopWithUserId:self.FromUserId][0];
    if (topModel)
    {
        topModel.isTop = @0;
        [topModel update];
    }
    
    self.isTop = @1;
    [self update];
}

+(NSMutableArray*)SearchTopWithUserId:(NSString*)userId
{
    return [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"FromUserId = \"%@\" AND isTop = %d",userId,1] order:nil];
}
+(NSMutableArray*)SearchDefualtWithUserId:(NSString*)userId
{
    NSMutableArray *array = [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"id = \"%@\" AND FromUserId = \"%@\"",@"1",userId] order:@"sortNumber"];
    
    return array;
}
+(NSMutableArray*)SearchOtherChatWithUserId:(NSString*)userId page:(int)page
{
    return [DynamicNewModel searchWithWhere:[NSString stringWithFormat:@"id = \"%@\" AND FromUserId = \"%@\" AND isTop = %d",@"2",userId,0] order:[NSString stringWithFormat:@"CreateTime desc limit 30 offset %d",0]];
}

@end
