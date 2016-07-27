//
//  CPGuessYLPositionVM.h
//  cepin
//
//  Created by ceping on 16/3/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "RegionDTO.h"
@interface CPGuessYLPositionVM : BaseTableViewModel
@property (nonatomic, strong) id guessYLStateCode;
@property (nonatomic, strong) NSMutableArray *visiabelGuessYLPositionDictArrayM;
@property (nonatomic, strong) NSMutableArray *allGuessYLPositionDictArrayM;
@property (nonatomic, strong) NSMutableArray *allGuessYLPositionArrayM;
@property (nonatomic, strong) NSMutableArray *visiabelGuessYLPositionArrayM;
@property(nonatomic,strong) Region *locationRegion;
- (void)getAllGuessYLPosition;
- (void)clickedMoreButton;
@end
