//
//  LENTurnTableHistoryViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/19.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableHistoryViewController.h"
#import "LENTurnHistoryTableViewCell.h"

@interface LENTurnTableHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *historys;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL editing;

@end

@implementation LENTurnTableHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)setUpUI{
    self.title = @"记录历史";
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItem:editItem];
    self.historys = [NSMutableArray arrayWithArray:self.model.historys];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

# pragma mark -- edit
- (void)edit{
    if (self.historys.count == 0) {
        self.editing = NO;
        self.tableView.editing = NO;
    } else {
        self.editing = !self.editing;
    }
    self.tableView.editing = self.editing;
}

# pragma mark -- tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LENTurnHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LENTurnHistoryTableViewCell class])];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LENTurnHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LENTurnHistoryTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.historys[indexPath.row];
    [cell configWithTitle:[dict valueForKey:@"title"] date:[dict valueForKey:@"date"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.historys.count > 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [self.historys removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    self.model.historys = self.historys;
    [LENHandle updateTurnTable:self.model];
    if (self.historys.count == 0) {
        self.editing = NO;
        self.tableView.editing = NO;
    }
}

@end
