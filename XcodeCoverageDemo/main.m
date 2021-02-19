//
//  main.m
//  XcodeCoverageDemo
//
//  Created by majianjie on 2020/12/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

/** 查看 main.gcda  main.gcno内容
 
 
 $ gcov -dump main.gcno
 ===== main (0) @ XcodeCoverageDemo/main.m:11
 Block : 0 Counter : 0
     Destination Edges : 1 (0),
     Lines : 11,
 Block : 1 Counter : 0
     Source Edges : 0 (0),
     Destination Edges : 2 (0),
     Lines : 12,13,15,16,17,18,
 Block : 2 Counter : 0
     Source Edges : 1 (0),
 
 
 
 $ gcov -dump main.gcda
 ===== main (0) @ XcodeCoverageDemo/main.m:11
 Block : 0 Counter : 1
     Destination Edges : 1 (1),
     Lines : 11,
 Block : 1 Counter : 1
     Source Edges : 0 (1),
     Destination Edges : 2 (1),
     Lines : 12,13,15,16,17,18,
 Block : 2 Counter : 1
     Source Edges : 1 (1),
 
 */
