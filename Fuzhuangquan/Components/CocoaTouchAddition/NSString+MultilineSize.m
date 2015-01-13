//
//  NSString+MultilineSize.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-7.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "NSString+MultilineSize.h"

@implementation NSString (MultilineSize)

- (CGSize)hly_sizeWithFont:(UIFont *)font constrainSize:(CGSize)constrainSize
{
    CGSize size = CGSizeZero;
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion < 7) {
        size = [self sizeWithFont:font constrainedToSize:constrainSize];
    } else {
        size = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont: font} context:nil].size;
    }
    
    return size;
}

@end
