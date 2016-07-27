//
//  CPTipsView.h
//  cepin
//
//  Created by ceping on 16/3/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPTipsView;
@protocol CPTipsViewDelegate <NSObject>
@optional
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton;
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton;
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier;
@end
@interface CPTipsView : UIView
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, weak) id<CPTipsViewDelegate> tipsViewDelegate;
+ (instancetype)tipsViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles showMessageVC:(UIViewController *)showMessageVC message:(NSString *)message;
+ (instancetype)tipsViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles showMessageRect:(CGRect)showMessageRect message:(NSString *)message;
@end
