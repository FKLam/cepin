//
//  CircleView.h
//  cepin
//
//  Created by ceping on 15-2-11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CircleTypeDefualt = 0,
    CircleTypeChecked,
}CircleViewType;

@interface CircleView : UIView

@property(nonatomic,assign)CircleViewType type;

-(void)setType:(CircleViewType)type;

@end
