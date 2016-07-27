//
//  CPSearchDefaultBean.h
//  cepin
//
//  Created by dujincai on 16/3/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "BaseBeanModel.h"
/**
 *"Id":26,"TypeId":3,"Title":"开发","ParentId":0,"SortNumber":1,"CreateDate":"2016-02-15","Status":1
 */
@interface CPSearchDefaultBean : BaseBeanModel

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger TypeId;
@property(nonatomic,strong)NSString<Optional> *Title;
@property(nonatomic,assign)NSInteger SortNumber;
@property(nonatomic,assign)NSInteger ParentId;
@property(nonatomic,strong)NSString<Optional> *CreateDate;

@end
