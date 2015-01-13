//
//  SimpleImagePullToRefreshLoaddingView.m
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "SimpleImagePullToRefreshLoaddingView.h"
#import "UIView+Size.h"
#import <UIImage+ImageWithColor.h>

@interface SimpleImagePullToRefreshLoaddingView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SimpleImagePullToRefreshLoaddingView

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon
{
    if (self = [super initWithFrame:frame]) {
        if (!icon) {
            icon = [UIImage imageWithColor:[UIColor yellowColor] size:CGSizeMake(15, 15)];
        }
        _iconView = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:_iconView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = self.width * 0.5;
    CGFloat vertSpace = 5;
    
    [self.textLabel sizeToFit];
    
    CGFloat top = (self.height - self.iconView.height - vertSpace - self.textLabel.height) * 0.5;
    
    self.iconView.centerX = centerX;
    self.iconView.top = top;
    
    self.textLabel.centerX = centerX;
    self.textLabel.top = self.iconView.bottom + vertSpace;
}

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state
{
    switch (state) {
            
        case HLYPullToRefreshStateNormal: {
            
            self.textLabel.hidden = NO;
            
            break;
        }
            
        case HLYPullToRefreshStatePulling:
            
            self.textLabel.hidden = NO;
            
            break;
            
        case HLYPullToRefreshStateLoading:
            
            self.textLabel.hidden = NO;
            
            break;
            
        case HLYPullToRefreshStateHide:
        default:
            self.textLabel.hidden = YES;
            
            break;
    }
    
    self.textLabel.text = [self statusMessageForState:state];
}

- (void)updateWithProgress:(CGFloat)progress
{
    
}

@end
