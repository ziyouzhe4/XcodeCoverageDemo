//
//  UNITaximeter.m
//  测试demo
//
//  Created by majianjie on 2020/9/24.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "UNITaximeter.h"
#import "UIView+Drag.h"
#import "Masonry.h"
#import "UNIPriceView.h"

@interface UNITaximeter ()

@property (nonatomic,strong)UIView *bgView;/// 背景

@property (nonatomic,strong)UIView *taximeterView;

@property (nonatomic,assign)CGFloat margin;

@property (nonatomic,strong)UILabel *preLabel;

@property (nonatomic,strong)UIImageView *circleImg;

@property (nonatomic,strong)UIImageView *goldCoinImg;

/// 价钱相关label
@property (nonatomic,strong)UNIPriceView *priceView;

@end


@implementation UNITaximeter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            NSMutableArray *mu = [NSMutableArray array];
//
//            [mu addObject:nil];
//
//        });
        
        
    }
    return self;
}

- (void)configUI{
    
    self.state = UNITaximeterBilling;
    self.backgroundColor = [UIColor clearColor];
    
    self.margin = 10;
    
    [self addSubview:self.bgView];
   
    [self.bgView addSubview:self.taximeterView];
   
    [self.taximeterView addSubview:self.preLabel];
    
    [self.taximeterView addSubview:self.goldCoinImg];
    
    [self.taximeterView addSubview:self.circleImg];
    
    [self.taximeterView addSubview:self.priceView];
    
    [self makeConstraint];
    
}

- (void)makeConstraint{
        
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(38);
    }];
    
    [self.taximeterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.margin);
        make.right.mas_equalTo(-self.margin);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.taximeterView.layer.cornerRadius = 6;
    self.taximeterView.layer.masksToBounds = YES;
    
    
    [self.preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(20);
    }];
    
    
    [self.circleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-9);
    }];
    
    
    [self.goldCoinImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.preLabel.mas_right).mas_offset(6);
        make.right.mas_equalTo(self.circleImg.mas_left).mas_offset(-6);
    }];
    
    [self.taximeterView bringSubviewToFront:self.goldCoinImg];
    [self startAnimation];
    
}

- (void)setPriceString:(NSString *)priceString{
    _priceString = priceString;
    
    self.state = UNITaximeterBilling;
    self.priceView.priceString = _priceString;  /// 设置这里后 就会跳回原位置
}

- (void)setState:(UNITaximeterState)state{
    _state = state;
    
    if (_state == UNITaximeterBilling) {
        [self startAnimation];
    }else{
        [self endAnimation];
    }
    
}

- (void)startAnimation{
 
    self.circleImg.image = [UIImage imageNamed:@"UNIBillingImage"];

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [self.circleImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];//开始动画
    
}

- (void)endAnimation{
    [self.circleImg.layer removeAnimationForKey:@"rotationAnimation"];//结束动画
    self.circleImg.image = [UIImage imageNamed:@"UNIEndChargeImage"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
    
    self.taximeterView.backgroundColor = [self gradientFromColor:ColorFrRGB(0x052A47) toColor:ColorFrRGB(0x114B85) withWidth:self.frame.size.width - 2 * self.margin andHeight:self.frame.size.height];
  
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIImageView *)circleImg{
    if (!_circleImg) {
        _circleImg = [[UIImageView alloc] init];
    }
    return _circleImg;
}

- (UIImageView *)goldCoinImg{
    if (!_goldCoinImg) {
        _goldCoinImg = [[UIImageView alloc] init];
        _goldCoinImg.image = [UIImage imageNamed:@"UNIGoldCoinImage"];
    }
    return _goldCoinImg;
}

- (UNIPriceView *)priceView{
    if (!_priceView) {
        _priceView = [[UNIPriceView alloc] init];
        _preLabel.dragType = DragTypeDisabled;
        _priceView.backgroundColor = [UIColor clearColor];
    }
    return _priceView;
}


- (UILabel *)preLabel{
    if (!_preLabel) {
        _preLabel = [[UILabel alloc] init];
        _preLabel.textAlignment = NSTextAlignmentCenter;
        _preLabel.text = @"星辰流水";
        _preLabel.font = [UIFont systemFontOfSize:9];
        _preLabel.numberOfLines = 2;
        _preLabel.textColor = ColorFrRGB(0xFAE0B4);
    }
    return _preLabel;
}

- (UIView *)taximeterView{
    if (!_taximeterView) {
        _taximeterView = [[UIView alloc] init];
        _taximeterView.backgroundColor = [UIColor redColor];
    }
    return _taximeterView;
}

- (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(CGFloat)width andHeight:(CGFloat)height{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, size.height), 0);
     
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
     
    return [UIColor colorWithPatternImage:image];
}



@end

