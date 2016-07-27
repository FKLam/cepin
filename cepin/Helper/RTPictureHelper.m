//
//  RTPictureHelper.m
//  yanyunew
//
//  Created by Ricky Tang on 14-5-23.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTPictureHelper.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageWithColor.h"
#import "SDWebImageManager.h"

static NSURL * ImageUrl(NSString *scr)
{
    return [NSURL URLWithString:scr];
}

@implementation RTPictureHelper

+(void)imageWithImageView:(UIImageView *)imageView scr:(NSString *)scr
{
    NSURL *url = ImageUrl(scr);
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hssd_local_image"]];
}

+(BOOL)fileExists:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    //先查找本地是否有
    if ([[NSFileManager defaultManager]fileExistsAtPath:uniquePath])
    {
        return YES;
    }
    return NO;
}

+(void)saveImage:(NSString*)urlString name:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSURL *url = [NSURL URLWithString:urlString];
                       NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                       UIImage *image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               //存储图片
                               [UIImagePNGRepresentation(image)writeToFile: uniquePath atomically:YES];
                           }
                       });
                   });
}

+(UIImage*)localfileFromFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:uniquePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        return [UIImage imageWithData:data];
    }
    return nil;
}

+(void)saveImageWithBlock:(NSString*)urlString name:(NSString*)imageName success:(void (^)(id responseObject))success
                  failure:(void (^)(id responseObject))failure
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSURL *url = [NSURL URLWithString:urlString];
                       NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                       UIImage *image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               //存储图片
                               [UIImagePNGRepresentation(image)writeToFile: uniquePath atomically:YES];
                               success(image);
                           }
                           else
                           {
                               failure(nil);
                           }
                       });
                   });
}

+(void)LoadImage:(NSString*)urlString  success:(void (^)(id responseObject))success
         failure:(void (^)(id responseObject))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSURL *url = [NSURL URLWithString:urlString];
                       NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                       UIImage *image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               success(image);
                           }
                           else
                           {
                               failure(nil);
                           }
                       });
                   });
}

+(void)deleteImage:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:uniquePath])
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:uniquePath error:&error];
    }
}


@end



