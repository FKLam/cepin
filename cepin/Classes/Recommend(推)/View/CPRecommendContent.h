//
//  CPRecommendContent.h
//  cepin
//
//  Created by ceping on 15/11/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRecommendContent : UIView

@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, strong) UIColor *contentTextColor;
@property (nonatomic, strong) UIFont *contentTextFont;
@property (nonatomic, assign) NSInteger lineSpace;
@property (nonatomic, assign) NSTextAlignment contentTextAlignment;

- (void)debugDraw;
- (void)clear;
- (BOOL)touchPoint:(CGPoint)point;

@end
