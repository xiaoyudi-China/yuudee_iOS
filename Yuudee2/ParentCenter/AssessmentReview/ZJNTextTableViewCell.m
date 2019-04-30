//
//  ZJNTextTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/26.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTextTableViewCell.h"
@interface ZJNTextTableViewCell()
@property (nonatomic ,strong)UILabel *titleLabel;
@end
@implementation ZJNTextTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = RGBColor(19, 16, 29, 1);
        dotView.layer.cornerRadius = ScreenAdapter(2.5);
        dotView.layer.masksToBounds = YES;
        [self.contentView addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(10));
            make.left.equalTo(self).offset(ScreenAdapter(20));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
        }];
        
        self.titleLabel = [UILabel createLabelWithTitle:@"" textColor:HexColor(textColor()) font:FontSize(13) textAlignment:NSTextAlignmentLeft numberOfLines:0];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 30, 0, 10));
        }];
        
    }
    return self;
}

-(void)setInfoStr:(NSString *)infoStr{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = ScreenAdapter(5);
    NSRange range = NSMakeRange(0, [infoStr length]);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:infoStr];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    self.titleLabel.attributedText = attrStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
