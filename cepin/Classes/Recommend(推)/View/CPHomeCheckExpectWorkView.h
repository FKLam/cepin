//
//  CPHomeCheckExpectWorkView.h
//  cepin
//
//  Created by ceping on 16/2/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeCheckExpectWorkView;
@protocol CPHomeCheckExpectWorkViewDelegate <NSObject>
@optional
- (void)homeCheckExpectWorkView:(CPHomeCheckExpectWorkView *)homeCheckExpectWorkView isCheckExpectWork:(BOOL)isCheckExpectWork;
@end
@interface CPHomeCheckExpectWorkView : UIView
@property (nonatomic, weak) id <CPHomeCheckExpectWorkViewDelegate> homeCheckExpectWorkViewDelegate;
@end
