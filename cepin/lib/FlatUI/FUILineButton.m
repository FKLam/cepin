//
//  FUILineButton.m
//  yanyunew
//
//  Created by Ricky Tang on 14-5-22.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "FUILineButton.h"
#import "UIImage+FlatUI.h"

@implementation FUILineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setButtonBorderColor:(UIColor *)buttonBorderColor
{
    _buttonBorderColor = buttonBorderColor;
    [self configureFlatButton];
}

-(void)setButtonHighlightBorderColor:(UIColor *)buttonHighlightBorderColor
{
    _buttonHighlightBorderColor = buttonHighlightBorderColor;
    [self configureFlatButton];
}

-(void)setButtonBorderWidth:(CGFloat)buttonBorderWidth
{
    _buttonBorderWidth = buttonBorderWidth;
    [self configureFlatButton];
}

- (void) configureFlatButton {
    
    UIImage *normalBackgroundImage = [UIImage buttonImageWithColor:self.buttonColor borderColor:self.buttonBorderColor borderWidth:self.buttonBorderWidth cornerRadius:self.cornerRadius shadowColor:self.shadowColor shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)];
    
    UIImage *highlightedBackgroundImage = [UIImage buttonImageWithColor:self.buttonHighlightedColor borderColor:self.buttonHighlightBorderColor borderWidth:self.buttonBorderWidth cornerRadius:self.cornerRadius shadowColor:self.shadowColor shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)];
    
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateSelected];
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    CGFloat dashPattern[] = {1.0, 2};
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//   
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetLineDash(context, 0.0, dashPattern, 2);
//    
//    CGContextAddRect(context, self.bounds);
//    
//    CGContextStrokePath(context);
//    
//    CGContextClosePath(context);
    [self drawDashLine];
}

- (void)drawDashLine
{
    CGFloat cornerRadius = 6.0;
    CGFloat borderWidth = 1.0;
//    CGFloat dashPattern[] = {1.0, 2};
    UIColor *lineColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
    
    CGRect frame = self.bounds;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    shapeLayer.path = path;
    
    CGPathRelease(path);
    
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.frame = frame;
    shapeLayer.masksToBounds = NO;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}

@end
