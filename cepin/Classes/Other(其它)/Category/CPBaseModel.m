//
//  CPBaseModel.m
//  cepin
//
//  Created by ceping on 15-11-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CPBaseModel.h"

@implementation CPBaseModel

/**
 *  返回模型对象的所有属性名称
 *
 *  @return 模型对象属性名称数组
 */
+ (NSArray *)propertyForModel
{
    unsigned int count;
    
    // 1.获得类中的所有成员变量
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    NSMutableArray *properNames = [NSMutableArray array];
    for(int index = 0; index < count; index++)
    {
        Ivar ivar = ivarList[index];
        
        // 2.获得成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 3.除去下划线，从第一个下标开始截取
        NSString *key = [name substringFromIndex:1];
        
        [properNames addObject:key];
    }
    return [properNames copy];
}

/**
 *  归档
 *
 *  @param enCoder
 */
- (void)encodeWithCoder:(NSCoder *)enCoder{
    
    // 取得所有成员变量名
    NSArray *propertyNames = [[self class] propertyForModel];
    
    for(NSString *propertyName in propertyNames)
    {
        // 创建指向get方法
        SEL getSel = NSSelectorFromString(propertyName);
        IMP imp = [self methodForSelector:getSel];
        id (*func)(id, SEL) = (void *)imp;
        func(self, getSel);
        
        // 对每一个属性实现归档
        [enCoder encodeObject:func(self, getSel) forKey:propertyName];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // 取得所有成员变量名
    NSArray *propertyNames = [[self class] propertyForModel];
    
    for(NSString *propertyName in propertyNames)
    {
        // 创建指向属性的set方法
        // 1.获取属性名的第一个字符，变为大写字母
        NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
        
        // 2.替换掉属性名的第一个字符为大写字母，并拼接出set方法的方法名
        NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:", firstCharater, [propertyName substringFromIndex:1]];
        SEL setSel = NSSelectorFromString(setPropertyName);
        IMP imp = [self methodForSelector:setSel];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, setSel, [aDecoder decodeObjectForKey:propertyName]);
    }
    return self;
}

/**
 *  实现在NSLog的时候把对象里的每个属性和值都打印出来
 *
 *  @return 对象里的属性和值
 */
- (NSString *)description{
    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"];
    
    // 取得所有成员变量名
    NSArray *propertyNames = [[self class] propertyForModel];
    
    for(NSString *propertyName in propertyNames)
    {
        // 创建指向get方法
        SEL getSel = NSSelectorFromString(propertyName);
        IMP imp = [self methodForSelector:getSel];
        id (*func)(id, SEL) = (void *)imp;
        
        NSString *propertyNameString = [NSString stringWithFormat:@"%@ - %@\n", propertyName, func(self, getSel)];
        [descriptionString appendString:propertyNameString];
    }
    return [descriptionString copy];
}
@end
