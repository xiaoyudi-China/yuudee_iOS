//
//  UIApplication+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIApplication+ZJNCategory.h"
#import <objc/runtime.h>
static const char * MG_CURRENVCKEY = "currenVC";
@implementation UIApplication (ZJNCategory)
+ (void)load{
//    [UITableView appearance].separatorStyle = UITableViewCellSeparatorStyleNone;
//    [[UITableView appearance] setTableFooterView:[[UIView alloc] init]];
//    [[UITableView appearance] setTableHeaderView:[[UIView alloc] init]];
    [UIButton appearance].exclusiveTouch = YES;
    [UITableViewCell appearance].selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setCurrenVC:(UIViewController *)currenVC{
    objc_setAssociatedObject(self, MG_CURRENVCKEY, currenVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController*)currenVC{
    return objc_getAssociatedObject(self, MG_CURRENVCKEY);
}

@end
