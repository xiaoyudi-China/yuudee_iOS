//
//  ZJNAddressPickerView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/1.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNAddressPickerView.h"
#import "BRPickerViewMacro.h"
@interface ZJNAddressPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
//选择器
@property (nonatomic, strong) UIPickerView *pickerView;
//省数组（固定）
@property (nonatomic ,copy)NSArray *pArr;
//省数组
@property (nonatomic ,copy)NSArray *provinceArr;
//市数组（固定）
@property (nonatomic ,copy)NSArray *cArr;
//市数组
@property (nonatomic ,copy)NSArray *cityArr;
//国家数组
@property (nonatomic ,copy)NSArray *countryArr;
//选中的省
@property (nonatomic ,strong)ZJNAreaModel *provinceModel;
//选中的市
@property (nonatomic ,strong)ZJNAreaModel *cityModel;
//选中的区
@property (nonatomic ,strong)ZJNAreaModel *areaModel;
//选中后的回调
@property (nonatomic ,copy)ZJNAddressResultBlock resultBlock;
@end
@implementation ZJNAddressPickerView
+(void)showZJNAddressPickerViewWithResultBlock:(ZJNAddressResultBlock)resultBlock{
    ZJNAddressPickerView *pickerView = [[ZJNAddressPickerView alloc]initWithResultBlock:resultBlock];
    [pickerView showWithAnimation:YES];
}
-(instancetype)initWithResultBlock:(ZJNAddressResultBlock)resultBlock{
    self = [super init];
    if (self) {
        self.titleLabel.text = @"选择地区";
        self.resultBlock = resultBlock;
        [self loadData];
        [self initUI];
    }
    return self;
}
- (void)initUI{
    [super initUI];
    [self.alertView addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
}
-(void)loadData{
    [[ZJNRequestManager sharedManager] postWithUrlString:GetThisCityClass parameters:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSMutableArray *countryList = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"][@"countryList"]) {
                ZJNAreaModel *model = [ZJNAreaModel yy_modelWithDictionary:dic];
                [countryList addObject:model];
            }
            NSMutableArray *provinceList = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"][@"provinceList"]) {
                ZJNAreaModel *model = [ZJNAreaModel yy_modelWithDictionary:dic];
                [provinceList addObject:model];
            }
            NSMutableArray *cityList = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"][@"cityList"]) {
                ZJNAreaModel *model = [ZJNAreaModel yy_modelWithDictionary:dic];
                [cityList addObject:model];
            }
            self.countryArr = countryList;
            self.pArr = provinceList;
            self.cArr = cityList;
            [self.pickerView reloadComponent:0];
            if (self.countryArr.count>0) {
                self.provinceModel = self.countryArr[0];
                [self getProvinceWithCountryModel:self.countryArr[0]];
            }
            
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
    return 3;
}
// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        // 返回省个数
        return self.countryArr.count;
    }
    if (component == 1) {
        // 返回市个数
        return self.provinceArr.count;
    }
    if (component == 2) {
        // 返回区个数
        return self.cityArr.count;
    }
    return 0;
}
#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.alertView.frame.size.width) / 3, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, (self.alertView.frame.size.width) / 3 - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (component == 0) {
        ZJNAreaModel *model = self.countryArr[row];
        label.text = model.areaname;
    }else if (component == 1){
        ZJNAreaModel *model = self.provinceArr[row];
        label.text = model.areaname;
    }else if (component == 2){
        ZJNAreaModel *model = self.cityArr[row];
        label.text = model.areaname;
    }
    return bgView;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (self.countryArr.count>0) {
            self.provinceModel = self.countryArr[row];
            [self getProvinceWithCountryModel:self.countryArr[row]];
        }
    }else if (component == 1){
        if (self.provinceArr.count>0) {
            self.cityModel = self.provinceArr[row];
            [self getCityWithProvinceModel:self.provinceArr[row]];
        }
    }else{
        if (self.cityArr.count>0) {
            self.areaModel = self.cityArr[row];
        }
    }
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
        self.resultBlock(self.provinceModel, self.cityModel, self.areaModel);
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

//根据国家 获得相应的省市
-(void)getProvinceWithCountryModel:(ZJNAreaModel *)countryModel{
    NSMutableArray *province = [NSMutableArray array];
    for (ZJNAreaModel *model in self.pArr) {
        if ([model.parentid isEqualToString:countryModel.areaid]) {
            [province addObject:model];
        }
    }
    self.provinceArr = province;
    [self.pickerView reloadComponent:1];
    if (self.provinceArr.count>0) {
        self.cityModel = self.provinceArr[0];
        [self getCityWithProvinceModel:self.provinceArr[0]];
    }else{
        self.areaModel = nil;
        self.cityModel = nil;
        self.cityArr = nil;
        [self.pickerView reloadComponent:2];
    }
    
}
-(void)getCityWithProvinceModel:(ZJNAreaModel *)provinceModel{
     NSMutableArray *city = [NSMutableArray array];
    for (ZJNAreaModel *model in self.cArr) {
        if ([model.parentid isEqualToString:provinceModel.areaid]) {
            [city addObject:model];
        }
    }
    self.cityArr = city;
    if (self.cityArr.count>0) {
        self.areaModel = self.cityArr[0];
    }else{
        self.areaModel = nil;
    }
    [self.pickerView reloadComponent:2];
}

- (void)testFunction{
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    [self didTapBackgroundView:nil];
    [self clickRightBtn];
    [self clickLeftBtn];
//    [self dismissWithAnimation:YES];
}

@end
