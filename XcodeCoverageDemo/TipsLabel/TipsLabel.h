//
//  TipsLabel.h
//  测试demo
//
//  Created by majianjie on 2020/8/25.
//  Copyright © 2020 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define IPHONEX_BOTTOM_OFFSET  ((IS_IPHONE_X)?19:0)
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xff0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00ff00) >>  8))/255.0 \
                blue:((float)((rgbValue & 0x0000ff) >>  0))/255.0 \
                alpha:1.0]
#define PingFangSemiboldFont(s) ([UIFont fontWithName:@"PingFangSC-Semibold" size:s]?:[UIFont boldSystemFontOfSize:s])


typedef enum {
    UNITipsTriangleAlignmentCenter =0,
    UNITipsTriangleAlignmentLeft,
    UNITipsTriangleAlignmentRight,
    UNITipsTriangleAlignmentBottomCenter,
    UNITipsTriangleAlignmentBottomLeft,
    UNITipsTriangleAlignmentBottomRight
}UNITipsTriangleAlignment;

typedef void(^ActionBlock)(id);


NS_ASSUME_NONNULL_BEGIN

@interface TipsLabel : UILabel

@property (nonatomic,copy) ActionBlock actionBlock;

-(instancetype)initWithTriangleAlignment:(UNITipsTriangleAlignment)triangleAlignment trianglePoint:(CGPoint)trianglePoint;

-(void)showOnWindowWithStartPoint:(CGPoint)startPoint andSize:(CGSize)size;
-(void)makeOverlayColor:(UIColor*)color alpha:(CGFloat)alpha;
-(void)tapAction:(id)ges;

@end

NS_ASSUME_NONNULL_END
