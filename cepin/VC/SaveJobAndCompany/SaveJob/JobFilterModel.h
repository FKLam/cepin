//
//  JobFilterModel.h
//  cepin
//  
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseFilterModel.h"
#import "BaseCodeDTO.h"

@interface JobFilterModel : BaseFilterModel

@property(nonatomic,strong)NSMutableArray<Region> *addresses;//工作地点
@property(nonatomic,strong)BaseCode<Optional> *jobProperty;//工作性质
@property(nonatomic,strong)BaseCode<Optional> *salary;
@property(nonatomic,strong)BaseCode<Optional> *WorkYears;
@property(nonatomic,strong)NSString<Optional> *keyWord;

-(BOOL)saveObjectToDisk;
-(BOOL)deleteObjectFromDisk;
-(void)reset;

@end
