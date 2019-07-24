//
//  LENTurnTableViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableViewController.h"
#import "LENTurnTableTableViewCell.h"
#import "LENAddTurnTableViewController.h"
#import "LENTurnTableShowViewController.h"
#import "LENSettingViewController.h"

@interface LENTurnTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LENTurnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.models = [NSMutableArray array];
    [self.models addObjectsFromArray:[LENHandle getTurnTables]];
    [self.tableView reloadData];
}

- (void)setUpUI{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:(UIBarButtonItemStyleDone) target:self action:@selector(add)];
    [self.navigationItem setLeftBarButtonItem:addItem];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStyleDone) target:self action:@selector(setting)];
    [self.navigationItem setRightBarButtonItem:settingItem];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

# pragma mark -- add
- (void)add{
    LENLog(@"add");
    LENAddTurnTableViewController *vc = [LENAddTurnTableViewController new];
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark -- setting
- (void)setting{
    LENLog(@"setting");
    LENSettingViewController *vc = [LENSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark -- tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LENTurnTableTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LENTurnTableTableViewCell class])];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LENTurnTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LENTurnTableTableViewCell" forIndexPath:indexPath];
    [cell configWithModel:self.models[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LENTurnTableShowViewController *vc = [LENTurnTableShowViewController new];
    LENTurnTableModel *model = self.models[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.models.count > 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    LENTurnTableModel *model = self.models[row];
    [LENHandle deleteTurnTableWithTid:model.t_id];
    [self.models removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
