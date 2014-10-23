//
//  HomeListCell.h
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListCell : UITableViewCell

- (void)configureCellWithHeadPath:(NSString *)headPath
                             name:(NSString *)name
                             city:(NSString *)city
                             rate:(NSString *)rate;

@end
