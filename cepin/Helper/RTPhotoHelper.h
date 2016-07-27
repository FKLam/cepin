//
//  RTImageHelper.h
//  yanyunew
//
//  Created by Ricky Tang on 14-5-16.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface RTPhotoHelper : NSObject
+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
@end
