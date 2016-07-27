//
//  CPHomeRegisterView.h
//  cepin
//
//  Created by ceping on 16/1/13.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeRegisterView;
@protocol CPHomeRegisterViewDelegate <NSObject>
@optional
- (void)homeRegisterView:(CPHomeRegisterView *)homeRegisterView isCanRegister:(BOOL)isCanRegister;
@end
@interface CPHomeRegisterView : UIView
@property (nonatomic, weak) id <CPHomeRegisterViewDelegate> homeRegisterViewDelegate;
@end
