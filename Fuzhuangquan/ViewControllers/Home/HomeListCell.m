//
//  HomeListCell.m
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import "HomeListCell.h"
#import <UIImageView+WebCache.h>

@interface HomeListCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation HomeListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithHeadPath:(NSString *)headPath name:(NSString *)name city:(NSString *)city rate:(NSString *)rate
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[ThemeImage placeholderImage1]];
    self.nameLabel.text = name;
    self.cityLabel.text = city;
    self.rateLabel.text = rate;
    
    [self setNeedsUpdateConstraints];
}

@end
