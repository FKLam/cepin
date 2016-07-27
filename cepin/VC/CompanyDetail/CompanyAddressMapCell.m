//
//  CompanyAddressMapCell.m
//  cepin
//
//  Created by dujincai on 15/7/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyAddressMapCell.h"
#import "NSString+Extension.h"

CGFloat globelW = 0;

@interface CompanyAddressMapCell()

@property (nonatomic, strong) UIView *custemLayer;

@end

@implementation CompanyAddressMapCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.addressImage = [[UIImageView alloc] init];
        self.addressImage.image = [UIImage imageNamed:@"ic_location"];
        [self.contentView addSubview:self.addressImage];
        self.addressLabel  = [[UILabel alloc] init];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.addressLabel.font = [[RTAPPUIHelper shareInstance] linkedWordsFont];
        [self.contentView addSubview:self.addressLabel];
        
        self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addressButton.frame = self.bounds;
        self.addressButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addressButton];
        
        UIView *custemLayer = [[UIView alloc] init];
        custemLayer.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
        custemLayer.frame = CGRectMake(0, self.viewHeight - 32.0 / 3.0, kScreenWidth, 32.0 / 3.0 );
        [self.contentView addSubview:custemLayer];
        _custemLayer = custemLayer;
    }
    return self;
}
+(int)computerCellHeihgt:(NSString*)str
{
    if (!str || [str isEqualToString:@""]) {
//        return 32.0 / 3.0;
        return [[RTAPPUIHelper shareInstance] linkedWordsFont].pointSize + 40 / 3.0 * 2.0 + 32.0 / 3.0;
    }else{
     
//        return StringFontSizeH(str, [[RTAPPUIHelper shareInstance] titleFont], kScreenWidth - 70)+(IS_IPHONE_5?20:15) + 18;
        
        CGFloat horizontal_marge = 40 / 3.0;
        CGFloat vertical_marge = 40 / 3.0;
        
        CGFloat maxMarge = kScreenWidth - globelW - vertical_marge * 2;
        CGSize addressSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] linkedWordsFont] text:str andWith:maxMarge];
        return 32.0 / 3.0 + addressSize.height + horizontal_marge * 2;
    }
}

- (void)layoutSubviews
{
    CGFloat horizontal_marge = 40 / 3.0;
    CGFloat vertical_marge = 40 / 3.0;
    self.addressImage.viewX = horizontal_marge;
    self.addressImage.viewSize = CGSizeMake(self.addressImage.image.size.width * 0.6, self.addressImage.image.size.width * 0.6 );
    self.addressImage.viewCenterY = (horizontal_marge + horizontal_marge + 42 / 3.0) / 2.0 + 1.0;
    globelW = CGRectGetMaxX(self.addressImage.frame);
    
    CGFloat maxMarge = kScreenWidth - CGRectGetMaxX(self.addressImage.frame) - 40 / 3.0 * 2;
    CGSize addressSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] linkedWordsFont] text:self.addressLabel.text andWith:maxMarge];
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.addressImage.frame) + 40 / 3.0, vertical_marge, addressSize.width, addressSize.height);
    self.addressButton.frame = self.addressLabel.frame;
    
    CGFloat custemLayerY = self.viewHeight - 32 / 3.0;
    self.custemLayer.frame = CGRectMake(0, custemLayerY, kScreenWidth, 32.0 / 3.0 );
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
