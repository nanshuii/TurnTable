//
//  LENColorSelectViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/12.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENColorSelectViewController.h"
#import "LENColorSelectImageView.h"

@interface LENColorSelectViewController ()

@end

@implementation LENColorSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)setUpUI{
    WEAKSELF(weakSelf);
    if (self.colors.count == 6) {
        int colorHex = [LENHandle getColorHexFormColors:self.colors];
        self.colorView.backgroundColor = UIColorFromHex(colorHex);
    }
    LENColorSelectImageView *imageView = [[LENColorSelectImageView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth - 20, kFullScreenWidth - 20)];
    [imageView setCurrentColorHex:^(int colorHex) {
        [weakSelf colorHandle:colorHex];
    }];
    [self.selectVIew addSubview:imageView];
}

- (void)colorHandle:(int)colorHex{
    self.colorView.backgroundColor = UIColorFromHex(colorHex);
    self.colors = [LENHandle getColorsFormColorHex:colorHex];
}

# pragma mark -- 取消
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -- 保存
- (IBAction)done:(id)sender {
    if (self.colors.count == 6) {
        NSDictionary *dict = @{
                               @"type": @"color",
                               @"colors": self.colors,
                               @"index": @(self.index)
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddTurnTableChange object:dict];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
