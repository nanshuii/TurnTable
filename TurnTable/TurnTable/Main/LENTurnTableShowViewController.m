//
//  LENTurnTableShowViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/16.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableShowViewController.h"
#import "LENTurnTableView.h"
#import "LENAddTurnTableViewController.h"
#import "LENTurnTableHistoryViewController.h"

@interface LENTurnTableShowViewController ()

@property (nonatomic, strong) LENTurnTableView *turnTableView;

@property (nonatomic, strong) NSMutableArray *colors;

@property (nonatomic, copy) NSString *currentSelect;

@property (nonatomic, strong) NSMutableArray *historys;

@end

@implementation LENTurnTableShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reopen:) name:kTurnTableShowChange object:nil];
}

- (void)setUpUI{
    WEAKSELF(weakSelf);
    self.title = self.model.name;
    self.currentSelect = nil;
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"edit" style:(UIBarButtonItemStyleDone) target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItem:editItem];
    
    BOOL recordOpen = [LENHandle getTurnTableRecord];
    if (recordOpen == NO) {
        self.historyButton.enabled = NO;
        self.historySaveButton.enabled = NO;
    }
    
    self.colors = [LENHandle getColorsFormTurnTableModel:self.model];
    self.turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth - 20) titles:self.model.titles rates:self.model.rates colors:self.colors];
    [self.turnTableView setFoodBlock:^(NSString * _Nonnull title, int index) {
        LENLog(@"title = %@ index = %i", title, index);
        weakSelf.nameLabel.text = title;
        weakSelf.currentSelect = title;
    }];
    [self.contentView addSubview:self.turnTableView];
    self.nameLabel.text = self.model.name;
}

# pragma mark -- 转动
- (IBAction)run:(id)sender {
    [self.turnTableView startCycle];
}

# pragma mark -- 编辑
- (void)edit{
    self.menuView.hidden = !self.menuView.hidden;
}

// 编辑标题
- (IBAction)editName:(id)sender {
    WEAKSELF(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"编辑标题" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alert.textFields[0].text;
        if (text && ![text isEqualToString:@""]) {
            [LENHandle updateTurnTableName:text tid:weakSelf.model.t_id];
            weakSelf.nameLabel.text = text;
            weakSelf.menuView.hidden = YES;
        } else {
            [LENHandle alertWithMessage:@"请输入标题" vc:self];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.model.name;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

// 编辑罗盘
- (IBAction)editTurnTable:(id)sender {
    self.menuView.hidden = YES;
    self.currentSelect = nil;
    LENAddTurnTableViewController *vc = [LENAddTurnTableViewController new];
    vc.isNew = NO;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

// 保存配色
- (IBAction)saveColors:(id)sender {
    [LENHandle updateTurnTableColors:self.turnTableView.colors tid:self.model.t_id];
    self.model.colors = self.turnTableView.colors;
    self.menuView.hidden = YES;
}

// 菜单隐藏
- (IBAction)hiddenMenu:(id)sender {
    self.menuView.hidden = YES;
}

# pragma mark -- reopen
- (void)reopen:(NSNotification *)notification{
    WEAKSELF(weakSelf);
    self.model = (LENTurnTableModel *)notification.object;
    [self.turnTableView removeFromSuperview];
    self.turnTableView = nil;
    self.colors = [LENHandle getColorsFormTurnTableModel:self.model];
    self.turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth) titles:self.model.titles rates:self.model.rates colors:self.colors];
    [self.turnTableView setFoodBlock:^(NSString * _Nonnull title, int index) {
        LENLog(@"title = %@ index = %i", title, index);
        weakSelf.nameLabel.text = title;
        weakSelf.currentSelect = title;
    }];
    [self.contentView addSubview:self.turnTableView];
}

# pragma mark -- 记录
// 保存这次记录
- (IBAction)saveHistory:(id)sender {
    if (self.currentSelect) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        LENLog(@"title = %@ dateString = %@", self.currentSelect, dateString);
        NSMutableArray *historys = [NSMutableArray arrayWithArray:self.model.historys];
        NSDictionary *dict = @{
                               @"title": self.currentSelect,
                               @"date": dateString
                               };
        [historys insertObject:dict atIndex:0];
        self.model.historys = historys;
        [LENHandle updateTurnTable:self.model];
        [LENHandle alertWithMessage:@"保存成功" vc:self];
    } else {
        [LENHandle alertWithMessage:@"请转动" vc:self];
    }
}
// 查看记录
- (IBAction)history:(id)sender {
    LENTurnTableHistoryViewController *vc = [LENTurnTableHistoryViewController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
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
