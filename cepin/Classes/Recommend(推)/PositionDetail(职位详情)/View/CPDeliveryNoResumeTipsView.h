//
//  CPDeliveryNoResumeTipsView.h
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPDeliveryNoResumeTipsView;
@protocol CPDeliveryNoResumeTipsViewDelegate <NSObject>
@optional
- (void)deliveryNoResumeTipsView:(CPDeliveryNoResumeTipsView *)deliveryNoResumeTipsView clickedCancleButton:(UIButton *)cancleButon;
- (void)deliveryNoResumeTipsView:(CPDeliveryNoResumeTipsView *)deliveryNoResumeTipsView clickedSureButton:(UIButton *)sureButon;
@end
@interface CPDeliveryNoResumeTipsView : UIView
@property (nonatomic, weak) id<CPDeliveryNoResumeTipsViewDelegate>deliveryNoResumeTipsViewDelegate;
+ (instancetype)tipsViewWithButtonTitles:(NSArray *)buttonTitles showMessageVC:(UIViewController *)showMessageVC message:(NSString *)message;
@end
