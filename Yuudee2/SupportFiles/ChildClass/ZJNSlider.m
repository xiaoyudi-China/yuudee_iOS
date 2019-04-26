//
//  ZJNSlider.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/28.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNSlider.h"

@implementation ZJNSlider
-(instancetype)init{
    self = [super init];
    if (self) {
        self.continuous = NO;
        self.minimumValue = 0;
        self.maximumValue = 1;
        self.minimumTrackTintColor = HexColor(0x00befa);
        self.maximumTrackTintColor = RGBColor(105, 77, 45, 1);
        self.layer.cornerRadius = 21.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = HexColor(yellowColor()).CGColor;
        self.layer.borderWidth = 1;
        [self setThumbImage:SetImage(@"sign_icon_right") forState:UIControlStateNormal];        
    }
    return self;
}
//覆写父类UISlider的方法改变滑条frame
- (CGRect)trackRectForBounds:(CGRect)bounds{
    
    return CGRectMake(0, 0, bounds.size.width, 43);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
