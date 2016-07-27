//
//  AOTag.m
//  AOTagDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AOTag.h"
#import "UIImageView+WebCache.h"
#import "CPCommon.h"
#define tagFontSize         ( 42 / CP_GLOBALSCALE )
#define tagFontType         @"Helvetica-Light"
#define tagMargin           ( 21 / CP_GLOBALSCALE )
#define tagHeight           ( 90 / CP_GLOBALSCALE )
#define tagCornerRadius     ( 10 / CP_GLOBALSCALE )
#define tagCloseButton      ( 27 / CP_GLOBALSCALE )

@interface AOTagList ()

@property (nonatomic, strong) NSNumber *tFontSize;
@property (nonatomic, strong) NSString *tFontName;
@property (nonatomic, assign) BOOL isExpectWork;
@end

@implementation AOTagList

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [NSMutableArray array];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [NSMutableArray array];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if ( !self.isExpectWork )
    {
        CGFloat margin = 20 / CP_GLOBALSCALE;
        CGFloat edge = 40 / CP_GLOBALSCALE;
        CGFloat panding = 32 / CP_GLOBALSCALE;
        CGFloat W = (kScreenWidth - margin * 2 - edge * 2) / 3.0;
        CGFloat H = 90 / CP_GLOBALSCALE;
        int n = 0;
        float x = edge;
        float y = 60 / CP_GLOBALSCALE;
        for (id v in [self subviews])
            if ([v isKindOfClass:[AOTag class]])
                [v removeFromSuperview];
        for (AOTag *tag in self.tags)
        {
            if (x + [tag getTagSize].width + margin > self.frame.size.width)
            {
                n = 0;
                x = edge;
                y += [tag getTagSize].height + panding;
            }
            else x += (n ? margin : 0.0f);
            [tag setFrame:CGRectMake(x, y, W, H)];
            [self addSubview:tag];
            x += W;
            
            n++;
        }
        CGRect r = [self frame];
        r.size.height = y + H;
        if (self.listHeightReflash) {
            self.listHeightReflash(r.size.height);
        }
        if ([self.delegate respondsToSelector:@selector(tagListReflashHeight:listView:)]) {
            [self.delegate tagListReflashHeight:r.size.height listView:self];
        }
        [self setFrame:r];
    }
    else if ( self.isExpectWork )
    {
        CGFloat margin = 20 / CP_GLOBALSCALE;
        CGFloat edge = 40 / CP_GLOBALSCALE;
        CGFloat panding = 32 / CP_GLOBALSCALE;
        CGFloat H = 90 / CP_GLOBALSCALE;
        int n = 0;
        float x = edge;
        float y = 60 / CP_GLOBALSCALE;
        for (id v in [self subviews])
            if ([v isKindOfClass:[AOTag class]])
                [v removeFromSuperview];
        for (AOTag *tag in self.tags)
        {
            CGFloat tempW = [tag getTagSize].width;
            if (x + tempW + edge > self.frame.size.width)
            {
                n = 0;
                x = edge;
                y += [tag getTagSize].height + panding + edge;
            }
            else
            {
                x += (n ? margin : 0.0f);
            }
            [tag setFrame:CGRectMake(x, y, tempW, H)];
            [self addSubview:tag];
            x += tempW;
            n++;
        }
        CGRect r = [self frame];
        r.size.height = y + H;
        if (self.listHeightReflash) {
            self.listHeightReflash(r.size.height);
        }
        if ([self.delegate respondsToSelector:@selector(tagListReflashHeight:listView:)]) {
            [self.delegate tagListReflashHeight:r.size.height listView:self];
        }
        [self setFrame:r];
    }
}

- (void)setTagFont:(NSString *)name withSize:(CGFloat)size
{
    [self setTFontSize:[NSNumber numberWithFloat:size]];
    [self setTFontName:name];
}

- (AOTag *)generateTagWithLabel:(NSString *)tTitle withImage:(NSString *)tImage
{
    AOTag *tag = [[AOTag alloc] initWithFrame:CGRectZero];
    
    [tag setTFontName:self.tFontName];
    [tag setTFontSize:self.tFontSize];
    
    [tag setDelegate:self.delegate];
    
    if ( tImage && [tImage length] > 0 )
        [tag setTImage:[UIImage imageNamed:tImage]];
    
    [tag setTTitle:tTitle];
    
    [self.tags addObject:tag];
    
    return tag;
}

- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle withImageURL:(NSURL *)imageURL andImagePlaceholder:(NSString *)tPlaceholderImage
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    [tag setTURL:imageURL];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
     withImage:(NSString *)tImage
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    tag.isExpectWork = self.isExpectWork;
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    tag.isHasImage = NO;
    [self setNeedsDisplay];
}
- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage withLabelColor:(UIColor *)labelColor withBackgroundColor:(UIColor *)backgroundColor withCloseButtonColor:(UIColor *)closeColor isExpectWork:(BOOL)isExpectWork
{
    _isExpectWork = isExpectWork;
    [self addTag:tTitle withImage:tImage withLabelColor:labelColor withBackgroundColor:backgroundColor withCloseButtonColor:closeColor];
}
- (void)addTagWithTitle:(NSString *)title labelColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:title withImage:@""];
    
    if (color) [tag setTLabelColor:color];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    tag.isHasImage = NO;
    tag.isHasCloseButton = YES;
    
    [self setNeedsDisplay];
}
- (void)addTagWithTitle:(NSString *)title labelColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor
{
    AOTag *tag = [self generateTagWithLabel:title withImage:@""];
    
    if (color) [tag setTLabelColor:color];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    tag.isHasImage = NO;
    tag.isHasCloseButton = NO;
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
withImagePlaceholder:(NSString *)tPlaceholderImage
  withImageURL:(NSURL *)imageURL
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    
    [tag setTURL:imageURL];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
}

- (void)addTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
        [self addTag:[tag objectForKey:@"title"] withImage:[tag objectForKey:@"image"]];
}

- (void)removeTag:(AOTag *)tag
{
    [self.tags removeObject:tag];
    
    [self setNeedsDisplay];
}

- (void)removeAllTag
{
    for (id t in [NSArray arrayWithArray:[self tags]])
        [self removeTag:t];
}

@end

@implementation AOTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:0.204 green:0.588 blue:0.855 alpha:1.000];
        self.tLabelColor = [UIColor whiteColor];
        self.tCloseButtonColor = [UIColor colorWithRed:0.710 green:0.867 blue:0.953 alpha:1.000];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
        
        self.tURL = nil;
        
        self.isHasImage = YES;
        self.isHasCloseButton = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}
- (CGSize)getTagSize
{
    CGFloat margin = 20 / CP_GLOBALSCALE;
    CGFloat edge = 40 / CP_GLOBALSCALE;
    CGFloat W = (kScreenWidth - margin * 2 - edge * 2) / 3.0;
    CGSize tSize = [self.tTitle respondsToSelector:@selector(sizeWithAttributes:)] ? [self.tTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]}] : [self.tTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]} context:nil].size;
    
    if (self.isHasImage && self.isHasCloseButton)
    {
        return CGSizeMake(tagHeight + tagMargin + tSize.width + tagMargin + tagCloseButton + tagMargin, tagHeight);
    }
    else if(self.isHasImage && self.isHasCloseButton == NO)
    {
        return CGSizeMake(tagHeight + tagMargin + tSize.width + tagMargin + tagMargin, tagHeight);
    }
    else if (self.isHasImage == NO && self.isHasCloseButton == YES)
    {
        if ( !self.isExpectWork )
            return tSize;
        return CGSizeMake(tSize.width + 90 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE, tSize.height);
    }
    return CGSizeMake(tagMargin + tSize.width + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat margin = 20 / CP_GLOBALSCALE;
    CGFloat edge = 40 / CP_GLOBALSCALE;
    CGFloat W = (kScreenWidth - margin * 2 - edge * 2) / 3.0;
    CGFloat H = 90 / CP_GLOBALSCALE;
    
    CGFloat titleW = [self getTagSize].width;
    CGFloat titleH = [self getTagSize].height;
    CGFloat titleMaxW = W - H;
    CGFloat titleX = (titleMaxW - titleW) / 2.0;
    CGFloat titleY = (H - titleH) / 2.0;
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    
    if (self.isHasImage) {
        self.tImageURL = [[UIImageView alloc] init];
        [self.tImageURL setBackgroundColor:[UIColor purpleColor]];
        [self.tImageURL setFrame:CGRectMake(0.0f, 0.0f, [self getTagSize].height, [self getTagSize].height)];
        if (self.tURL) [self.tImageURL sd_setImageWithURL:self.tURL placeholderImage:self.tImage];
        [self addSubview:self.tImageURL];
    }
    if ([self.tTitle respondsToSelector:@selector(drawAtPoint:withAttributes:)])
    {
        if (self.isHasImage && self.isHasCloseButton) {
            [self.tTitle drawInRect:CGRectMake(tagHeight + tagMargin, ([self getTagSize].height / 2.0f) - ([self getTagSize].height / 2.0f), [self getTagSize].width, [self getTagSize].height)
                     withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
        }else if(self.isHasImage == NO && self.isHasCloseButton == NO){
            
            [self.tTitle drawInRect:CGRectMake( tagMargin, tagMargin, [self getTagSize].width , [self getTagSize].height)
                     withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
        }
        else if (self.isHasImage == NO && self.isHasCloseButton == YES){
            if ( !self.isExpectWork )
                [self.tTitle drawInRect:CGRectMake( (self.viewWidth - [self getTagSize].width - H / 2.0) / 2.0, tagMargin, [self getTagSize].width, [self getTagSize].height)
                         withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
            else
                [self.tTitle drawInRect:CGRectMake( 20 / CP_GLOBALSCALE, tagMargin, [self getTagSize].width - 90 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE, [self getTagSize].height)
                         withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
        }
        
        
    }
    else
    {
        [self.tLabelColor set];
        if (self.isHasImage && self.isHasCloseButton) {
            
            [self.tTitle drawInRect:CGRectMake(tagHeight + tagMargin, ([self getTagSize].height / 2.0f) - ([self getTagSize].height / 2.0f), [self getTagSize].width, [self getTagSize].height)
                           withFont:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]] lineBreakMode:NSLineBreakByWordWrapping];
        }else if(self.isHasImage == NO && self.isHasCloseButton == NO){
            [self.tTitle drawInRect:CGRectMake( tagMargin, tagMargin, [self getTagSize].width, [self getTagSize].height)
                           withFont:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]] lineBreakMode:NSLineBreakByWordWrapping];
        }
        
    }
    if (self.isHasCloseButton) {
        AOTagCloseButton *close = [[AOTagCloseButton alloc] initWithFrame:CGRectMake(self.viewWidth - H, 0.0, H, H)
                                                                withColor:self.tCloseButtonColor];
        [self addSubview:close];
    }
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidAddTag:)])
        [self.delegate performSelector:@selector(tagDidAddTag:) withObject:self];
}
- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidSelectTag:)])
        [self.delegate performSelector:@selector(tagDidSelectTag:) withObject:self];
}

- (void)tagClose:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidRemoveTag:)])
        [self.delegate performSelector:@selector(tagDidRemoveTag:) withObject:self];
    
    [(AOTagList *)[self superview] removeTag:self];
}

@end

@implementation AOTagCloseButton

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setCColor:color];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [self.cColor setStroke];
    bezierPath.lineWidth = 2.0;
    [bezierPath stroke];
    
    UIBezierPath *bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [bezier2Path addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [self.cColor setStroke];
    bezier2Path.lineWidth = 2.0;
    [bezier2Path stroke];
    
    UIBezierPath *bezierVerPath = [UIBezierPath bezierPath];
    [bezierVerPath moveToPoint:CGPointMake(15 / CP_GLOBALSCALE, 15 / CP_GLOBALSCALE)];
    [bezierVerPath addLineToPoint:CGPointMake(15 / CP_GLOBALSCALE, (90 - 15) / CP_GLOBALSCALE)];
    [[UIColor colorWithHexString:@"ffffff"] setStroke];
    bezierVerPath.lineWidth = 1 / CP_GLOBALSCALE;
    [bezierVerPath stroke];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClose:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}
- (void)tagClose:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(tagClose:)])
        [[self superview] performSelector:@selector(tagClose:) withObject:self];
}
@end