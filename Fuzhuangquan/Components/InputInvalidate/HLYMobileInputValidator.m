//
//  HLYMobileInputValidator.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYMobileInputValidator.h"

@implementation HLYMobileInputValidator

- (BOOL)validateInput:(NSString *)input error:(NSError **)error
{
    NSError *regError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(134|135|136|137|138|139|150|151|152|158|159|157|182|187|188|147|130|131|132|155|185|186|133|153|180|189|177)[0-9]{8}$" options:NSRegularExpressionAnchorsMatchLines error:&regError];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:input options:NSMatchingAnchored range:NSMakeRange(0, input.length)];
    
    if (numberOfMatches == 0) {
        if (error != nil) {
            
        }
        
        return NO;
    }
    
    return YES;
}

@end
