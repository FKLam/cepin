//
//  CPPositionDetailDescribeLabel.h
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, VerticalAlignment)
{
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom
};
@interface CPPositionDetailDescribeLabel : UILabel
@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@end
