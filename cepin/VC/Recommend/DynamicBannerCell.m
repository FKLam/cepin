//
//  DynamicBannerCell.m
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "DynamicBannerCell.h"

@implementation DynamicBannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor blueColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageArray = [NSMutableArray new];
    }
    return self;
}

- (void)createScrollViewWith:(NSMutableArray*)imageDatas
{
    if ( !self.bannerView )
    {
        [self.imageArray removeAllObjects];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < imageDatas.count; i++) {
            BannerModel *model = [BannerModel beanFromDictionary:imageDatas[i]];
            UIImageView *imageview = [[UIImageView alloc] init];
            
            imageview.frame=CGRectMake(0, 0, self.viewWidth, 350 / 3.0);
            
            [imageview sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]
                      placeholderImage:[UIImage imageNamed:@"ad_loading_img"]];
            [self.imageArray addObject:imageview];
        }
        self.bannerView = [[BannerView alloc] initWithFrameRect:CGRectMake(0, 0, self.viewWidth, 350 / 3.0) ImageArray:self.imageArray];
        
        self.bannerView.delegate = self;
        [self addSubview:self.bannerView];
    }
}

- (void)EScrollerViewDidClicked:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didPushWith:)]) {
        [self.delegate didPushWith:index];
    }
}
+(int)computyHith:(UIImage *)image
{
    int height = image.size.height * kScreenWidth/image.size.width;
    
    return height;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
