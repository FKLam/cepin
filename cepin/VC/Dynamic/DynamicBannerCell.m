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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageArray = [NSMutableArray new];
    }
    return self;
}

- (void)createScrollViewWith:(NSMutableArray*)imageDatas
{
    [self.imageArray removeAllObjects];
    for (int i = 0; i < imageDatas.count; i++) {
        BannerModel *model = [BannerModel beanFromDictionary:imageDatas[i]];
        [self.imageArray addObject:model.ImgUrl];
    }
 
    self.scrollView = [[EScrollerView alloc]initWithFrameRect:CGRectMake(0, 0, self.viewWidth, self.viewHeight) ImageArray:self.imageArray TitleArray:nil];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
}

- (void)EScrollerViewDidClicked:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didPushWith:)]) {
        [self.delegate didPushWith:index];
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
