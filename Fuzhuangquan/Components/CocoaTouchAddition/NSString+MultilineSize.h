//
//  NSString+MultilineSize.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-7.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MultilineSize)

- (CGSize)hly_sizeWithFont:(UIFont *)font constrainSize:(CGSize)constrainSize;

@end
