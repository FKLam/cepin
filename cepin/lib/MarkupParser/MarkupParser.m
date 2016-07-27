//
//  MarkupParser.m
//  CoreTextMagazine
//
//  Created by zyq on 13-4-25.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import "MarkupParser.h"
#import "UIColor+Hex.h"

/*callbacks*/
static void deallocCallback(void *ref)
{
    [(id)ref release];
}
static CGFloat ascentCallback(void *ref)
{
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"]floatValue];
}
static CGFloat descentCallback(void *ref)
{
    return [(NSString *)[(NSDictionary *)ref objectForKey:@"descent"]floatValue];
}
static CGFloat widthCallback(void *ref)
{
    return [(NSString *)[(NSDictionary*)ref objectForKey:@"width"]floatValue];
}

@implementation MarkupParser
@synthesize font,color,strokeColor,strokeWidth;
@synthesize images;

- (id)init
{
    self = [super init];
    if (self) {
        self.fontF = [UIFont systemFontOfSize:14];
        self.font = self.fontF.fontName;
        self.fontSize = self.fontF.pointSize;
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.textAlignment = NSTextAlignmentLeft;
        self.images = [NSMutableArray array];
        self.lineSpace = 1;
    }
    return self;
}


-(void)setFontF:(UIFont *)value
{
    _fontF = value;
    self.font = self.fontF.fontName;
    self.fontSize = self.fontF.pointSize;
}

-(NSAttributedString *)attrStringFromMarkup:(NSString *)markup
{
    [self.images removeAllObjects];
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:@""];//1
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:@"(.*?)(<[^>]+>|\\z)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];//2
    NSArray *chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, [markup length])];
    [regex release];
    
    NSMutableParagraphStyle *paragraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    paragraph.alignment = self.textAlignment;//设置对齐方式
    paragraph.lineBreakMode = self.lineBreakMode;
    
    
    
    for (NSTextCheckingResult *b in chunks) {
        NSArray *parts = [[markup substringWithRange:b.range] componentsSeparatedByString:@"<"];//1
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font, self.fontSize, NULL);
        //apply the current text style //2
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)self.color.CGColor,kCTForegroundColorAttributeName,(id)fontRef,kCTFontAttributeName,(id)self.strokeColor.CGColor,(NSString *)kCTStrokeColorAttributeName,(id)[NSNumber numberWithFloat:self.strokeWidth],(NSString *)kCTStrokeWidthAttributeName,(id)paragraph,kCTParagraphStyleAttributeName, nil];
        
        [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        
        CFRelease(fontRef);
        
        //handle new formatting tag //3
        if ([parts count] > 1) {
            NSString *tag = (NSString *)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
                NSRegularExpression *scolorRegex = [[[NSRegularExpression alloc]initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL]autorelease];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    if ([[tag substringWithRange:result.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    }else
                    {
                        self.strokeWidth = -3.0f;
//                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color",[tag substringWithRange:result.range]]);
//                        self.strokeColor = [UIColor performSelector:colorSel];
                        self.strokeColor = [UIColor colorWithHexString:[tag substringWithRange:result.range]];
                    }
                }];
                
                //color
                NSRegularExpression *colorRegex = [[[NSRegularExpression alloc]initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL]autorelease];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color",[tag substringWithRange:result.range]]);
//                    self.color = [UIColor performSelector:colorSel];
                    self.color = [UIColor colorWithHexString:[tag substringWithRange:result.range]];
                }];
                
                //face
                NSRegularExpression *faceRegex = [[[NSRegularExpression alloc]initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL]autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.font = [tag substringWithRange:result.range];
                }];
                
                //size
                NSRegularExpression *sizeRegex = [[[NSRegularExpression alloc]initWithPattern:@"(?<=size=\")[^\"]+" options:0 error:NULL]autorelease];
                [sizeRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.fontSize = [[tag substringWithRange:result.range] floatValue];
                }];
            }//end of font parsing
            
            if ([tag hasPrefix:@"img"]) {
                __block NSNumber *width = [NSNumber numberWithInt:0];
                __block NSNumber *height = [NSNumber numberWithInt:0];
                __block NSString *fileName = @"";
                __block NSNumber *offsetX = [NSNumber numberWithFloat:0];
                __block NSNumber *offsetY = [NSNumber numberWithFloat:0];
                
                //width
                NSRegularExpression *widthRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL]autorelease];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    width = [NSNumber numberWithInt:[[tag substringWithRange:result.range] intValue]];
                }];
                
                //height
                NSRegularExpression *faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL]autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    height = [NSNumber numberWithInt:[[tag substringWithRange:result.range]intValue]];
                }];
                
                
                //offestX
                NSRegularExpression *xRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=offsetX=\")[^\"]+" options:0 error:NULL]autorelease];
                [xRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    offsetX = [NSNumber numberWithInt:[[tag substringWithRange:result.range]intValue]];
                }];
                
                //offsetY
                NSRegularExpression *yRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=offsetY=\")[^\"]+" options:0 error:NULL]autorelease];
                [yRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    offsetY = [NSNumber numberWithInt:[[tag substringWithRange:result.range]intValue]];
                }];
                
                //image
                NSRegularExpression *srcRegex = [[[NSRegularExpression alloc]initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL]autorelease];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    fileName = [tag substringWithRange:result.range];
                }];
                
                //add the image for drawing
                [self.images addObject:[NSDictionary dictionaryWithObjectsAndKeys:width,@"width",height,@"height",offsetX,@"offsetX",offsetY,@"offsetY",fileName,@"fileName",[NSNumber numberWithUnsignedInteger:[aString length]],@"location", nil]];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary *imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys:width,@"width",height,@"height", nil]retain];
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr);
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:(id)delegate,(NSString*)kCTRunDelegateAttributeName, nil];
                
                [aString appendAttributedString:[[[NSAttributedString alloc]initWithString:@" " attributes:attrDictionaryDelegate] autorelease]];
            }
        }
    }
    
    return (NSAttributedString*)aString;
}

-(void)dealloc
{
    self.font=nil;
    self.color=nil;
    self.strokeColor=nil;
    self.images=nil;
    
    [super dealloc];
}
@end
