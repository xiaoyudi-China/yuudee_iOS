//
//  ZJNTotalProgressView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/19.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTotalProgressView.h"
@interface ZJNTotalProgressView()
{
    CAShapeLayer *trackLayer;
    CAShapeLayer *progressLayer;
    UIImageView  *endPoint;
}
@property (nonatomic ,strong)UILabel *progressLabel;
@end
@implementation ZJNTotalProgressView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayer];
        [self addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            
        }];

    }
    return self;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel createLabelWithTextColor:HexColor(0x24cffd) font:FontSize(19)];
//        _progressLabel.text = @"99.99%";
    }
    return _progressLabel;
}

-(void)buildLayer{
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    float radius  = (self.bounds.size.width-ScreenAdapter(22))/2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:(1.5f*M_PI) clockwise:YES];
    
    trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = RGBColor(170, 147, 119, 1).CGColor;
    trackLayer.lineWidth = ScreenAdapter(22);
    trackLayer.path = [path CGPath];
    trackLayer.strokeEnd = 1;
    [self.layer addSublayer:trackLayer];
    
    progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bounds;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [[UIColor blackColor] CGColor];
//    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = ScreenAdapter(22);
    progressLayer.path = [path CGPath];
    progressLayer.strokeEnd = 0;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGBColor(96, 205, 248, 1) CGColor],(id)[RGBColor(96, 205, 248, 1) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:progressLayer];
    [self.layer addSublayer:gradientLayer];
    
}

-(void)setProgress:(CGFloat)progress{
    progressLayer.strokeEnd = progress;
    [progressLayer removeAllAnimations];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
