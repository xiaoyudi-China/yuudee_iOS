//
//  XLAgainVC.h
//  Yuudee2
//
//  Created by GZP on 2018/11/19.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  过渡页面

#import "ZJNBasicViewController.h"

@interface XLAgainVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger type; //1名词,2动词,3句子成组,4句子分解

@property(nonatomic,strong)NSMutableArray * helpTime;
@property(nonatomic,strong)NSMutableArray * trainArr;
@property(nonatomic,strong)NSMutableArray * testArr;

@end
