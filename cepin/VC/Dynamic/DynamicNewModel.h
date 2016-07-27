//
//  DynamicNewModel.h
//  cepin
//
//  Created by ceping on 14-12-8.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "JSONModel+Sqlite.h"

typedef enum
{
    DynamicModelJobType = 1,
    DynamicModelFairType,
    DynamicModelFairSystemType,
    DynamicModelExamType,
    DynamicModelCompanyChatType,
    DynamicModelChatType,
}DynamicModelType;

@interface DynamicNewModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *id;
@property(nonatomic,strong)NSString<Optional> *name;
@property(nonatomic,strong)NSString<Optional> *image;
@property(nonatomic,strong)NSString<Optional> *message;
@property(nonatomic,strong)NSNumber<Optional> *type;
@property(nonatomic,strong)NSString<Optional> *FromUserId;
@property(nonatomic,strong)NSString<Optional> *ToUserId;
@property(nonatomic,strong)NSNumber<Optional> *UnReadCount;
@property(nonatomic,strong)NSDate<Optional>   *CreateTime;
@property(nonatomic,strong)NSNumber<Optional> *isTop;
@property(nonatomic,strong)NSNumber<Optional> *sortNumber;
@property(nonatomic,strong)NSNumber<Optional> *messageId;

+(void)createDefualtDataWithUserId:(NSString*)userId;
+(NSMutableArray *)DynamicWithPageAndUserId:(NSInteger)size userId:(NSString*)userId;
+(BOOL)SaveWithDynamicModel:(DynamicNewModel*)model isSendFromMe:(BOOL)isSendFromMe;
+(NSMutableArray*)SearchTopWithUserId:(NSString*)userId;
+(NSMutableArray*)SearchDefualtWithUserId:(NSString*)userId;
+(NSMutableArray*)SearchOtherChatWithUserId:(NSString*)userId page:(int)page;
-(void)toTop;

@end

