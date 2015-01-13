//
//  NSObject+Validator.h
//  laohu
//
//  Created by Jinxiao on 8/20/13.
//  Copyright (c) 2013 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (TQAddition)

- (NSString *)tq_validString;
- (NSArray *)tq_validArray;
- (NSDictionary *)tq_validDictionary;
- (NSURL *)tq_validURL;
- (NSNumber *)tq_validNumber;

@end

@interface NSDictionary (TQAddition)

- (id)tq_safeObjectForKey:(id<NSCopying>)key;
- (id)tq_safeObjectForKey:(id<NSCopying>)key defaultValue:(id)defaultValue;

- (NSNumber *)tq_validNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)tq_validNumberForKey:(NSString *)key;

- (NSString *)tq_validStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSString *)tq_validStringForKey:(NSString *)key;

- (NSArray *)tq_validArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSArray *)tq_validArrayForKey:(NSString *)key;

- (NSDictionary *)tq_validDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (NSDictionary *)tq_validDictionaryForKey:(NSString *)key;

- (NSDate *)tq_validDateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
- (NSDate *)tq_validDateForKey:(NSString *)key;

@end

@interface NSMutableDictionary (TQAddition)

- (void)tq_setSafeObject:(id)object forKey:(id<NSCopying>)key;

@end

@interface NSMutableArray (TQAddition)

- (void)tq_addSafeObject:(id)object;

@end

@interface NSArray (TQAddition)

- (id)tq_safeObjectAtIndex:(NSInteger)index;

@end