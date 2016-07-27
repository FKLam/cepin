//
//  RTPictureHelper.h
//  yanyunew
//
//  Created by Ricky Tang on 14-5-23.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageViewWithImageSrc(_imageView_,_scr_) [RTPictureHelper imageWithImageView:_imageView_ scr:_scr_]

@interface RTPictureHelper : NSObject

+(void)imageWithImageView:(UIImageView *)imageView scr:(NSString *)scr;

+(void)saveImage:(NSString*)urlString name:(NSString*)imageName;

+(void)saveImageWithBlock:(NSString*)urlString name:(NSString*)imageName success:(void (^)(id responseObject))success
                  failure:(void (^)(id responseObject))failure;

+(void)LoadImage:(NSString*)urlString  success:(void (^)(id responseObject))success
         failure:(void (^)(id responseObject))failure;

+(BOOL)fileExists:(NSString*)fileName;

+(UIImage*)localfileFromFileName:(NSString*)fileName;

+(void)deleteImage:(NSString*)fileName;




@end

