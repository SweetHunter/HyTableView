//
//  HyTableViewCell.h
//  HyTableView
//
//  Created by tongfang on 2018/5/7.
//  Copyright © 2018年 Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HyTableViewCell : UIView
/*当前cell的索引*/
@property (nonatomic,assign) NSInteger index;
/*当前Cell的标识符*/
@property (nonatomic,readonly,copy) NSString *identifier;
/*contentView*/
@property (nonatomic,readonly,copy) UIView *contentView;

/*初始化*/
- (instancetype) initWithIdentifier:(NSString*)identifier;
@end
