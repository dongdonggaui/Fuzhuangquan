//
//  HLYAutoLayoutTableManager.h
//  HuangLuyang
//
//  Created by huangluyang on 14-7-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  管理cell的自动布局管理器
 *
 *  使用方法：
 *
 *  1、使用相关tableView初始化
 *
 *  2、配置好cellAtIndexPath和configureCellAtIndexPath
 *
 *  3、在tableView的DataSource方法tableView:cellForRowAtIndexPath:方法中调用cellAtIndexPath
 *  和configureCellAtIndexPath
 *
 *  4、在tableView的Delegate方法tableView:heightForRowAtIndexPath:方法中调用
 *  heightForCellAtIndexPath:reuseIdentifier方法返回计算好的高度
 *
 */
@interface HLYAutoLayoutTableManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 *  获取cell
 */
@property (nonatomic, copy) UITableViewCell* (^cellAtIndexPath)(NSIndexPath*);

/**
 *  完善cell布局所需要的数据
 */
@property (nonatomic, copy) void (^configureCellAtIndexPath)(UITableViewCell *tableViewCell, NSIndexPath *indexPath);

/**
 *  获取根据cell配置的数据和约束计算后的高度
 */
- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier;

@end