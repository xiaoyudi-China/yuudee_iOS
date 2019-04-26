//
//  UIScrollView+ZJNCategory.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 险峰科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ZJNCategory)
/**
 添加下拉刷新
 
 @param block blcok
 */
- (void)addRefreshHeaderWithRefreshingBlock:(dispatch_block_t)block;

/**
 添加上拉加载
 
 @param block block
 */
- (void)addRefreshFooterWithRefreshingBlock:(dispatch_block_t)block;

/**
 开始刷新
 */
- (void)beginRefreshing;

/**
 结束刷新
 */
- (void)endRefreshing;

/**
 没有更多数据
 */
- (void)noticeNoMoreData;

/**
 重置
 */
- (void)resetNoMoreData;


/**
 删除上拉加载
 */
- (void)removeRefreshFooter;

/**
 删除下拉刷新
 */
- (void)removeRefreshHeader;

/**
 是否需要自动适配安全区域
 */
@property (nonatomic, assign) BOOL notNeedSafeArea;

@end
