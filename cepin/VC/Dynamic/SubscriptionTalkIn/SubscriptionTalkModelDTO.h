//
//  SubscriptionTalkModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface SubscriptionTalkModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *schools;//String	高校名称（多选，最多三个，传SchoolId，多个用“，”隔开）

@end
