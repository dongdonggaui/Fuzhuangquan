//
//  NSObject+Validator.m
//  laohu
//
//  Created by Jinxiao on 8/20/13.
//  Copyright (c) 2013 wanmei. All rights reserved.
//

#import "NSObject+TQAddition.h"

@implementation NSObject (TQAddition)

- (NSString *)tq_validString
{
    id result = nil;
    
    if(self && ![self isKindOfClass:[NSNull class]])
    {
        result = [NSString stringWithFormat:@"%@", self];
    }
    
    return result;
}

- (NSArray *)tq_validArray
{
    id result = nil;
    
    if([self isKindOfClass:[NSArray class]])
    {
        result = self;
    }
    
    return result;
}

- (NSDictionary *)tq_validDictionary
{
    id result = nil;
    
    if([self isKindOfClass:[NSDictionary class]])
    {
        result = self;
    }
    
    return result;
}

- (NSURL *)tq_validURL
{
    id result = nil;
    
    NSString *validString = [self tq_validString];
    if(validString)
    {
        result = [NSURL URLWithString:validString];
    }
    
    return result;
}

- (NSNumber *)tq_validNumber
{
    id result = nil;
    
    if([self isKindOfClass:[NSNumber class]])
    {
        result = self;
    }
    
    return result;
}

@end

@implementation NSDictionary (TQAddition)

- (id)tq_safeObjectForKey:(id<NSCopying>)key
{
    return [self tq_safeObjectForKey:key defaultValue:nil];
}

- (id)tq_safeObjectForKey:(id<NSCopying>)key defaultValue:(id)defaultValue
{
    if (!key) {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    
    if (!object || object == [NSNull null]) {
        return defaultValue;
    }
    
    return object;
}

- (NSNumber *)tq_validNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    if(!key)
    {
        return defaultValue;
    }
    
	id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSNumber class]])
    {
        return defaultValue;
    }
    
    return object;
}

- (NSNumber *)tq_validNumberForKey:(NSString *)key
{
	return [self tq_validNumberForKey:key defaultValue:nil];
}

- (NSString *)tq_validStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSString class]])
    {
        if([object isKindOfClass:[NSNumber class]])
        {
            return [object stringValue];
        }
        return defaultValue;
    }
    
    return object;
}

- (NSString *)tq_validStringForKey:(NSString *)key;
{
    return [self tq_validStringForKey:key defaultValue:nil];
}

- (NSArray *)tq_validArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
{
    if(!key)
    {
        return defaultValue;
    }
    
    id array = [self objectForKey:key];
    if(![array isKindOfClass:[NSArray class]])
    {
        return defaultValue;
    }
    
    return array;
}

- (NSArray *)tq_validArrayForKey:(NSString *)key;
{
    return [self tq_validArrayForKey:key defaultValue:nil];
}

- (NSDictionary *)tq_validDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSDictionary class]])
    {
        return defaultValue;
    }
    
    return object;
}
- (NSDictionary *)tq_validDictionaryForKey:(NSString *)key
{
    return [self tq_validDictionaryForKey:key defaultValue:nil];
}

- (time_t)tq_validTimeForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    NSString *stringTime = [self tq_validStringForKey:key];
    if((id)stringTime == [NSNull null])
    {
        stringTime = @"";
    }
    
	struct tm created;
    time_t now;
    time(&now);
    
	if(stringTime)
    {
		if(strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL)
        {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (time_t)tq_validTimeForKey:(NSString *)key
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self tq_validTimeForKey:key defaultValue:defaultValue];
}

- (NSDate *)tq_validDateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if([object isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSince1970:[object intValue]];
    }
    else if([object isKindOfClass:[NSString class]] && [object length] > 0)
    {
        return [NSDate dateWithTimeIntervalSince1970:[self tq_validTimeForKey:key]];
    }
    
    return nil;
}

- (NSDate *)tq_validDateForKey:(NSString *)key
{
    return [self tq_validDateForKey:key defaultValue:nil];
}

@end

@implementation NSMutableDictionary (TQAddition)

- (void)tq_setSafeObject:(id)object forKey:(id<NSCopying>)key
{
    if(object && key)
    {
        [self setObject:object forKey:key];
    }
}

@end

@implementation NSMutableArray (TQAddition)

- (void)tq_addSafeObject:(id)object
{
    if(object)
    {
        [self addObject:object];
    }
}

@end

@implementation NSArray (TQAddition)

- (id)tq_safeObjectAtIndex:(NSInteger)index
{
    if(index >= 0 && index < [self count])
    {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

@end
