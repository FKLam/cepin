//
//  DynamicCompanyChatModel.h
//  cepin
//
//  Created by ceping on 14-12-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "DynamicNewModel.h"

@interface DynamicCompanyChatModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *image;
@property(nonatomic,strong)NSDate<Optional>   *CreateTime;
@property(nonatomic,strong)NSString<Optional> *FromUserId;
@property(nonatomic,strong)NSString<Optional> *ToUserId;
@property(nonatomic,strong)NSString<Optional> *message;

+(void)saveWithDynamicNewModel:(DynamicNewModel*)model;
+(NSMutableArray*)SearchWithDynamicNewModel:(DynamicNewModel*)model;

@end
