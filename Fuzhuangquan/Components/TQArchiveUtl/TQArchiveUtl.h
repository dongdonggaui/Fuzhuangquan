//
//  TQArchiveUtl.h
//  Laohu
//
//  Created by huangluyang on 14/11/21.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ArchiveType) {
    ArchiveTypeCache,
    ArchiveTypeDocument,
};

@interface TQArchiveUtl : NSObject

/**
 *  写缓存
 *
 *  @param object     缓存对象
 *  @param entityName 缓存对你标识符
 */
+ (void)writeObject:(id)object withEntityName:(NSString *)entityName archiveType:(ArchiveType)type;

/**
 *  读缓存
 *
 *  @param entityName 缓存对象标识符
 *
 *  @return 已缓存的对象
 */
+ (id)readObjectForEntity:(NSString *)entityName archiveType:(ArchiveType)type;

@end
