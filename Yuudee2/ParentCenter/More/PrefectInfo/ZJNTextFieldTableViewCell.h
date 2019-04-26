//
//  ZJNTextFieldTableViewCell.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNBasicTextField.h"
@interface ZJNTextFieldTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIView *coverView;
@property (nonatomic ,strong)ZJNBasicTextField *textField;
@end
