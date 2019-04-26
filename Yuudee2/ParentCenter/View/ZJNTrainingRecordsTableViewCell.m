//
//  ZJNTrainingRecordsTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/14.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTrainingRecordsTableViewCell.h"

@implementation ZJNTrainingRecordsTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = RGBColor(19, 16, 29, 1);
        dotView.layer.cornerRadius = 2.5;
        dotView.layer.masksToBounds = YES;
        [self.contentView addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(ScreenAdapter(30));
            make.left.equalTo(self.contentView).offset(ScreenAdapter(35));
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        
        [self.contentView addSubview:self.nextButton];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-ScreenAdapter(20));
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(40), ScreenAdapter(40)));
        }];
        
        [self.contentView addSubview:self.progressImageV];
        [self.progressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(10));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(315), ScreenAdapter(39)));
        }];
        
        [self.contentView addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.progressImageV).offset(-ScreenAdapter(15));
            make.centerY.equalTo(self.progressImageV).offset(-ScreenAdapter(2.2));
            make.width.mas_equalTo(ScreenAdapter(40));
        }];
        
        [self.contentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressImageV).offset(-ScreenAdapter(2.2));
            make.left.equalTo(self.progressImageV).offset(ScreenAdapter(15));
            make.right.equalTo(self.progressLabel.mas_left).offset(-ScreenAdapter(5));
            make.height.mas_equalTo(ScreenAdapter(6));
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:RGBColor(19, 16, 29, 1) font:FontSize(14)];
        _titleLabel.text = @"总体通关进度";
    }
    return _titleLabel;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _nextButton.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    }
    return _nextButton;
}

-(UIImageView *)progressImageV{
    if (!_progressImageV) {
        _progressImageV = [[UIImageView alloc]initWithImage:SetImage(@"progress_bg")];
    }
    return _progressImageV;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel createLabelWithTextColor:RGBColor(100, 72, 34, 1) font:FontSize(12)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.text = @"0.00%";
    }
    return _progressLabel;
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.layer.cornerRadius = ScreenAdapter(3);
        _progressView.layer.masksToBounds = YES;
//        _progressView.trackTintColor = RGBColor(90, 76, 62, 1);
//        _progressView.progressTintColor = RGBColor(194, 91, 85, 1);
        _progressView.trackImage = SetImage(@"line_bg");
        _progressView.progress = 0;
    }
    return _progressView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
