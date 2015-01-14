//
//  HLYViewController.h
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HLYViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *datas;

/**
 *  override，自定义返回按钮样式，标识是否可返回
 */
- (BOOL)hly_isNavRootViewController;

/**
 *  错误消息提示
 */
- (void)showErrorMessage:(NSString *)errorMessage;

/**
 *  正确消息提示
 */
- (void)showSuccessMessage:(NSString *)message;

/**
 *  仅重写，不要直接掉用
 */
- (void)hly_backgroundIndicatorDidTapped;

- (void)hly_setNeedsUpdateUI;
- (void)hly_updateUIIfNeeded;

- (void)hly_updateLoginState;

- (void)hly_setNeedsUpdateLoginState;
- (void)hly_updateLoginStateIfNeeded;

- (void)hly_loadDatas;
- (void)hly_setNeedsLoadDatas;
- (void)hly_loadDatasIfNeeded;

// function
- (AppDelegate *)hly_appDelegate;
- (NSUserDefaults *)hly_userDefaults;
- (CGFloat)hly_topLayoutGuideLength;
- (CGFloat)hly_bottomLayoutGuideLength;
- (void)hly_presentLoginViewCompleted:(void(^)(void))completed;
- (void)hly_showBackgroundIndicatorWithImage:(UIImage *)image message:(NSString *)message;
- (void)hly_hidBackgroundIndicator;
- (void)hly_adjustScrollView:(UIScrollView *)scrollView topLayout:(BOOL)top bottomLayout:(BOOL)bottom;

@end
