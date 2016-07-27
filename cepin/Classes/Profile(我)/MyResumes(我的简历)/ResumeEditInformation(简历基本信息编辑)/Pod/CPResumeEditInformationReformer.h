//
//  CPResumeEditInformationReformer.h
//  cepin
//
//  Created by ceping on 16/1/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPResumeEditInformationReformer : NSObject
+ (void)SaveOneWord:(NSString *)oneWordStr;
+ (NSString *)onwWordStr;
+ (NSArray *)searchMatchAddressWithMatchString:(NSString *)matchString originArray:(NSArray *)originArray;
@end
