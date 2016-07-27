//
//  CPCompanyDetailIntroduceView.h
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPWCompanyDetailButton.h"
@interface CPCompanyDetailIntroduceView : UIView
@property (nonatomic, strong) CPWCompanyDetailButton *lookMoreButton;
- (void)configWithDict:(NSDictionary *)companyDict;
@end
