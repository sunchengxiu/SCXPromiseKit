//
//  SCXPromiseThenTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCXPromise+ThenSync.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
#import "SCXTestHelper.h"
@interface SCXPromiseThenTest : XCTestCase

/**
 promise
 */
@property(nonatomic , strong)SCXPromise *promise;
@end

@implementation SCXPromiseThenTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testAsyncThen{
    [[[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.1, ^{
            fulfill(@(1));
        });
    }] then:^id _Nullable(id  _Nullable value) {
        return [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
            SCXDelay(0.2, ^{
                fulfill(@(2));
            });
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        return @(3);
    }] then:^id _Nullable(id  _Nullable value) {
        return @(4);
    }] ;
    SCXWaitForPromisesWithTimeout(10);
}
- (void)testThen{
    [[[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.1, ^{
            fulfill(@(1));
        });
    }] then:^id _Nullable(id  _Nullable value) {
        return @(2);
    }] then:^id _Nullable(id  _Nullable value) {
        return @(3);
    }] then:^id _Nullable(id  _Nullable value) {
        return @(4);
    }] ;
    SCXWaitForPromisesWithTimeout(10);
}
- (void)testThenFirst{
    SCXPromise *promise = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fulfill(@(1));
        });
        
    }];
    [promise then:^id _Nullable(id  _Nullable value) {
        return @(3);
    }];

    SCXWaitForPromisesWithTimeout(10000000);
    NSLog(@"111");
}
- (void)testThenLast{
    SCXPromise *promise = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(1));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
        
        NSLog(@"234");
        [promise then:^id _Nullable(id  _Nullable value) {
            return @(3);
        }];
    });
    SCXWaitForPromisesWithTimeout(10000000);
    NSLog(@"111");
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
