//
//  FileManagerHelper.m
//  
//
//  Created by 嘉宾 唐 on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileManagerHelper.h"


@implementation FileManagerHelper

+(NSString *)selectedFolderPathWith:(kUseDocumentType)type
{
    NSString *retureStr = nil;

    switch (type) {
        case kUseDocumentTypeDocuments:
            retureStr = kAPP_DOCUMENT_PATH;
            break;
        case kUseDocumentTypeTemp:
            retureStr = kAPP_TEMP_PATH;
            break;
        case kUseDocumentTypeLibrary:
            retureStr = kAPP_LIBRARY_PATH;
            break;
        case kUseDocumentTypeLibraryCaches:
            retureStr = kAPP_LIBRARY_CACHES_PATH;
            break;
        case kUseDocumentTypeBundle:
            retureStr = [[NSBundle mainBundle] resourcePath];
            break;
        default:
            break;
    }
    
    return retureStr;
}

+(BOOL)isHasFolderInDocumentWithName:(NSString *)name andSandBoxFolder:(kUseDocumentType)type
{
    BOOL isHasFolder = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *folderPath = [documentPath stringByAppendingPathComponent:name];
    if ([fileManager fileExistsAtPath:folderPath]) {
        isHasFolder = YES;
    }
    return isHasFolder;
}

+(BOOL)createFolderInDocumentWithFoldName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type
{
    if (![FileManagerHelper isHasFolderInDocumentWithName:folderName andSandBoxFolder:type]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
        NSString *folderPath = [documentPath stringByAppendingPathComponent:folderName];
        NSError *err;
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (!err) {
            return YES;
        }
        else {
            return NO;
            RTLog(@"file manager helper create err %@",[err description]);
        }
    }
    return NO;
}

+(BOOL)isHasFileInDocumentWithFolderName:(NSString *)name andFileName:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type
{
    NSString *path = [name stringByAppendingPathComponent:fileName];
    if ([FileManagerHelper isHasFolderInDocumentWithName:path andSandBoxFolder:type]) {
        return YES;
    }
    return NO;
}

+(NSString *)getFilePathFromDocumentWithFileName:(NSString *)name andSandBoxFolder:(kUseDocumentType)type
{
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *path = [documentPath stringByAppendingPathComponent:name];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    return path;
}

+(BOOL)moveFileFromPath:(NSString *)filePath toDocumentWithFileName:(NSString *)fileName andFolderName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type
{
    NSString *path;
    BOOL isSuccess;
    if ([FileManagerHelper isHasFileInDocumentWithFolderName:folderName andFileName:fileName andSandBoxFolder:type]) {
        return NO;
    }
    if (folderName != nil){
        [FileManagerHelper createFolderInDocumentWithFoldName:folderName andSandBoxFolder:type];
        path = [[FileManagerHelper selectedFolderPathWith:type] stringByAppendingPathComponent:folderName];
        path = [path stringByAppendingPathComponent:fileName];
    }
    else {
        path = [[FileManagerHelper selectedFolderPathWith:type] stringByAppendingPathComponent:fileName];
    }
    isSuccess = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:path error:nil];
    return isSuccess;
}

+(NSArray *)getFilesOfFolderInDocumentWithFolderName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filesArr;
    if ([FileManagerHelper isHasFolderInDocumentWithName:folderName andSandBoxFolder:type]) {
        NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
        NSString *folderPath = [documentPath stringByAppendingPathComponent:folderName];
        NSError *err;
        filesArr = [fileManager contentsOfDirectoryAtPath:folderPath error:&err];
        if (err) {
            return nil;
            RTLog(@"get files in document err %@",[err description]);
        }
        else {
            return filesArr;
        }
    }
    return nil;
}

+(BOOL)writeData:(id)data withFile:(NSString *)fileName andFolder:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type
{
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *filePath;
    
    if (!data || !fileName) {
        return NO;
    }
    
    if (folderName != nil) {
        [FileManagerHelper createFolderInDocumentWithFoldName:folderName andSandBoxFolder:type];
        NSString *folderPath = [documentPath stringByAppendingPathComponent:folderName];
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
    else {
        filePath = [documentPath stringByAppendingPathComponent:fileName];
    }
    
    //NSError *error;
    //BOOL isYes = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    BOOL isYes = [data writeToFile:filePath atomically:YES];
    return isYes;
}

+(id)readDataWithFolder:(NSString *)folderName andFile:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type
{
    if (fileName == nil || [fileName isEqualToString:@""]) {
        return nil;
    }
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *filePath;
    if ([FileManagerHelper isHasFileInDocumentWithFolderName:folderName andFileName:fileName andSandBoxFolder:type]) {
        if (folderName != nil && [folderName isEqualToString:@""]) {
            filePath = [[documentPath stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
            return [NSData dataWithContentsOfFile:filePath];
            //return [[NSFileManager defaultManager] contentsAtPath:filePath];
        }
        else {
            filePath = [documentPath stringByAppendingPathComponent:fileName];
            return [NSData dataWithContentsOfFile:filePath];
//            return [[NSFileManager defaultManager] contentsAtPath:fileName];
        }
    }
    return nil;
}

+(BOOL)writeObject:(id)object file:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type
{
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *filePath;
    
    if (!object || !fileName) {
        return NO;
    }
    if (folderName != nil) {
        [FileManagerHelper createFolderInDocumentWithFoldName:folderName andSandBoxFolder:type];
        NSString *folderPath = [documentPath stringByAppendingPathComponent:folderName];
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
    else {
        filePath = [documentPath stringByAppendingPathComponent:fileName];
    }
    
    BOOL sucess = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    return sucess;
}

+(id)readObjectWithfile:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type
{
    if (fileName == nil || [fileName isEqualToString:@""]) {
        return nil;
    }
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *filePath;
    if ([FileManagerHelper isHasFileInDocumentWithFolderName:folderName andFileName:fileName andSandBoxFolder:type]) {
        if (folderName != nil && ![folderName isEqualToString:@""]) {
            filePath = [[documentPath stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
        }
        else {
            filePath = [documentPath stringByAppendingPathComponent:fileName];
        }
        RTLog(@"fileName %@",filePath);
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        return object;
    }
    return nil;
}


+(BOOL)deleteObjectWithFile:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type
{
    if (fileName == nil || [fileName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    NSString *filePath;
    if ([FileManagerHelper isHasFileInDocumentWithFolderName:folderName andFileName:fileName andSandBoxFolder:type]) {
        if (folderName != nil && ![folderName isEqualToString:@""]) {
            filePath = [[documentPath stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
        }
        else {
            filePath = [documentPath stringByAppendingPathComponent:fileName];
        }
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+(NSData *)objectChangeToData:(id)aData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aData];
    return data;
}

+(id)dataChangeToObject:(NSData *)aData
{
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    return object;
}

+(BOOL)writePlistData:(NSArray*)data withFile:(NSString *)fileName andFolder:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type
{
    if (!data || !fileName) {
        return NO;
    }
    NSData  *storeData = [NSKeyedArchiver archivedDataWithRootObject:data];
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];

    if (folderName)
    {
        [FileManagerHelper createFolderInDocumentWithFoldName:folderName andSandBoxFolder:type];
        documentPath = [[documentPath stringByAppendingPathComponent:folderName]stringByAppendingPathComponent:fileName];
    }
    else
    {
        documentPath = [documentPath stringByAppendingPathComponent:fileName];
    }
    
    /*NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:documentPath])
    {
        NSError *error = nil;
        [manager removeItemAtPath:documentPath error:&error];
        if (error)
        {
            return NO;
        }
    }*/
    
    NSError *error;
    BOOL isYes = [storeData writeToFile:documentPath options:NSDataWritingAtomic error:&error];
    RTLog(@"plist file store error : %@",error);
    
    //[storeData writeToFile:documentPath atomically:YES];
    return isYes;
}

+(NSMutableArray*)readPlistDataWithFolder:(NSString *)folderName andFile:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type
{
    if (fileName == nil || [fileName isEqualToString:@""]) {
        return nil;
    }
    
    NSString *documentPath = [FileManagerHelper selectedFolderPathWith:type];
    
    if (!folderName || [folderName isEqualToString:@""])
    {
        documentPath = [documentPath stringByAppendingPathComponent:fileName];
    }
    else
    {
        documentPath = [[documentPath stringByAppendingPathComponent:folderName]stringByAppendingPathComponent:fileName];
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:documentPath])
    {
        NSData * data = [NSData dataWithContentsOfFile:documentPath];
        return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

@end
