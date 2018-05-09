//
//  HyTableView.h
//  HyTableView
//
//  Created by tongfang on 2018/5/7.
//  Copyright © 2018年 Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HyTableView;
@class HyTableViewCell;

@protocol HyTableViewDatasource<NSObject>
@required
/*返回cell的数量*/
- (NSInteger )numberOfRowInHyTableView:(HyTableView *)tableView;

/*返回cell*/
- (HyTableViewCell *)hyTableView:(HyTableView *)tableView cellAtRow:(NSInteger)row;
@end

@protocol HyTableViewDelegate<NSObject>

@optional
/*返回每个单元格的高度*/
- (CGFloat)hyTableView:(HyTableView *)tableView heightForRow:(NSInteger)row;
@end

@interface HyTableView : UIScrollView
/*数据源*/
@property (nonatomic,weak) id <HyTableViewDatasource>dataSource;
/*代理*/
@property (nonatomic,weak) id <HyTableViewDelegate>hyDelegate;

/*构造方法*/
- (instancetype)initWithFrame:(CGRect)frame;
/*刷新数据*/
- (void)reloadData;
/*从缓存池中取cell*/
- (HyTableViewCell *)hy_dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
