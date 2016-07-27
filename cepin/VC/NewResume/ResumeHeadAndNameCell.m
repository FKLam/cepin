//
//  ResumeHeadAndNameCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeHeadAndNameCell.h"

@interface ResumeHeadAndNameCell ()

@property (nonatomic, weak) UILabel *resume;
@property (nonatomic, weak) UILabel *name;

@end

@implementation ResumeHeadAndNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        int hight = IS_IPHONE_5?18:21;
        int imageHight = IS_IPHONE_5?50:60;
        int labelHight = IS_IPHONE_5?40:48;
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(hight);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageButton.frame = CGRectMake(20, 10, imageHight, imageHight);
        self.imageButton.backgroundColor = [UIColor clearColor];
        self.imageButton.layer.cornerRadius = imageHight/2;
        self.imageButton.layer.masksToBounds = YES;
        [backView addSubview:self.imageButton];
     
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imageHight, imageHight)];
        self.headImage.layer.cornerRadius = imageHight/2;
        self.headImage.layer.masksToBounds = YES;
        self.headImage.image = UIIMAGE(@"icon_32_08");
        [backView addSubview:self.headImage];;
        
        UILabel *resume = [[UILabel alloc]initWithFrame:CGRectMake(self.imageButton.viewX + self.imageButton.viewWidth + 5, 0, IS_IPHONE_5?50:60, labelHight)];
        resume.text = @"简历名称";
        resume.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        resume.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        [backView addSubview:resume];
        _resume = resume;
        
        self.ResumeName = [[UITextField alloc]init];
        
#pragma mark - 修改textfield的placeholder字体的颜色
        self.ResumeName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入简历名称" attributes:@{NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance]labelColorGreen]}];
        
        self.ResumeName.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.ResumeName.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        self.ResumeName.textAlignment = NSTextAlignmentRight;
        self.ResumeName.clearButtonMode = UITextFieldViewModeWhileEditing;
        [backView addSubview:self.ResumeName];
        
        [self.ResumeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(resume.mas_right);
            make.top.equalTo(backView.mas_top);
            make.right.equalTo(backView.mas_right).offset(-20);
            make.height.equalTo(@(labelHight));
        }];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [backView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right);
            make.left.equalTo(resume.mas_left);
            make.top.equalTo(resume.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(self.imageButton.viewX + self.imageButton.viewWidth + 5, resume.viewHeight + resume.viewY, IS_IPHONE_5?30:40, labelHight)];
        name.text = @"姓名";
        name.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        name.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        [backView addSubview:name];
        _name = name;
        
        self.NameText = [[UITextField alloc]init];
        
#pragma mark - 修改textfield的placeholder字体的颜色
        self.NameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance]labelColorGreen]}];
        
        self.NameText.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.NameText.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        self.NameText.textAlignment = NSTextAlignmentRight;
        self.NameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [backView addSubview:self.NameText];
        
        [self.NameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right);
            make.top.equalTo(name.mas_top);
            make.right.equalTo(backView.mas_right).offset(-20);
            make.height.equalTo(@(labelHight));
        }];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [backView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right);
            make.left.equalTo(name.mas_left);
            make.top.equalTo(name.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize resumeSize = [self.resume.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileBaseInformatonFont]} context:nil].size;
    CGRect resumeFrame = self.resume.frame;
    resumeFrame.size.width = resumeSize.width;
    resumeFrame.size.height = 40;
    self.resume.frame = resumeFrame;
    
    CGSize nameSize = [self.name.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileBaseInformatonFont]} context:nil].size;
    CGRect nameFrame = self.name.frame;
    nameFrame.size.width = nameSize.width;
    nameFrame.size.height = 40;
    self.name.frame = nameFrame;
}

@end
