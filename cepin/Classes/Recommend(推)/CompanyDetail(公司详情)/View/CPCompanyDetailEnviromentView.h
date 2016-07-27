//
//  CPCompanyDetailEnviromentView.h
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPCompanyDetailEnviromentViewDelegate <NSObject>

@optional
- (void)checkEnviroment;

@end

@interface CPCompanyDetailEnviromentView : UIView

@property (nonatomic, weak) id<CPCompanyDetailEnviromentViewDelegate> detailEnviromentDelegate;

@end
