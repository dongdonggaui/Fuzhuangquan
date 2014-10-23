//
//  HomeRankCell.h
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRankCell : UITableViewCell

- (void)configureCellWithPatternMakerImage:(NSString *)pmImagePath
                         patternMakerTitle:(NSString *)pmTitle
                              factoryImage:(NSString *)factImagePath
                              factoryTitle:(NSString *)factTitle
                             retailerImage:(NSString *)retImagePath
                             retailerTitle:(NSString *)retTitle;

@end
