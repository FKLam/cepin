//
//  TalkInFilterModel.h
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseFilterModel.h"
#import "SchoolDTO.h"

@interface TalkInFilterModel : BaseFilterModel

@property(nonatomic,strong)NSMutableArray<School> *schools;

-(void)reloadWithFileName:(NSString*)fieName;
-(BOOL)saveObjectToDiskWithFile:(NSString*)fieName;
-(BOOL)deleteObjectFromDisk:(NSString*)fileName;
-(void)deleteObjectFromNet:(NSString*)fileName;
-(void)resetWithModelAndFileName:(TalkInFilterModel*)model file:(NSString*)fileName;



@end
