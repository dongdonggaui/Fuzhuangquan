//
//  HomeViewController.m
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import "HomeViewController.h"
#import "HLYPullToRefreshManager.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//
@property (nonatomic, strong) HLYPullToRefreshManager *tableManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - private
- (void)h_setupUI
{
    __weak typeof(self) safeSelf = self;
    self.tableManager = [[HLYPullToRefreshManager alloc] initWithTableView:self.tableView];
    self.tableManager.cellHeightForTableViewAtIndexPath = ^CGFloat (UITableView *tableView, NSIndexPath *indexPath) {
        if (0 == indexPath.row) {
            return 160;
        } else {
            return 120;
        }
    };
    self.tableManager.didSelectedTableViewAtIndexPath = ^void (UITableView *tableView, NSIndexPath *indexPath) {
        
    };
    self.tableManager.headerView.stateLabel.textColor = [ThemeColor numberThreeColor];
    self.tableManager.footerView.stateLabel.textColor = [ThemeColor numberThreeColor];
}

@end
