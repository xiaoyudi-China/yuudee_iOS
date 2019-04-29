//
//  ZJNLineChartsView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/20.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNLineChartsView : UIView
@property (nonatomic ,copy)NSArray *xArr;
@property (nonatomic ,copy)NSArray *yArr;
@property (nonatomic ,copy)NSArray *dotArr;
@property (nonatomic ,copy)NSString *xStr;
@property (nonatomic ,copy)NSString *yStr;
@property (nonatomic ,assign)CGFloat maxX;
@property (nonatomic ,assign)CGFloat maxY;
@property (nonatomic ,strong)UIColor *dotColor;

- (void)testFunction;
@end
