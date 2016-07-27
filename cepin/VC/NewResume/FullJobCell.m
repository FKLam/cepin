//
//  FullJobCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullJobCell.h"
#import "FullJobCellView.h"
#import "NSString+Extension.h"

@interface FullJobCell ()

@property (nonatomic, weak) FullJobCellView *cellView;

@end

@implementation FullJobCell
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
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.viewcell.viewY, self.viewWidth - 40 / 3.0 * 2, self.viewcell.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.viewcell addSubview:self.titleLabel];
        
        self.des = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewY + self.titleLabel.viewHeight, 150, 120 / 3.0)];
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
- (void)createCellWithModel:(ResumeNameModel *)model;
{
    if ( !self.cellView )
    {
        NSInteger totalH = 0;
        CGFloat tempH = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
        CGFloat maxMarge = kScreenWidth - 40  - 40 / 3.0;
        
        for ( NSDictionary *workDict in model.WorkList )
        {
            WorkListDateModel *work = [WorkListDateModel beanFromDictionary:workDict];
            
            NSMutableString *proveStr = [NSMutableString string];
            if(work.AttestorName)
            {
                [proveStr appendFormat:@"证明人：%@", work.AttestorName];
            }
            
            if(work.AttestorRelation)
            {
                [proveStr appendFormat:@"／%@", work.AttestorRelation];
            }
            
            if(work.AttestorPosition)
            {
                [proveStr appendFormat:@"／%@", work.AttestorPosition];
            }
            
            if(work.AttestorPhone)
            {
                [proveStr appendFormat:@"／%@", work.AttestorPhone];
            }
            
            if(work.AttestorCompany)
            {
                [proveStr appendFormat:@"\n证明人单位：%@", work.AttestorCompany];
            }
            
            if ( proveStr.length > 0 )
                totalH += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] jobInformationDetaillFont] text:proveStr andWith:maxMarge].height + 5.0;
            else
                totalH += tempH;
        }
        
        FullJobCellView *cellView = [[FullJobCellView alloc] initWithFrame:CGRectMake(0, 102 / 3.0, kScreenWidth, totalH) model:model];
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
