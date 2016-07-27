//
//  FullTrainCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullTrainCell.h"
#import "FullTrainCellView.h"

@interface FullTrainCell()

@property (nonatomic, weak) FullTrainCellView *cellView;

@end

@implementation FullTrainCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
//        int hight = IS_IPHONE_5?12:15;
        self.viewcell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        self.viewcell.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.viewcell];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.viewcell.viewY, self.viewWidth - 40, self.viewcell.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.viewcell addSubview:self.titleLabel];
        
        self.des = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewHeight+self.titleLabel.viewY, 150, 120 / 3.0)];
        self.des.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.des.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.viewcell addSubview:self.des];
    }
    return self;
}
- (void)desWithOut:(BOOL)none
{
    if (!none) {
        self.des.text = @"无";
    }else
    {
        self.des.text = @"";
    }
    
}

- (void)createCellWithModel:(ResumeNameModel *)model height:(int)height
{
    if ( !self.cellView )
    {
        FullTrainCellView *cellView = [[FullTrainCellView alloc]initWithFrame:CGRectMake(0, 102 / 3.0, self.viewWidth, height) model:model];
        [self.contentView addSubview:cellView];
        _cellView = cellView;
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
