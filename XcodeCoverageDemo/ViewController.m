//
//  ViewController.m
//  XcodeCoverageDemo
//
//  Created by majianjie on 2020/12/23.
//

#import "ViewController.h"
#import "UIView+Drag.h"
#import "UNITaximeter.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UNITaximeter *taximeter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dragDemo];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"目录： %@",paths.lastObject);
}

- (void)dragDemo{
    
//    NSURL *url = [NSURL fileURLWithPath:nil];

    self.taximeter = [[UNITaximeter alloc] initWithFrame:CGRectMake(0, 200, 200, 38)];
    [self.view addSubview:self.taximeter];
    self.taximeter.priceString = @"130.09";
    
    self.taximeter.dragType = DragTypePullOver;
    self.taximeter.dragInBounds = YES;
    
//    [self.taximeter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(38);
//        make.top.mas_equalTo(200);
//    }];
    
    
    UIView *aa = [[UIView alloc] init];
    aa.backgroundColor = [UIColor redColor];
    [self.view addSubview:aa];
    [aa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.top.left.mas_equalTo(100);
    }];
    
    
    
    UIView *bb = [[UIView alloc] init];
    bb.backgroundColor =[UIColor blueColor];
//    [aa addSubview:bb];
    [bb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(29);
    }];
    
    NSLog(@"sssssssss");
    
}


@end
