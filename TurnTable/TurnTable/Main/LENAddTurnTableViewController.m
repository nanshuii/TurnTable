//
//  LENAddTurnTableViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENAddTurnTableViewController.h"
#import "LENAddTrunTableViewCell.h"
#import "LENColorSelectViewController.h"
#import "LENTurnTablePreviewViewController.h"

@interface LENAddTurnTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation LENAddTurnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification:) name:kAddTurnTableChange object:nil];
}

- (void)setUpUI{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"save" style:(UIBarButtonItemStyleDone) target:self action:@selector(save)];
    [self.navigationItem setRightBarButtonItem:item];
    self.buttonsView.layer.borderColor = UIColorFromHex(0xE0E0E0).CGColor;
    self.buttonsView.layer.borderWidth = 1.0;
    self.models = [NSMutableArray array];
    if (self.isNew == NO) {
        self.title = self.model.name;
        [self modelToModels];
    } else {
        
    }
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

# pragma mark -- model to models
- (void)modelToModels{
    NSArray *titles = self.model.titles;
    NSArray *colors = self.model.colors;
    NSArray *rates = self.model.rates;
    for (int i = 0; i < titles.count; i++) {
        NSMutableArray *m_colors = colors[i];
        NSString *message = titles[i];
        int rate = [rates[i] intValue];
        LENAddTrunTableModel *m = [[LENAddTrunTableModel alloc] initOldModelWithColor:m_colors message:message rate:rate];
        [self.models addObject:m];
    }
}

# pragma mark -- 编辑
- (IBAction)edit:(id)sender {
    if (self.models.count == 0) {
        return;
    }
    self.tableView.editing = !self.tableView.editing;
}

# pragma mark -- 添加
- (IBAction)addAction:(id)sender {
    LENLog(@"add");
    if (self.tableView.editing) {
        self.tableView.editing = NO;
    }
    LENAddTrunTableModel *model = [[LENAddTrunTableModel alloc] initNewModel];
    [self.models addObject:model];
    [self.tableView reloadData];
}

# pragma mark -- tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LENAddTrunTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LENAddTrunTableViewCell class])];
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF(weakSelf);
    LENAddTrunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LENAddTrunTableViewCell class]) forIndexPath:indexPath];
    [cell configWithModel:self.models[indexPath.row]];
    [cell setMessageChangeBlock:^(NSString * _Nonnull message) {
        [weakSelf updateMessageWithIndexPath:indexPath message:message];
    }];
    [cell setRateChangeBlock:^(NSString * _Nonnull rate) {
        [weakSelf updateRateWithIndexPath:indexPath rate:rate];
    }];
    [cell setColorButtonBlock:^{
        [weakSelf updateColorWithIndexPath:indexPath];
    }];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.models removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    if (self.models.count == 0) {
        self.tableView.editing = NO;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LENAddTrunTableViewCell *cell1 = (LENAddTrunTableViewCell *)cell;
    [cell1 removeNotifications];
}

# pragma mark -- 更新message
- (void)updateMessageWithIndexPath:(NSIndexPath *)indexPath message:(NSString *)message{
    LENAddTrunTableModel *model = self.models[indexPath.row];
    model.message = message;
    [self.models replaceObjectAtIndex:indexPath.row withObject:model];
}

# pragma mark -- 更新rate
- (void)updateRateWithIndexPath:(NSIndexPath *)indexPath rate:(NSString *)rate{
    LENAddTrunTableModel *model = self.models[indexPath.row];
    model.rate = [rate intValue];
    [self.models replaceObjectAtIndex:indexPath.row withObject:model];
}

# pragma mark -- 更新颜色
- (void)updateColorWithIndexPath:(NSIndexPath *)indexPath{
    LENColorSelectViewController *vc = [LENColorSelectViewController new];
    LENAddTrunTableModel *model = self.models[indexPath.row];
    vc.colors = model.colors;
    vc.index = indexPath.row;
    [self presentViewController:vc animated:YES completion:nil];
}

# pragma mark -- modelCreate
- (void)modelCreateWithType:(int)type{
    BOOL save = YES;
    NSMutableArray *titles = [NSMutableArray new];
    NSMutableArray *colors = [NSMutableArray new];
    NSMutableArray *rates = [NSMutableArray new];
    for (LENAddTrunTableModel *m in self.models) {
        // 检查所有的东西中内容是否有空
        NSString *message = m.message;
        if (message == nil || [message isEqualToString:@""]) {
            save = NO;
            break;
        }
        [titles addObject:message];
        NSMutableArray *m_colors = m.colors;
        [colors addObject:m_colors];
        int rate = m.rate;
        [rates addObject:@(rate)];
    }
    if (save == NO) {
        [LENHandle alertWithMessage:@"内容不能为空" vc:self];
        return;
    }
    if (type == 0) {
        // 预览模式
        LENTurnTableModel *model = [LENTurnTableModel new];
        model.titles = titles;
        model.colors = colors;
        model.rates = rates;
        LENTurnTablePreviewViewController *vc = [LENTurnTablePreviewViewController new];
        vc.model = model;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        // 保存模式
        WEAKSELF(weakSelf);
        if (self.isNew) {
            [LENHandle alertWithTextField:@"取一个名字" vc:self callback:^(NSString * _Nonnull text) {
                [weakSelf saveModelWithTitles:titles colors:colors rates:rates name:text];
            }];
        } else {
            [weakSelf saveModelWithTitles:titles colors:colors rates:rates name:@""];
        }
    }
}

# pragma mark -- 预览
- (IBAction)preview:(id)sender {
    [self modelCreateWithType:0];
}

# pragma mark -- 保存
- (void)save{
    LENLog(@"Save");
    [self modelCreateWithType:1];
}

- (void)saveModelWithTitles:(NSMutableArray *)titles colors:(NSMutableArray *)colors rates:(NSMutableArray *)rates name:(NSString *)name{
    if (self.isNew) {
        self.model = [LENTurnTableModel new];
        self.model.t_id = [LENHandle currentDate];
        self.model.createDate = [LENHandle currentDate];
        self.model.status = @"0";
        self.model.name = name;
    }
    self.model.titles = titles;
    self.model.colors = colors;
    self.model.rates = rates;
    self.model.updateDate = [LENHandle currentDate];
    if (self.isNew) {
        [LENHandle saveTurnTable:self.model];
    } else {
        [LENHandle updateTurnTable:self.model];
        [[NSNotificationCenter defaultCenter] postNotificationName:kTurnTableShowChange object:self.model];
    }
    [LENHandle turnTableImageCreateWithModel:self.model];
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark -- notification update
- (void)updateNotification:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    NSString *type = [dict valueForKey:@"type"];
    if ([type isEqualToString:@"color"]) {
        NSMutableArray *colors = [dict valueForKey:@"colors"];
        NSInteger index = [[dict valueForKey:@"index"] integerValue];
        LENAddTrunTableModel *model = self.models[index];
        model.colors = colors;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }
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
