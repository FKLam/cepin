//
//  CPPositionDetaildelivery.h
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class CPPositionDetaildelivery;
@protocol CPPositionDetaildeliveryDelegate <NSObject>
@optional
- (void)positionDetailDeliveryView:(CPPositionDetaildelivery *)positionDetailDeliveryView selectedResume:(ResumeNameModel *)selectedResume;
- (void)positionDetailDeliveryViewTouchFreeArea;
@end
@interface CPPositionDetaildelivery : UIView
@property (nonatomic, weak) id<CPPositionDetaildeliveryDelegate>positionDetailDeliveryViewDelegate;
- (void)configWithArray:(NSArray *)resumeArray;
@end
