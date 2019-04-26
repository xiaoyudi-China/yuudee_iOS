//
//  NSArray+NilSafe.m
//  testNilSafe
//
//  Created by Miao. on 2018/3/2.
//  Copyright © 2018年 Miao. All rights reserved.
//

#import "NSArray+NilSafe.h"
#import "NSObject+Swizzling.h"

@implementation NSArray (NilSafe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") methodSwizzlingWithOriginalSelector:@selector(objectAtIndex:) bySwizzledSelector:@selector(safeObjectAtIndex:)];
    });
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    if (index > self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    return [self safeObjectAtIndex:index];
}
@end
