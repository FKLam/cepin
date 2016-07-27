//
//  HttpUploadImage.h
//  cepin
//
//  Created by ceping on 14-12-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUploadImage : NSObject

+(void)uploadImage:(NSDictionary*)params success:(void (^)(id responseObject))success failure:(void (^)(id responseObject))failure;
+(void)uploadResumeImage:(NSDictionary*)params success:(void (^)(id responseObject))success failure:(void (^)(id responseObject))failure;
+(void)uploadResumeAttachmentFile:(NSDictionary*)params success:(void (^)(id responseObject))success failure:(void (^)(id responseObject))failure;

@end
