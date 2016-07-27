//
//  NSString+Encrypto.m
//  yanyunew
//
//  Created by Ricky Tang on 14-6-21.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "NSString+Encrypto.h"
#import "CommonCrypto/CommonDigest.h"   
#import "RTBase64.h"


@implementation NSString (Encrypto)
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *) sha1_base64
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [RTBase64 encodeData:base64];
//    base64 = [base64 base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) md5_base64
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [RTBase64 encodeData:base64];
//    base64 = [base64 base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) base64
{
    NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    data = [RTBase64 encodeData:data];
//    data = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}
@end
