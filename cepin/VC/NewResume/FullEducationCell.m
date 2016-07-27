//
//  FullEducationCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullEducationCell.h"
#import "NSString+Extension.h"

@implementation FullEducationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.viewcell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        self.viewcell.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.viewcell];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.viewcell.viewY, self.viewWidth - 40 / 3.0, self.viewcell.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.viewcell addSubview:self.titleLabel];
        
        self.des = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewY + self.titleLabel.viewHeight, 150, 120 / 3.0)];
        self.des.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.des.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.des];
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


- (void)createCellWithModel:(ResumeNameModel *)model
{
    if ( !self.cellView )
    {
       self.cellView = [[FullEducationCellView alloc] initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, [self caculateHeight:model]) model:model];
    }
    
    [self.contentView addSubview:self.cellView];
}

- (CGFloat)caculateHeight:(ResumeNameModel *)model
{
    CGFloat height = 0;
    CGFloat tempH = [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
    NSMutableString *detailStrM = [NSMutableString string];
    
    for ( NSDictionary *dict in model.EducationList )
    {
        EducationListDateModel *educationModel = [EducationListDateModel beanFromDictionary:dict];
        
        if ( educationModel.ScoreRanking && educationModel.ScoreRanking.length > 0 )
        {
            [detailStrM appendFormat:@"成绩排名 : %@", educationModel.ScoreRanking];
        }
        
        if ( educationModel.Description && educationModel.Description.length > 0 )
        {
            if ( detailStrM.length > 0 )
            {
                [detailStrM appendFormat:@"\n主修课程 : %@", educationModel.Description];
            }
            else
            {
                [detailStrM appendFormat:@"主修课程 : %@", educationModel.Description];
            }
        }
        
        if ( detailStrM.length > 0 )
        {
            height += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont] text:detailStrM andWith:kScreenWidth - 40 - 40 / 3.0].height + 5.0;
        }
        else
            height += tempH;
    }
    
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
