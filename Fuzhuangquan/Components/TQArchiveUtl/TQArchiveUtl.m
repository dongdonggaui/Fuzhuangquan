//
//  TQArchiveUtl.m
//  Laohu
//
//  Created by huangluyang on 14/11/21.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQArchiveUtl.h"

@implementation TQArchiveUtl

+ (void)writeObject:(id)object withEntityName:(NSString *)entityName archiveType:(ArchiveType)type
{
    if (!entityName || entityName.length == 0) {
        return;
    }
    
    NSString *archivePath = [[self directoryWithType:type] stringByAppendingString:entityName];
    if (object) {
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:object];
        [archiveData writeToFile:archivePath atomically:YES];
    } else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:archivePath error:&error];
            if (error) {
                LoggerError(2, @"delete file error --> %@", error);
            }
        }
    }
}

+ (id)readObjectForEntity:(NSString *)entityName archiveType:(ArchiveType)type
{
    if (!entityName) {
        return nil;
    }
    
    id result = nil;
    
    NSString *archivePath = [[self directoryWithType:type] stringByAppendingString:entityName];
    NSData *data = [NSData dataWithContentsOfFile:archivePath];
    if (data) {
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return result;
}

#pragma mark -
#pragma mark - private
+ (NSString *)directoryWithType:(ArchiveType)type
{
    NSArray *paths = type == ArchiveTypeCache ? NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) : NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [bundleInfo objectForKey:(NSString *)kCFBundleNameKey];
    NSString *documentPath = [directory stringByAppendingPathComponent:appName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create error --> %@", error);
        }
    }
    return documentPath;
}

@end
