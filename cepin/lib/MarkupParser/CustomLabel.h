//
//  customLabel.h
//  CoreTextMagazine
//
//  Created by zyq on 13-4-27.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CustomLabel : UILabel
{
    float frameXOffset;
    float frameYOffset;
    
    NSAttributedString *attString;
}
@property (retain,nonatomic) NSAttributedString *attString;
@property (nonatomic,copy) NSArray *images;
-(void)setAttString:(NSAttributedString *)attString images:(NSArray *)images;
@end
