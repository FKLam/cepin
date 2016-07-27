
//
//  UIView+Frame.h
//  yanyu
//
//  Created by rickytang on 13-9-12.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property(nonatomic,readwrite)CGFloat viewX;
@property(nonatomic,readwrite)CGFloat viewY;
@property(nonatomic,readwrite)CGPoint viewPoint;
@property(nonatomic,readwrite)CGFloat viewWidth;
@property(nonatomic,readwrite)CGFloat viewHeight;
@property(nonatomic,readwrite)CGSize viewSize;
@property(nonatomic,readwrite)CGFloat viewCenterX;
@property(nonatomic,readwrite)CGFloat viewCenterY;
@end
