//
//  OMGToast.m
//  ttsharing
//
//  Created by zql on 14-3-13.
//  Copyright (c) 2014年 zql. All rights reserved.
//

#import "OMGToast.h"
#import <QuartzCore/QuartzCore.h> 
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface OMGToast (private)

- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat) duration_;

- (void)dismisToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset_;
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;

@end

@implementation OMGToast

- (id)initWithText:(NSString *)text_{
    if (self = [super init]) {
        
        text = [text_ copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize textSize = CGSizeZero;
        textSize = [text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        
        duration = DEFAULT_DISPLAY_DURATION;
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];*/
        
       
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}

-(void)dismissToast{
    if (contentView)
    {
        [contentView removeFromSuperview];
    }
}

-(void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration_{
    duration = duration_;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    if (!contentView)
    {
        return;
    }
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat) top_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, top_ + contentView.frame.size.height/2);
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat) bottom_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom_ + contentView.frame.size.height/2));
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}


+ (void)showWithText:(NSString *)text_{
    [OMGToast showWithText:text_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
            duration:(CGFloat)duration_{
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast show];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_{
    [OMGToast showWithText:text_  topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
            duration:(CGFloat)duration_{
    NSString *tmp = [text_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tmp =[tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    tmp=[tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    OMGToast *toast = [[OMGToast alloc] initWithText:tmp];
    [toast setDuration:duration_];
    [toast showFromBottomOffset:topOffset_];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_{
    [OMGToast showWithText:text_  bottomOffset:bottomOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_
            duration:(CGFloat)duration_
{
    if ( CP_SYSTEM_VERSION >= 8.0 )
    {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:text_ preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtrl addAction:okAction];
        UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [vc presentViewController:alertCtrl animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:text_ delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alerView show];
    }
}
+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_
            duration:(CGFloat)duration_ setVeiwController:(UIViewController *)setViewController
{
    if ( CP_SYSTEM_VERSION >= 8.0 )
    {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:text_ preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtrl addAction:okAction];
        UIViewController *vc = setViewController;
        if ( !vc )
            vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [vc presentViewController:alertCtrl animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:text_ delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alerView show];
    }
}
@end
