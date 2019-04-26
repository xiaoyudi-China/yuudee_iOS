//
//  ZJNCityListViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/12.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"
#import "ZJNCityModel.h"
@interface ZJNCityListViewController : ZJNBasicViewController
@property (nonatomic ,copy)void (^changeAreaCodeBlock)(ZJNCityModel *cityModel);
@end
