//
//  HLYAddressInputValidator.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYAddressInputValidator.h"

@implementation HLYAddressInputValidator

- (BOOL)validateInput:(NSString *)input error:(NSError **)error
{
    if (input.length == 0) {
        return NO;
    }
    NSCharacterSet *invalidateSet = [NSCharacterSet characterSetWithCharactersInString:@"$^&*"];
    NSRange invalidateRange = [input rangeOfCharacterFromSet:invalidateSet options:NSLiteralSearch];
    if (invalidateRange.length != 0) {
        return NO;
    }
    
    return YES;
}

@end
