//
//  TempVC.m
//  XcodeCoverageDemo
//
//  Created by majianjie on 2021/1/4.
//

#import "TempVC.h"

#import <Masonry/Masonry.h>

@interface TempVC ()

//@property (nonatomic, strong) UNITaximeter *taximeter;

@end

@implementation TempVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s",__func__);

    self.view.backgroundColor = [UIColor whiteColor];
    [self dragDemo];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"目录： %@",paths.lastObject);
}

- (void)dragDemo{
    
//    NSURL *url = [NSURL fileURLWithPath:nil];

//    self.taximeter = [[UNITaximeter alloc] initWithFrame:CGRectMake(0, 200, 200, 38)];
//    [self.view addSubview:self.taximeter];
//    self.taximeter.priceString = @"130.09";
//
//    self.taximeter.dragType = DragTypePullOver;
//    self.taximeter.dragInBounds = YES;
    
}

- (void)dealloc{

//    NSLog(@"%s",__func__);
//    [self.taximeter removeFromSuperview];
//    self.taximeter = nil;
}


@end
