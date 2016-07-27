#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)screenshot
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[[UIColor clearColor] setFill];
	[[UIBezierPath bezierPathWithRect:self.bounds] fill];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[self.layer renderInContext:ctx];
	UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return anImage;
}

-(UIImage *)flipScreenShotWith:(UIImageOrientation)orientation
{
    UIImage *imageTemp = [self screenshot];
    
    UIImage *image = [UIImage imageWithCGImage:imageTemp.CGImage scale:1 orientation:orientation];
    return image;
}

@end
