//
//  HLYDateFormatManager.m
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYDateFormatManager.h"

@interface HLYDateFormatManager ()

@property (nonatomic, strong) NSDateFormatter *yearMothDayHourMinuteSecondFormater;
@property (nonatomic, strong) NSDateFormatter *yMDFormater;

@end

@implementation HLYDateFormatManager

+ (instancetype)sharedInstance
{
    static HLYDateFormatManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[HLYDateFormatManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark - setters & getters
- (NSDateFormatter *)yearMothDayHourMinuteSecondFormater
{
    if (!_yearMothDayHourMinuteSecondFormater) {
        _yearMothDayHourMinuteSecondFormater = [[NSDateFormatter alloc] init];
        _yearMothDayHourMinuteSecondFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return _yearMothDayHourMinuteSecondFormater;
}

- (NSDateFormatter *)yMDFormater
{
    if (!_yMDFormater) {
        _yMDFormater = [[NSDateFormatter alloc] init];
        _yMDFormater.dateFormat = @"yyyy/MM/dd";
    }
    
    return _yMDFormater;
}

#pragma mark -
#pragma mark - public
- (NSString *)lapseTimeFormatFromDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    if (!date) {
        date = now;
    }
    NSTimeInterval timeLapse = [now timeIntervalSinceDate:date];
    NSString *timeString = nil;
    
    if (timeLapse < 180) {
        timeString = @"刚刚";
    } else if (timeLapse < 3600) {
        NSString *lapse = @"分钟前";
        timeString = [NSString stringWithFormat:@"%d %@", (int)ceilf(timeLapse / 60.), lapse];
    } else {
        timeString = [NSString stringWithFormat:@"%@", [self.yearMothDayHourMinuteSecondFormater stringFromDate:date]];
    }
    
    return timeString;
}

- (NSString *)longDisplayStringFromDate:(NSDate *)date
{
    if (!date) {
        date = [NSDate date];
    }
    
    return [self.yearMothDayHourMinuteSecondFormater stringFromDate:date];
}

- (NSString *)shortDisplayStringFromDate:(NSDate *)date
{
    return [self.yMDFormater stringFromDate:date];
}

#pragma mark -
#pragma mark - private

- (NSBundle *)hly_bundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HLYDateFormatManager" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
}

@end
