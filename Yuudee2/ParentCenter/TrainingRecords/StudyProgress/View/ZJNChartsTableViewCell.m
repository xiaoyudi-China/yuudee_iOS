//
//  ZJNChartsTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNChartsTableViewCell.h"

@interface ZJNChartsTableViewCell()

@end

@implementation ZJNChartsTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lineChartsView];
        [self.lineChartsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(-ScreenAdapter(10), 0, -ScreenAdapter(10), 0));
        }];
    }
    return self;
}

-(ZJNLineChartsView *)lineChartsView{
    if (!_lineChartsView) {
        _lineChartsView = [[ZJNLineChartsView alloc]init];
    }
    return _lineChartsView;
}

@end
