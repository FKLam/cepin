//
//  CPHomeCompanyDetailController.h
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchModel.h"
@interface CPWPositionShareButton : UIButton
@end
@interface CPHomePositionDetailController : UIViewController
- (void)configWithPosition:(JobSearchModel *)position;
- (void)configWithPositionId:(NSString *)positionId;
@end
