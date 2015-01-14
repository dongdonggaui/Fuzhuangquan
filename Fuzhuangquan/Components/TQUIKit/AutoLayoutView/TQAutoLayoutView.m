//
//  TQAutoLayoutView.m
//  Fuzhuangquan
//
//  Created by huangluyang on 15/1/14.
//  Copyright (c) 2015年 HLY. All rights reserved.
//

#import "TQAutoLayoutView.h"

@implementation TQAutoLayoutView

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
