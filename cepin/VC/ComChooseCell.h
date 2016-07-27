//
//  ComChooseCell.h
//  cepin
//
//  Created by zhu on 14/12/14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCustomLineCell.h"

typedef enum
{
    ComChooseNextType = 0,
    ComChooseSelectType,
}ComChooseCellType;

typedef enum
{
    ComChooseEnable = 0,
    ComChooseHasSelect,
    ComChooseDisable,
}ComChooseCellSelctType;

@interface ComChooseCell : BaseCustomLineCell

@property(nonatomic,assign)ComChooseCellType chooseType;
@property(nonatomic,assign)ComChooseCellSelctType selectType;
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UILabel *labelSub;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property(nonatomic,retain)UIImageView *imageSelectFlag;
@property(nonatomic,strong)UIImageView *tickImage;

-(void)setChooseType:(ComChooseCellType)type;
-(void)setSelectType:(ComChooseCellSelctType)type;

-(void)configureLableTitleText:(NSString*)text;
-(void)configureLableSubText:(NSString*)text;

@property(nonatomic,readwrite)BOOL isSelected;

@end
