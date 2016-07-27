//
//  CPResumeEditExpectWorkReformer.m
//  cepin
//
//  Created by kun on 16/2/22.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditExpectWorkReformer.h"
#import "CPCommon.h"
@implementation CPResumeEditExpectWorkReformer
+ (CGFloat)selecteExpectWorkHeight:(NSMutableArray *)secData
{
    CGFloat totalHeight = 0;
    CGFloat margin = 20 / CP_GLOBALSCALE;
    CGFloat edge = 40 / CP_GLOBALSCALE;
    CGFloat panding = 32 / CP_GLOBALSCALE;
    CGFloat H = 90 / CP_GLOBALSCALE;
    int n = 0;
    float x = edge;
    float y = 60 / CP_GLOBALSCALE;
    for ( NSString *name in secData )
    {
        CGFloat tempW = [self caculateNameSize:name].width;
        if (x + tempW + edge + H + margin > kScreenWidth)
        {
            n = 0;
            x = edge;
            y += [self caculateNameSize:name].height + panding + edge;
        }
        
        {
            x += margin;
            x += tempW + H;
        }
        n++;
    }
    if ( 0 < n )
    {
        totalHeight += y + H + 60 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGSize)caculateNameSize:(NSString *)name
{
    CGSize tSize = [name respondsToSelector:@selector(sizeWithAttributes:)] ? [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]}] : [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    return tSize;
}
@end
