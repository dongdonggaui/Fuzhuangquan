//
//  UIView+Size.h
//  GameRank
//
//  Created by Jinxiao on 6/26/13.
//  Copyright (c) 2013 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Size)

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end