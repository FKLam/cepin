//
//  CPSearchMatchDTO.h
//  cepin
//
//  Created by dujincai on 16/2/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "BaseBeanModel.h"


@interface SearchMatch : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Keyword;
@property(nonatomic,strong)NSNumber<Optional> *Frequency;
@property(nonatomic,strong)NSString<Optional> *PositionCount;

@end

