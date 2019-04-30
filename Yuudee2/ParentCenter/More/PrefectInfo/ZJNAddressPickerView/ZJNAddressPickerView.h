//
//  ZJNAddressPickerView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/1.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <BRPickerView/BRPickerView.h>
#import "ZJNAreaModel.h"

typedef void (^ZJNAddressResultBlock)(ZJNAreaModel *province,ZJNAreaModel *city,ZJNAreaModel *area);
typedef void (^ZJNAddressCancelBlock)(void);

@interface ZJNAddressPickerView : BRBaseView
+(void)showZJNAddressPickerViewWithResultBlock:(ZJNAddressResultBlock)resultBlock;
-(instancetype)initWithResultBlock:(ZJNAddressResultBlock)resultBlock;

- (void)testFunction;
@end
