//
//  HLYQQInputValidator.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYQQInputValidator.h"

@implementation HLYQQInputValidator

- (BOOL)validateInput:(NSString *)input error:(NSError **)error
{
    if (input.length < 5 || input.length > 13) {
        return NO;
    }
    
    NSError *regError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$" options:NSRegularExpressionAnchorsMatchLines error:&regError];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:input options:NSMatchingAnchored range:NSMakeRange(0, input.length)];
    
    if (numberOfMatches == 0) {
        if (error != nil) {
            
        }
        
        return NO;
    }
    
    return YES;
}

@end
