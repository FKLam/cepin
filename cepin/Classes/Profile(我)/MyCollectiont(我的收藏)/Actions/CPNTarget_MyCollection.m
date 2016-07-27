//
//  CPNTarget_MyCollection.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_MyCollection.h"
#import "SaveVC.h"
@implementation CPNTarget_MyCollection
- (UIViewController *)CPNAction_nativeMyCollectionViewController:(NSDictionary *)params
{
    SaveVC *viewController = [[SaveVC alloc] init];
    return viewController;
}
@end
