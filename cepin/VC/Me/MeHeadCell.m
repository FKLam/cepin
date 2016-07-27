//
//  MeHeadCell.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MeHeadCell.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
@implementation MeHeadCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int lefthight = 180.0 / CP_GLOBALSCALE;
        self.leftImage = [[UIImageView alloc] init];
        self.leftImage.layer.cornerRadius = lefthight / 2.0;
        self.leftImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftImage];
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont systemFontOfSize:48.0 / CP_GLOBALSCALE];
        self.title.textColor = [UIColor colorWithHexString:@"404040" alpha:1.0];
        [self.contentView addSubview:self.title];
        self.rightArrow = [[UIImageView alloc]init];
        self.rightArrow.image = [UIImage imageNamed:@"ic_next"];
        CGSize arrowSize = self.rightArrow.image.size;
        [self.contentView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@( arrowSize.width / CP_GLOBALSCALE));
            make.width.equalTo(@( arrowSize.width / CP_GLOBALSCALE ));
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.contentView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom ).offset( 0 );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ));
        }];
        //修改个人头像返回
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetHeadImage:) name:@"resetHeadImage" object:nil];
        
    }
    return self;
}
-(void)resetHeadImage:(NSNotification*)notify
{
    UIImage *image = [[notify userInfo] objectForKey:@"resetHeadImage"];
    self.leftImage.image = image;
}
-(void)setLabelTitleText:(UserInfoDTO *)userDTO
{
    NSString *strUserName = userDTO.RealName;
      if (!strUserName || [strUserName isKindOfClass:[NSNull class]] || [strUserName isEqualToString:@""])
        {
            NSString *mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            if ( !mobileString || 0 == [mobileString length] )
            {
                mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
            }
            if ( !mobileString || 0 == [mobileString length] )
            {
                self.title.text = @"请登录";
            }
            else
            {
                self.title.text = @"编辑姓名";
            }
//            if (![MemoryCacheData shareInstance].isLogin)
//            {
//                self.title.text = @"请登录";
//            }
//            else
//            {
//                self.title.text = @"编辑姓名";
//            }
        }
        else
        {
            self.title.text = strUserName;
        }
    if (userDTO.PhotoUrl)
    {
        [self.leftImage sd_setImageWithURL:[NSURL URLWithString:userDTO.PhotoUrl] placeholderImage:UIIMAGE(@"portrait_blue")];
    }
    else
    {
        self.leftImage.image = UIIMAGE(@"portrait_blue");
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftImage.frame = CGRectMake(40 / CP_GLOBALSCALE, (self.viewHeight - 186 / CP_GLOBALSCALE ) / 2.0, 186 / CP_GLOBALSCALE, 186 / CP_GLOBALSCALE);
    
    self.title.frame = CGRectMake(CGRectGetMaxX(self.leftImage.frame) + 40.0 / CP_GLOBALSCALE, 0, self.viewWidth - CGRectGetMaxX(self.leftImage.frame) - self.rightArrow.viewWidth - 40 / CP_GLOBALSCALE, self.viewHeight);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ( self.isHighlighted || self.isSelected )
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f0eef5" alpha:1.0];
        self.title.textColor = [UIColor colorWithHexString:@"288add" alpha:1.0];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.title.textColor = [UIColor colorWithHexString:@"404040" alpha:1.0];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setNeedsDisplay];
}
@end
