//
//  DGAlertView.h
//  DGAlertView
//
//  Created by Jinxiao on 10/9/12.
//  Copyright (c) 2012年 debugeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _AlertStyle
{
    AlertStyleNone = 0,
    AlertStyleSuccess,
    AlertStyleFail,
    AlertStyleWarning,
    AlertStyleIndicator
} AlertStyle;

typedef enum _AlertToken
{
    AlertTokenNomal             = 0,
    AlertTokenUninterruptible   = 1 << 0,   //设置AlertTokenUninterruptible后提示将不被打断，只能使用hideAlert强制隐藏
    AlertTokenInfinite          = 1 << 1,
} AlertToken;

@interface DGAlertView : UIView

+ (void)registerPersistentWindow:(UIWindow *)window;

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle;

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle duration:(CGFloat)duration;

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle alertToken:(AlertToken)alertToken;

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle alertToken:(AlertToken)alertToken duration:(CGFloat)duration;

+ (void)hideAlert;

@end
