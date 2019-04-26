//
//  ZJNTextFieldTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTextFieldTableViewCell.h"

@interface ZJNTextFieldTableViewCell()

@end

@implementation ZJNTextFieldTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(ScreenAdapter(30));
            make.right.equalTo(self.contentView).offset(-ScreenAdapter(30));
            make.height.mas_equalTo(ScreenAdapter(44));
        }];
        
        [self.contentView addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.textField);
        }];
    }
    return self;
}
-(ZJNBasicTextField *)textField{
    if (!_textField) {
        _textField = [[ZJNBasicTextField alloc]init];
    }
    return _textField;
}
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.hidden = YES;
    }
    return _coverView;
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
