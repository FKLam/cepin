//
//  DynamicCompanyChatModel.m
//  cepin
//
//  Created by ceping on 14-12-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicCompanyChatModel.h"
#import "DynamicNewModel.h"

@implementation DynamicCompanyChatModel

+(void)saveWithDynamicNewModel:(DynamicNewModel*)model
{
    //@property(nonatomic,strong)NSString<Optional> *image;
    //@property(nonatomic,strong)NSDate<Optional>   *CreateTime;
    //@property(nonatomic,strong)NSString<Optional> *FromUserId;
    //@property(nonatomic,strong)NSString<Optional> *ToUserId;
    //@property(nonatomic,strong)NSString<Optional> *message;
    
    DynamicCompanyChatModel *newModel = [DynamicCompanyChatModel new];
    newModel.CreateTime = model.CreateTime;
    newModel.image = model.image;
    newModel.FromUserId = model.FromUserId;
    newModel.ToUserId = model.ToUserId;
    newModel.message = model.message;
    
    [newModel save];
}

+(NSMutableArray*)SearchWithDynamicNewModel:(DynamicNewModel*)model
{
    return [DynamicCompanyChatModel searchWithWhere:[NSString stringWithFormat:@"FromUserId = \"%@\" AND ToUserId = \"%@\"",model.FromUserId,model.ToUserId] order:nil];
    
    //[NSString stringWithFormat:@"CreateTime desc limit 30 offset %d",0]
}


@end
