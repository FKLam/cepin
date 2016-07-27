//
//  ChooseCell.h
//  cepin
//
//  Created by dujincai on 15/7/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseCustomLineCell.h"

typedef enum
{
    ChooseNextType = 0,
    ChooseSelectType,
}ChooseCellType;

typedef enum
{
    ChooseEnable = 0,
    ChooseHasSelect,
    ChooseDisable,
}ChooseCellSelctType;

@interface ChooseCell : BaseCustomLineCell
@property(nonatomic,assign)ChooseCellType chooseType;
@property(nonatomic,assign)ChooseCellSelctType selectType;
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UILabel *labelSub;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property(nonatomic,retain)UIImageView *imageSelectFlag;
@property(nonatomic,strong)UIImageView *tickImage;

-(void)setChooseType:(ChooseCellType)type;
-(void)setSelectType:(ChooseCellSelctType)type;

-(void)configureLableTitleText:(NSString*)text;
-(void)configureLableSubText:(NSString*)text;

@property(nonatomic,readwrite)BOOL isSelected;
@end
