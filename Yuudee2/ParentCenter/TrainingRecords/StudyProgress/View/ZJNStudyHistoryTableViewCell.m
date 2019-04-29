//
//  ZJNStudyHistoryTableViewCell.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNStudyHistoryTableViewCell.h"
@interface ZJNStudyHistoryTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIButton *moreBtn;
@end
@implementation ZJNStudyHistoryTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(ScreenWidth()*2/3.0);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-ScreenAdapter(32));
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_moreBtn setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = FontSize(14);
        [_moreBtn sizeToFit];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //交换button中title和image的位置
        _moreBtn.titleLabel.backgroundColor = _moreBtn.backgroundColor;
        _moreBtn.imageView.backgroundColor = _moreBtn.backgroundColor;
        CGFloat labelWidth = _moreBtn.titleLabel.width;
        CGFloat imageWith = _moreBtn.imageView.width;
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
    return _moreBtn;
}
#pragma mark-UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dayResultList.count>5?5:self.model.dayResultList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenAdapter(30);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    NSString *blueStr = [NSString stringWithFormat:@"第%ld次测试正确率：%@",indexPath.row+1,accStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:blueStr];
    NSRange blueRange = NSMakeRange([blueStr rangeOfString:accStr].location, [blueStr rangeOfString:accStr].length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:HexColor(0x01ceff) range:blueRange];
    [titleLabel setAttributedText:attrStr];
    return cell;
}

-(void)moreBtnClick{
    if (self.getMoreInfoBlock) {
        self.getMoreInfoBlock();
    }
}
-(void)setModel:(DayListModel *)model{
    _model = model;
    if (model.dayResultList.count>5) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)testFunction{
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView heightForRowAtIndexPath:path];
    [self tableView:self.tableView  cellForRowAtIndexPath:path];
    [self moreBtnClick];
}
@end
