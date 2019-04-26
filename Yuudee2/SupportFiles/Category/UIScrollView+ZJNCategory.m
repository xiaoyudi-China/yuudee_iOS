//
//  UIScrollView+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 险峰科技. All rights reserved.
//

#import "UIScrollView+ZJNCategory.h"
#import <MJRefresh.h>
#import <objc/runtime.h>

static const char * MG_NOTNEEDSAFEAREAKEY = "notNeedSafeArea";

@implementation UIScrollView (ZJNCategory)

- (void)setNotNeedSafeArea:(BOOL)notNeedSafeArea{
    objc_setAssociatedObject(self, MG_NOTNEEDSAFEAREAKEY, @(notNeedSafeArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)notNeedSafeArea{
    return objc_getAssociatedObject(self, MG_NOTNEEDSAFEAREAKEY);
}

- (void)addRefreshHeaderWithRefreshingBlock:(dispatch_block_t)block {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}

- (void)addRefreshFooterWithRefreshingBlock:(dispatch_block_t)block {
    self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:block];
}

- (void)beginRefreshing {
    if (!self.mj_header.isRefreshing) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endRefreshing {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)noticeNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

- (void)removeRefreshFooter {
    self.mj_footer = nil;
}

- (void)removeRefreshHeader {
    self.mj_header = nil;
}

- (void)safeAreaInsetsDidChange{
    if (self.notNeedSafeArea) {
        return;
    }
    UIEdgeInsets edge = self.safeAreaInsets;
    if (edge.top > self.contentInset.top) {
        self.contentInset = UIEdgeInsetsMake(edge.top, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
        [self setContentOffset:CGPointMake(0, -edge.top)];
    }
    if (edge.bottom > self.contentInset.bottom) {
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, edge.bottom, self.contentInset.right);
    }
}

@end
