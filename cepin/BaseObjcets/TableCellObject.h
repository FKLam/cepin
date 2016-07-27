//
//  TableCellObject.h
//  yanyunew
//
//  Created by Ricky Tang on 14-4-26.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModel.h"

@protocol TableCellObject @end

@interface TableCellObject : JSONModel
@property(nonatomic,strong)NSString *cellClassName;
@property(nonatomic,strong)NSString<Optional> *cellTitle;
@property(nonatomic,strong)NSString<Optional> *cellDetail;
@property(nonatomic,strong)NSString<Optional> *cellImage;
@property(nonatomic,strong)NSNumber *cellHeight;
@property(nonatomic,strong)NSNumber<Optional> *type;
@property(nonatomic,strong)NSString<Optional> *separatorColor;
@property(nonatomic,assign)NSNumber<Optional> *isHasSeparator;
@property(nonatomic,strong)NSString<Optional> *separatoreColor;
@end
