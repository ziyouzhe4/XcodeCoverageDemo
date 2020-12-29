//
//  UIView+Drag.m
//  测试demo
//
//  Created by majianjie on 2020/9/24.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import "UIView+Drag.h"
#import <objc/runtime.h>

#define DDStatusBarH ((CGSizeEqualToSize(CGSizeMake(375.0f, 812.0f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(414.0f, 896.0f), [UIScreen mainScreen].bounds.size)) ? 44.0f : 20.0f)  // 增加iPhoneX适配
#define DDNavBarH   44.0f
#define DDNav_StatusH  (DDNavBarH + DDStatusBarH)


static const NSInteger kAdsorbingTag = 10000;
static const CGFloat kAdsorbDuration = 0.5f;

@implementation UIView (Drag)

-(UIPanGestureRecognizer *)panGesture {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setPanGesture:(UIPanGestureRecognizer *)panGesture {
    objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_ASSIGN);
}

-(id<DragDelegate>)delegate {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setDelegate:(id<DragDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (DragType)dragType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setDragType:(DragType)dragType {
    
    objc_setAssociatedObject(self, @selector(dragType), [NSNumber numberWithInteger:dragType], OBJC_ASSOCIATION_ASSIGN);
    [self makeDraggable:!(dragType == DragTypeDisabled)]; /// 0. 不能拖拽
    switch (dragType) {
        case DragTypePullOver: /// 3. 自动靠边,只会靠左右两边
            [self pullOverAnimated:YES];
            break;
        default:
            break;
    }
}

-(BOOL)dragInBounds {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setDragInBounds:(BOOL)draggingInBounds {
    objc_setAssociatedObject(self, @selector(dragInBounds), [NSNumber numberWithBool:draggingInBounds], OBJC_ASSOCIATION_ASSIGN);
}

-(CGPoint)revertPoint {
    NSString *pointString = objc_getAssociatedObject(self, _cmd);
    CGPoint point = CGPointFromString(pointString);
    return point;
}

-(void)setRevertPoint:(CGPoint)revertPoint {
    NSString *point = NSStringFromCGPoint(revertPoint);
    objc_setAssociatedObject(self,  @selector(revertPoint), point, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 是否可以拖动
-(void)makeDraggable:(BOOL)draggable {
    [self setUserInteractionEnabled:YES];
    [self removeConstraints:self.constraints];
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self]) {
            [self.superview removeConstraint:constraint];
        }
    }
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    UIPanGestureRecognizer *panGesture = [self panGesture];
    if (draggable) {
        if (!panGesture) {
            panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            panGesture.delegate = self;
            [self addGestureRecognizer:panGesture];
            [self setPanGesture:panGesture];
        }
    }else{
        if (panGesture) {
            [self setPanGesture:nil];
            [self removeGestureRecognizer:panGesture];
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self bringViewBack];
            [self setRevertPoint:self.center];
            [self dragging:panGestureRecognizer];
            [self.delegate dragDidBegan:self];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self dragging:panGestureRecognizer];
            [self.delegate dragDidChanged:self];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            switch ([self dragType]) {
                case DragTypeRevert: {
                    [self revertAnimated:YES];
                }
                    break;
                case DragTypePullOver: {
                    [self pullOverAnimated:YES];
                }
                    break;
                default:
                    break;
            }
            [self.delegate dragDidEnded:self];
        }
            break;
        default:
            break;
    }
}

-(void)dragging:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;
    CGPoint translation = [panGestureRecognizer translationInView:view.superview];
    CGPoint center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    if ([self dragInBounds]) {
        CGSize size = view.frame.size;
        CGSize superSize = view.superview.frame.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat superWidth = superSize.width;
        CGFloat superHeight = superSize.height;
        center.x = (center.x<width/2)?width/2:center.x;
        center.x = (center.x+width/2>superWidth)?superWidth-width/2:center.x;
        center.y = (center.y<height/2)?height/2:center.y;
        center.y = (center.y+height/2>superHeight)?superHeight-height/2:center.y;
        if ((center.y - height/2) <= DDNav_StatusH) {
            center.y = DDNav_StatusH + height/2;
        }
    }
    [view setCenter:center];
    [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
}

#pragma mark 主动靠边
-(void)pullOverAnimated:(BOOL)animated {
    [self bringViewBack];
    CGPoint center = [self centerByPullOver];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [self setCenter:center];
    } completion:nil];
}

-(CGPoint)centerByPullOver {
    CGPoint center = [self center];
    CGSize size = self.frame.size;
    CGSize superSize = [self superview].frame.size;
    if (center.x<superSize.width/2) {
        center.x = size.width/2;
    }else{
        center.x = superSize.width-size.width/2;
    }
    if (center.y<size.height/2) {
        center.y = size.height/2;
    }else if (center.y>superSize.height-size.height/2){
        center.y = superSize.height-size.height/2;
    }
    return center;
}

#pragma mark 主动还原位置
-(void)revertAnimated:(BOOL)animated {
    [self bringViewBack];
    CGPoint center = [self revertPoint];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [self setCenter:center];
    } completion:nil];
}

-(void)sendToView:(UIView *)view {
    CGRect convertRect = [self.superview convertRect:self.frame toView:view];
    [view addSubview:self];
    [self setFrame:convertRect];
}

-(void)bringViewBack {
    UIView *adsorbingView = self.superview;
    if (adsorbingView.tag == kAdsorbingTag) {
        [self sendToView:adsorbingView.superview];
        [adsorbingView removeFromSuperview];
    }
}

@end
