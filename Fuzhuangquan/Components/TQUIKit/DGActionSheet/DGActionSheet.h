//
//  DGActionSheet.h
//  laohu
//
//  Created by Jinxiao on 8/13/13.
//  Copyright (c) 2013 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DGActionSheetBasicBlock) (void);
typedef void (^DGActionSheetIndexBlock) (NSInteger index);

typedef enum _DGActionSheetClickBlockType : NSInteger
{
    DGActionSheetClickBlockTypeDidDismiss       = 0,
    DGActionSheetClickBlockTypeDidClickButton   = 1,
} DGActionSheetClickBlockType;

@interface DGActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (nonatomic, retain) id userInfo;

@property (nonatomic, copy) DGActionSheetBasicBlock willPresentBlock;
@property (nonatomic, copy) DGActionSheetBasicBlock didPresentBlock;
@property (nonatomic, copy) DGActionSheetBasicBlock didCancelBlock;
@property (nonatomic, copy) DGActionSheetIndexBlock didClickButtonBlock;
@property (nonatomic, copy) DGActionSheetIndexBlock willDismissBlock;
@property (nonatomic, copy) DGActionSheetIndexBlock didDismissBlock;

@property (nonatomic, assign) DGActionSheetClickBlockType clickBlockType;

+ (id)actionSheetWithTitle:(NSString *)title;

- (NSInteger)addButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block;
- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title;

@end