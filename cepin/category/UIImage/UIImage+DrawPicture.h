//
//  UIImage+DrawPicture.h
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    RTDrawSlideTypeLeft,
    RTDrawSlideTypeRight,
    RTDrawSlideTypeTop,
    RTDrawSlideTypeBottom
    
}RTDrawSlideType;

@interface UIImage (DrawPicture)
//-(UIImage *)drawImageWithSlideType:(RTDrawSlideType)type rect:(CGSize)size lineColor:(UIColor *)color fillColor:(UIColor *)color;
@end
