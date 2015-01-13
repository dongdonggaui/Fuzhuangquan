//
//  SimpleImagePullToRefreshLoaddingView.h
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "HLYPullToRefreshLoadingView.h"

@interface SimpleImagePullToRefreshLoaddingView : HLYPullToRefreshLoadingView

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon;

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state;

- (void)updateWithProgress:(CGFloat)progress;

@end
