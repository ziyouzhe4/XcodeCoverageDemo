//
//  AppDelegate.m
//  XcodeCoverageDemo
//
//  Created by majianjie on 2020/12/23.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self codeCoverage];/// 生成覆盖率记录
    
    int a = 5;
    if (a == 6) {
        NSLog(@"666666666");
    }
}

- (void)codeCoverage{
    
#if COVERAGE
#if !TARGET_IPHONE_SIMULATOR
    /// 真机走这里的逻辑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    /// setenv的意思是将数据的根目录设置为app的Documents;
    setenv("GCOV_PREFIX", [documentsDirectory cStringUsingEncoding:NSUTF8StringEncoding], 1);
    /// setenv的意思是strip掉一些目录层次，因为覆盖率数据默认会写入一个很深的目录层次。
    setenv("GCOV_PREFIX_STRIP", "13", 1);
#endif
    /// 模拟器走这里的逻辑
    extern void __gcov_flush(void);
    __gcov_flush();
    
#endif
     
}

@end
