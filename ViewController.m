//
//  ViewController.m
//  HyTableView
//
//  Created by tongfang on 2018/5/7.
//  Copyright © 2018年 Hyman. All rights reserved.
//

#import "ViewController.h"
#import "HyTableView.h"
#import "HyTableViewCell.h"
static NSString* const identifier = @"HyTableViewCell";

@interface ViewController ()<HyTableViewDatasource,HyTableViewDelegate>

@end

@implementation ViewController{
    NSArray *_cellHeights;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeights = @[@(30),@(40),@(70),@(100),@(10),@(40),@(70),@(20),@(50),@(90),@(60),@(55),@(44),@(77),@(88)];
    self.view.backgroundColor = [UIColor whiteColor];
    HyTableView *tableView = [[HyTableView alloc] initWithFrame:self.view.frame];
    tableView.dataSource = self;
    tableView.hyDelegate = self;
    [self.view addSubview:tableView];
    
}

- (NSInteger )numberOfRowInHyTableView:(HyTableView *)tableView{
    return _cellHeights.count;
}


- (HyTableViewCell *)hyTableView:(HyTableView *)tableView cellAtRow:(NSInteger)row{
    HyTableViewCell *cell = [tableView hy_dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HyTableViewCell alloc] initWithIdentifier:identifier];
        cell.backgroundColor = [self randomColor];
    }
    return cell;
}

- (UIColor *)randomColor{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
- (CGFloat)hyTableView:(HyTableView *)tableView heightForRow:(NSInteger)row{
    return 90.f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
