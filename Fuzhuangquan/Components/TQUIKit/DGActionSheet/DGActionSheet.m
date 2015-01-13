//
//  DGActionSheet.m
//  laohu
//
//  Created by Jinxiao on 8/13/13.
//  Copyright (c) 2013 wanmei. All rights reserved.
//

#import "DGActionSheet.h"

@interface DGActionSheet ()
{
    NSMutableDictionary *_buttonBlocks;
}
@property (nonatomic, assign) id<UIActionSheetDelegate> sheetDelegate;
@end

@implementation DGActionSheet

+ (id)actionSheetWithTitle:(NSString *)title
{
    DGActionSheet *as = [[[[self class] alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
    as.delegate = as;
    return as;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        self.delegate = self;
    }
    
    return self;
}

//- (void)setDelegate:(id <UIActionSheetDelegate>)delegate
//{
//    [super setDelegate:self];
//
//    _sheetDelegate = delegate;
//}

//- (id <UIActionSheetDelegate>)delegate
//{
//    return _sheetDelegate;
//}

#pragma mark - Add Buttons

- (NSInteger)addButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block
{
    NSInteger buttonIndex = [super addButtonWithTitle:title];
    
    NSString *key = [NSString stringWithFormat:@"%d", buttonIndex];
    
    if(_buttonBlocks == nil)
    {
        _buttonBlocks = [[NSMutableDictionary alloc] init];
    }
    
    if(block)
    {
        [_buttonBlocks setObject:[[block copy] autorelease] forKey:key];
    }
    
    return buttonIndex;
}

- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block
{
    NSInteger buttonIndex = [self addButtonWithTitle:title clickBlock:block];
    
    [self setDestructiveButtonIndex:buttonIndex];
    
    return buttonIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title clickBlock:(DGActionSheetBasicBlock)block
{
    NSInteger buttonIndex = [self addButtonWithTitle:title clickBlock:block];
    
    [self setCancelButtonIndex:buttonIndex];
    
    return buttonIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title
{
    NSInteger buttonIndex = [self addButtonWithTitle:title];
    
    [self setCancelButtonIndex:buttonIndex];
    
    return buttonIndex;
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [_sheetDelegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
    
    if(_didClickButtonBlock)
    {
        _didClickButtonBlock(buttonIndex);
    }
    
    if(_clickBlockType == DGActionSheetClickBlockTypeDidClickButton)
    {
        DGActionSheetBasicBlock block = [_buttonBlocks objectForKey:[NSString stringWithFormat:@"%d", buttonIndex]];
        if(block)
        {
            block();
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(actionSheetCancel:)])
    {
        [_sheetDelegate actionSheetCancel:self];
    }
    
    if(_didCancelBlock)
    {
        _didCancelBlock();
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(willPresentActionSheet:)])
    {
        [_sheetDelegate willPresentActionSheet:self];
    }
    
    if(_willPresentBlock)
    {
        _willPresentBlock();
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(didPresentActionSheet:)])
    {
        [_sheetDelegate didPresentActionSheet:self];
    }
    
    if(_didPresentBlock)
    {
        _didPresentBlock();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
    {
        [_sheetDelegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if(_willDismissBlock)
    {
        _willDismissBlock(buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(_sheetDelegate && [_sheetDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
    {
        [_sheetDelegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
    }
    
    if(_didDismissBlock)
    {
        _didDismissBlock(buttonIndex);
    }
    
    if(_clickBlockType == DGActionSheetClickBlockTypeDidDismiss)
    {
        DGActionSheetBasicBlock block = [_buttonBlocks objectForKey:[NSString stringWithFormat:@"%d", buttonIndex]];
        if(block)
        {
            block();
        }
    }
}

- (void)dealloc
{
    [_userInfo release], _userInfo = nil;
    
    [_willPresentBlock release], _willPresentBlock = nil;
    [_didPresentBlock release], _didPresentBlock = nil;
    [_didCancelBlock release], _didCancelBlock = nil;
    [_didClickButtonBlock release], _didClickButtonBlock = nil;
    [_willDismissBlock release], _willDismissBlock = nil;
    [_didDismissBlock release], _didDismissBlock = nil;
    
    [_buttonBlocks release], _buttonBlocks = nil;
    
    [super dealloc];
}

@end
