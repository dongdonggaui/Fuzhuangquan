//
//  HLYViewController.m
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import "HLYViewController.h"
#import "UIView+Frame.h"
#import <UIColor+Hex.h>
#import <UIImage+ImageWithColor.h>

@interface HLYViewController ()

@property (nonatomic, strong) UIView *backgroundIndicatorView;
@property (nonatomic, assign) BOOL needsToUpdateUI;
@property (nonatomic, assign) BOOL needsToUpdateLoginState;
@property (nonatomic, assign) BOOL needsToLoadDatas;

@end

@implementation HLYViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xF2F2F2];
    
    if (![self hly_isNavRootViewController]) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [backButton sizeToFit];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    self.needsToUpdateUI = NO;
    self.needsToUpdateLoginState = NO;
    self.needsToLoadDatas = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hly_updateUIIfNeeded];
    [self hly_updateLoginStateIfNeeded];
    [self hly_loadDatasIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - public
- (void)showErrorMessage:(NSString *)errorMessage
{
    if (errorMessage.length == 0) {
        errorMessage = @"未知错误";
    }
    //TODO: 
}

- (void)showSuccessMessage:(NSString *)message
{
    //TODO:
}

- (void)hly_setNeedsUpdateUI
{
    self.needsToUpdateUI = YES;
}

- (void)hly_updateUIIfNeeded
{
    if (self.needsToUpdateUI) {
        [self hly_updateUI];
    }
    
    self.needsToUpdateUI = NO;
}

- (void)hly_setNeedsUpdateLoginState
{
    self.needsToUpdateLoginState = YES;
}

- (void)hly_updateLoginStateIfNeeded
{
    if (self.needsToUpdateLoginState) {
        [self hly_updateLoginState];
    }
    
    self.needsToUpdateLoginState = NO;
}

- (void)hly_setNeedsLoadDatas
{
    self.needsToLoadDatas = YES;
}

- (void)hly_loadDatasIfNeeded
{
    if (self.needsToLoadDatas) {
        [self hly_loadDatas];
    }
    
    self.needsToLoadDatas = NO;
}

- (void)hly_adjustScrollView:(UIScrollView *)scrollView topLayout:(BOOL)top bottomLayout:(BOOL)bottom
{
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        UIEdgeInsets insets = scrollView.contentInset;
        if (top) {
            insets.top = [self.topLayoutGuide length];
        }
        
        if (bottom) {
            insets.bottom = [self.bottomLayoutGuide length];
        }
        
        scrollView.contentInset = insets;
        scrollView.scrollIndicatorInsets = insets;
    }
}

- (void)hly_showBackgroundIndicatorWithImage:(UIImage *)image message:(NSString *)message
{
    if (image) {
        [self hly_backgroundIndicatorImageView].image = image;
    }
    if (message) {
        [self hly_backgroundIndicatorLabel].text = message;
    }
    
    self.backgroundIndicatorView.hidden = NO;
    [self.view endEditing:YES];
    
    [self.view bringSubviewToFront:self.backgroundIndicatorView];
}

- (void)hly_hidBackgroundIndicator
{
    self.backgroundIndicatorView.hidden = YES;
}

- (AppDelegate *)hly_appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSUserDefaults *)hly_userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (CGFloat)hly_topLayoutGuideLength
{
    CGFloat offset = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        offset = [self.topLayoutGuide length];
    }
    
    return offset;
}

- (CGFloat)hly_bottomLayoutGuideLength
{
    CGFloat offset = 0;
    if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
        offset = [self.bottomLayoutGuide length];
    }
    
    return offset;
}

#pragma mark -
#pragma mark - tobe override
// 默认不开启旋转，如果subclass需要支持屏幕旋转，重写这个方法return YES即可
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)hly_backgroundIndicatorDidTapped
{
    
}

- (BOOL)hly_isNavRootViewController
{
    return NO;
}

- (void)hly_updateUI
{
    
}

- (void)hly_updateLoginState
{
    
}

- (void)hly_loadDatas
{
    
}

- (void)hly_presentLoginViewCompleted:(void (^)(void))completed
{
    
}

#pragma mark -
#pragma mark - private
- (void)backButtonDidTapped:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hly_setupUI
{
    [self hly_setupBackgroundIndcatorView];
}

- (void)hly_setupBackgroundIndcatorView
{
    self.backgroundIndicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundIndicatorView.userInteractionEnabled = YES;
    self.backgroundIndicatorView.backgroundColor = [UIColor whiteColor];
    self.backgroundIndicatorView.hidden = YES;
    [self.backgroundIndicatorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hly_backgroundIndicatorTapped:)]];
    [self.view addSubview:self.backgroundIndicatorView];
    
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectZero];
    spaceView1.backgroundColor = [UIColor clearColor];
    spaceView1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundIndicatorView addSubview:spaceView1];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    indicatorImageView.tag = 111111;
    indicatorImageView.image = [UIImage imageWithColor:[UIColor yellowColor]];
    indicatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundIndicatorView addSubview:indicatorImageView];
    
    UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    indicatorLabel.tag = 111112;
    indicatorLabel.backgroundColor = [UIColor clearColor];
    indicatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    indicatorLabel.numberOfLines = 0;
    indicatorLabel.preferredMaxLayoutWidth = 280;
    indicatorLabel.text = @"网络不给力，轻触重新加载";
    [self.backgroundIndicatorView addSubview:indicatorLabel];
    
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectZero];
    spaceView2.backgroundColor = [UIColor clearColor];
    spaceView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundIndicatorView addSubview:spaceView2];
    
    NSDictionary *viewsDic = @{@"background": self.backgroundIndicatorView,
                               @"indicatorImageView": indicatorImageView,
                               @"indicatorLabel": indicatorLabel,
                               @"space1": spaceView1,
                               @"space2": spaceView2};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[background]-0-|" options:0 metrics:nil views:viewsDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[background]-0-|" options:0 metrics:nil views:viewsDic]];
    [self.backgroundIndicatorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[space1(==0)]" options:0 metrics:nil views:viewsDic]];
    [self.backgroundIndicatorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[space2(==0)]" options:0 metrics:nil views:viewsDic]];
    [self.backgroundIndicatorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[space1(>=10)]-[indicatorImageView]-[indicatorLabel]-[space2(==space1)]-|" options:0 metrics:nil views:viewsDic]];
    [self.backgroundIndicatorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[indicatorImageView(>=80)]-100-|" options:0 metrics:nil views:viewsDic]];
    [self.backgroundIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:indicatorImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.backgroundIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:indicatorImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.backgroundIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:spaceView1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:indicatorImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.backgroundIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:spaceView2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:indicatorImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)hly_backgroundIndicatorTapped:(UITapGestureRecognizer *)tap
{
    [self hly_backgroundIndicatorDidTapped];
}

- (UIImageView *)hly_backgroundIndicatorImageView
{
    return (UIImageView *)[self.backgroundIndicatorView viewWithTag:111111];
}

- (UILabel *)hly_backgroundIndicatorLabel
{
    return (UILabel *)[self.backgroundIndicatorView viewWithTag:111112];
}

@end
