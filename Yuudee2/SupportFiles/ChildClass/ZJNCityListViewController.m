//
//  ZJNCityListViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/12.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNCityListViewController.h"
#import "ZJNCityModel.h"
@interface ZJNCityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy)NSArray *sectionArray;
@property (nonatomic ,copy)NSArray *dataArray;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)ZJNPhoneResultModel *baseDataModel;
@end

@implementation ZJNCityListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择手机号归属地";

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *kDic in dic[@"CityList"]) {
        ZJNCityModel *model = [ZJNCityModel yy_modelWithDictionary:kDic];
        [tempArr addObject:model];
    }
    [self getDataFromService];
    // Do any additional setup after loading the view.
}
-(void)getDataFromService{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Host,QCellCoreList];
    
    [[ZJNRequestManager sharedManager] getWithUrlString:urlStr success:^(id data) {
        
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            
            self.baseDataModel = [ZJNPhoneResultModel yy_modelWithJSON:data];
            
            NSMutableArray *baseData =  [NSMutableArray array];
            NSMutableArray *titleArr = [NSMutableArray array];
            [self.baseDataModel.data enumerateObjectsUsingBlock:^(ZJNPhoneAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ZJNPhoneAreaModel *model = [ZJNPhoneAreaModel yy_modelWithJSON:obj];
                //隐藏热门城市
                NSString *title = model.title;
                if (![title isEqualToString:@"热门城市"]) {
                    [titleArr addObject:model.title];
                }
                
                NSMutableArray *modelArr = [NSMutableArray array];
                
                [model.list enumerateObjectsUsingBlock:^(ZJNCityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    ZJNCityModel *cityModel = [ZJNCityModel yy_modelWithJSON:obj];
                    [modelArr addObject:cityModel];
                    
                }];
                
                model.list = [modelArr copy];
                [baseData addObject:model];
                
            }];
            self.sectionArray = [titleArr copy];
            self.baseDataModel.data = [baseData copy];
            [self.tableView reloadData];
        }else{
            
            [self showHint:data[@"msg"]];
            
        }
    } failure:^(NSError *error) {
        
        [self showHint:ErrorInfo];
        
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:HexColor(textColor())];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.baseDataModel.data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ZJNPhoneAreaModel *areaModel = self.baseDataModel.data[section];
    return areaModel.list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;//隐藏热门城市 防止客户再要求显示出来
    }
    return 32;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZJNPhoneAreaModel *areaModel = self.baseDataModel.data[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 32)];
    view.backgroundColor = HexColor(0xf7f7f7);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth()-15, 32)];
    titleLabel.font = FontSize(16);
    titleLabel.textColor = HexColor(textColor());
    titleLabel.text = areaModel.title;
    [view addSubview:titleLabel];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionArray;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = HexColor(0x9b9b9b);
        label.font = FontSize(12);
        label.tag = 10;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-ScreenAdapter(30));
        }];
    }
    ZJNPhoneAreaModel *areaModel = self.baseDataModel.data[indexPath.section];
    ZJNCityModel *model = areaModel.list[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = HexColor(textColor());
    cell.textLabel.font = FontSize(14);
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"+%@",model.phonePrefix];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJNPhoneAreaModel *areaModel = self.baseDataModel.data[indexPath.section];
    ZJNCityModel *model = areaModel.list[indexPath.row];
    if (self.changeAreaCodeBlock) {
        self.changeAreaCodeBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
