//
//  PagedFlowView.m
//  taobao4iphone
//
//  Created by Lu Kejin on 3/2/12.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import "PagedFlowView.h"
#import <QuartzCore/QuartzCore.h>

@interface PagedFlowView ()<UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL needsReload;
@property(nonatomic, assign) CGSize pageSize;
@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, strong) NSMutableArray *cells;
@property(nonatomic, assign) NSRange visibleRange;
@property(nonatomic, strong) NSMutableArray *reusableCells;

@end

@implementation PagedFlowView
@synthesize orientation;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer {
    NSInteger index = [_cells indexOfObject:gestureRecognizer.view];
//    NSInteger pageIndex = ceil(MAX(_scrollView.contentOffset.x, 0) / _pageSize.width);
//    _currentPageIndex = pageIndex;
    if ([self.delegate respondsToSelector:@selector(flowView:didTapPageAtIndex:)]) {
        [self.delegate flowView:self didTapPageAtIndex:index];
    }
//    NSInteger tappedIndex = 0;
//    CGPoint locationInScrollView = [gestureRecognizer locationInView:_scrollView];
//    if (CGRectContainsPoint(_scrollView.bounds, locationInScrollView)) {
//        tappedIndex = _currentPageIndex;
//        UIView *view = gestureRecognizer.view;
//        if (tappedIndex == 0) {
//            if (view.frame.origin.x <= 100) {
//                if ([self.delegate respondsToSelector:@selector(flowView:didTapPageAtIndex:)]) {
//                    [self.delegate flowView:self didTapPageAtIndex:tappedIndex];
//                }
//            }else {
//                [self scrollToPage:1];
//            }
//        }else {
//            if (view.frame.origin.x <= 100) {
//                [self scrollToPage:0];
//            }else {
//                if ([self.delegate respondsToSelector:@selector(flowView:didTapPageAtIndex:)]) {
//                    [self.delegate flowView:self didTapPageAtIndex:tappedIndex];
//                }
//            }
//        }
//    }
}

- (void)initialize{
    self.clipsToBounds = YES;
    
    _needsReload = YES;
    _pageSize = self.bounds.size;
    _pageCount = 0;
    _currentPageIndex = 0;
    
    _minimumPageAlpha = 1.0;
    _minimumPageScale = 1.0;
    
    _visibleRange = NSMakeRange(0, 0);
    
    _reusableCells = [[NSMutableArray alloc] initWithCapacity:0];
    _cells = [[NSMutableArray alloc] initWithCapacity:0];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
//    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;

    /*由于UIScrollView在滚动之后会调用自己的layoutSubviews以及父View的layoutSubviews
    这里为了避免scrollview滚动带来自己layoutSubviews的调用,所以给scrollView加了一层父View
     */
    UIView *superViewOfScrollView = [[UIView alloc] initWithFrame:self.bounds];
    [superViewOfScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [superViewOfScrollView setBackgroundColor:[UIColor clearColor]];
    [superViewOfScrollView addSubview:_scrollView];
    [self addSubview:superViewOfScrollView];
    
}


- (void)dealloc{
    _scrollView.delegate = nil;
}

- (void)queueReusableCell:(UIView *)cell{
    [_reusableCells addObject:cell];
}

- (void)removeCellAtIndex:(NSInteger)index{
    UIView *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) {
        return;
    }
    
    [self queueReusableCell:cell];
    
    if (cell.superview) {
        cell.layer.transform = CATransform3DIdentity;
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)refreshVisibleCellAppearance{
    
    if (_minimumPageAlpha == 1.0 && _minimumPageScale == 1.0) {
        return;//无需更新
    }
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:{
            CGFloat offset = _scrollView.contentOffset.x;
            
            for (NSUInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
                UIView *cell = [_cells objectAtIndex:i];
                CGFloat origin = cell.frame.origin.x;
                CGFloat delta = fabs(origin - offset);
                                                
                [UIView beginAnimations:@"CellAnimation" context:nil];
                if (delta < _pageSize.width) {
                    cell.alpha = 1 - (delta / _pageSize.width) * (1 - _minimumPageAlpha);
                    
                    CGFloat pageScale = 1 - (delta / _pageSize.width) * (1 - _minimumPageScale);
                    cell.layer.transform = CATransform3DMakeScale(pageScale, pageScale, 1);
                } else {
                    cell.alpha = _minimumPageAlpha;
                    cell.layer.transform = CATransform3DMakeScale(_minimumPageScale, _minimumPageScale, 1);
                }
                [UIView commitAnimations];
            }
            break;   
        }
        case PagedFlowViewOrientationVertical:{
            CGFloat offset = _scrollView.contentOffset.y;
            
            for (NSUInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
                UIView *cell = [_cells objectAtIndex:i];
                CGFloat origin = cell.frame.origin.y;
                CGFloat delta = fabs(origin - offset);
                                
                [UIView beginAnimations:@"CellAnimation" context:nil];
                if (delta < _pageSize.height) {
                    cell.alpha = 1 - (delta / _pageSize.height) * (1 - _minimumPageAlpha);
                    
                    CGFloat pageScale = 1 - (delta / _pageSize.height) * (1 - _minimumPageScale);
                    cell.layer.transform = CATransform3DMakeScale(pageScale, pageScale, 1);
                } else {
                    cell.alpha = _minimumPageAlpha;
                    cell.layer.transform = CATransform3DMakeScale(_minimumPageScale, _minimumPageScale, 1);
                }
                [UIView commitAnimations];
            }
        }
        default:
            break;
    }

}

- (void)setPageAtIndex:(NSInteger)pageIndex{
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);
    
    UIView *cell = [_cells objectAtIndex:pageIndex];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [_dataSource flowView:self cellForPageAtIndex:pageIndex];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [cell addGestureRecognizer:tapRecognizer];
        NSAssert(cell!=nil, @"datasource must not return nil");
        [_cells replaceObjectAtIndex:pageIndex withObject:cell];
        
        
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal:
                cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
                break;
            case PagedFlowViewOrientationVertical:
                cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
                break;
            default:
                break;
        }
        
        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
    }
}


- (void)setPagesAtContentOffset:(CGPoint)offset{
    
    NSUInteger cellCount = [self.cells count];
    
    if (cellCount == 0) return;
    
    // scrollView的大小是由pageSize决定的，然后放置于PagedFlowView的正中心
    CGPoint startPoint = CGPointMake(offset.x - CGRectGetMinX(_scrollView.frame), offset.y - CGRectGetMinY(_scrollView.frame));
    CGPoint endPoint = CGPointMake(startPoint.x + CGRectGetWidth(self.bounds), startPoint.y + CGRectGetHeight(self.bounds));
    
    
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:{
            NSUInteger startIndex = 0;
            if (startPoint.x > 0) {
                startIndex = floor(startPoint.x / self.pageSize.width);
            }
            
            NSInteger endIndex = ceil(endPoint.x / self.pageSize.width);
            if (endIndex > cellCount - 1) {
                endIndex = cellCount - 1;
            }
            
            //可见页分别向前向后扩展一个，提高效率
            if (startIndex > 0) {
                startIndex -= 1;
            }
            if (endIndex < cellCount - 1) {
                endIndex += 1;
            }
            
            if (_visibleRange.location == startIndex &&
                _visibleRange.length == (endIndex - startIndex + 1)) {
                return;
            }
            
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            
            for (NSUInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (int i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSUInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        case PagedFlowViewOrientationVertical:{
            NSInteger startIndex = 0;
            NSUInteger cellCount = [self.cells count];
            if (startPoint.y > 0) {
                startIndex = floor(startPoint.y / self.pageSize.height);
            }
            
            NSInteger endIndex = ceil(endPoint.y / self.pageSize.height);
            if (endIndex > cellCount - 1) {
                endIndex = cellCount - 1;
            }
            
            //可见页分别向前向后扩展一个，提高效率
            if (startIndex > 0) {
                startIndex -= 1;
            }
            
            if (endIndex < cellCount - 1) {
                endIndex += 1;
            }
            
            if (_visibleRange.location == startIndex &&
                _visibleRange.length == (endIndex - startIndex + 1)) {
                return;
            }
            
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            
            for (NSUInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (int i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSUInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        default:
            break;
    }
    
    
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_needsReload) {
        //如果需要重新加载数据，则需要清空相关数据全部重新加载
        
        
        //重置pageCount
        if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInFlowView:)]) {
            _pageCount = [_dataSource numberOfPagesInFlowView:self];
            
            if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
                [self.pageControl setNumberOfPages:_pageCount];
            }
        }
        
        //重置pageWidth
        if (_delegate && [_delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
            _pageSize = [_delegate sizeForPageInFlowView:self];
        }
        
        [_reusableCells removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
        
        //从supperView上移除cell
        for (NSInteger i=0; i<[_cells count]; i++) {
            [self removeCellAtIndex:i];
        }
        
        //填充cells数组
        [_cells removeAllObjects];
        for (NSInteger index=0; index<_pageCount; index++)
        {
            [_cells addObject:[NSNull null]];
        }
        
        // 重置_scrollView的contentSize
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal://横向
                _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, _pageSize.height);
                _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, _pageSize.height);
//                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//                _scrollView.center = theCenter;
                break;
            case PagedFlowViewOrientationVertical:{
                _scrollView.contentSize = CGSizeMake(_pageSize.width ,_pageSize.height * _pageCount);
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                break;
            }
            default:
                break;
        }
    }
    

    [self setPagesAtContentOffset:_scrollView.contentOffset];//根据当前scrollView的offset设置cell
    
    [self refreshVisibleCellAppearance];//更新各个可见Cell的显示外貌
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView API

- (void)reloadData
{
    _needsReload = YES;
    
    [self setNeedsLayout];
}


- (UIView *)dequeueReusableCell{
    UIView *cell = [_reusableCells lastObject];
    if (cell)
    {
        [_reusableCells removeLastObject];
    }
    
    return cell;
}

- (void)scrollToPage:(NSUInteger)pageNumber {
    if (pageNumber < _pageCount) {
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal:{
//                CGFloat offset = _scrollView.contentOffset.x;
//                UIView *cell = [_cells objectAtIndex:pageNumber];
//                CGFloat origin = cell.frame.origin.x;
//                CGFloat delta = fabs(origin - offset);
                CGFloat pageScale = 0.8;
                
                [_scrollView setContentOffset:CGPointMake(pageNumber == 0 ? 0 : ((_pageSize.width - 20) * pageScale + _pageSize.width*(pageNumber-1)), 0) animated:YES];
            }

                break;
            case PagedFlowViewOrientationVertical:
                [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * pageNumber) animated:YES];
                break;
        }
//        [self setPagesAtContentOffset:_scrollView.contentOffset];
        [self refreshVisibleCellAppearance];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark hitTest

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
////    if ([self pointInside:point withEvent:event]) {
//    if (event.type == UIEventTypeTouches) {
//
//    }
//        CGPoint newPoint = CGPointZero;
//        UIView *cell = [_cells objectAtIndex:self.currentPageIndex];
//        newPoint.x = point.x - cell.frame.origin.x + _scrollView.contentOffset.x;
//        newPoint.y = point.y - cell.frame.origin.y + _scrollView.contentOffset.y;
//        if ([cell pointInside:newPoint withEvent:event]) {
//            return [cell hitTest:newPoint withEvent:event];
//        }
//
//        return nil;
////    }
////
////    return nil;
//}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if (vel.x < -5) {
        //向右拖动
        NSInteger pageIndex = 0;
        if (scrollView.contentOffset.x < 100) {
            pageIndex = 1;
        }else if (scrollView.contentOffset.x > 100 && scrollView.contentOffset.x < 300) {
            pageIndex = 2;
        }else {
            return;
        }
        [self scrollToPage:pageIndex];
    }else if (vel.x > 5) {
        //向左拖动
        NSInteger pageIndex = 0;
        if (scrollView.contentOffset.x > 300) {
            pageIndex = 1;
        }else if (scrollView.contentOffset.x < 300) {
            pageIndex = 0;
        }else {
            return;;
        }
        [self scrollToPage:pageIndex];
    }else if (vel.x == 0) {
        //停止拖拽
    }
    
//    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //如果有PageControl，计算出当前页码，并对pageControl进行更新
    
    NSInteger pageIndex;
    
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:
            pageIndex = ceil(MAX(_scrollView.contentOffset.x, 0) / _pageSize.width);
            break;
        case PagedFlowViewOrientationVertical:
            pageIndex = ceil(MAX(_scrollView.contentOffset.y, 0) / _pageSize.height);
            break;
        default:
            break;
    }
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        [self.pageControl setCurrentPage:pageIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(flowView:didScrollToPageAtIndex:)] && _currentPageIndex != pageIndex) {
        [_delegate flowView:self didScrollToPageAtIndex:pageIndex];
    }
    
    _currentPageIndex = pageIndex;
}

@end
