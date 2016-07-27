//
//  MarkupParser.h
//  CoreTextMagazine
//
//  Created by zyq on 13-4-25.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface MarkupParser : NSObject
{
    NSString *font;
    UIColor  *color;
    UIColor  *strokeColor;
    float    strokeWidth;
    
    NSMutableArray *images;
}
@property (retain,nonatomic) NSString *font;
@property (assign,nonatomic) CGFloat fontSize;
@property (retain,nonatomic) UIFont *fontF;
@property (retain,nonatomic) UIColor  *color;
@property (retain,nonatomic) UIColor  *strokeColor;
@property (assign,nonatomic) float    strokeWidth;
@property (assign,nonatomic) NSTextAlignment textAlignment;
@property (assign,nonatomic) NSLineBreakMode lineBreakMode;
@property (assign,nonatomic) float lineSpace;

@property (retain,nonatomic) NSMutableArray *images;//未用到。

-(NSAttributedString *)attrStringFromMarkup:(NSString *)markup;
@end
