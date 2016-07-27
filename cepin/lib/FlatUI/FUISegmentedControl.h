//
//  FUISegmentedControl.h
//  FlatUIKitExample
//
//  Created by Alex Medearis on 5/17/13.
//
//

#import <UIKit/UIKit.h>

@interface FUISegmentedControl : UISegmentedControl

@property(nonatomic, retain) UIColor *selectedColor;
@property(nonatomic, retain) UIColor *deselectedColor;
@property(nonatomic, retain) UIColor *dividerColor;
@property(nonatomic, readwrite) CGFloat cornerRadius;
@property(nonatomic, retain) UIFont *selectedFont;
@property(nonatomic, retain) UIFont *deselectedFont;
@property(nonatomic, retain) UIColor *selectedFontColor;
@property(nonatomic, retain) UIColor *deselectedFontColor;



@end
