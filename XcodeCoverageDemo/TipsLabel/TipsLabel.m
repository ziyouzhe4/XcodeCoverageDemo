//
//  TipsLabel.m
//  测试demo
//
//  Created by majianjie on 2020/8/25.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "TipsLabel.h"

#define PingFangFont(s) ([UIFont fontWithName:@"PingFangSC-Regular" size:s]?:[UIFont systemFontOfSize:s])

@interface TipsLabel()
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIBezierPath *borderPath;
@property (nonatomic, assign) UNITipsTriangleAlignment  triangleAlignment;

@property(nonatomic,strong) UIWindow *window;
@property(nonatomic,strong) UIButton *overlay;

@property (nonatomic,assign)CGPoint trianglePoint;

@end

@implementation TipsLabel

-(instancetype)initWithTriangleAlignment:(UNITipsTriangleAlignment)triangleAlignment trianglePoint:(CGPoint)trianglePoint{
    self = [self init];
    if(self){
        if(triangleAlignment){
            self.triangleAlignment = triangleAlignment;
        }
        if (trianglePoint.x ) {
            self.trianglePoint = trianglePoint;
        }
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.userInteractionEnabled = YES;
        self.maskLayer = [CAShapeLayer layer];
        [self.layer setMask:self.maskLayer];
        self.borderPath = [UIBezierPath bezierPath];
        self.triangleAlignment = UNITipsTriangleAlignmentCenter;
        self.font = PingFangFont(13);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.textColor = [UIColor whiteColor];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.trianglePoint.x) {
        [self style2];
    }else{
        [self style1];
    }
    
}

-(void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {10, 10, 10, 5};
    switch (self.triangleAlignment) {
        case UNITipsTriangleAlignmentCenter:
        case UNITipsTriangleAlignmentLeft:
        case UNITipsTriangleAlignmentRight:{
            insets = UIEdgeInsetsMake(10, 10, 10, 5);
        }break;
        case UNITipsTriangleAlignmentBottomCenter:
        case UNITipsTriangleAlignmentBottomRight:
        case UNITipsTriangleAlignmentBottomLeft:{
            insets = UIEdgeInsetsMake(5, 10, 10, 5);
        }break;
    }
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

-(void)tapAction:(id)ges{
    if(self.actionBlock){
        self.actionBlock(nil);
        self.actionBlock = nil;
    }
    [self removeFromSuperview];
    [self.overlay removeFromSuperview];
    self.window = nil;
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
}

-(void)showOnWindowWithStartPoint:(CGPoint)startPoint andSize:(CGSize)size{
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.windowLevel = UIWindowLevelStatusBar+1;
    _window.opaque = NO;
    [_window makeKeyAndVisible];
    
    _overlay = [[UIButton alloc] initWithFrame:_window.bounds];
    [_overlay addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    _overlay.opaque = NO;
    _overlay.backgroundColor = [UIColor whiteColor];
    _overlay.alpha = 0.2f;
    [_window addSubview:_overlay];
    self.frame = CGRectMake(startPoint.x, startPoint.y, size.width, size.height);
    [_window addSubview:self];
}

- (void)makeOverlayColor:(UIColor*)color alpha:(CGFloat)alpha{
    _overlay.backgroundColor = color;
    _overlay.alpha = alpha;
}

- (void)style1{
    
    // 遮罩层frame
    self.maskLayer.frame = self.bounds;
    switch (self.triangleAlignment) {
        case UNITipsTriangleAlignmentCenter:
        case UNITipsTriangleAlignmentLeft:
        case UNITipsTriangleAlignmentRight:{
            // 设置path起点
            [self.borderPath moveToPoint:CGPointMake(0, 12)];
            // 左上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(7, 5) controlPoint:CGPointMake(0, 5)];
            
            // 顶部的小三角形
            if(self.triangleAlignment == UNITipsTriangleAlignmentLeft){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4, 5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4+5, 0)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 + 10,5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 5)];
            }else if (self.triangleAlignment == UNITipsTriangleAlignmentRight){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4*3, 5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4*3+5, 0)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4*3 + 10,5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 5)];
            }else if(self.triangleAlignment == UNITipsTriangleAlignmentCenter){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2+5, 0)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 + 10,5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 5)];
            }
            
            // 右上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 12) controlPoint:CGPointMake(self.bounds.size.width, 5)];
            // 直线，到右下角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-7)];
            // 右下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width - 7, self.bounds.size.height) controlPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
            // 直线，到左下角
            [self.borderPath addLineToPoint:CGPointMake(7, self.bounds.size.height)];
            // 左下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(0, self.bounds.size.height-7) controlPoint:CGPointMake(0, self.bounds.size.height)];
            // 直线，回到起点
            [self.borderPath addLineToPoint:CGPointMake(0, 7)];
            // 将这个path赋值给maskLayer的path
            self.maskLayer.path = self.borderPath.CGPath;
        }
            break;
        case UNITipsTriangleAlignmentBottomCenter:
        case UNITipsTriangleAlignmentBottomRight:
        case UNITipsTriangleAlignmentBottomLeft:{
            // 设置path起点
            [self.borderPath moveToPoint:CGPointMake(0, 7)];
            // 左上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(7, 0) controlPoint:CGPointMake(0, 0)];
            // 直线，到右上角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 0)];
            // 右上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 7) controlPoint:CGPointMake(self.bounds.size.width, 0)];
            // 直线，到右下角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-12)];
            // 右下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width - 7, self.bounds.size.height -5) controlPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height -5)];
            if(self.triangleAlignment == UNITipsTriangleAlignmentBottomRight){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 *3, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 *3 -5, self.bounds.size.height)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4*3 - 10,self.bounds.size.height -5)];
            }else if(self.triangleAlignment == UNITipsTriangleAlignmentBottomCenter){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 -5, self.bounds.size.height )];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 - 10,self.bounds.size.height -5)];
            }else if (self.triangleAlignment == UNITipsTriangleAlignmentBottomLeft){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 +10, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4+5, self.bounds.size.height)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4,self.bounds.size.height -5)];
            }
            
            // 直线，到左下角
            [self.borderPath addLineToPoint:CGPointMake(7, self.bounds.size.height -5)];
            // 左下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(0, self.bounds.size.height-12) controlPoint:CGPointMake(0, self.bounds.size.height -5)];
            // 直线，回到起点
            [self.borderPath addLineToPoint:CGPointMake(0, 7)];
            // 将这个path赋值给maskLayer的path
            self.maskLayer.path = self.borderPath.CGPath;
        }break;
    }
    
}

- (void)style2{
 
    // 遮罩层frame
    self.maskLayer.frame = self.bounds;
    switch (self.triangleAlignment) {
        case UNITipsTriangleAlignmentCenter:
        case UNITipsTriangleAlignmentLeft:
        case UNITipsTriangleAlignmentRight:{
            // 设置path起点
            [self.borderPath moveToPoint:CGPointMake(0, 12)];
            // 左上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(7, 5) controlPoint:CGPointMake(0, 5)];
            
            // 顶部的小三角形
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 5)];
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2+5, 0)];
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 + 10,5)];
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 5)];
            
            
            // 右上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 12) controlPoint:CGPointMake(self.bounds.size.width, 5)];
            // 直线，到右下角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-7)];
            // 右下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width - 7, self.bounds.size.height) controlPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
            // 直线，到左下角
            [self.borderPath addLineToPoint:CGPointMake(7, self.bounds.size.height)];
            // 左下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(0, self.bounds.size.height-7) controlPoint:CGPointMake(0, self.bounds.size.height)];
            // 直线，回到起点
            [self.borderPath addLineToPoint:CGPointMake(0, 7)];
            // 将这个path赋值给maskLayer的path
            self.maskLayer.path = self.borderPath.CGPath;
        }
            break;
        case UNITipsTriangleAlignmentBottomCenter:
        case UNITipsTriangleAlignmentBottomRight:
        case UNITipsTriangleAlignmentBottomLeft:{
            // 设置path起点
            [self.borderPath moveToPoint:CGPointMake(0, 7)];
            // 左上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(7, 0) controlPoint:CGPointMake(0, 0)];
            // 直线，到右上角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width -7, 0)];
            // 右上角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 7) controlPoint:CGPointMake(self.bounds.size.width, 0)];
            // 直线，到右下角
            [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-12)];
            // 右下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width - 7, self.bounds.size.height -5) controlPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height -5)];
            if(self.triangleAlignment == UNITipsTriangleAlignmentBottomRight){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 *3, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 *3 -5, self.bounds.size.height)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4*3 - 10,self.bounds.size.height -5)];
            }else if(self.triangleAlignment == UNITipsTriangleAlignmentBottomCenter){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 -5, self.bounds.size.height )];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2 - 10,self.bounds.size.height -5)];
            }else if (self.triangleAlignment == UNITipsTriangleAlignmentBottomLeft){
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4 +10, self.bounds.size.height -5)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4+5, self.bounds.size.height)];
                [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/4,self.bounds.size.height -5)];
            }
            
            // 直线，到左下角
            [self.borderPath addLineToPoint:CGPointMake(7, self.bounds.size.height -5)];
            // 左下角的圆角
            [self.borderPath addQuadCurveToPoint:CGPointMake(0, self.bounds.size.height-12) controlPoint:CGPointMake(0, self.bounds.size.height -5)];
            // 直线，回到起点
            [self.borderPath addLineToPoint:CGPointMake(0, 7)];
            // 将这个path赋值给maskLayer的path
            self.maskLayer.path = self.borderPath.CGPath;
        }break;
    }
    
}



@end

