//
//  CPPositionDetailTopView.h
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobDetailModelDTO.h"
@interface CPWXinsanbanButton : UIButton
@end
@protocol CPPositionDetailTopViewDelegate <NSObject>
@optional
- (void)checkCompanyDetail;
- (void)clickedXinsanbanButton;
@end

@interface CPPositionDetailTopView : UIView
- (void)configWithPosition:(NSDictionary *)position;
- (CGFloat)companyWelfareHeightWithWalfearData:(NSArray *)companyData;
@property (nonatomic, weak) id<CPPositionDetailTopViewDelegate> positonDetailDelegate;

@end
