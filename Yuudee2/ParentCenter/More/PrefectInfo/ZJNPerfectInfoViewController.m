//
//  ZJNPerfectInfoViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPerfectInfoViewController.h"
#import "ZJNTextFieldTableViewCell.h"
#import "BRPickerView.h"
#import "ZJNPerfectInfoModel.h"
#import "ZJNPerfectSaveInfoModel.h"
#import "ZJNAddressPickerView.h"
#import "ZJNMedicalPickerView.h"
#import "ZJNMainAssessmentReviewController.h"
#import "ZJNParentCenterViewController.h"
@interface ZJNPerfectInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *imageNameArr;
    NSArray *placeHolderArr;
    
}
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIButton *loginButton;
@property (nonatomic ,strong)ZJNUserInfoModel *model;
@property (nonatomic ,strong)ZJNPerfectInfoModel *infoModel;
@property (nonatomic ,strong)ZJNPerfectSaveInfoModel *saveModel;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNPerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageNameArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    placeHolderArr = @[@"请输入儿童昵称",@"请选择性别",@"请选择出生日期",@"请选择长期居住地",@"请选择医学诊断",@"请选择或填写儿童第一语言",@"请选择或填写儿童第二语言",@"请选择父亲最高文化程度",@"请选择母亲最高文化程度",@"请选择目前尝试的训练及疗法"];
    NSString *saveType = [[NSUserDefaults standardUserDefaults] objectForKey:@"SAVETYPE"];
    if ([saveType isEqualToString:@"1"]) {
        NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        NSDictionary *save = [[NSUserDefaults standardUserDefaults] objectForKey:@"save"];
        self.infoModel = [ZJNPerfectInfoModel yy_modelWithDictionary:info];
        self.saveModel = [ZJNPerfectSaveInfoModel yy_modelWithDictionary:save];
        if (!self.infoModel) {
            self.infoModel = [[ZJNPerfectInfoModel alloc]init];
        }
        if (!self.saveModel) {
            self.saveModel = [[ZJNPerfectSaveInfoModel alloc]init];
        }
    }else{
        self.infoModel = [[ZJNPerfectInfoModel alloc]init];
        self.saveModel = [[ZJNPerfectSaveInfoModel alloc]init];
    }
    
    _model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    
    [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScreenAdapter(195)+AddNav());
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(22));
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(greetingTextFieldChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    // Do any additional setup after loading the view.
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTitle:@"完善训练儿童个人信息" textColor:HexColor(textColor()) font:FontSize(16) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _titleLabel;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [self tableFooterView];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
-(UIView *)tableFooterView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenAdapter(120))];
    UIButton *_loginButton = [UIButton itemWithTitle:@"完成" titleColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(loginBtnClick)];
    [_loginButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
    _loginButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
//    _loginButton.userInteractionEnabled = NO;
    [bgView addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(ScreenAdapter(28));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    return bgView;
}
#pragma mark-UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenAdapter(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellid = @"cellid";
    NSString *cellid = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    ZJNTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textField.imageName = imageNameArr[indexPath.row];
    cell.textField.placeholder = placeHolderArr[indexPath.row];
    [cell.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    if (indexPath.row != 0) {
        cell.coverView.hidden = NO;
    }else{
        cell.coverView.hidden = YES;
    }
    cell.textField.delegate = self;
    if (indexPath.row == 0) {
        cell.textField.text = self.saveModel.name;
    }else if (indexPath.row == 1){
        cell.textField.text = self.saveModel.sex;
    }else if (indexPath.row == 2){
        cell.textField.text = self.saveModel.birthdate;
    }else if (indexPath.row == 3){
        cell.textField.text = self.saveModel.address;
    }else if (indexPath.row == 4){
        cell.textField.text = self.saveModel.medical;
    }else if (indexPath.row == 5){
        cell.textField.text = self.saveModel.firstLanguage;
    }else if (indexPath.row == 6){
        cell.textField.text = self.saveModel.secondLanguage;
    }else if (indexPath.row == 7){
        cell.textField.text = self.saveModel.fatherCulture;
    }else if (indexPath.row == 8){
        cell.textField.text = self.saveModel.motherCulture;
    }else{
        cell.textField.text = self.saveModel.trainingMethod;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        //选择性别
        [self showStrTitleWithTitle:@"选择性别" optionArray:@[@"男",@"女"] indexPath:indexPath];
    }else if (indexPath.row == 2){
        //选择出生日期
        [self setDatePicker];
    }else if (indexPath.row == 3){
        //选择长期居住地
        [self setPickerView];
    }else if (indexPath.row == 4){
        //选择医学诊断
//        [self showStrTitleWithTitle:@"医学诊断" optionArray:@[@"自闭症：轻",@"自闭症：中",@"自闭症：重",@"自闭症：不清楚",@"语言发育迟缓（其他正常）",@"单纯性智力低下（无自闭症状）",@"其他诊断",@"正常"] indexPath:indexPath];
        [self setMedicalPickerView];
    }else if (indexPath.row == 5){
        //儿童第一语言
        [self showStrTitleWithTitle:@"儿童第一语言" optionArray:@[@"普通话",@"方言",@"其他语言"] indexPath:indexPath];
    }else if (indexPath.row == 6){
        //儿童第二语言
        [self showStrTitleWithTitle:@"儿童第二语言" optionArray:@[@"普通话",@"方言",@"其他语言"] indexPath:indexPath];
    }else if (indexPath.row == 7){
        //父亲文化程度
        [self showStrTitleWithTitle:@"父亲文化程度" optionArray:@[@"小学-高中",@"大学",@"硕士研究生",@"博士或类似"] indexPath:indexPath];
    }else if (indexPath.row == 8){
        //母亲文化程度
        [self showStrTitleWithTitle:@"母亲文化程度" optionArray:@[@"小学-高中",@"大学",@"硕士研究生",@"博士或类似"] indexPath:indexPath];
    }else if (indexPath.row == 9){
        //尝试的训练及疗法
        [self showStrTitleWithTitle:@"尝试的训练及疗法" optionArray:@[@"ABA训练",@"其他疗法训练",@"无训练"] indexPath:indexPath];
    }
}
#pragma mark-输入框代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    ZJNTextFieldTableViewCell *cell = (ZJNTextFieldTableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //拼音九键的本质 其实也是在输入符号
    if ([NSString isNineKeyBoard:string]) {
        return YES;
    }else{
        if ([NSString isContainsEmoji:string]) {
            return NO;
        }
    }
    
//    if (range.length == 1 && string.length == 0) {
//        return YES;
//    }else if (textField.text.length>=13) {
//        textField.text = [textField.text substringToIndex:13];
//        return NO;
//    }else{
        BOOL isV = [NSString validateNickName:string];
        if (isV) {
            if (indexPath.row == 0) {
                [self showHint:@"请输入字母，数字或文字形式的儿童昵称"];
            }else{
                [self showHint:@"请输入字母，数字或文字"];
            }
            return NO;
        }
//    }
    return YES;

}

-(void)setDatePicker{
    NSDate *maxDate = [NSDate date];
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:6 defaultSelValue:nil minDate:[NSDate dateWithTimeIntervalSince1970:0] maxDate:maxDate isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd"]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        
        NSDate* date = [formatter dateFromString:selectValue];
        NSString *currentDateString = [formatter stringFromDate:date];
        
        NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
        NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
        NSLog(@"%@___%@",currentDateString,timeString);
        ZJNTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.textField.text = currentDateString;
        self.infoModel.birthdate = currentDateString;
        self.saveModel.birthdate = currentDateString;
    } cancelBlock:^{
        NSLog(@"点击了背景或取消按钮");
    }];
}
-(void)setMedicalPickerView{
    [ZJNMedicalPickerView showZJNMedicalPickerViewWithResultBlock:^(NSString * _Nonnull medical) {
        ZJNTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        //诊断结果
        cell.textField.text = medical;
        NSString *value = medical;
        self.saveModel.medical = medical;
        if ([value containsString:@"轻"]) {
            self.infoModel.medical = @"0";
            self.infoModel.medicalState = @"0";
        }else if ([value containsString:@"中"]){
            self.infoModel.medical = @"0";
            self.infoModel.medicalState = @"1";
        }else if ([value containsString:@"重"]){
            self.infoModel.medical = @"0";
            self.infoModel.medicalState = @"2";
        }else if ([value containsString:@"不清楚"]){
            self.infoModel.medical = @"0";
            self.infoModel.medicalState = @"3";
        }else if ([value containsString:@"其他正常"]){
            self.infoModel.medical = @"1";
            self.infoModel.medicalState = @"";
        }else if ([value containsString:@"单纯"]){
            self.infoModel.medical = @"2";
            self.infoModel.medicalState = @"";
        }else if ([value isEqualToString:@"正常"]){
            self.infoModel.medical = @"4";
            self.infoModel.medicalState = @"";
        }else{
            self.infoModel.medical = @"3";
            self.infoModel.medicalState = @"";
            cell.textField.text = nil;
            [cell.textField becomeFirstResponder];
        }
    }];
}
-(void)setPickerView{
    [ZJNAddressPickerView showZJNAddressPickerViewWithResultBlock:^(ZJNAreaModel * _Nonnull province, ZJNAreaModel * _Nonnull city, ZJNAreaModel * _Nonnull area) {

        ZJNTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.textField.text = [NSString stringWithFormat:@"%@-%@-%@",SetStr(province.areaname),SetStr(city.areaname),SetStr(area.areaname)];
        self.saveModel.address = [NSString stringWithFormat:@"%@-%@-%@",SetStr(province.areaname),SetStr(city.areaname),SetStr(area.areaname)];
        self.infoModel.countiyId = province.areaid;
        self.infoModel.provinceId = city.areaid;
        self.infoModel.cityId = area.areaid;
    }];

}

-(void)showStrTitleWithTitle:(NSString *)title optionArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath{
    
    [BRStringPickerView showStringPickerWithTitle:title dataSource:array defaultSelValue:array[0] resultBlock:^(id selectValue) {
        
        ZJNTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1){
            //性别
            cell.textField.text = selectValue;
            self.saveModel.sex = selectValue;
            if ([selectValue isEqualToString:@"男"]) {
                self.infoModel.sex = @"0";
            }else{
                self.infoModel.sex = @"1";
            }
        }else if (indexPath.row == 5) {
            //第一语言
            if ([selectValue isEqualToString:@"其他语言"]) {
                self.infoModel.firstLanguage = @"10";
                self.infoModel.firstRests = @"";
                self.saveModel.firstLanguage = @"";
                cell.textField.text = nil;
                [cell.textField becomeFirstResponder];
            }else{
                cell.textField.text = selectValue;
                self.saveModel.firstLanguage = selectValue;
                if ([selectValue isEqualToString:@"普通话"]) {
                    self.infoModel.firstLanguage = @"0";
                    self.infoModel.firstRests = @"";
                }else{
                    self.infoModel.firstLanguage = @"1";
                    self.infoModel.firstRests = @"";
                }
            }
        }else if (indexPath.row == 6){
            //第二语言
            if ([selectValue isEqualToString:@"其他语言"]) {
                self.infoModel.secondLanguage = @"10";
                cell.textField.text = nil;
                self.infoModel.secondRests = @"";
                self.saveModel.secondLanguage = @"";
                [cell.textField becomeFirstResponder];
            }else{
                cell.textField.text = selectValue;
                self.saveModel.secondLanguage = selectValue;
                if ([selectValue isEqualToString:@"普通话"]) {
                    self.infoModel.secondLanguage = @"0";
                    self.infoModel.secondRests = @"";
                }else{
                    self.infoModel.secondLanguage = @"1";
                    self.infoModel.secondRests = @"";
                }
            }
        }else if (indexPath.row == 7){
            //父亲最高文化程度
            cell.textField.text = selectValue;
            self.saveModel.fatherCulture = selectValue;
            if([selectValue isEqualToString:@"小学-高中"]){
                self.infoModel.fatherCulture = @"0";
            }else if ([selectValue isEqualToString:@"大学"]){
                self.infoModel.fatherCulture = @"1";
            }else if ([selectValue isEqualToString:@"硕士研究生"]){
                self.infoModel.fatherCulture = @"2";
            }else{
                self.infoModel.fatherCulture = @"3";
            }
        }else if (indexPath.row == 8){
            //母亲最高文化程度
            cell.textField.text = selectValue;
            self.saveModel.motherCulture = selectValue;
            if([selectValue isEqualToString:@"小学-高中"]){
                self.infoModel.motherCulture = @"0";
            }else if ([selectValue isEqualToString:@"大学"]){
                self.infoModel.motherCulture = @"1";
            }else if ([selectValue isEqualToString:@"硕士研究生"]){
                self.infoModel.motherCulture = @"2";
            }else{
                self.infoModel.motherCulture = @"3";
            }
        }else if (indexPath.row == 9){
            //目前尝试的训练及疗法
            if ([selectValue isEqualToString:@"其他疗法训练"]) {
                [cell.textField becomeFirstResponder];
                cell.textField.text = nil;
                self.infoModel.trainingMethod = @"2";
            }else{
                cell.textField.text = selectValue;
                self.saveModel.trainingMethod = selectValue;
                if ([selectValue isEqualToString:@"ABA训练"]) {
                    self.infoModel.trainingMethod = @"1";
                    self.infoModel.trainingRests = @"";
                }else{
                    self.infoModel.trainingMethod = @"3";
                    self.infoModel.trainingRests = @"";
                }
            }
        }else{
            
        }
    }];
}
-(void)textFieldValueChanged:(UITextField *)textField{
    ZJNTextFieldTableViewCell *cell = (ZJNTextFieldTableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        self.saveModel.name = textField.text;
        self.infoModel.name = textField.text;
    }else if (indexPath.row == 4){
        self.saveModel.medical = textField.text;
        self.infoModel.medicalState = textField.text;
    }else if (indexPath.row == 5){
        self.saveModel.firstLanguage = textField.text;
        self.infoModel.firstRests = textField.text;
    }else if (indexPath.row == 6){
        self.saveModel.secondLanguage = textField.text;
        self.infoModel.secondRests = textField.text;
    }else if (indexPath.row == 9){
        self.saveModel.trainingMethod = textField.text;
        self.infoModel.trainingRests = textField.text;
    }
}
-(void)homeBtnClick{
    //填写儿童信息时 中途退出 需要保存填写的信息，这里直接保存到本地，下次进来从本地获取信息 然后展示上次填写的信息。当SAVETYPE = 1时 说明用户之前填写过信息 中途退出了，如果不等于1说明用户第一次进来这个页面。
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SAVETYPE"];
    [self saveInfoWithState:@"0"];
    
}
-(void)loginBtnClick{
    if (self.infoModel.name.length == 0) {
        [self showHint:@"请输入儿童昵称"];
        return;
    }
    if (self.infoModel.sex.length == 0) {
        [self showHint:@"请选择性别"];
        return;
    }
    if (self.infoModel.birthdate.length == 0) {
        [self showHint:@"请选择出生日期"];
        return;
    }
    if (self.infoModel.countiyId.length == 0) {
        [self showHint:@"请选择长期居住地"];
        return;
    }
    if (self.infoModel.medical.length == 0) {
        [self showHint:@"请选择医学诊断"];
        return;
    }
    if ([self.infoModel.medical isEqualToString:@"3"] && self.infoModel.medicalState.length == 0) {
        [self showHint:@"请选择医学诊断"];
        return;
    }
    
    if (self.infoModel.firstLanguage.length == 0) {
        [self showHint:@"请选择或填写儿童第一语言"];
        return;
    }
    if ([self.infoModel.firstLanguage isEqualToString:@"10"]) {
        if (self.infoModel.firstRests.length == 0) {
            [self showHint:@"请选择或填写儿童第一语言"];
            return;
        }
    }
    
    if (self.infoModel.secondLanguage.length == 0) {
        [self showHint:@"请选择或填写儿童第二语言"];
        return;
    }
    if ([self.infoModel.secondLanguage isEqualToString:@"10"]) {
        if (self.infoModel.secondRests.length == 0) {
            [self showHint:@"请选择或填写儿童第二语言"];
            return;
        }
    }

    if (self.infoModel.fatherCulture.length == 0) {
        [self showHint:@"请选择父亲最高文化程度"];
        return;
    }
    if (self.infoModel.motherCulture.length == 0) {
        [self showHint:@"请选择母亲最高文化程度"];
        return;
    }
    if (self.infoModel.trainingMethod.length == 0) {
        [self showHint:@"请选择目前尝试的训练及疗法"];
        return;
    }
    if ([self.infoModel.trainingMethod isEqualToString:@"2"]&&self.infoModel.trainingRests.length == 0) {
        [self showHint:@"请选择目前尝试的训练及疗法"];
        return;
    }
    
    [self saveInfoWithState:@"1"];
}
-(void)saveInfoWithState:(NSString *)state{

    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken],@"name":SetStr(self.infoModel.name),@"sex":SetStr(self.infoModel.sex),@"birthdate":SetStr(self.infoModel.birthdate),@"medical":SetStr(self.infoModel.medical),@"medicalState":SetStr(self.infoModel.medicalState),@"firstLanguage":SetStr(self.infoModel.firstLanguage),@"firstRests":SetStr(self.infoModel.firstRests),@"secondLanguage":SetStr(self.infoModel.secondLanguage),@"secondRests":SetStr(self.infoModel.secondRests),@"fatherCulture":SetStr(self.infoModel.fatherCulture),@"motherCulture":SetStr(self.infoModel.motherCulture),@"trainingMethod":SetStr(self.infoModel.trainingMethod),@"trainingRests":SetStr(self.infoModel.trainingRests),@"countiyId":SetStr(self.infoModel.countiyId),@"provinceId":SetStr(self.infoModel.provinceId),@"cityId":SetStr(self.infoModel.cityId),@"states":state};
    [self showHudInView:self.view hint:nil];
    [[ZJNRequestManager sharedManager] postWithUrlString:AddChild parameters:dic success:^(id data) {
        if (self.success) {
            self.success(data);
        }
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            //完善儿童信息成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshName" object:nil];
            if ([state isEqualToString:@"1"]) {
                self.model.IsRemind = @"2";
                self.model.chilName = self.infoModel.name;
                [[ZJNFMDBManager shareManager] updateCurrentUserInfoWithModel:self.model];
                ZJNMainAssessmentReviewController *viewC = [[ZJNMainAssessmentReviewController alloc]init];
                [self.navigationController pushViewController:viewC animated:YES];
                [self showHint:data[@"msg"]];
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SAVETYPE"];
            }else{

                NSDictionary *infoDic = [self.infoModel yy_modelToJSONObject];
                NSDictionary *saveDic = [self.saveModel yy_modelToJSONObject];
                [[NSUserDefaults standardUserDefaults] setObject:infoDic forKey:@"info"];
                [[NSUserDefaults standardUserDefaults] setObject:saveDic forKey:@"save"];
                if ([self.pushFrom isEqualToString:@"register"]) {
                    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
                    ZJNParentCenterViewController *viewC = [[ZJNParentCenterViewController alloc]init];
                    viewC.pushType = FormRegister;
                    delegate.window.rootViewController = [[ZJNNavigationController alloc]initWithRootViewController:viewC];;
                    
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            [self showHint:data[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.navigationController popViewControllerAnimated:YES];
        [self showHint:ErrorInfo];
        [self hideHud];
        if (self.failure) {
            self.failure(error);
        }
    }];
}
-(void)setPushFrom:(NSString *)pushFrom{
    _pushFrom = pushFrom;
}

-(void)greetingTextFieldChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式n
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > 13) {
                textField.text = [toBeString substringToIndex:13];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > 13) {
            textField.text= [toBeString substringToIndex:13];
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)testAddChild:(NSString *)token userName:(NSString *)name success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    [self homeBtnClick];
    [self loginBtnClick];
}

@end
