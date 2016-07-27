//
//  RTTextView.h
//  cepin
//
//  Created by Ricky Tang on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
// 用于处理有占位字符串的UITextView

#import <UIKit/UIKit.h>

@interface RTTextView : UITextView
@property(nonatomic,strong)NSString *placeHolderString;
@property(nonatomic,strong)UIColor *placeHolderStringColor;
@property(nonatomic,strong)UIColor *mainTextColor;
-(void)setPlaceHolder;
@end
