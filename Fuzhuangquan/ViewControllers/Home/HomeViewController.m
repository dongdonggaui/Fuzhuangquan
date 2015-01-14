//
//  HomeViewController.m
//  Fuzhuangquan
//
//  Created by huangluyang on 14/10/23.
//  Copyright (c) 2014年 HLY. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeRankCell.h"
#import "HomeListCell.h"

#import "HLYTableViewPullToRefreshManager.h"
#import "HLYAutoLayoutTableManager.h"

@interface HomeViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//
@property (nonatomic, strong) HLYTableViewPullToRefreshManager *pullToRefreshManager;
@property (nonatomic, strong) HLYAutoLayoutTableManager *autoLayoutTableManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"推荐", @"推荐");

    [self h_setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.pullToRefreshManager updateLayoutGuidesWithViewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self h_updateUI];
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
    self.tableView.dataSource = self;
    
    // 配置自动布局
    self.autoLayoutTableManager = [[HLYAutoLayoutTableManager alloc] initWithTableView:self.tableView];
    self.autoLayoutTableManager.cellAtIndexPath = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = nil;
        NSString *reuseIdentifier = nil;
        
        if (indexPath.section == 0) {
            
            reuseIdentifier = @"rankCell";
            cell = [safeSelf.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[HomeRankCell alloc] init];
            }
            
        } else {
            
            reuseIdentifier = @"itemCell";
            cell = [safeSelf.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[HomeListCell alloc] init];
            }
            
        }
        
        return cell;
    };
    self.autoLayoutTableManager.configureCellAtIndexPath = ^void (UITableViewCell *tableViewCell, NSIndexPath *indexPath, BOOL forHeightCaculate) {
        if (!tableViewCell || !indexPath) {
            return;
        }
        
        if (indexPath.section == 0) {
            
            [(HomeRankCell *)tableViewCell configureCellWithPatternMakerImage:nil patternMakerTitle:@"打版师榜" factoryImage:nil factoryTitle:@"代工厂榜" retailerImage:nil retailerTitle:@"销售商榜"];
            
        } else {
            
            HomeListCell *theCell = (HomeListCell *)tableViewCell;
            
            [theCell configureCellWithHeadPath:nil name:@"黄师傅" city:@"广东-广州" rate:@"100"];
        }
    };
    
    // 配置下拉刷新
    self.pullToRefreshManager = [[HLYTableViewPullToRefreshManager alloc] initWithTableView:self.tableView];
    self.pullToRefreshManager.cellHeightForTableViewAtIndexPath = ^CGFloat (UITableView *tableView, NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            return 160;
        } else {
            return 138;
        }
    };
    self.pullToRefreshManager.didSelectedTableViewAtIndexPath = ^void (UITableView *tableView, NSIndexPath *indexPath) {
        
    };
    self.pullToRefreshManager.enableLoadMore = NO;
}

- (void)h_updateUI
{
    // 更新自动布局
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {
        count = 1;
    } else {
        count = 3;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *reuseIdentifier = nil;
    
    if (indexPath.row == 0) {
        
        reuseIdentifier = @"rankCell";
        
    } else {
        
        reuseIdentifier = @"itemCell";
        
    }
    
    if (self.autoLayoutTableManager.cellAtIndexPath) {
        cell = self.autoLayoutTableManager.cellAtIndexPath(tableView, indexPath);
        
        if (self.autoLayoutTableManager.configureCellAtIndexPath) {
            self.autoLayoutTableManager.configureCellAtIndexPath(cell, indexPath, NO);
        }
    }
    
    return cell;
}

@end
