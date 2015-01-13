//
//  SimpleImagePullToRefreshLoaddingView+Pocket.m
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "SimpleImagePullToRefreshLoaddingView+Pocket.h"

@implementation SimpleImagePullToRefreshLoaddingView (Pocket)

+ (instancetype)pa_defaultLoadingViewWithWidth:(CGFloat)width
{
    SimpleImagePullToRefreshLoaddingView *loadingView = [[SimpleImagePullToRefreshLoaddingView alloc] initWithFrame:CGRectMake(0, 0, width, 60) icon:nil];
    
    return loadingView;
}

@end
