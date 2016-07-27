//
//  CPSearchMoreFilterView.h
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchVM.h"
#import "JobSearchResultVC.h"

@interface CPSearchMoreFilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame modle:(JobSearchVM *)model;
@property(nonatomic,weak) id<filterChangeDeleger> filterChangeDeleger;
- (void)resetView;

@end
