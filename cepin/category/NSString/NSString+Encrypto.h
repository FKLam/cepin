//
//  NSString+Encrypto.h
//  yanyunew
//
//  Created by Ricky Tang on 14-6-21.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypto)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;
@end
