//
//  MeCell.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIImageView *rightArrow;
@property(nonatomic,strong)UILabel *reminderView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL separatorLineShowLong;

- (void)setLeftNormalImage:(NSString *)normal hightLightImage:(NSString *)hightLight;
@end
