//
//  UIView+Drag.h
//  测试demo
//
//  Created by majianjie on 2020/9/24.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
 拖拽方式
 - DragTypeDisabled :不能拖拽
 - DragTypeNormal: 正常拖拽
 - DragTypeRevert: 释放后还原
 - DragTypePullOver: 自动靠边,只会靠左右两边
 */
typedef NS_ENUM(NSUInteger, DragType) {
    DragTypeDisabled,
    DragTypeNormal,
    DragTypeRevert,
    DragTypePullOver,
};

#define ColorFrRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xff0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00ff00) >>  8))/255.0 \
                blue:((float)((rgbValue & 0x0000ff) >>  0))/255.0 \
                alpha:1.0]

@protocol DragDelegate <NSObject>

-(void)dragDidBegan:(UIView *)view;/// 开始拖拽
-(void)dragDidChanged:(UIView *)view;/// 拖拽变化
-(void)dragDidEnded:(UIView *)view; /// 拖拽结束

@end

@interface UIView (Drag)<UIGestureRecognizerDelegate>

/// 拖拽事件委托，可监听拖拽的开始、拖拽变化以及拖拽结束事件。
@property (weak, nonatomic) id<DragDelegate> delegate;

/// 拖拽方式，默认是DraggingTypeDisabled。
@property(nonatomic)DragType dragType;

/// 是否可只能在subView的范围内，默认是NO。
/// 如果NO，超出subView范围的部分无法响应拖拽。剪裁超出部分可直接使用superView.clipsToBounds=YES
@property(nonatomic)BOOL dragInBounds;


@end

NS_ASSUME_NONNULL_END
