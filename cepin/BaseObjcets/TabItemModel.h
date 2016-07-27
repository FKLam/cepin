//
//  TabItemModel.h
//  letsgo
//
//  Created by Ricky Tang on 14-8-13.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabItemModel : NSObject
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *titleColor;
@end
