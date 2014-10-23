//
//  TQShareManager.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-25.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TQShareManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

static NSString * const TQShareManagerTencentAppId = @"1101217493";
static NSString * const TQShareManagerTencentAppSecret = @"quS3El51AQ9ecYWL";

static NSString * const TQShareManagerWeixinAppId = @"wx064a18522de58d6c";
//static NSString * const TQShareManagerWeixinAppSecret = @"88fe49805ccb20928a2f81ed11b21ed0";

static NSString * const TQShareManagerWeiboShareUrl = @"https://upload.api.weibo.com/2/statuses/upload.json";
static NSString * const TQShareManagerWeiboAppId = @"956011131";
static NSString * const TQShareManagerWeiboAppSecret = @"011193d9a83231ada3e30c9f0a6290a0";
static NSString * const TQShareManagerWeiboRedirectUrl = @"http://www.laohu.com";

static NSString * const TQShareManagerDefaultShareTitle = @"老虎游戏";
static NSString * const TQShareManagerDefaultShareDetail = @"老虎游戏";

NSString * const TQShareManagerDidSendToWeiboSuccessNotification = @"com.hly.sharemanager.notification.weibo.sendsuccess";
NSString * const TQShareManagerDidSendToWeiboFailedNotification = @"com.hly.sharemanager.notification.weibo.sendfailed";

NSString * const TQShareManagerDidSendToWeixinSuccessNotification = @"com.hly.sharemanager.notification.weixin.sendsuccess";
NSString * const TQShareManagerDidSendToWeixinFailedNotification = @"com.hly.sharemanager.notification.weixin.sendfailed";

NSString * const TQShareManagerDidSendToQQSuccessNotification = @"com.hly.sharemanager.notification.qq.sendsuccess";
NSString * const TQShareManagerDidSendToQQFailedNotification = @"com.hly.sharemanager.notification.qq.sendfailed";

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TQWeiboOAuth : NSObject

+ (instancetype)sharedInstance;

/** Access Token凭证，用于后续访问各开放接口 */
@property (nonatomic, copy) NSString * accessToken;

/** Access Token的失效期 */
@property (nonatomic, copy) NSDate   * expirationDate;

/** 用户授权登录后对该用户的唯一标识 */
@property (nonatomic, copy) NSString * openId;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TQShareManager () <WXApiDelegate, TencentSessionDelegate, WeiboSDKDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation TQShareManager

+ (instancetype)sharedInstance
{
    static TQShareManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[TQShareManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark - public
- (void)setup
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:TQShareManagerTencentAppId andDelegate:self];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:TQShareManagerWeiboAppId];
    
    [WXApi registerApp:TQShareManagerWeixinAppId];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *path = url.absoluteString;
    if ([path hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([path hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (void)authWithType:(TQShareType)type
{
    if (type == TQShareTypeQQ) {
        [self.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_USER_INFO]];
    } else if (type == TQShareTypeWeibo) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = TQShareManagerWeiboRedirectUrl;
        request.scope = @"all";
        request.userInfo = @{@"other_info": @(123)};
        [WeiboSDK sendRequest:request];
    }
}

- (void)shareWithType:(TQShareType)type title:(NSString *)title detail:(NSString *)detail image:(UIImage *)image url:(NSString *)url
{
    BOOL shareEnabled = NO;
    switch (type) {
        case TQShareTypeWeixin:
        case TQShareTypeWeixinTimeline:
        {
            shareEnabled = [self checkIfWeixinShareEnabled];
            break;
        }
        case TQShareTypeQQ:
            shareEnabled = YES;
            break;
        case TQShareTypeWeibo:
            shareEnabled = YES;
            break;
        default:
            break;
    }
    
    if(shareEnabled)
    {
        
        UIImage *thumbnail = nil;
        if(image) {
            thumbnail = [self thumbImageWithImage:image limitSize:CGSizeMake(150.f, 150.f)];
        } else {
            thumbnail = [self thumbImageWithImage:[UIImage imageNamed:@"icon.png"] limitSize:CGSizeMake(150.f, 150.f)];
        }
        
        title = title ? : [self defaultShareTitle];
        detail = detail ? : [self defaultShareDetail];
        
        switch(type)
        {
            case TQShareTypeWeixin:
            case TQShareTypeWeixinTimeline:
            {
                WXMediaMessage *message = [WXMediaMessage message];
                
                if(title)
                {
                    message.title = title;
                }
                
                if(detail)
                {
                    message.description = detail;
                }
                
                if(url)
                {
                    WXWebpageObject *webObj = [WXWebpageObject object];
                    webObj.webpageUrl = url;
                    message.mediaObject = webObj;
                }
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                
                if(type == TQShareTypeWeixin)
                {
                    req.scene = WXSceneSession;
                }
                else
                {
                    req.scene = WXSceneTimeline;
                }
                req.bText = NO;
                req.message = message;
                [WXApi sendReq:req];
                
                break;
            }
                
            case TQShareTypeQQ:
            {
                QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:detail previewImageData:UIImageJPEGRepresentation(thumbnail, 0.01)];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleQQSendResult:sent];
                NSLog(@"qq sent code --> %d", sent);
                
                break;
            }
                
            case TQShareTypeWeibo:
            {
                if ([WeiboSDK isWeiboAppInstalled]) {
                    
                    WBMessageObject *message = [WBMessageObject message];
                    message.text = detail;
                    WBImageObject *imageObj = [WBImageObject object];
                    imageObj.imageData = UIImageJPEGRepresentation(thumbnail, 0.01);
                    message.imageObject = imageObj;
                    
                    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                    
                    [WeiboSDK sendRequest:request];
                    
                } else {
                    
                    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
                    request.redirectURI = TQShareManagerWeiboRedirectUrl;
                    request.scope = @"all";
                    request.userInfo = @{@"type": @"share",
                                         @"content": @{@"text": [detail stringByAppendingFormat:@" %@", url],
                                                       @"image": UIImageJPEGRepresentation(thumbnail, 0.01)}
                                         };
                    [WeiboSDK sendRequest:request];
                }
                
                
                break;
            }
            default:
                break;
        }
    }
}

- (NSString *)defaultShareTitle
{
    return TQShareManagerDefaultShareTitle;
}

- (NSString *)defaultShareDetail
{
    return TQShareManagerDefaultShareDetail;
}

- (UIImage *)defaultShareImage
{
    return [self thumbImageWithImage:[UIImage imageNamed:@"icon.png"] limitSize:CGSizeMake(150.f, 150.f)];
}


#pragma mark -
#pragma mark - private
- (BOOL)checkIfWeixinShareEnabled
{
    BOOL enabled = ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
    if(!enabled)
    {
        NSLog(@"您还没有安装微信或者您微信的版本不支持分享功能!");
    }
    return enabled;
}

- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if(scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height)
    {
        return scImg;
    }
    CGSize thumbSize;
    if(scImg.size.width/scImg.size.height > limitSize.width/limitSize.height)
    {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width/scImg.size.width * scImg.size.height;
    } else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height/scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

- (void)handleQQSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            NSLog(@"App未注册");
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSLog(@"发送参数错误");
        }
        case EQQAPIQQNOTINSTALLED:
        {
            NSLog(@"未安装手Q");
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSLog(@"API接口不支持");
        }
        case EQQAPISENDFAILD:
        {
            NSLog(@"发送失败");
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            NSLog(@"空间分享不支持纯文本分享，请使用图文分享");
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            NSLog(@"空间分享不支持纯图片分享，请使用图文分享");
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToQQFailedNotification object:nil];
            break;
        }
        default:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToQQSuccessNotification object:nil];
            break;
        }
    }
}

#pragma mark -
#pragma mark - tecent
- (void)tencentDiNSLogin
{
    NSLog(@"tencent did login");
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"cancelled --> %@", cancelled ? @"YES" : @"NO");
}

- (void)tencentDidNotNetWork
{
    NSLog(@"unreachable");
}

- (BOOL)onTencentReq:(TencentApiReq *)req
{
    NSLog(@"req --> %@", req);
    
    return YES;
}

- (BOOL)onTencentResp:(TencentApiResp *)resp
{
    NSLog(@"resp --> %@", resp);
    
    return YES;
}

#pragma mark -
#pragma mark - weibo
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *autorizeResponse = (WBAuthorizeResponse *)response;
        if (autorizeResponse.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [TQWeiboOAuth sharedInstance].accessToken = autorizeResponse.accessToken;
            [TQWeiboOAuth sharedInstance].expirationDate = autorizeResponse.expirationDate;
            [TQWeiboOAuth sharedInstance].openId = autorizeResponse.userID;
            
            if (response.requestUserInfo) {
                NSString *type = [response.requestUserInfo objectForKey:@"type"];
                if (type && [type isEqualToString:@"share"]) {
                    NSDictionary *content = [response.requestUserInfo objectForKey:@"content"];
                    if (!content) {
                        return;
                    }
                    
                    NSString *text = [content objectForKey:@"text"];
                    if (!text) {
                        return;
                    }
                    
                    NSData *imageData = [content objectForKey:@"image"];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
                    [parameters setObject:text forKey:@"status"];
                    [parameters setObject:autorizeResponse.accessToken forKey:@"access_token"];
                    if (imageData) {
                        [parameters setObject:imageData forKey:@"pic"];
                    }
                    
                    [WBHttpRequest requestWithAccessToken:autorizeResponse.accessToken url:TQShareManagerWeiboShareUrl httpMethod:@"POST" params:parameters delegate:self withTag:nil];
                }
            }
        }
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboSuccessNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:nil];
        }
    }
}

#pragma mark -
#pragma mark - weibo http delegate
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:error];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error && responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboSuccessNotification object:responseObject];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:error];
    }
}

#pragma mark -
#pragma mark - weixin
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"weixin on response");
    if (resp.errCode == WXSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeixinSuccessNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeixinFailedNotification object:nil];
    }
}

- (void)onReq:(BaseReq *)req
{
    NSLog(@"weixin on request");
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TQWeiboOAuth

+ (instancetype)sharedInstance
{
    static TQWeiboOAuth *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedObj) {
            sharedObj = [[TQWeiboOAuth alloc] init];
        }
    });
    
    return sharedObj;
}

@end
