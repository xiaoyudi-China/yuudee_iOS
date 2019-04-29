//
//  GuoDuVC.h
//  Yuudee2
//
//  Created by GZP on 2018/9/29.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  过渡页面

#import "ZJNBasicViewController.h"

@interface GuoDuVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger type; //1名词,2动词,3句子成组,4句子分解,5名词意义测试(控制跳转哪个页面)

@property(nonatomic,strong)NSMutableArray * testArr;
@property(nonatomic,strong)NSMutableArray * yyTestArr;

@end
