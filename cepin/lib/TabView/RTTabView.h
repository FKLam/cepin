//
//  RTTabView.h
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTTabDelegate <NSObject>

-(void)RTTabDidPushIndex:(int)index;

@end

@class RTTabFlowLayout;
@class RTTabCollectionCell;
@class RTTabItem;

@interface RTTabView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)RTTabFlowLayout *layout;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *textHightedColor;
@property(nonatomic,strong)UIImage *imageBackground;
@property(nonatomic,strong)UIImage *imageHightedBackground;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,assign)NSUInteger currentIndex;
@property(nonatomic,copy)void(^selectedObject)(NSInteger index);
@property(nonatomic,weak)id<RTTabDelegate> tabDelegate;

@property (nonatomic, assign) BOOL customChange;

-(void)selectedWithIndex:(NSInteger)index;

-(void)reloadData;
@end


@interface RTTabFlowLayout : UICollectionViewFlowLayout

@end


@interface RTTabCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *labelTitle;
@property(nonatomic,strong)UIImageView *imageBackground;
@property(nonatomic,strong)UIView  *viewHasNew;
@end


@interface RTTabCollectionImageCell : RTTabCollectionCell
@property(nonatomic,strong)UIImageView *imageLogo;
@end


@interface RTTabItem : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIImage *imageNormal;
@property(nonatomic,strong)UIImage *imageHighted;
@end



