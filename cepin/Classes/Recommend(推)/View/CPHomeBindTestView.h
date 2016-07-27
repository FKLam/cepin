//
//  CPHomeBindTestView.h
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeBindTestView;
@protocol CPHomeBindTestViewDelegate <NSObject>
@optional
- (void)homeBindTestView:(CPHomeBindTestView *)homeBindTestView isCanBind:(BOOL)isCanBind;
- (void)homeBindTestView:(CPHomeBindTestView *)homeBindTestView isCanTest:(BOOL)isCanTest;
@end
@interface CPHomeBindTestView : UIView
@property (nonatomic, weak) id <CPHomeBindTestViewDelegate> homeBindTestViewDelegate;
- (void)resetFrameWithUserData:(NSString *)IsHasEmailVerify examData:(NSDictionary *)examData;
@end
