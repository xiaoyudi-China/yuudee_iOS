//
//  ZJNBasicTextField.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/3.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicTextField.h"
@interface ZJNBasicTextField()
@property (nonatomic ,strong)UIImageView *leftImageView;
@property (nonatomic ,strong)UILabel     *placeHolderLabel;

@end
@implementation ZJNBasicTextField
-(instancetype)init{
    self = [super init];
    if (self) {
        self.layer.borderColor = HexColor(yellowColor()).CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = ScreenAdapter(21.5);
        self.layer.masksToBounds = YES;
        self.textColor = HexColor(yellowColor());
        self.font = FontSize(14);
        self.leftView = self.leftImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.placeHolderLabel];
        [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return self;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.frame = CGRectMake(14, 12.5, 40, 18);
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _leftImageView;
}

-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel createLabelWithTitle:@"" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _placeHolderLabel;
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.leftImageView.image = [UIImage imageNamed:imageName];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
