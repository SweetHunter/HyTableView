//
//  HyTableView.m
//  HyTableView
//
//  Created by tongfang on 2018/5/7.
//  Copyright © 2018年 Hyman. All rights reserved.
//

#import "HyTableView.h"
#import "HyTableViewCell.h"
#define  KHYTABLEVIEWCELLDEFAULTHEIGHT  70.f


@interface HyCellFrameInfo:NSObject
/*cell的编号*/
@property (nonatomic,assign) NSUInteger row;
/*cell在Y方向上的偏移量*/
@property (nonatomic,assign) CGFloat offsetY;
/*cell的高度*/
@property (nonatomic,assign) CGFloat cellHeight;
/*cell的宽度*/
@property (nonatomic,assign) CGFloat cellWidth;

@end

@implementation HyCellFrameInfo

@end

@interface HyTableView()

@end

@implementation HyTableView{
    /*储存可见Cell的信息*/
    NSMutableDictionary <NSNumber *,HyTableViewCell *>*_visibleCellsDict;
    /*缓存池里面的Cell*/
    NSMutableSet <HyTableViewCell *>*_cacheCells;
    /*数据源返回的cell的数量*/
    NSUInteger _numberOfCells;
    /*存储cell的高度*/
    NSMutableArray <HyCellFrameInfo *>*_cellFrameInfos;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)config{
    _visibleCellsDict = [[NSMutableDictionary alloc] init];
    _cacheCells = [[NSMutableSet alloc] init];
    _cellFrameInfos = [[NSMutableArray alloc] init];
}

- (void)setDataSource:(id<HyTableViewDatasource>)dataSource{
    _dataSource  =  dataSource;
    [self updateContentSize];
}

- (void)setHyDelegate:(id<HyTableViewDelegate>)hyDelegate{
    _hyDelegate = hyDelegate;
    [self updateContentSize];
}

- (void)reloadData{
    [self updateContentSize];
    [self layoutScreenDisplayingCells];
}

- (void)layoutSubviews{
//    [super layoutSubviews];
    [self layoutScreenDisplayingCells];
}

- (void)updateContentSize{
    NSInteger numberOfRows = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfRowInHyTableView:)]) {
        numberOfRows = [_dataSource numberOfRowInHyTableView:self];
        _numberOfCells = numberOfRows;
    }
    
    BOOL isRespondsHeightForRow = [_hyDelegate respondsToSelector:@selector(hyTableView:heightForRow:)];
    NSLog(@"isRespondsHeightForRow = %d",isRespondsHeightForRow);
    CGFloat offsetY = 0;
    NSMutableArray <HyCellFrameInfo *> *cellFrameInfos =@[].mutableCopy;
    for (int i = 0; i < numberOfRows; i ++) {
        CGFloat cellHeight = isRespondsHeightForRow ? [_hyDelegate hyTableView:self heightForRow:i] : KHYTABLEVIEWCELLDEFAULTHEIGHT;
        offsetY += cellHeight;
        HyCellFrameInfo *info = [[HyCellFrameInfo alloc] init];
        info.row = i;
        info.offsetY = offsetY;
        info.cellHeight = cellHeight;
        info.cellWidth = CGRectGetWidth(self.bounds);
        [cellFrameInfos addObject:info];
    }
    _cellFrameInfos = cellFrameInfos;
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds), offsetY);
    [self setContentSize:contentSize];
}

- (void)layoutScreenDisplayingCells{
    NSRange screenDisplayingRange = [self findDisplayingRange];
    for (NSInteger i = screenDisplayingRange.location; i < screenDisplayingRange.location + screenDisplayingRange.length; i ++) {
        HyTableViewCell *cell = [self cellForRow:i];
        [self storageDisplayingCell:cell index:i];
        [self removeOutScreenCellWithDisplayingCellInScreenRange:screenDisplayingRange];
    }
}

- (NSRange )findDisplayingRange{
    NSInteger firstCellAtIndex = 0;
    NSInteger endCellAtIndex = 0;
    CGFloat currentOffsetY = self.contentOffset.y;
    CGFloat screenDisplayingFirstCellDistance = 0;
    CGFloat screenDisplayingEndCellDistance = currentOffsetY + CGRectGetHeight(self.bounds);
    for (NSInteger i = 0; i < _numberOfCells; i ++) {
        HyCellFrameInfo *info = _cellFrameInfos[i];
        screenDisplayingFirstCellDistance += info.cellHeight;
        if (screenDisplayingFirstCellDistance >=currentOffsetY) {
            firstCellAtIndex = i;
            break;
        }
    }
    
    for (NSInteger j = 0; j <_numberOfCells; j ++) {
        HyCellFrameInfo *info = _cellFrameInfos[j];
        if (info.offsetY >= screenDisplayingEndCellDistance) {
            endCellAtIndex = j;
            break;
        }
        
        if (j == _numberOfCells - 1) {
            endCellAtIndex = j;
            break;
        }
    }
    return NSMakeRange(firstCellAtIndex, endCellAtIndex - firstCellAtIndex +1);
}

- (HyTableViewCell *)cellForRow:(NSInteger)row{
    HyTableViewCell *visibleCell = [_visibleCellsDict objectForKey:@(row)];
    if (!visibleCell) {
        visibleCell = [_dataSource hyTableView:self cellAtRow:row];
    }
    return visibleCell;
}

- (void)storageDisplayingCell:(HyTableViewCell *)cell index:(NSInteger)index{
    cell.frame = [self rectForCellAtRow:index];
    cell.index = index;
    [self insertSubview:cell atIndex:0];
    _visibleCellsDict[@(index)] = cell;
}

- (CGRect)rectForCellAtRow:(NSInteger)row{
    HyCellFrameInfo *info = _cellFrameInfos[row];
    CGFloat cellFrameX = 0;
    CGFloat cellFrameY = info.offsetY - info.cellHeight;
    CGFloat cellFrameWidth = info.cellWidth;
    CGFloat cellFrameHeight = info.cellHeight;
    return CGRectMake(cellFrameX, cellFrameY, cellFrameWidth, cellFrameHeight);
}

- (HyTableViewCell *)hy_dequeueReusableCellWithIdentifier:(NSString *)identifier{
    HyTableViewCell *cell = nil;
    for (HyTableViewCell *reusableCell in _cacheCells) {
        if (reusableCell.identifier == identifier) {
            cell = reusableCell;
            break;
        }
    }
    if (cell) {
        [_cacheCells removeObject:cell];
    }
    return cell;
}

- (void)hy_enqueueReusableCell:(HyTableViewCell *)cell{
    if (cell) {
        [_cacheCells addObject:cell];
        [cell removeFromSuperview];
    }
}

- (void)removeOutScreenCellWithDisplayingCellInScreenRange:(NSRange )displayRange{
    NSArray *indexs = _visibleCellsDict.allKeys;
    for (NSNumber *index  in indexs) {
        NSInteger rowValue = index.integerValue;
        if (!NSLocationInRange(rowValue, displayRange)) {
            HyTableViewCell *cell = _visibleCellsDict[index];
            [_visibleCellsDict removeObjectForKey:index];
            [self hy_enqueueReusableCell:cell];
        }
    }
}
@end
