//
//  UIView+Controller.m
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (UIViewController *)viewController
{
    id next = [self nextResponder];
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    }
    return nil;
}
@end
