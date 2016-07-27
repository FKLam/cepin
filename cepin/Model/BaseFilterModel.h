//
//  BaseFilterModel.h
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "RegionDTO.h"


@interface BaseFilterModel : JSONModel

+(instancetype)shareInstance;
-(BOOL)saveObjectToDisk;
+(instancetype)loadData;

@end
