//
//  TableSectionObject.h
//  yanyunew
//
//  Created by Ricky Tang on 14-4-27.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModel.h"
#import "TableCellObject.h"

@protocol TableSectionObject
@end

@interface TableSectionObject : JSONModel
@property(nonatomic,strong)NSString<Optional> *headClassName;
@property(nonatomic,strong)NSString<Optional> *headTitle;
@property(nonatomic,strong)NSString<Optional> *headTitleInsets;
@property(nonatomic,strong)NSNumber<Optional> *headHeight;
@property(nonatomic,strong)NSNumber<Optional> *type;
@property(nonatomic,strong)NSMutableArray<TableCellObject> *cells;
@end
