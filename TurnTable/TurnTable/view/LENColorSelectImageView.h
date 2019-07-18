//
//  LENColorSelectImageView.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/12.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CurrentColorHex)(int colorHex);

@interface LENColorSelectImageView : UIImageView

@property (nonatomic, copy) CurrentColorHex currentColorHex;

@end

NS_ASSUME_NONNULL_END
