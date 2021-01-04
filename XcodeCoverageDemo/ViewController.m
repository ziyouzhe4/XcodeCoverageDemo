//
//  ViewController.m
//  XcodeCoverageDemo
//
//  Created by majianjie on 2020/12/23.
//

#import "ViewController.h"
#import "TempVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    TempVC *t = [[TempVC alloc] init];
    [self.navigationController pushViewController:t animated:YES];
    
}


@end
