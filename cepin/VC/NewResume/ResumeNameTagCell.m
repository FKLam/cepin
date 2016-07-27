//
//  ResumeNameTagCell.m
//  cepin
//
//  Created by dujincai on 15/7/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeNameTagCell.h"
#import "TBTextUnit.h"
@implementation ResumeNameTagCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        int hight = IS_IPHONE_5?21:25;
//        self.tagView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.viewWidth - 20, self.tagView.viewHeight - 20)];
//        [self addSubview:self.tagView];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
        [self addSubview:self.title];
        self.title.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.title.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.title.text = @"请输入标签";
        self.title.hidden = YES;
        
       self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth - 30 -hight, (self.viewHeight - hight)/2, hight, hight)];
        self.arrowImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:self.arrowImage];
    
        self.tagList = [[AOTagList alloc]initWithFrame:CGRectMake(10, 10, self.viewWidth - hight - 30, self.viewHeight)];
        [self addSubview:self.tagList];
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(hight));
        }];
      
    }
    return self;
}

- (void)layoutSubviews
{
//    self.tagList.frame = CGRectMake(10, 10 , self, <#CGFloat height#>)
}

+(int)computerTextWidth:(NSString*)str
{
    int hight = 40;
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
    
    if (tagArray.count == 1 || tagArray.count == 0) {
        return 40;
    }
    for (int i = 0; i < tagArray.count; i++){
       
        NSString *tagStr1 = tagArray[i];
      
        if (tagStr1.length > 10) {
            hight = hight + 40;
        }else
        {
            
            hight = hight + 9;
        }
    }
    
    return hight;
//    CGFloat size = StringFontSizeH(str, [[RTAPPUIHelper shareInstance]bigTitleFont], kScreenWidth - (IS_IPHONE_5?21:25) - 30);
//    return size;
}

- (void)createTagWith:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        self.title.hidden = NO;
    }else
    {
        self.title.hidden = YES;
        NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
        [self.tagList removeAllTag];
        for (int i = 0; i < tagArray.count; i++){
            
            [self.tagList addTagWithTitle:tagArray[i] labelColor:[UIColor whiteColor] backgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen]];
        }
        [tagArray removeAllObjects];
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
