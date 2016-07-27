//
//  FullLanguageCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullLanguageCell.h"
#import "FullLanguageCellView.h"

@interface FullLanguageCell()

@property (nonatomic, weak) FullLanguageCellView *cellView;

@property (nonatomic, strong) ResumeNameModel * model;

@property (nonatomic, copy) NSDictionary *CET4ScoreDict;

@end

@implementation FullLanguageCell

- (NSDictionary *)CET4ScoreDict
{
    if ( !_CET4ScoreDict )
    {
        if (_model)
        {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            if ( _model.IsHasCET4Score.intValue == 1 && _model.CET4Score)
            {
                [tempDict setObject:_model.CET4Score forKey:@"英语 CET4"];
            }
            
            if ( _model.IsHasCET6Score.intValue == 1 && _model.CET6Score )
            {
                [tempDict setObject:_model.CET6Score forKey:@"英语 CET6"];
            }
            
            if ( _model.IsHasTEM4Score.intValue == 1 && _model.TEM4Score )
            {
                [tempDict setObject:_model.TEM4Score forKey:@"英语 TEM4"];
            }
            
            if ( _model.IsHasTEM8Score.intValue == 1 && _model.TEM8Score )
            {
                [tempDict setObject:_model.TEM8Score forKey:@"英语 TEM8"];
            }
            
            if ( _model.IsHasIELTSScore.intValue == 1 && _model.IELTSScore )
            {
                [tempDict setObject:_model.IELTSScore forKey:@"英语 雅思"];
            }
            
            if ( _model.IsHasTOEFLScore.intValue == 1 && _model.TOEFLScore )
            {
                [tempDict setObject:_model.TOEFLScore forKey:@"英语 托福"];
            }
            
            if ( tempDict.count > 0 )
                _CET4ScoreDict = [tempDict copy];
                
        }
    }
    return _CET4ScoreDict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
//        int hight = IS_IPHONE_5?12:15;
        self.viewcell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        self.viewcell.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.viewcell];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.viewcell.viewY, self.viewWidth - 40, self.viewcell.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.viewcell addSubview:self.titleLabel];
    
        self.des = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewHeight + self.titleLabel.viewY, 150, 120 / 3.0)];
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

- (void)createCellWithModel:(ResumeNameModel *)model languageViewHeight:(CGFloat)languageViewHeight
{
    if ( !self.cellView )
    {
        _model = model;
        
        FullLanguageCellView *cellView = [[FullLanguageCellView alloc]initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, languageViewHeight) model:model CETDict:self.CET4ScoreDict];
        
        [self addSubview:cellView];
        _cellView = cellView;
    }
}

- (void)createCellWithModel:(id)model height:(int)height
{
    if ( !self.cellView )
    {
        _model = model;
        
        FullLanguageCellView *cellView = [[FullLanguageCellView alloc] initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, height) model:model CETDict:self.CET4ScoreDict];
        
        [self addSubview:cellView];
        _cellView = cellView;
    }
}

- (void)createCellWithModel:(ResumeNameModel *)model;
{
    if ( !self.cellView )
    {
        _model = model;
        
        FullLanguageCellView *cellView = [[FullLanguageCellView alloc]initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, 30*(model.LanguageList.count + model.CredentialList.count + model.SkillList.count + self.CET4ScoreDict.count)) model:model CETDict:self.CET4ScoreDict];
        
        [self addSubview:cellView];
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
