//
//  UNIPriceView.m
//  测试demo
//
//  Created by majianjie on 2020/10/9.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "UNIPriceView.h"
#import "UIView+Drag.h"
#import "Masonry.h"
#import "UNIIntegerView.h"

#define DINAlternateBoldFont(s)  ([UIFont fontWithName:@"DINAlternate-Bold" size:s]?:[UIFont systemFontOfSize:s])


@interface UNIPriceView ()

@property (nonatomic,strong)UILabel *pointFLabel;/// 小数点后 第一位
@property (nonatomic,strong)UILabel *pointSLabel;/// 小数点后 第二位
@property (nonatomic,strong)UIView *pointView;/// 小数点

@property (nonatomic,strong)UNIIntegerView *integerView;/// 小数点


@property (nonatomic,assign)int priceL;/// 整数部分
@property (nonatomic,assign)double priceS;/// 小数部分


@end


@implementation UNIPriceView

- (instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (void)setPriceString:(NSString *)priceString{
    
    _priceString = priceString;
    
    /// 整数部分
    self.priceL = floor([priceString doubleValue]);
    self.integerView.integer = self.priceL;

    /// 小数部分
    NSArray *array = [priceString componentsSeparatedByString:@"."];
    NSString *tempString;
    if (array.count == 1) {
        tempString = @"0";
    }else{
        tempString = [priceString componentsSeparatedByString:@"."].lastObject;
    }

    if (tempString.length <= 2) {
        if (tempString.length == 1) {
            self.pointFLabel.text = tempString;
            self.pointSLabel.text = @"0";
        }else{
            self.priceS = [tempString intValue];
            self.pointFLabel.text = [NSString stringWithFormat:@"%.f",floor(self.priceS/10)];
            self.pointSLabel.text = [NSString stringWithFormat:@"%.f",self.priceS - floor(self.priceS/10) * 10];
        }
    }else{

        int realPrice = [[tempString substringToIndex:2] intValue];
        self.pointFLabel.text = [NSString stringWithFormat:@"%.f",floor(realPrice/10)];
        self.pointSLabel.text = [NSString stringWithFormat:@"%.f",realPrice - floor(realPrice/10) * 10];
    }
    
}

- (void)configUI{
    
    [self addSubview:self.pointSLabel];
    
    [self addSubview:self.pointFLabel];
    
    [self addSubview:self.pointView];
    
    [self addSubview:self.integerView];
    
    
    [self makeConstraint];
}

- (void)makeConstraint{
    
    [self.pointSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(22);
    }];
    
    [self.pointFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.pointSLabel.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(22);
      }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.pointFLabel.mas_left).mas_offset(-2);
        make.bottom.mas_equalTo(-3);
        make.width.height.mas_equalTo(3);
    }];
    
    [self.integerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.pointView.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
}


#pragma mark 懒加载

- (UILabel *)pointFLabel{
    if (!_pointFLabel) {
        _pointFLabel = [[UILabel alloc] init];
        _pointFLabel.textColor = ColorFrRGB(0xFAE0B4);
        _pointFLabel.textAlignment = NSTextAlignmentCenter;
        _pointFLabel.font = DINAlternateBoldFont(18);

        _pointFLabel.backgroundColor = ColorFrRGB(0x46648C);
        _pointFLabel.layer.cornerRadius = 2;
        _pointFLabel.layer.masksToBounds = YES;
    }
    return _pointFLabel;
}

- (UILabel *)pointSLabel{
    if (!_pointSLabel) {
        _pointSLabel = [[UILabel alloc] init];
        _pointSLabel.textColor = ColorFrRGB(0xFAE0B4);
        _pointFLabel.font = DINAlternateBoldFont(18);

        _pointSLabel.textAlignment = NSTextAlignmentCenter;
        _pointSLabel.layer.cornerRadius = 2;
        _pointSLabel.layer.masksToBounds = YES;
        _pointSLabel.backgroundColor = ColorFrRGB(0x46648C);
    }
    return _pointSLabel;
}

- (UIView *)pointView{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = ColorFrRGB(0xFAE0B4);
        _pointView.layer.cornerRadius = 1.5;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

- (UNIIntegerView *)integerView{
    if (!_integerView) {
        _integerView = [[UNIIntegerView alloc] init];
    }
    return _integerView;
}


@end
