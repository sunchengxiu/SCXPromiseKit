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
    XCTAssert(SCXWaitForPromisesWithTimeout(15.0));
}
- (void)testAttempts{
    NSError *retryError = [NSError errorWithDomain:SCXPromiseRetryErrorDomain code:42 userInfo:nil];
    SCXPromise *promis = [[[SCXPromise attempts:3 retry:^id _Nullable{
        NSLog(@"-------------");
        return retryError;;
    }] then:^id _Nullable(id  _Nullable value) {
        XCTFail(@"Promise should not be resolved with error.");
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }] ;
    XCTAssert(SCXWaitForPromisesWithTimeout(15.0));
}

- (void)testCustomDelay{
    SCXPromise *promise = [SCXPromise attempts:3 delay:2 condition:nil retry:^id _Nullable{
        NSError *retryError = [NSError errorWithDomain:SCXPromiseRetryErrorDomain code:42 userInfo:nil];
        NSLog(@"------");
        return retryError;;
    }];
     XCTAssert(SCXWaitForPromisesWithTimeout(15.0));
}
- (void)testCondition{
    SCXPromise *promise = [SCXPromise attempts:3 delay:1 condition:^BOOL(NSInteger count, NSError * _Nonnull error ) {
        NSLog(@"count : %d , error : %@",count,error);
        return error.code == 42;
    } retry:^id _Nullable{
        NSError *retryError = [NSError errorWithDomain:SCXPromiseRetryErrorDomain code:42 userInfo:nil];
        NSLog(@"------");
        return retryError;;
    }];
    XCTAssert(SCXWaitForPromisesWithTimeout(15.0));

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
