//
//  TalkInFilterModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TalkInFilterModel.h"
#import "FileManagerHelper.h"
#import "UserLoginDTO.h"

static NSString *const TalkInFilterData = @"TalkInFilterData.json";
static NSString *const TalKInFilterNoUserData = @"TalKInFilterNoUserData.json";

@implementation TalkInFilterModel

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static TalkInFilterModel *instance;
    dispatch_once(&onceToken, ^{
        //instance = [TalkInFilterModel loadData];
        instance = [TalkInFilterModel new];
    });
    
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.schools = (NSMutableArray<School>*)[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)reloadWithFileName:(NSString*)fieName
{
    if ([fieName isEqualToString:@""])
    {
        NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:TalKInFilterNoUserData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
        TalkInFilterModel *model = [[TalkInFilterModel alloc] initWithString:jsonString error:nil];
        if (model && model.schools)
        {
            self.schools = model.schools;
        }
        else
        {
            [self.schools removeAllObjects];
        }
    }
    else
    {
        NSString *saveFileName = [NSString stringWithFormat:@"talkin_%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
        
        /*NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:TalkInFilterData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];*/
        NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:saveFileName andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
        
        TalkInFilterModel *model = [[TalkInFilterModel alloc] initWithString:jsonString error:nil];
        if (model && model.schools)
        {
            self.schools = model.schools;
        }
        else
        {
            [self.schools removeAllObjects];
        }
    }
}


-(BOOL)saveObjectToDiskWithFile:(NSString*)fieName
{
    NSString *jsonString = [[TalkInFilterModel shareInstance] toJSONString];
    
    if ([fieName isEqualToString:@""])
    {
        return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:TalKInFilterNoUserData andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
    }
    
    NSString *saveFileName = [NSString stringWithFormat:@"talkin_%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
    return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:saveFileName andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
}

-(BOOL)deleteObjectFromDisk:(NSString*)fileName
{
    [self.schools removeAllObjects];
    if ([fileName isEqualToString:@""])
    {
        return  [FileManagerHelper deleteObjectWithFile:TalKInFilterNoUserData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    }
    NSString *saveFileName = [NSString stringWithFormat:@"talkin_%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
    return  [FileManagerHelper deleteObjectWithFile:saveFileName folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}

-(void)deleteObjectFromNet:(NSString*)fileName
{
    [self.schools removeAllObjects];
    [self deleteObjectFromDisk:fileName];
}


-(void)resetWithModelAndFileName:(TalkInFilterModel*)model file:(NSString*)fileName
{
    if (model && model.schools)
    {
        self.schools = model.schools;
    }
    else
    {
        self.schools = (NSMutableArray<School>*)[[NSMutableArray alloc] initWithCapacity:3];
    }
    
    [self saveObjectToDiskWithFile:fileName];
}


@end
