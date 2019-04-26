//
//  NSString+Color.h
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Color)

- (UIColor *)hexStringToColor;

- (UIColor *)hexStringToColorWithAlpha: (CGFloat)alpha;

@end
