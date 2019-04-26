//
//  NSObject+Swizzling.h
//  NSDictionary-NilSafe
//
//  Created by Miao. on 2018/1/5.
//  Copyright © 2018年 Glow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzling)
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;
@end
