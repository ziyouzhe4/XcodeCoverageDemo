//
//  UNITaximeter.h
//  测试demo
//
//  Created by majianjie on 2020/9/24.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    UNITaximeterBillingType,
    UNITaximeterEndChargeType,
} UNITaximeterStateType;


@interface UNITaximeter2 : UIView

@property (nonatomic,strong)NSString *priceString;
@property (nonatomic,assign)UNITaximeterStateType state;

@end

NS_ASSUME_NONNULL_END
