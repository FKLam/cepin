//
//  CustemLineLable.h
//  cepin
//
//  Created by peng on 14-11-11.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustemLineLable : UILabel

typedef enum{
    LineTypeNone,//没有画线
    LineTypeUp ,// 上边画线
    LineTypeMiddle,//中间画线
    LineTypeDown,//下边画线
} LineType ;


@property (assign, nonatomic) LineType lineType;
@property (assign, nonatomic) UIColor * lineColor;

@end
