//
//  ZJNLineChartsView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/20.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNLineChartsView.h"

@interface ZJNLineChartsView(){
    BOOL isFinish;
}
@property (nonatomic ,assign)CGSize mySize;
@property (nonatomic ,assign)NSInteger xCount;
@property (nonatomic ,assign)NSInteger yCount;
@property (nonatomic ,assign)CGFloat xWidth;
@property (nonatomic ,assign)CGFloat yWidth;
@property (nonatomic ,strong)UIBezierPath *xLinePath;
@property (nonatomic ,strong)UIBezierPath *yLinePath;
@property (nonatomic ,strong)CAShapeLayer *xLineLayer;
@property (nonatomic ,strong)CAShapeLayer *yLineLayer;
@property (nonatomic ,strong)UIBezierPath *linePath;
@property (nonatomic ,strong)UILabel *xLabel;
@property (nonatomic ,strong)UILabel *yLabel;
@property (nonatomic ,strong)NSMutableArray *subViewsArr;
@end
@implementation ZJNLineChartsView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.opaque = NO;
        _subViewsArr = [NSMutableArray array];
        [self addSubview:self.xLabel];
        [self.xLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(40));
            make.top.equalTo(self).offset(ScreenAdapter(20));
            
        }];
        
        [self addSubview:self.yLabel];
        [self.yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ScreenAdapter(10));
            make.bottom.equalTo(self).offset(-ScreenAdapter(50));
        }];
        
    }
    return self;
}
-(UILabel *)xLabel{
    if (!_xLabel) {
        _xLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(12) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _xLabel;
}

-(UILabel *)yLabel{
    if (!_yLabel) {
        _yLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(12) textAlignment:NSTextAlignmentRight numberOfLines:1];
    }
    return _yLabel;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!isFinish) {
        isFinish = YES;
        
        self.mySize = self.bounds.size;
        //设置背景色为透明
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        // Drawing code
        //画X轴 Y轴
        _xLinePath = [UIBezierPath bezierPath];
        [_xLinePath moveToPoint:CGPointMake(ScreenAdapter(40), self.mySize.height-ScreenAdapter(40))];
        [_xLinePath addLineToPoint:CGPointMake(ScreenAdapter(40), ScreenAdapter(40))];
        
        _yLinePath = [UIBezierPath bezierPath];
        [_yLinePath moveToPoint:CGPointMake(ScreenAdapter(40), self.mySize.height-ScreenAdapter(40))];
        [_yLinePath addLineToPoint:CGPointMake(self.mySize.width-ScreenAdapter(40), self.mySize.height-ScreenAdapter(40))];
        
        _xLineLayer = [[CAShapeLayer alloc]init];
        _xLineLayer.path = self.xLinePath.CGPath;
        _xLineLayer.strokeColor = HexColor(textColor()).CGColor;
        _xLineLayer.lineWidth = 3.0;
        _xLineLayer.lineCap = @"round";
        _xLineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.xLineLayer];
        
        _yLineLayer = [[CAShapeLayer alloc]init];
        _yLineLayer.path = self.yLinePath.CGPath;
        _yLineLayer.strokeColor = HexColor(textColor()).CGColor;
        _yLineLayer.lineWidth = 3.0;
        _yLineLayer.lineCap = @"round";
        _yLineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.yLineLayer];
        
        [self setUpXView];
        [self setUpYView];
        [self setUpDotView];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark-画X轴上的节点
-(void)setUpXView{
    self.xCount = self.xArr.count;
    self.xWidth = (self.mySize.width - ScreenAdapter(100))/self.xCount;
    UILabel *zeroLabel = [UILabel createLabelWithTitle:@"0" textColor:HexColor(textColor()) font:FontSize(12) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [self addSubview:zeroLabel];
    [zeroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-ScreenAdapter(20));
        ;
        make.left.equalTo(self).offset(ScreenAdapter(40)-self.xWidth/2.0);
        make.width.mas_equalTo(self.xWidth);
    }];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 1; i <self.xCount+1; i ++) {
        [path moveToPoint:CGPointMake(ScreenAdapter(40)+i*self.xWidth, self.mySize.height-ScreenAdapter(40))];
        [path addLineToPoint:CGPointMake(ScreenAdapter(40)+i*self.xWidth, self.mySize.height-ScreenAdapter(40)-5)];
        NSString *title = self.xArr[i-1];
        if ([title isEqualToString:@"0"]) {
            title = @"";
        }
        //添加对应的label
        UILabel *label = [UILabel createLabelWithTitle:title textColor:HexColor(textColor()) font:FontSize(12) textAlignment:NSTextAlignmentCenter numberOfLines:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-ScreenAdapter(20));
            ;
            make.left.equalTo(self).offset(ScreenAdapter(40)+i*self.xWidth-self.xWidth/2.0-5);
            make.width.mas_equalTo(self.xWidth+20);
        }];
    }
    
    CAShapeLayer *xLayer = [[CAShapeLayer alloc]init];
    xLayer.path = path.CGPath;
    xLayer.strokeColor = HexColor(textColor()).CGColor;
    xLayer.lineWidth = 0.5;
    xLayer.lineCap = @"round";
    xLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:xLayer];
}

#pragma mark-画Y轴上的节点
-(void)setUpYView{
    self.yCount = self.yArr.count;
    self.yWidth = (self.mySize.height - ScreenAdapter(100))/self.yCount;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 1; i <self.yCount+1; i ++) {
        [path moveToPoint:CGPointMake(ScreenAdapter(40), self.mySize.height-ScreenAdapter(40)-i*self.yWidth)];
        [path addLineToPoint:CGPointMake(ScreenAdapter(40)+5, self.mySize.height-ScreenAdapter(40)-i*self.yWidth)];
        
        //添加对应的label
        UILabel *label = [UILabel createLabelWithTitle:self.yArr[i-1] textColor:HexColor(textColor()) font:FontSize(12) textAlignment:NSTextAlignmentRight numberOfLines:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.mas_equalTo(ScreenAdapter(35));
            make.bottom.equalTo(self).offset(-(ScreenAdapter(40)+i*self.yWidth-10));
            make.height.mas_equalTo(20);
        }];
    }
    
    CAShapeLayer *yLayer = [[CAShapeLayer alloc]init];
    yLayer.path = path.CGPath;
    yLayer.strokeColor = HexColor(textColor()).CGColor;
    yLayer.lineWidth = 0.5;
    yLayer.lineCap = @"round";
    yLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:yLayer];
}

//画节点和label
-(void)setUpDotView{
    
    self.linePath = [UIBezierPath bezierPath];
    for (int i = 0; i <self.dotArr.count; i ++) {
        id dot = self.dotArr[i];
        CGFloat yh;
        CGFloat xw;
        NSString *title;
        if ([dot isKindOfClass:[NSString class]]) {
            NSString *str = self.dotArr[i];
            if ([str isEqualToString:@""]) {
                continue;
            }
            CGFloat doty = [str floatValue];
            yh = (doty/self.maxY)*(self.mySize.height-ScreenAdapter(20)-ScreenAdapter(80));
            xw = (i+1) *self.xWidth;
            title = str;
        }else{
            NSArray *pArr = self.dotArr[i];
            CGFloat doty = [pArr[1] floatValue];
            yh = (doty/self.maxY)*(self.mySize.height-ScreenAdapter(20)-ScreenAdapter(80));
            CGFloat dotx = [pArr[0] floatValue];
            xw = (dotx/self.maxX)*(self.mySize.width-ScreenAdapter(100));
            title = pArr[1];
        }
        
        CGPoint point = CGPointMake(ScreenAdapter(40)+xw,self.mySize.height-ScreenAdapter(40)-yh);
        NSLog(@"%.f___%.f",point.x,point.y);
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenAdapter(5), ScreenAdapter(5))];
        dotView.backgroundColor = self.dotColor;
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = ScreenAdapter(2.5);
        dotView.center = point;
        [self addSubview:dotView];
        [self.subViewsArr addObject:dotView];
        
        UILabel *dotLabel = [UILabel createLabelWithTitle:title textColor:self.dotColor font:FontSize(12) textAlignment:NSTextAlignmentCenter numberOfLines:1];
        dotLabel.frame = CGRectMake(0, 0, ScreenAdapter(50), ScreenAdapter(20));
//        if (self.dotArr.count>5) {
//            int x = i%2;
//            if (x == 0) {
//                dotLabel.center = CGPointMake(point.x, point.y-ScreenAdapter(15));
//            }else{
//                dotLabel.center = CGPointMake(point.x, point.y+ScreenAdapter(15));
//            }
//        }else{
//            dotLabel.center = CGPointMake(point.x, point.y-ScreenAdapter(15));
//        }
        int x = i%2;
        if (x == 0) {
            dotLabel.center = CGPointMake(point.x, point.y-ScreenAdapter(15));
        }else{
            dotLabel.center = CGPointMake(point.x, point.y+ScreenAdapter(15));
        }
        
        [self addSubview:dotLabel];
        [self.subViewsArr addObject:dotLabel];
        
        if (i == 0) {
            [self.linePath moveToPoint:point];
        }else{
            [self.linePath addLineToPoint:point];
        }
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.path = self.linePath.CGPath;
        layer.strokeColor = self.dotColor.CGColor;
        layer.lineWidth = 0.5;
        layer.lineCap = @"round";
        layer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
    }
}

#pragma mark-set方法
-(void)setXArr:(NSArray *)xArr{
    _xArr = xArr;
}
-(void)setYArr:(NSArray *)yArr{
    _yArr = yArr;
}
-(void)setXStr:(NSString *)xStr{
    self.xLabel.text = xStr;
}
-(void)setYStr:(NSString *)yStr{
    self.yLabel.text = yStr;
}
-(void)setDotArr:(NSArray *)dotArr{
    _dotArr = dotArr;

}
-(void)setMaxX:(CGFloat)maxX{
    _maxX = maxX;
}
-(void)setMaxY:(CGFloat)maxY{
    _maxY = maxY;
}
-(void)setDotColor:(UIColor *)dotColor{
    _dotColor = dotColor;
}

- (void)testFunction{
    isFinish = NO;
    self.xArr = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周"];
    self.yArr = @[@"50",@"100"];
    self.xStr = @"测试正确率/百分比";
    self.dotArr = @[@"2",@"2",@"2",@"2",@"2"];
    [self layoutSubviews];
    [self setUpXView];
    [self setUpYView];
    
}
@end
