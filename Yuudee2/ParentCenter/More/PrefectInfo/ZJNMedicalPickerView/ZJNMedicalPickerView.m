//
//  ZJNMedicalPickerView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/12/3.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNMedicalPickerView.h"
#import "BRPickerViewMacro.h"
@interface ZJNMedicalPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
//选择器
@property (nonatomic, strong) UIPickerView *pickerView;
//选中后的回调
@property (nonatomic ,copy)ZJNMedicalResultBlock resultBlock;

@property (nonatomic ,copy)NSArray *dataArr;

@property (nonatomic ,copy)NSString *sMedical;
@end
@implementation ZJNMedicalPickerView
+(void)showZJNMedicalPickerViewWithResultBlock:(ZJNMedicalResultBlock)resultBlock{
    
    ZJNMedicalPickerView *pickerView = [[ZJNMedicalPickerView alloc]initWithResultBlock:resultBlock];
    [pickerView showWithAnimation:YES];
}
-(instancetype)initWithResultBlock:(ZJNMedicalResultBlock)resultBlock{
    self = [super init];
    if (self) {
        self.dataArr = @[@"自闭症：轻",@"自闭症：中",@"自闭症：重",@"自闭症：不清楚",@"语言发育迟缓（其他正常）",@"单纯性智力低下（无自闭症状）",@"其他诊断",@"正常"];
        self.sMedical = self.dataArr[0];
        self.titleLabel.text = @"请选择医学诊断";
        self.resultBlock = resultBlock;
        [self initUI];
    }
    return self;
}
- (void)initUI{
    [super initUI];
    [self.alertView addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
}
#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.dataArr.count;
}
#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, self.alertView.frame.size.width - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    label.text = self.dataArr[row];
    return bgView;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.sMedical = self.dataArr[row];
}
#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    // 点击确定按钮后，执行回调
    if(self.resultBlock) {
        self.resultBlock(self.sMedical);
    }
}
#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)testFunction{
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    [self didTapBackgroundView:nil];
    [self clickRightBtn];
    [self clickLeftBtn];
    [self dismissWithAnimation:YES];
}

@end
