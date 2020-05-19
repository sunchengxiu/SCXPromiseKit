//
//  SCXPromiseRetryTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/5/19.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCXPromise+Recover.h"
#import "SCXPromise+Catch.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
#import "SCXTestHelper.h"
#import "SCXPromise+ThenAsync.h"
#import "SCXPromise+ThenSync.h"
#import "SCXPromise+Retry.h"
@interface SCXPromiseRetryTest : XCTestCase

@end

@implementation SCXPromiseRetryTest
NSErrorDomain const SCXPromiseRetryErrorDomain = @"com.rongcloud.promise.Error";
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testRetry{
    __block NSUInteger cout = 2;
    SCXPromise *promise = [[[SCXPromise retry:^id _Nullable{
        NSLog(@"retry promise");
        cout -= 1 ;
        return cout == 0 ? @42 : [NSError errorWithDomain:SCXPromiseRetryErrorDomain code:42 userInfo:nil];;
    }] then:^id _Nullable(id  _Nullable value) {
        XCTAssertEqual(value, @42);
        NSLog(@"成功了 : %@",value);
        return value;
    }] catch:^(NSError * _Nonnull error) {
        XCTFail(@"Promise should not be resolved with error.");
    }] ;
}
- (void)tearDown {
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
