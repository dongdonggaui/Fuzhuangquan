//
//  InputAlertView.h
//  Feedoo
//
//  Created by Jinxiao on 13-3-30.
//  Copyright (c) 2013年 debugeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ConfirmActionBlock) (NSString *text);
typedef void (^ CancelActionBlock) (void);

@interface InputAlertView : UIAlertView <UITextFieldDelegate>
{
    ConfirmActionBlock _confirmActionBlock;
    CancelActionBlock _cancelActionBlock;
}

- (id)initWithAlertTitle:(NSString *)title confirmButtonTitle:(NSString *)confirmButtonTitle confirmActionBlock:(ConfirmActionBlock)confirmActionBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelActionBlock:(CancelActionBlock)cancelActionBlock;

- (void)setPlaceholder:(NSString *)placeholder;
- (void)show;

@end
