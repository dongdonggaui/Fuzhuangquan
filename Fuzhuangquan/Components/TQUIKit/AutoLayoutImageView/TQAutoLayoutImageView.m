//
//  TQAutoLayoutImageView.m
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/12.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "TQAutoLayoutImageView.h"

@implementation TQAutoLayoutImageView

- (CGSize)intrinsicContentSize
{
    return self.placeholderIntrinsicContentSize;
}

- (void)setPlaceholderIntrinsicContentSize:(CGSize)placeholderIntrinsicContentSize
{
    _placeholderIntrinsicContentSize = placeholderIntrinsicContentSize;
    
    [self invalidateIntrinsicContentSize];
}

@end
