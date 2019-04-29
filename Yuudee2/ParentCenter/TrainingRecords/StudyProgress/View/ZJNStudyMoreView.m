//
//  ZJNStudyMoreView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNStudyMoreView.h"
@interface ZJNStudyMoreView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIButton *closeBtn;
@property (nonatomic ,strong)UIView   *titleView;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UILabel  *timeLabel;
@end
@implementation ZJNStudyMoreView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(0, 0, 0, 0.7);
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(340), ScreenAdapter(977/2.0)));
        }];
        
        [self addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView).offset(ScreenAdapter(22));
            make.left.right.equalTo(self.bgImageView);
            make.height.mas_equalTo(ScreenAdapter(30));
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImageView).insets(UIEdgeInsetsMake(ScreenAdapter(52), ScreenAdapter(10), ScreenAdapter(22), ScreenAdapter(10)));
        }];
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView).offset(ScreenAdapter(30));
            make.right.equalTo(self.bgImageView).offset(-ScreenAdapter(15));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(30), ScreenAdapter(30)));
        }];
    }
    return self;
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView itemWithImage:SetImage(@"more_bg") backColor:nil];
    }
    return _bgImageView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:SetImage(@"button_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIView *)titleView{
    if (!_titleView) {
        UIView *bgView = [[UIView alloc]init];
        UILabel *titleLabel = [UILabel createLabelWithTitle:@"" textColor:HexColor(textColor()) font:FontSize(13) textAlignment:NSTextAlignmentCenter numberOfLines:1];
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(ScreenAdapter(40));
            make.bottom.equalTo(bgView);
            
        }];
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = HexColor(textColor());
        dotView.layer.cornerRadius = 2.5;
        dotView.layer.masksToBounds = YES;
        [bgView addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(titleLabel.mas_left).offset(-ScreenAdapter(10));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
        }];
        
        _titleView = bgView;
        _timeLabel = titleLabel;
    }
    return _titleView;
}
#pragma mark-UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dayResultList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenAdapter(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UILabel *titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
        titleLabel.tag = 10;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView).offset(5);
            make.left.equalTo(cell.contentView).offset(ScreenAdapter(35));
        }];
    }
    ZJNStudyModel *model = self.model.dayResultList[indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    cell.backgroundColor = [UIColor clearColor];
    CGFloat acc = 100*[model.accuracy floatValue];
    NSString *accStr = [NSString stringWithFormat:@"%.f%%",acc];
    titleLabel.text = [NSString stringWithFormat:@"第%ld次测试正确率：%@",indexPath.row+1,accStr];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)setModel:(DayListModel *)model{
    _model = model;
    CGFloat studyTime = [self.model.studyTime floatValue];
    NSString *mTime = [NSString stringWithFormat:@"%.2f",studyTime/60.0];
    self.timeLabel.text = [NSString stringWithFormat:@"%@（学习时间%@分钟）",[NSString changeDateWithDateStr:[model.time integerValue]],mTime];
    [self.tableView reloadData];
}
-(void)closeBtnClick{
    [self removeFromSuperview];
}

- (void)testFunctionWithModel:(ZJNStudyModel *)model{
    self.model.dayResultList = @[model,model];
    self.model.studyTime = @"18878977700";
    self.model.time = @"19878998000";
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView heightForRowAtIndexPath:path];
    [self tableView:self.tableView cellForRowAtIndexPath:path];
    [self closeBtnClick];
}

@end
