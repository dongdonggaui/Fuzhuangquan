//
//  DGAlertView.m
//  DGAlertView
//
//  Created by Jinxiao on 10/9/12.
//  Copyright (c) 2012年 debugeek. All rights reserved.
//

#import "DGAlertView.h"
#import "UIView+Size.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultDuration        2.5f
#define kMaxDuration            MAXFLOAT

#define kTestWord               @"$"
#define kAlertViewMaxWidth      295
#define kAlertViewMaxHeight     336

#define kAlertViewMinWidth      114
#define kAlertViewMinHeight     114

#define kAlertViewLeftPadding   20
#define kAlertViewRightPadding  20
#define kAlertViewHeaderPadding 20
#define kAlertViewFooterPadding 20

#define kAlertViewIconWidth     46
#define kAlertViewIconHeight    46
#define kAlertViewIndicatorWidth    40
#define kAlertViewIndicatorHeight   40

#define kAlertViewIconFooterHeight  17
#define kAlertViewTitleFooterHeight 9

#define kAlertViewTitleFont         [UIFont boldSystemFontOfSize:15]
#define kAlertViewTitleColor        [UIColor whiteColor]
#define kAlertViewTitleShadowColor  [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.35f]

#define kAlertViewTextFont          [UIFont systemFontOfSize:13]
#define kAlertViewTextColor         [UIColor colorWithWhite:0.8f alpha:0.9f]
#define kAlertViewTextShadowColor   [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.35f]

@interface DGAlertView ()
{
    UIActivityIndicatorView *_indicatiorView;
    UIImageView *_styleView;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    
    NSTimer *_alertTimer;
}
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic) AlertStyle alertStyle;
@property (nonatomic) AlertToken alertToken;
@end

@implementation DGAlertView

static float lastAlertDate = 0.f;
static UIWindow *persistentWindow = nil;

+ (void)registerPersistentWindow:(UIWindow *)window
{
    persistentWindow = [window retain];
}

+ (DGAlertView *)sharedInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle
{
    [self showAlertTitle:title message:message alertStyle:alertStyle alertToken:AlertTokenNomal duration:kDefaultDuration];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle alertToken:(AlertToken)alertToken
{
    [self showAlertTitle:title message:message alertStyle:alertStyle alertToken:alertToken duration:kDefaultDuration];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle duration:(CGFloat)duration
{
    [self showAlertTitle:title message:message alertStyle:alertStyle alertToken:AlertTokenNomal duration:duration];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(AlertStyle)alertStyle alertToken:(AlertToken)alertToken duration:(CGFloat)duration
{
    BOOL canAlert = NO;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if (0 == lastAlertDate)
    {
		lastAlertDate = currentTime;
		canAlert = YES;
	}
	else
    {
        double interval = ABS(currentTime - lastAlertDate);
        lastAlertDate = currentTime;
        if(interval > .5f)
        {
            canAlert = YES;
        }
        else
        {
            canAlert = NO;
        }
    }
    
    DGAlertView *alertView = [self sharedInstance];
    
    // 如果之前显示的alert已经被设置为不可打断，则return
    if(alertView.alertToken&AlertTokenUninterruptible || !canAlert)
    {
        return;
    }
    
    [alertView disappearWithCompletion:^{
        alertView.alertToken = alertToken;
        alertView.alertStyle = alertStyle;
        alertView.duration = duration > kMaxDuration ? kMaxDuration : duration;
        [alertView showAlertWithTitle:title message:message alertStyle:alertStyle];
    }];
}

+ (void)hideAlert
{
    DGAlertView *alertView = [self sharedInstance];
    
    // 如果之前显示的alert已经被设置为不可打断，则return
    if(alertView.alertToken&AlertTokenUninterruptible)
    {
        return;
    }
    
    [alertView disappear];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        _alertStyle = AlertStyleNone;
        _alertToken = AlertTokenNomal;
    }
    
    return self;
}

- (void)dealloc
{
    [self cancelTimer];
    
    [super dealloc];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertStyle:(AlertStyle)alertStyle
{
    [self adjustElementsWithAlertStyle:alertStyle title:title message:message];
    
    [self appear];
}

- (void)adjustElementsWithAlertStyle:(AlertStyle)alertStyle title:(NSString *)title message:(NSString *)message
{
    float maxWidth = kAlertViewMaxWidth;
    float maxHeight = kAlertViewMaxHeight;
    float width = 0;
    float height = 0;
    
    maxWidth -= kAlertViewLeftPadding + kAlertViewRightPadding;
    maxHeight -= kAlertViewHeaderPadding + kAlertViewFooterPadding;
    
    CGSize styleSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
    if(AlertStyleSuccess == alertStyle)
    {
        styleSize = CGSizeMake(kAlertViewIconWidth, kAlertViewIconHeight);
        maxHeight -= styleSize.height;
        maxHeight -= kAlertViewIconFooterHeight;
    }
    else if(AlertStyleFail == alertStyle)
    {
        styleSize = CGSizeMake(kAlertViewIconWidth, kAlertViewIconHeight);
        maxHeight -= styleSize.height;
        maxHeight -= kAlertViewIconFooterHeight;
    }
    else if(AlertStyleWarning == alertStyle)
    {
        styleSize = CGSizeMake(kAlertViewIconWidth, kAlertViewIconHeight);
        maxHeight -= styleSize.height;
        maxHeight -= kAlertViewIconFooterHeight;
    }
    else if(AlertStyleIndicator == alertStyle)
    {
        styleSize = CGSizeMake(kAlertViewIndicatorWidth, kAlertViewIndicatorHeight);
        maxHeight -= styleSize.height;
        maxHeight -= kAlertViewIconFooterHeight; /*icon footer padding*/
    }
    
    int linesOfTitle = 0, linesOfMessage = 0;
    
    if(title && [title isKindOfClass:[NSString class]])
    {
        CGSize wordSize = [kTestWord sizeWithFont:kAlertViewTitleFont];
        titleSize = [title sizeWithFont:kAlertViewTitleFont constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:NSLineBreakByWordWrapping];
        linesOfTitle = ceil(titleSize.height/wordSize.height);
        maxHeight -= titleSize.height;
        maxHeight -= kAlertViewTitleFooterHeight;
    }
    
    if(message && [message isKindOfClass:[NSString class]])
    {
        CGSize wordSize = [kTestWord sizeWithFont:kAlertViewTextFont];
        messageSize = [message sizeWithFont:kAlertViewTextFont constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:NSLineBreakByWordWrapping];
        linesOfMessage = ceil(messageSize.height/wordSize.height);
    }
    
    width = MAX(styleSize.width, titleSize.width);
    width = MAX(width, messageSize.width);
    width += kAlertViewLeftPadding + kAlertViewRightPadding;
    height = styleSize.height + titleSize.height + messageSize.height;
    height += kAlertViewHeaderPadding + kAlertViewFooterPadding;
    if(alertStyle != AlertStyleNone)
    {
        height += kAlertViewIconFooterHeight;
    }
    if(title)
    {
        height += kAlertViewTitleFooterHeight;
    }
    
    // 确保最小尺寸
    width = MAX(width, kAlertViewMinWidth);
    height = MAX(height, kAlertViewMinHeight);
    CGSize alertSize = CGSizeMake(width, height);
    
    CGRect frame = self.frame;
    frame.size = alertSize;
    self.frame = frame;
    
    
    switch(alertStyle)
    {
        case AlertStyleNone:
            break;
            
        case AlertStyleSuccess:
        {
            _styleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_success.png"]];
            [self addSubview:_styleView];
            [_styleView release];
            
            break;
        }
            
        case AlertStyleFail:
        {
            _styleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_fail.png"]];
            [self addSubview:_styleView];
            [_styleView release];
            
            break;
        }
            
        case AlertStyleWarning:
        {
            _styleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_warning.png"]];
            [self addSubview:_styleView];
            [_styleView release];
            
            break;
        }
            
        case AlertStyleIndicator:
        {
            _indicatiorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _indicatiorView.hidesWhenStopped = YES;
            [_indicatiorView startAnimating];
            [self addSubview:_indicatiorView];
            [_indicatiorView release];
        }
            
        default:
            break;
    }
    
    if(title)
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setText:title];
        [_titleLabel setTextColor:kAlertViewTitleColor];
        [_titleLabel setFont:kAlertViewTitleFont];
        [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_titleLabel setNumberOfLines:linesOfTitle];
        
        _titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _titleLabel.shadowColor = kAlertViewTitleShadowColor;
        
        [self addSubview:_titleLabel];
        [_titleLabel release];
    }
    
    if(message)
    {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        [_messageLabel setText:message];
        [_messageLabel setTextColor:kAlertViewTextColor];
        [_messageLabel setFont:kAlertViewTextFont];
        [_messageLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_messageLabel setNumberOfLines:linesOfMessage];
        
        _messageLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _messageLabel.shadowColor = kAlertViewTextShadowColor;
        
        [self addSubview:_messageLabel];
        [_messageLabel release];
    }
    
    if(!title && !message && alertStyle == AlertStyleNone)
    {
        
    }
    else if(!title && !message && alertStyle != AlertStyleNone)
    {
        switch(alertStyle)
        {
            case AlertStyleNone:
                break;
                
            case AlertStyleSuccess:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, (alertSize.width - styleSize.height)/2, styleSize.width, styleSize.height);
                
                break;
            }
                
            case AlertStyleFail:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, (alertSize.width - styleSize.height)/2, styleSize.width, styleSize.height);
                
                break;
            }
                
            case AlertStyleWarning:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, (alertSize.width - styleSize.height)/2, styleSize.width, styleSize.height);
                
                break;
            }
                
            case AlertStyleIndicator:
            {
                _indicatiorView.frame = CGRectMake((alertSize.width - styleSize.width)/2, (alertSize.width - styleSize.height)/2, styleSize.width, styleSize.height);
                
                break;
            }
                
            default:
                break;
        }
    }
    else if(title && !message && alertStyle == AlertStyleNone)
    {
        _titleLabel.frame = CGRectMake((self.width - titleSize.width)/2, (self.height - titleSize.height)/2, titleSize.width, titleSize.height);
    }
    else if(!title && message && alertStyle == AlertStyleNone)
    {
        _messageLabel.frame = CGRectMake((self.width - messageSize.width)/2, (self.height - messageSize.height)/2, messageSize.width, messageSize.height);
    }
    else if(title && message && alertStyle == AlertStyleNone)
    {
        float offset = (alertSize.height - titleSize.height - messageSize.height - kAlertViewTitleFooterHeight)/2;
        _titleLabel.frame = CGRectMake((alertSize.width - titleSize.width)/2, offset, titleSize.width, titleSize.height);
        offset += titleSize.height + kAlertViewTitleFooterHeight;
        _messageLabel.frame = CGRectMake((alertSize.width - messageSize.width)/2, offset, messageSize.width, messageSize.height);
    }
    else if(title && !message && alertStyle != AlertStyleNone)
    {
        float offset = (alertSize.height - styleSize.height - titleSize.height - kAlertViewIconFooterHeight)/2;;
        switch(alertStyle)
        {
            case AlertStyleNone:
                break;
                
            case AlertStyleSuccess:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleFail:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleWarning:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleIndicator:
            {
                _indicatiorView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
            }
                
            default:
                break;
        }
        _titleLabel.frame = CGRectMake((alertSize.width - titleSize.width)/2, offset, titleSize.width, titleSize.height);
    }
    else if(!title && message && alertStyle != AlertStyleNone)
    {
        float offset = (alertSize.height - styleSize.height - messageSize.height - kAlertViewIconFooterHeight)/2;
        switch(alertStyle)
        {
            case AlertStyleNone:
                break;
                
            case AlertStyleSuccess:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleFail:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleWarning:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleIndicator:
            {
                _indicatiorView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
            }
                
            default:
                break;
        }
        _messageLabel.frame = CGRectMake((alertSize.width - messageSize.width)/2, offset, messageSize.width, messageSize.height);
    }
    else
    {
        float offset = kAlertViewHeaderPadding;
        switch(alertStyle)
        {
            case AlertStyleNone:
                break;
                
            case AlertStyleSuccess:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleFail:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleWarning:
            {
                _styleView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
                
                break;
            }
                
            case AlertStyleIndicator:
            {
                _indicatiorView.frame = CGRectMake((alertSize.width - styleSize.width)/2, offset, styleSize.width, styleSize.height);
                offset += styleSize.height + kAlertViewIconFooterHeight;
            }
                
            default:
                break;
        }
        _titleLabel.frame = CGRectMake((alertSize.width - titleSize.width)/2, offset, titleSize.width, titleSize.height);
        offset += titleSize.height + kAlertViewTitleFooterHeight;
        _messageLabel.frame = CGRectMake((alertSize.width - messageSize.width)/2, offset, messageSize.width, messageSize.height);
    }
}

- (void)appear
{
    UIWindow *window = persistentWindow ?: [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.center = CGPointMake(self.superview.center.x, self.superview.center.y - 80.f);
    
    [self cancelTimer];
    
    if(~_alertToken&AlertTokenInfinite)
    {
        [self scheduleTimer];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.65f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)disappear
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self clearAlertView];
    }];
}

- (void)disappearWithCompletion:(void (^)(void))completion
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self clearAlertView];
        
        if(completion)
        {
            completion();
        }
    }];
}

- (void)clearAlertView
{
    [_styleView removeFromSuperview];
    _styleView = nil;
    [_indicatiorView removeFromSuperview];
    _indicatiorView = nil;
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    [_messageLabel removeFromSuperview];
    _messageLabel = nil;
    
    _alertStyle = AlertStyleNone;
    _alertToken = AlertTokenNomal;
    
    [self removeFromSuperview];
}

- (void)scheduleTimer
{
    _alertTimer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(disappear) userInfo:nil repeats:NO];
    [_alertTimer retain];
}

- (void)cancelTimer
{
    [_alertTimer invalidate];
    [_alertTimer release], _alertTimer = nil;
}
@end
