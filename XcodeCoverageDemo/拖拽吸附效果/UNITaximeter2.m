//
//  UNITaximeter.m
//  测试demo
//
//  Created by majianjie on 2020/9/24.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "UNITaximeter2.h"
#import "UIView+Drag.h"
#import "Masonry.h"
#import "UNIPriceView.h"
#import "Lottie.h"

@interface UNITaximeter2 ()

@property (nonatomic,strong)UIView *bgView;/// 背景

@property (nonatomic,strong)UIView *taximeterView;

@property (nonatomic,assign)CGFloat margin;

@property (nonatomic,strong)UILabel *preLabel;

//@property (nonatomic,strong)UIImageView *circleImg;
//@property (nonatomic,strong)UIImageView *goldCoinImg;

@property (nonatomic, strong) UIImageView *defaultImageView;

@property (nonatomic, strong) LOTAnimationView *circleLottieView;
@property (nonatomic, strong) LOTAnimationView *flyLottieView;
@property (nonatomic, strong) NSMutableArray *changingNumberQueue;



/// 价钱相关label
@property (nonatomic,strong)UNIPriceView *priceView;

@end


@implementation UNITaximeter2

- (instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    self.dragType = DragTypePullOver;
    self.dragInBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.changingNumberQueue = [[NSMutableArray alloc] init];

    
    self.margin = 10;
    
    [self addSubview:self.bgView];
   
    [self.bgView addSubview:self.taximeterView];
   
    [self.taximeterView addSubview:self.preLabel];
    
    
    [self.taximeterView addSubview:self.defaultImageView];
    self.defaultImageView.hidden = YES;
    
    [self.taximeterView addSubview:self.circleLottieView];
    
    [self.taximeterView addSubview:self.flyLottieView];
    
    [self.circleLottieView play];
    
    [self.taximeterView addSubview:self.priceView];
    
    [self makeConstraint];
    
}

- (void)makeConstraint{
        
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
        make.width.mas_equalTo(26);
    }];
    
    
    [self.circleLottieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(60);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    
    [self.flyLottieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(59);
        make.width.mas_equalTo(98);
        make.right.equalTo(self.circleLottieView.mas_right);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(self.preLabel.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.circleLottieView.mas_left).mas_offset(-5);
    }];

}

- (void)setPriceString:(NSString *)priceString{
    
    [self makeChangingFrom:[self.priceView.priceString floatValue] to:[priceString floatValue]];

    _priceString = priceString;
    
    self.state = UNITaximeterBillingType;
//    self.priceView.priceString = _priceString;
    
}

- (void)setState:(UNITaximeterStateType)state{
    _state = state;
    
    [self updateUI];
}

- (void)makeChangingFrom:(float)from to:(float)to {
    if (to < from) return;
    [self.changingNumberQueue removeAllObjects];
    [self makeChangingNumbersFrom:from to:to];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(makeNextChaning) object:nil];
    [self makeNextChaning];
}

- (void)makeNextChaning {
    if (!self.changingNumberQueue || self.changingNumberQueue.count == 0) {
        return;
    }
    NSNumber *number = [self.changingNumberQueue firstObject];
    [self.changingNumberQueue removeObjectAtIndex:0];
    [self updateEarning:number.floatValue];
    [self performSelector:@selector(makeNextChaning) withObject:nil afterDelay:0.05];
}

- (void)updateEarning:(float)number {
    
    [self makeOnlineLottieRunning:^{
        
    }];
    
    
    self.priceView.priceString = [NSString stringWithFormat:@"%.2f",number];
    
    
}

- (void)makeChangingNumbersFrom:(float)from to:(float)to {
    if (to < from) return;
    NSInteger time = 10;
    float d = 0.01;
    float diff = to - from;

    if (diff < d * time) {
        time = (NSInteger)(diff / d);
    }
    else {
        d = diff / (float)time;
    }
    for (NSInteger i = 0; i <= time; i++) {
        if (i == 0) {
            [self.changingNumberQueue addObject:[NSNumber numberWithFloat:from]];
        }
        else if (i == time) {
            [self.changingNumberQueue addObject:[NSNumber numberWithFloat:to]];
        }
        else {
            [self.changingNumberQueue addObject:[NSNumber numberWithFloat:from + d * i]];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.taximeterView.backgroundColor = [self gradientFromColor:ColorFrRGB(0x052A47) toColor:ColorFrRGB(0x114B85) withWidth:self.frame.size.width - 2 * self.margin andHeight:self.frame.size.height];
}

- (void)updateOnlineEarning:(NSString *)onlineEarning otherEarning:(NSString *)otherEarning {
    
    __weak typeof(self) weakSelf = self;
    [self makeOnlineLottieRunning:^{
        
        [weakSelf updateUI];
        
    }];
}

- (void)updateUI{
    
    if (self.state == UNITaximeterBillingType) {
        self.defaultImageView.hidden = YES;
        [self.circleLottieView play];
        self.circleLottieView.hidden = NO;
        self.flyLottieView.hidden = NO;
        
        if (self.priceView) {
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.circleLottieView.mas_left).mas_offset(-5);
            }];
        }
        
    }else{
        self.defaultImageView.hidden = NO;
        [self.circleLottieView stop];
        self.circleLottieView.hidden = YES;
        [self.flyLottieView stop];
        self.flyLottieView.hidden = YES;
        
        [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.defaultImageView.mas_left).mas_offset(-5);
        }];
        
    }
    
}

- (void)makeOnlineLottieRunning:(void(^)(void))completion {
    [self.flyLottieView playFromProgress:0 toProgress:1 withCompletion:^(BOOL animationFinished) {
        if (completion) {
            completion();
        }
    }];
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UNIPriceView *)priceView{
    if (!_priceView) {
        _priceView = [[UNIPriceView alloc] init];
        _priceView.backgroundColor = [UIColor clearColor];
    }
    return _priceView;
}


- (UILabel *)preLabel{
    if (!_preLabel) {
        _preLabel = [[UILabel alloc] init];
        _preLabel.textAlignment = NSTextAlignmentCenter;
        _preLabel.text = @"星辰流水";
        _preLabel.font = [UIFont systemFontOfSize:11];
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

- (LOTAnimationView *)circleLottieView {
    if (!_circleLottieView) {
        _circleLottieView = [LOTAnimationView animationNamed:@"x-xingchen-circle.json"];
        _circleLottieView.contentMode = UIViewContentModeScaleAspectFill;
        _circleLottieView.clipsToBounds = YES;
        _circleLottieView.loopAnimation = YES;
    }
    return _circleLottieView;
}


- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        _defaultImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"UNIEndChargeImage"];
            imageView;
        });
    }
    return _defaultImageView;
}

- (LOTAnimationView *)flyLottieView {
    if (!_flyLottieView) {
        _flyLottieView = [LOTAnimationView animationNamed:@"x-xingchen-coinfly.json"];
        _flyLottieView.contentMode = UIViewContentModeScaleAspectFill;
        _flyLottieView.clipsToBounds = YES;
        _flyLottieView.loopAnimation = NO;
        _flyLottieView.animationSpeed = 0.8;
    }
    return _flyLottieView;
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
