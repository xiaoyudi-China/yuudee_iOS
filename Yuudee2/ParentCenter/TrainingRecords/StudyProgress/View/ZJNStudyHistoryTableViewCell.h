//
//  ZJNStudyHistoryTableViewCell.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNDayHistoryModel.h"
@interface ZJNStudyHistoryTableViewCell : UITableViewCell
@property (nonatomic ,strong)DayListModel *model;
@property (nonatomic ,copy)void (^getMoreInfoBlock)(void);

- (void)testFunction;
@end
