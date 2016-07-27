//
//  FileManagerHelper.h
//  
//
//  Created by 嘉宾 唐 on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAPP_DOCUMENT_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kAPP_TEMP_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"temp"]
#define kAPP_LIBRARY_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define kAPP_LIBRARY_CACHES_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]


typedef enum {
    kUseDocumentTypeDocuments,
    //苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
    
    kUseDocumentTypeTemp,
    //提供一个即时创建临时文件的地方。iPhone在重启时，会丢弃所有的tmp文件。
    
    kUseDocumentTypeLibrary,
    //存储程序的默认设置或其它状态信息；
    
    kUseDocumentTypeLibraryCaches,
    //存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
    
    kUseDocumentTypeBundle,
    //读取沙盒的根目录
    
}kUseDocumentType;

@interface FileManagerHelper : NSObject
+(NSString *)selectedFolderPathWith:(kUseDocumentType)type;

+(BOOL)isHasFolderInDocumentWithName:(NSString *)name andSandBoxFolder:(kUseDocumentType)type;

+(BOOL)isHasFileInDocumentWithFolderName:(NSString *)name andFileName:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type;

+(BOOL)moveFileFromPath:(NSString *)filePath toDocumentWithFileName:(NSString *)fileName andFolderName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type;
+(BOOL)createFolderInDocumentWithFoldName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type;

+(NSString *)getFilePathFromDocumentWithFileName:(NSString *)name andSandBoxFolder:(kUseDocumentType)type;

+(NSArray *)getFilesOfFolderInDocumentWithFolderName:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type;

+(BOOL)writeData:(id)data withFile:(NSString *)fileName andFolder:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type;

+(NSData *)readDataWithFolder:(NSString *)folderName andFile:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type;
+(NSMutableArray*)readPlistDataWithFolder:(NSString *)folderName andFile:(NSString *)fileName andSandBoxFolder:(kUseDocumentType)type;

+(BOOL)writeObject:(id)object file:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type;

+(id)readObjectWithfile:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type;

+(BOOL)deleteObjectWithFile:(NSString *)fileName folder:(NSString *)folderName sandBoxFolder:(kUseDocumentType)type;

+(NSData *)objectChangeToData:(id)aData;
+(id)dataChangeToObject:(NSData *)aData;

+(BOOL)writePlistData:(NSArray*)data withFile:(NSString *)fileName andFolder:(NSString *)folderName andSandBoxFolder:(kUseDocumentType)type;

+(NSString*)filePathWithNameAndFolderAndSandBoxFolder:(NSString*)fileName folder:(NSString*)folderName sandBoxFolder:(kUseDocumentType)type;
@end
