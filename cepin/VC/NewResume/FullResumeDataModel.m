//
//  FullResumeDataModel.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullResumeDataModel.h"
#import "MJExtension.h"

@implementation FullResumeDataModel

+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    FullResumeDataModel *model = [[self alloc]initWithDic:dic];
    return model;
}

-(instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end

@implementation CertificateDataModel
+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    CertificateDataModel *fullmodel = [[self alloc]initWithDic:dic];
    return fullmodel;
}

-(instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end

@implementation EducationListDataModel

+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    EducationListDataModel *fullmodel = [[self alloc]initWithDic:dic];
    return fullmodel;
}

-(instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
//
@implementation LanguageListDataModel
+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    LanguageListDataModel *bean = [[self alloc]initWithDic:dic];
    return bean;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}
@end
//
@implementation PracticalListDataModel

@end



@implementation ProjectDataModel
+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    ProjectDataModel *bean = [[self alloc]initWithDic:dic];
    return bean;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end


@implementation TrainingListDataModel
+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    TrainingListDataModel *bean = [[self alloc]initWithDic:dic];
    return bean;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end


@implementation StudentLeadersListDataModel
+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    StudentLeadersListDataModel *bean = [[self alloc]initWithDic:dic];
    return bean;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
