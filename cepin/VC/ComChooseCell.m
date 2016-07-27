//
//  ComChooseCell.m
//  cepin
//
//  Created by zhu on 14/12/14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "ComChooseCell.h"

@implementation ComChooseCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        int hight = IS_IPHONE_5?12:14;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-10-22-5-70 + 20, self.viewHeight)];
        self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.labelTitle.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelSub = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-10-22-5-70, 0, 70, 43)];
        self.labelSub.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.labelSub.font = [[RTAPPUIHelper shareInstance] subTitleFont];
        self.labelSub.textAlignment = NSTextAlignmentRight;
        self.labelSub.numberOfLines = 2;
        self.labelSub.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelSub];
        
        self.imageViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-(imagehight), (self.viewHeight-(imagehight))/2, hight, hight)];
        self.imageViewArrow.backgroundColor = [UIColor clearColor];
        self.imageViewArrow.image = UIIMAGE(@"indicate_right_grey");
        [self.contentView addSubview:self.imageViewArrow];
        
        self.imageSelectFlag = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-22, (43-22)/2, 22, 22)];
        self.imageSelectFlag.backgroundColor = [UIColor clearColor];
        self.imageSelectFlag.image = UIIMAGE(@"");
        [self.contentView addSubview:self.imageSelectFlag];
        
        self.tickImage = [[UIImageView alloc]init];
        self.tickImage.image = [UIImage imageNamed:@"ic_tick"];
        self.tickImage.hidden = YES;
        [self.contentView addSubview:self.tickImage];
        [self.tickImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageViewArrow.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(imagehight));
            make.height.equalTo(@(imagehight));
        }];
    }
    return self;
}

//ic_tick
-(void)setChooseType:(ComChooseCellType)type
{
    _chooseType = type;
    if (_chooseType == ComChooseNextType)
    {
        self.imageSelectFlag.hidden = YES;
        self.imageViewArrow.hidden = NO;
    }
    else
    {
        self.imageViewArrow.hidden = YES;
        self.imageSelectFlag.hidden = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.labelTitle.viewHeight = self.viewHeight;
}

-(void)configureLableTitleText:(NSString*)text
{
    self.labelTitle.text = text;
}
-(void)configureLableSubText:(NSString*)text
{
    if (text)
    {
        self.labelSub.text = text;
    }
    else
    {
        self.labelSub.text = @"";
    }
}

-(void)setIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        self.imageSelectFlag.image = UIIMAGE(@"ic_tick");
    }
    else
    {
        self.imageSelectFlag.image = UIIMAGE(@"");
    }
}

-(void)setSelectType:(ComChooseCellSelctType)type
{
    _selectType = type;
    switch (_selectType)
    {
        case ComChooseEnable:self.imageSelectFlag.image = UIIMAGE(@"");
            break;
        case ComChooseHasSelect:self.imageSelectFlag.image = UIIMAGE(@"ic_tick");
            break;
        case ComChooseDisable:self.imageSelectFlag.image = UIIMAGE(@"");
            break;
            
        default:
            break;
    }
}
@end
