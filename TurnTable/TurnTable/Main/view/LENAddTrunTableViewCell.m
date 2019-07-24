//
//  LENAddTrunTableViewCell.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENAddTrunTableViewCell.h"

@interface LENAddTrunTableViewCell()<UITextFieldDelegate>

@end

@implementation LENAddTrunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(LENAddTrunTableModel *)model{
    self.rateTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.rateTextField.text = [NSString stringWithFormat:@"%i", model.rate];
    self.messageTextField.text = model.message;
    if (model.colors.count == 0) {
        [self.colorButton setTitle:@"默认随机" forState:(UIControlStateNormal)];
        [self.colorButton setTitleColor:[UIColor magentaColor] forState:(UIControlStateNormal)];
        self.colorButton.backgroundColor = [UIColor clearColor];
    } else {
        [self.colorButton setTitle:@"" forState:(UIControlStateNormal)];
        //
        int value = [LENHandle getColorHexFormColors:model.colors];
        self.colorButton.backgroundColor = UIColorFromHex(value);
    }
    self.messageTextField.delegate = self;
    self.rateTextField.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNoti:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKeyboard) name:kRemoveTextFieldkeyboard object:nil];
}

# pragma mark -- 点击颜色
- (IBAction)colorButtonAction:(UIButton *)sender {
    if (_colorButtonBlock) {
        _colorButtonBlock();
    }
}

# pragma mark -- textField delegate
- (void)textFieldDidEndEditingNoti:(NSNotification *)noti{
    UITextField *textField = noti.object;
    if (textField == self.messageTextField) {
        LENLog(@"message = %@", self.messageTextField.text);
        if (_messageChangeBlock) {
            _messageChangeBlock(self.messageTextField.text);
        }
    } else if (textField == self.rateTextField) {
        LENLog(@"rate = %@", self.rateTextField.text);
        if (_rateChangeBlock) {
            _rateChangeBlock(self.rateTextField.text);
        }
    }
}

- (void)removeKeyboard{
    [self.messageTextField resignFirstResponder];
    [self.rateTextField resignFirstResponder];
}

- (void)removeNotifications{
    LENLog(@"remove notifications");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
