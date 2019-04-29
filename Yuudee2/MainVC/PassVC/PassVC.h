//
//  PassVC.h
//  Yuudee2
//
//  Created by GZP on 2018/11/8.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  跳转页面

#import "ZJNBasicViewController.h"

@interface PassVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger type; //1,2,3,4

@property(nonatomic,strong)NSMutableArray * JZFJTrainArr; //跳转句子分解
@property(nonatomic,strong)NSMutableArray * JZFJTestArr;
@property(nonatomic,strong)NSMutableArray * JZFJHelpTime;

@end
