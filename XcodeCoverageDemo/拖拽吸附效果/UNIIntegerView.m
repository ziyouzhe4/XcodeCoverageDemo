//
//  UNIIntegerView.m
//  测试demo
//
//  Created by majianjie on 2020/10/9.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "UNIIntegerView.h"
#import "UIView+Drag.h"
#import "Masonry.h"

#define DINAlternateBoldFont(s)  ([UIFont fontWithName:@"DINAlternate-Bold" size:s]?:[UIFont systemFontOfSize:s])

@interface UNIIntegerView ()

@end

@implementation UNIIntegerView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self configUI];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)configUI{
    NSLog(@"do nothing %s",__func__);
}

- (void)setInteger:(int)integer{
    
    _integer = integer;
    
    [self installUI];
    
}

- (void)installUI{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger sum = 0;
    int temp = self.integer;
    
    UILabel *last;
    while(temp >= 1 ) {
        
        int num = temp % 10;
        UILabel *label = [self createLabelWithTitle:[NSString stringWithFormat:@"%d",num]];
        [self addSubview:label];
        label.restorationIdentifier = @"99999999999";

        temp = temp / 10;
        sum = sum + 1;
        
        if (sum == 1) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.width.mas_equalTo(14);
                make.top.bottom.mas_equalTo(0);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(last.mas_left).mas_offset(-2);
                make.width.mas_equalTo(14);
                make.top.bottom.mas_equalTo(0);
            }];
        }
        
        last = label;
    }
    
    if (sum == 2) {
        /// 补位
        [self placeHolderView:1 lastView:last];
    }else if (sum == 1){
        /// 补位
        [self placeHolderView:2 lastView:last];
    }else if(sum == 0){
        /// 补位
        [self placeHolderView:3 lastView:nil];
    }else{
        [last mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    }
    
}

- (void)placeHolderView:(int)count lastView:(UILabel *)lastView{
    
    for (int i = 0; i < count; i++) {
        
        UILabel *label = [self createLabelWithTitle:@"0"];
        
        [self addSubview:label];
        
        if (lastView) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(lastView.mas_left).mas_offset(-2);
                make.width.mas_equalTo(14);
                make.top.bottom.mas_equalTo(0);
            }];
            
            lastView  = label;
            
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.width.mas_equalTo(14);
                make.top.bottom.mas_equalTo(0);
            }];
            
            lastView = label;
        }
        
    }
    
    if (lastView) {
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    }
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title{
    
    UILabel *label = [[UILabel alloc] init];
    label.layer.cornerRadius = 2;
    label.text = title;
    label.layer.masksToBounds = YES;
    label.font = DINAlternateBoldFont(18);
    label.textColor = ColorFrRGB(0xFAE0B4);
    label.backgroundColor = ColorFrRGB(0x46648C);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


@end
