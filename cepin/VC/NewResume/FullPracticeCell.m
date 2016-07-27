//
//  FullPracticeCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullPracticeCell.h"
#import "FullPracticeCellView.h"
#import "NSString+Extension.h"

@interface FullPracticeCell()

@property (nonatomic, weak) FullPracticeCellView *cellView;

@end

@implementation FullPracticeCell
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
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.viewcell.viewY, self.viewWidth - 40 / 3.0 * 2, self.viewcell.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.viewcell addSubview:self.titleLabel];
        
        self.des = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewHeight+self.titleLabel.viewY, 150, 120 / 3.0)];
        self.des.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.des.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
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
- (void)createCellWithModel:(ResumeNameModel *)model height:(int)height;
{
    if ( !self.cellView )
    {
        CGFloat practiceHeight = 0;
        
        for ( NSDictionary *dict in model.PracticeList )
        {
            PracticeListDataModel *pracitce = [PracticeListDataModel beanFromDictionary:dict];
            
            practiceHeight += [self caculatePracticeHeight:pracitce];
        }
        
        FullPracticeCellView *cellView = [[FullPracticeCellView alloc] initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, height) model:model];
        
        [self addSubview:cellView];
        _cellView = cellView;
    }
}

- (CGFloat)caculatePracticeHeight:(PracticeListDataModel *)practice
{
    CGFloat height = 0;
    CGFloat fixdHeight = 40 / 3.0 * 2 + 5 * 3 + [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3;
    CGFloat maxMarge = kScreenWidth - 40 - 40 / 3.0;
    
    CGSize practiceSize = CGSizeZero;
    
    if ( practice.Content && practice.Content.length > 0 )
    {
        practiceSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:practice.Content andWith:maxMarge];
        height += practiceSize.height + 5.0;
    }
    
    height += fixdHeight;
    
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
