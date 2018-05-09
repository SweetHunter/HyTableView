//
//  HyTableViewCell.m
//  HyTableView
//
//  Created by tongfang on 2018/5/7.
//  Copyright © 2018年 Hyman. All rights reserved.
//

#import "HyTableViewCell.h"

@implementation HyTableViewCell

- (instancetype) initWithIdentifier:(NSString *)identifier{
    if (self = [super init]) {
        _identifier = identifier;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config{
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
}

- (void)layoutSubviews{
    _contentView.frame = self.bounds;
}
@end
