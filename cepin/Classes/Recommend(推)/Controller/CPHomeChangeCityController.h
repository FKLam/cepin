//
//  CPHomeChangeCityController.h
//  cepin
//
//  Created by ceping on 16/1/13.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendVC.h"

@interface CPHomeChangeCityController : UIViewController
@property(nonatomic,assign) NSObject<ChangeCityListener> *cityDelegate;
@end
