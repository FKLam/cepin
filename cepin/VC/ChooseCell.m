//
//  ChooseCell.m
//  cepin
//
//  Created by dujincai on 15/7/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40 / 3.0, 0, self.viewWidth / 2.0, self.viewHeight)];
        self.labelTitle.textColor = [UIColor colorWithHexString:@"404040"];
        self.labelTitle.font = [UIFont systemFontOfSize:42 / 3.0];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        self.imageViewArrow = [[UIImageView alloc] init];
        self.imageViewArrow.backgroundColor = [UIColor clearColor];
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_up_gray"];
        [self.contentView addSubview:self.imageViewArrow];
        [self.imageViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -35 / 3.0 );
            make.centerY.equalTo( self.mas_centerY );
            make.width.equalTo( @( 70 / 3.0 ) );
            make.height.equalTo( @( 70 / 3.0 ) );
        }];
    }
    return self;
}

//ic_tick
-(void)setChooseType:(ChooseCellType)type
{
    _chooseType = type;
    if (_chooseType == ChooseNextType)
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
//    if (isSelected)
//    {
//        self.imageSelectFlag.image = UIIMAGE(@"ic_tick");
//    }
//    else
//    {
//        self.imageSelectFlag.image = UIIMAGE(@"");
//    }
}

-(void)setSelectType:(ChooseCellSelctType)type
{
    _selectType = type;
    switch (_selectType)
    {
        case ChooseEnable:self.imageSelectFlag.image = UIIMAGE(@"");
            break;
        case ChooseHasSelect:self.imageSelectFlag.image = UIIMAGE(@"ic_tick");
            break;
        case ChooseDisable:self.imageSelectFlag.image = UIIMAGE(@"");
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
