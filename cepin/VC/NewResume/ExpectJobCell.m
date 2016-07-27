//
//  ExpectJobCell.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectJobCell.h"

@implementation ExpectJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //input__xx
        self.selectionStyle = UITableViewCellSelectionStyleNone;
 
        int hight = IS_IPHONE_5?21:25;
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 75, 30)];
        self.titlelabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.titlelabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        [self addSubview:self.titlelabel];
        
        self.placeholderField = [[CPResumeTextField alloc]initWithFrame:CGRectMake(self.titlelabel.viewX + self.titlelabel.viewWidth,0, 200, 44)];
        self.placeholderField.userInteractionEnabled = NO;
        self.placeholderField.textAlignment = NSTextAlignmentRight;
        self.placeholderField.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.placeholderField.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        self.placeholderField.placeholder = @"请选择";
        [self addSubview:self.placeholderField];
        
        self.inputImage = [[UIImageView alloc]init];
        self.inputImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:self.inputImage];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(75));
        }];
        [self.placeholderField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titlelabel.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
            make.right.equalTo(self.inputImage.mas_left);
        }];
        [self.inputImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(hight));
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right).offset( 0 );
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}

-(void)configureTextFieldText:(NSString*)text
{
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
