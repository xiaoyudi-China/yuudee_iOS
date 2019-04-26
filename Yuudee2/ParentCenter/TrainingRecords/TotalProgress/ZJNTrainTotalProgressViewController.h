//
//  ZJNTrainTotalProgressViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"

@interface ZJNTrainTotalProgressViewController : ZJNBasicViewController

@property (nonatomic ,copy)NSArray *modelArr;
@property (nonatomic ,copy)NSString *sumRate;
-(instancetype)initWithModelArray:(NSArray *)modelArr progress:(CGFloat)progress;

- (void)testFunction;

@end
