//
//  HLYInputValidator.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLYInputValidator : NSObject

- (BOOL)validateInput:(NSString *)input error:(NSError **)error;

@end
