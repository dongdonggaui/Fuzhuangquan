//
//  HomeRankCell.m
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import "HomeRankCell.h"
#import <UIImageView+WebCache.h>

@interface HomeRankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *patternMakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *patternMakerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *factoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *factoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retailerImageView;
@property (weak, nonatomic) IBOutlet UILabel *retailerLabel;

@end

@implementation HomeRankCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)configureCellWithPatternMakerImage:(NSString *)pmImagePath
                         patternMakerTitle:(NSString *)pmTitle
                              factoryImage:(NSString *)factImagePath
                              factoryTitle:(NSString *)factTitle
                             retailerImage:(NSString *)retImagePath
                             retailerTitle:(NSString *)retTitle
{
    [self.patternMakerImageView sd_setImageWithURL:[NSURL URLWithString:pmImagePath] placeholderImage:[ThemeImage placeholderImage1]];
    self.patternMakerLabel.text = pmTitle;
    
    [self.factoryImageView sd_setImageWithURL:[NSURL URLWithString:factImagePath] placeholderImage:[ThemeImage placeholderImage1]];
    self.factoryLabel.text = factTitle;
    
    [self.retailerImageView sd_setImageWithURL:[NSURL URLWithString:retImagePath] placeholderImage:[ThemeImage placeholderImage1]];
    self.retailerLabel.text = retTitle;
    
    [self setNeedsUpdateConstraints];
}

@end