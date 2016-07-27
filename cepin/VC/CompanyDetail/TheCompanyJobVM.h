//
//  TheCompanyJobVM.h
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "PositionIdModel.h"
@interface TheCompanyJobVM : BaseTableViewModel
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,retain)NSString *theCompanyId;
@property(nonatomic, strong)NSMutableArray *positionIdArray;

-(instancetype)initWithCompanyId:(NSString*)companyId;

- (void)allPositionId;
@end
