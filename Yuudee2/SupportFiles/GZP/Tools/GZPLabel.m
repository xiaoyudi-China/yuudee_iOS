//
//  GZPLabel.m
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "GZPLabel.h"

@implementation GZPLabel

-(void)fillWithText:(NSString *)text color:(NSString *)color font:(NSInteger)font aligenment:(NSInteger)alignment
{
    self.text = text;
    self.textColor = [color hexStringToColor];
    self.font = [UIFont systemFontOfSize:font];
    self.textAlignment = alignment;
}


@end
