//
//  FullViewCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullViewCell.h"
#import "ResumeNameModel.h"
#import "TBTextUnit.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

@interface FullViewCell()

@property (nonatomic, weak) UIImageView *imageLogo;
@property (nonatomic, weak) UILabel *detailLabel;
@end

@implementation FullViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        CGFloat imageHight = 21.0;
        CGFloat hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        _imageLogo = imageLogo;
        
        self.time = [[UILabel alloc] init];
        self.time.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.time];
        
        self.school = [[UILabel alloc]initWithFrame:CGRectMake(self.time.viewX, self.time.viewHeight + 10, self.viewWidth - 40, hight)];
        self.school.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.school.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.school];
        
        self.major = [[UILabel alloc]initWithFrame:CGRectMake(self.school.viewX, self.school.viewY + self.school.viewHeight + 10, self.viewWidth - 40, hight)];
        self.major.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.major.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.major];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        detailLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        detailLabel.numberOfLines = 0;
        [self.contentView addSubview:detailLabel];
        _detailLabel = detailLabel;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        _separatorView = separatorView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize;
    
    CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
    
    CGSize timeSize = [NSString caculateTextSize:self.time.font text:self.time.text andWith:maxMarge];
    self.time.frame = CGRectMake(40, 40 / 3.0, timeSize.width, tempH);
    
    CGSize schoolSize = [NSString caculateTextSize:self.school.font text:self.school.text andWith:maxMarge];
    self.school.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, schoolSize.width, tempH);
    
    CGSize majorSize = [NSString caculateTextSize:self.major.font text:self.major.text andWith:maxMarge];
    self.major.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.school.frame) + 5.0, majorSize.width, tempH);
    
    CGSize detailSize = [NSString caculateTextSize:self.detailLabel.font text:self.detailLabel.text andWith:maxMarge];
    self.detailLabel.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.major.frame) + 5.0, detailSize.width, detailSize.height);
    
    self.separatorView.frame = CGRectMake(self.time.viewX, self.viewHeight - 1.0, kScreenWidth - self.time.viewX, 1 / 2.0);
}

-(void)getModel:(id)model
{
    EducationListDateModel *eduModel = model;
    NSString *star = [self managestrTime:eduModel.StartDate];
    NSString *end = [self managestrTime:eduModel.EndDate];
    NSString *time = [NSString stringWithFormat:@"%@-%@",star,end];
    self.time.text = time;
    self.school.text = eduModel.School;
    NSString *major = [TBTextUnit fullResumeDetail:eduModel.Major degle:eduModel.Degree];
    
    NSMutableString *majorM = [NSMutableString stringWithString:major];
    if ( eduModel.XueWei && eduModel.XueWei.length > 0 )
        [majorM appendFormat:@" | %@学位", eduModel.XueWei];
    
    self.major.text = [majorM copy];
    
//    Description ScoreRanking
    NSMutableString *detailStrM = [NSMutableString string];
    
    if ( eduModel.ScoreRanking && eduModel.ScoreRanking.length > 0 )
    {
        if ( [eduModel.ScoreRanking intValue] == 0 )
        {
            [detailStrM appendFormat:@"成绩排名 : 其他"];
        }
        else
            [detailStrM appendFormat:@"成绩排名 : 年级前%@%@", eduModel.ScoreRanking, @"%"];
    }
    
    if ( eduModel.Description && eduModel.Description.length > 0 )
    {
        if ( detailStrM.length > 0 )
        {
            [detailStrM appendFormat:@"\n主修课程 : %@", eduModel.Description];
        }
        else
        {
            [detailStrM appendFormat:@"主修课程 : %@", eduModel.Description];
        }
    }
    
    self.detailLabel.text = [detailStrM copy];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
