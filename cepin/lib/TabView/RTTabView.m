//
//  RTTabView.m
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTTabView.h"
@implementation RTTabView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}
-(void)_init
{
    RTTabFlowLayout *layout = [RTTabFlowLayout new];
    self.layout = layout;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView registerClass:[RTTabCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([RTTabCollectionCell class])];
    [self.collectionView registerClass:[RTTabCollectionImageCell class] forCellWithReuseIdentifier:NSStringFromClass([RTTabCollectionImageCell class])];
    self.collectionView.backgroundColor = [[RTAPPUIHelper shareInstance] darkGrayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
}
-(void)selectedWithIndex:(NSInteger)index
{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}
-(void)reloadData
{
    [self.collectionView reloadData];
}
#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath.row;
    if (self.selectedObject) {
        self.selectedObject(indexPath.row);
    }
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(RTTabDidPushIndex:)])
    {
        [self.tabDelegate RTTabDidPushIndex:(int)indexPath.row];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _customChange )
    {
        CGFloat scale = 270 / 150.0;
        CGFloat width = collectionView.frame.size.width / self.titles.count;
        CGFloat height = width / scale;
        CGFloat tempHeight = collectionView.frame.size.height - height;
        if ( 0 < tempHeight )
        {
            [self.layout setSectionInset:UIEdgeInsetsMake(tempHeight / 2.0, 0, 0, 0)];
        }
        return CGSizeMake( width, height );
    }
    return CGSizeMake(collectionView.frame.size.width / self.titles.count, collectionView.frame.size.height);
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id temp = self.titles[indexPath.row];
    RTTabCollectionCell *cell = nil;
    if ([temp isKindOfClass:[NSString class]])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RTTabCollectionCell class]) forIndexPath:indexPath];
        cell.labelTitle.text = (NSString *)temp;
    }
    else if([temp isKindOfClass:[RTTabItem class]])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RTTabCollectionImageCell class]) forIndexPath:indexPath];
        RTTabCollectionImageCell *item = (RTTabCollectionImageCell *)cell;
        RTTabItem *i = (RTTabItem *)temp;
        item.labelTitle.text = i.title;
        item.imageLogo.image = i.imageNormal;
        item.imageLogo.highlightedImage = i.imageHighted;
    }
    cell.labelTitle.textColor = self.textColor;
    cell.labelTitle.highlightedTextColor = self.textHightedColor;
    cell.labelTitle.font = self.font;
    cell.imageBackground.image = self.imageBackground;
    cell.imageBackground.highlightedImage = self.imageHightedBackground;
    return cell;
}
@end
@implementation RTTabFlowLayout
-(instancetype)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}
@end
@implementation RTTabCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageBackground.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageBackground];
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        [self.imageBackground mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, -.4, 0, 0));
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
@implementation RTTabCollectionImageCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageBackground.backgroundColor = [[RTAPPUIHelper shareInstance] darkGrayColor];
        [self.contentView addSubview:self.imageBackground];
        self.imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageLogo.backgroundColor = [[RTAPPUIHelper shareInstance] darkGrayColor];
        [self.contentView addSubview:self.imageLogo];
        [self.imageBackground mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, -.4, 0, 0));
        }];
        [self.imageLogo mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.centerX.equalTo(self.contentView.mas_centerX);
            maker.centerY.equalTo(self.contentView.mas_centerY);
            maker.width.equalTo(self.mas_width);
            maker.height.equalTo(self.mas_height);
        }];
    }
    return self;
}
@end
@implementation RTTabItem

@end