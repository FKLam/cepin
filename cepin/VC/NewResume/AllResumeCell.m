//
//  AllResumeCell.m
//  cepin
//
//  Created by ceping on 15-3-10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AllResumeCell.h"
#import "RTAPPUIHelper.h"
#import "CPCommon.h"

@implementation AllResumeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isShowMenu = [NSNumber numberWithInt:2];
        self.resumeNameLable = [[UILabel alloc] init];
        self.resumeNameLable.backgroundColor = [UIColor clearColor];
        self.resumeNameLable.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        
        self.resumeNameLable.textColor = [[RTAPPUIHelper shareInstance] profileResumeNameColor];
        self.resumeNameLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.resumeNameLable];
        
        
        self.schoolImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.resumeNameLable.viewX+self.resumeNameLable.viewWidth+8, self.resumeNameLable.viewY, 24, 24)];
        
        self.schoolImageIcon.backgroundColor = [UIColor clearColor];
        self.schoolImageIcon.image = UIIMAGE(@"list_ic_edutab");
        [self.contentView addSubview:self.schoolImageIcon];
    
        
        self.topImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.schoolImageIcon.viewX+self.schoolImageIcon.viewWidth+8, self.resumeNameLable.viewY, 15, 15)];
        self.topImageIcon.backgroundColor = [UIColor clearColor];
        self.topImageIcon.image = UIIMAGE(@"ic_totop");
        [self.contentView addSubview:self.topImageIcon];
        
        self.canSend = [[UILabel alloc]initWithFrame:CGRectMake(self.resumeNameLable.viewX, self.resumeNameLable.viewY+self.resumeNameLable.viewHeight+8, 30, 20)];
        self.canSend.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        self.canSend.textColor = [[RTAPPUIHelper shareInstance] profileResumeStatueColor];
        self.canSend.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.canSend];
        
        
        self.reviewNumLable = [[UILabel alloc]initWithFrame:CGRectMake(self.canSend.viewX+self.canSend.viewWidth, self.canSend.viewY, 40, 20)];
        self.reviewNumLable.backgroundColor = [UIColor clearColor];
        self.reviewNumLable.font = [[RTAPPUIHelper shareInstance] profileResumeMessageFont];
        self.reviewNumLable.textColor = [[RTAPPUIHelper shareInstance] profileResumeMessageColor];
        self.reviewNumLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.reviewNumLable];
        
        self.moreImageIcon = [[UIButton alloc] init];
//        self.moreImageIcon.backgroundColor = UIIMAGE(@"ic_i");
//        self.moreImageIcon.image = UIIMAGE(@"ic_i");
        [self.moreImageIcon setBackgroundColor:[UIColor clearColor]];
         [self.moreImageIcon setImage:[UIImage imageNamed:@"dropdownbox_ic_down"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.moreImageIcon];
//
        self.moreButton = [[UIButton alloc] init];
        self.moreButton.backgroundColor = [UIColor clearColor];
//        [self.moreButton setImage:[UIImage imageNamed:@"dropdownbox_ic_down"] forState:UIControlStateNormal];
        [self.moreButton setContentMode:UIViewContentModeCenter];
//        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"dropdownbox_ic_down"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.moreButton];
        
        self.lineView = [[UIView alloc] init];
//        self.lineView.alpha = 0.5;
//        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        self.lineView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 1.0);
        [self.contentView addSubview:self.lineView];
        
        self.resumeOperaView  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reviewNumLable.frame), self.viewWidth, 40.0)];
        [self.contentView addSubview:self.resumeOperaView];
        int w = kScreenWidth/4;
        self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readBtn.frame = CGRectMake(0, 0, w-1, self.resumeOperaView.viewHeight);
        [self.readBtn setTitle:@"预览" forState:UIControlStateNormal];
        self.readBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.readBtn.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.readBtn setTitleColor:[[RTAPPUIHelper shareInstance] mainTitleColor] forState:UIControlStateNormal];
        [self.resumeOperaView addSubview:self.readBtn];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(w-1, self.readBtn.viewY, 1, self.resumeOperaView.viewHeight)];
        line1.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.resumeOperaView addSubview:line1];
        
        self.setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.setDefaultBtn.frame = CGRectMake(w, self.readBtn.viewY, w-1, self.resumeOperaView.viewHeight);
        self.setDefaultBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self.setDefaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        self.setDefaultBtn.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.setDefaultBtn setTitleColor:[[RTAPPUIHelper shareInstance]mainTitleColor] forState:UIControlStateNormal];
        [self.resumeOperaView addSubview:self.setDefaultBtn];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(2*w-1, self.setDefaultBtn.viewY, 1, self.resumeOperaView.viewHeight)];
        line2.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.resumeOperaView addSubview:line2];
        
        self.cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cpBtn.frame = CGRectMake(2*w, self.readBtn.viewY, w-1, self.resumeOperaView.viewHeight);
        self.cpBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.cpBtn.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.cpBtn setTitleColor:[[RTAPPUIHelper shareInstance]mainTitleColor] forState:UIControlStateNormal];
        [self.cpBtn setTitle:@"复制" forState:UIControlStateNormal];
        [self.resumeOperaView addSubview:self.cpBtn];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(3*w-1, self.cpBtn.viewY, 1, self.resumeOperaView.viewHeight)];
        line3.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.resumeOperaView addSubview:line3];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(3*w, self.readBtn.viewY, w,  self.resumeOperaView.viewHeight);
        self.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.deleteBtn.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.deleteBtn setTitleColor:[[RTAPPUIHelper shareInstance]mainTitleColor] forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.resumeOperaView addSubview:self.deleteBtn];
        
        self.endView = [[UIView alloc]initWithFrame:CGRectZero];
        self.endView.alpha = 0.5;
        self.endView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.resumeOperaView addSubview:self.endView];
        [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.resumeOperaView.mas_bottom);
            make.height.equalTo(@(1));
            make.width.equalTo(self.mas_width);
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize moreImageSize = self.moreImageIcon.imageView.image.size;
    
    // 简历名称
    CGFloat nameX = 40 / 3.0;
    CGFloat nameY = 40 / 3.0;
    CGSize nameSize = [self.resumeNameLable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeNameFont]} context:nil].size;
    
    CGSize schoolSize = self.schoolImageIcon.image.size;
    if( !self.isSchool )
        schoolSize = CGSizeZero;
    
    CGSize topSize = self.topImageIcon.image.size;
    if( !self.isDefault )
        topSize = CGSizeZero;
    
    CGFloat maxMarge = kScreenWidth - 40 / 3.0 - moreImageSize.width * 2 / 3.0 - nameX - 4.0;
    
    if ( nameSize.width + schoolSize.width + topSize.width > maxMarge )
        nameSize.width = maxMarge - schoolSize.width * 2 / 3.0 - topSize.width;
    
    self.resumeNameLable.frame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    if(self.isSchool){
        self.schoolImageIcon.hidden = NO;
        self.schoolImageIcon.frame = CGRectMake(CGRectGetMaxX(self.resumeNameLable.frame) + 2.0, self.resumeNameLable.viewY - fabs(schoolSize.height * 2 / 3.0 - self.resumeNameLable.frame.size.height) / 2.0, schoolSize.width * 2 / 3.0, schoolSize.height * 2 / 3.0);
    }else{
        self.schoolImageIcon.frame = CGRectZero;
        self.schoolImageIcon.hidden = YES;
    }

    if(self.isDefault){
        self.topImageIcon.hidden = NO;
        if(self.isSchool){
            self.topImageIcon.frame = CGRectMake(CGRectGetMaxX(self.schoolImageIcon.frame) + 2.0, self.schoolImageIcon.frame.origin.y, topSize.width, topSize.height);
        }else{
            self.topImageIcon.frame = CGRectMake(CGRectGetMaxX(self.resumeNameLable.frame) + 2.0, self.resumeNameLable.viewY - fabs( topSize.height - self.resumeNameLable.frame.size.height ) / 2.0, topSize.width, topSize.height);
        }
    }else{
        self.topImageIcon.frame = CGRectZero;
        self.topImageIcon.hidden = YES;
    }
    
    // 简历状态
    CGFloat statueX = nameX;
    CGFloat statueY = CGRectGetMaxY(self.resumeNameLable.frame) + 32.0 / 3.0;
    CGSize statueSize = [self.canSend.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeStatueFont]} context:nil].size;
    self.canSend.frame = CGRectMake(statueX, statueY, statueSize.width, statueSize.height);
    
    // 简历信息
    CGFloat messageX = CGRectGetMaxX(self.canSend.frame) + 10.0;
    CGFloat messageY = statueY;
    CGSize messageSize = [self.reviewNumLable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeMessageFont] } context:nil].size;
    self.reviewNumLable.frame = CGRectMake(messageX, messageY, messageSize.width, messageSize.height);
    
    self.moreImageIcon.frame = CGRectMake( kScreenWidth - 40 / 3.0 - moreImageSize.width * 2 / 3.0, self.resumeNameLable.viewY + ( self.resumeNameLable.viewHeight - moreImageSize.height * 2 / 3.0 ) / 2.0, moreImageSize.width * 2 / 3.0, moreImageSize.height * 2 / 3.0 );
    
    self.moreButton.frame = CGRectMake(self.moreImageIcon.viewX, 0, self.viewWidth - self.moreImageIcon.viewX, self.viewHeight);
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.canSend.frame) + 15.0, self.viewWidth, 1.0);
    
    
    if (self.isShowMenu.intValue == 1) {
        self.resumeOperaView.hidden = NO;
        self.resumeOperaView.frame  = CGRectMake(0, CGRectGetMaxY(self.canSend.frame) + 15 + 1.0, self.viewWidth, 40);
    }else{
        self.resumeOperaView.hidden = YES;
        self.resumeOperaView.frame  = CGRectZero;
    }
    
}

+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [UIFont boldSystemFontOfSize:16]);
    return size.width;
}

+(int)computerSubTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [UIFont boldSystemFontOfSize:11]);
    return size.width;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
