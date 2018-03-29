//
//  ViewController.m
//  HCScrollViewForever
//
//  Created by UltraPower on 2017/7/19.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "ViewController.h"
#import "HCShowScrollForeverViewController.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *titlesArray;

@end

@implementation ViewController


- (NSArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = @[@"HCCollectionForeverView",@"HCScrollForeverView",@"HCCardCollectionView",@"HCCardScrollView"];
    }
    return _titlesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轮播图演示";
    [self setupUI];
}

- (void)setupUI {
    UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollForeverView"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScrollForeverView"];
    }
    
    cell.textLabel.text = self.titlesArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCShowScrollForeverViewController *vc = [[HCShowScrollForeverViewController alloc] init];
    vc.title = self.titlesArray[indexPath.row];
    vc.contentTypeStr = self.titlesArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
