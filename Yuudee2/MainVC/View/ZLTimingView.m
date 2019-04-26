//
//  ZLTimingView.m
//  圆圈计时器
//
//  Created by a on 2018/10/8.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ZLTimingView.h"

//间隔时间
#define KAnimationSeparTime 0.1
#define KRadius self.bounds.size.width*0.5

@interface ZLTimingView ()

//定时器
@property (nonatomic,strong)NSTimer *timer;

//绘制时间
@property (nonatomic,assign)CGFloat drawTime;

@property (nonatomic,strong)UIImageView * floor;

@end

@implementation ZLTimingView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float angle_start = 0-M_PI*2/4.0;
    float angle_end = _drawTime/_animationTime*M_PI*2-M_PI*2/4.0;
    
    [self drawArcWithContext:ctx withPoint:CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5) wiithStart:angle_start withEnd:angle_end withColor:_runColor];
    
}

- (void)drawArcWithContext:(CGContextRef )ctx withPoint:(CGPoint )point wiithStart:(CGFloat )angle_start withEnd:(CGFloat )angle_end withColor:(UIColor *)color {
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddArc(ctx, point.x, point.y, KRadius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaultData];
        [self _initSubView];
    }
    return self;
}

- (void)defaultData {
    
    self.runColor = [@"00ceff" hexStringToColor];
    _animationTime = 3;
}

- (void)_initSubView {
    
    self.floor = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/4, self.height/4, self.width/2, self.height/2)];
    self.floor.image = [UIImage imageNamed:@"floor"];
    self.floor.layer.masksToBounds = YES;
    self.floor.layer.cornerRadius = self.floor.width/2;
    [self addSubview:self.floor];
    
    self.layer.cornerRadius = self.frame.size.height*0.5;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [@"cbb399" hexStringToColor];
}

/*
 *动画开始
 */
- (void)start {
    
    [_timer invalidate];
    _timer = nil;
    
    _drawTime = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:KAnimationSeparTime target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    
    _drawTime += KAnimationSeparTime;
    
    [self setNeedsDisplay];
    
    if (_drawTime > _animationTime) {
        
        //绘制完成
        [_timer invalidate];
        _timer = nil;
    }
    
}

/*
 *停止动画
 */
- (CGFloat)stop {
    
    [_timer invalidate];
    _timer = nil;
    if (_animationTime > 0 && self.drawTime > 1) {
        self.animationTime = 0;
        return self.drawTime;
    }
    return 1;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"销毁了");
}




@end
