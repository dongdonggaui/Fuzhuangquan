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

#import "HLYPullToRefreshManager.h"
#import "HLYAutoLayoutTableManager.h"

@interface HomeViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//
@property (nonatomic, strong) HLYPullToRefreshManager *tableManager;
@property (nonatomic, strong) HLYAutoLayoutTableManager *tableLayoutManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self h_setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        self.tableManager.topLayoutGuide = [self.topLayoutGuide length];
    }
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
    self.tableLayoutManager = [[HLYAutoLayoutTableManager alloc] initWithTableView:self.tableView];
    self.tableLayoutManager.cellAtIndexPath = ^UITableViewCell *(NSIndexPath *indexPath) {
        
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
    
    // 配置下拉刷新
    self.tableManager = [[HLYPullToRefreshManager alloc] initWithTableView:self.tableView];
    self.tableManager.cellHeightForTableViewAtIndexPath = ^CGFloat (UITableView *tableView, NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            return 160;
        } else {
            return 138;
        }
    };
    self.tableManager.didSelectedTableViewAtIndexPath = ^void (UITableView *tableView, NSIndexPath *indexPath) {
        
    };
    self.tableManager.headerView.stateLabel.textColor = [ThemeColor numberThreeColor];
    self.tableManager.footerView.stateLabel.textColor = [ThemeColor numberThreeColor];
    self.tableManager.enableLoadMore = NO;
}

- (void)h_updateUI
{
    // 更新自动布局
    self.tableLayoutManager.configureCellAtIndexPath = ^void (UITableViewCell *cell, NSIndexPath *indexPath) {
        if (!cell || !indexPath) {
            return;
        }
        
        if (indexPath.section == 0) {
            
            [(HomeRankCell *)cell configureCellWithPatternMakerImage:nil patternMakerTitle:@"打版师榜" factoryImage:nil factoryTitle:@"代工厂榜" retailerImage:nil retailerTitle:@"销售商榜"];
            
        } else {
            
            HomeListCell *theCell = (HomeListCell *)cell;
            
            [theCell configureCellWithHeadPath:nil name:@"黄师傅" city:@"广东-广州" rate:@"100"];
        }
    };
    
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
    
    if (self.tableLayoutManager.cellAtIndexPath) {
        cell = self.tableLayoutManager.cellAtIndexPath(indexPath);
        
        if (self.tableLayoutManager.configureCellAtIndexPath) {
            self.tableLayoutManager.configureCellAtIndexPath(cell, indexPath);
        }
    }
    
    return cell;
}

@end
