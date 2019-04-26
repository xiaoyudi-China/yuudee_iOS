//
//  ZJNChartsSecondTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNChartsSecondTableViewCell.h"

@implementation ZJNChartsSecondTableViewCell
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
