//
//  SCXPromiseRecoverTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/4/28.
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
@interface SCXPromiseRecoverTest : XCTestCase

@end
NSErrorDomain const SCXPromiseRecoverErrorDomain = @"com.rongcloud.promise.Error";
@implementation SCXPromiseRecoverTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testRecoverCatch{
    SCXPromise *p = [[[[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"1");
    }] then:^id _Nullable(id  _Nullable value) {
        return [NSError errorWithDomain:SCXPromiseRecoverErrorDomain code:49 userInfo:nil];
    }] recover:^id _Nullable(NSError * _Nonnull error) {
        NSLog(@"error");
        if (error.code == 49) {
            return [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
                SCXDelay(3, ^{
                    fulfill(@(5));
                });
            }];
        } else {
            return @(6);
        }
    }] catch:^(NSError * _Nonnull error) {
        XCTFail();
    }] then:^id _Nullable(id  _Nullable value) {
        XCTAssertEqual(value, @(5));
        return @(7);
    }] ;
    SCXWaitForPromisesWithTimeout(100000000);
    XCTAssertEqual(p.value, @(7));
}
- (void)testRecover{
    SCXPromise *p = [[[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"1");
    }] then:^id _Nullable(id  _Nullable value) {
        return [NSError errorWithDomain:SCXPromiseRecoverErrorDomain code:49 userInfo:nil];
    }] recover:^id _Nullable(NSError * _Nonnull error) {
        NSLog(@"error");
        if (error.code == 49) {
            return [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
                SCXDelay(3, ^{
                    fulfill(@(5));
                });
            }];
        } else {
            return @(6);
        }
    }] then:^id _Nullable(id  _Nullable value) {
        XCTAssertEqual(value, @(5));
        return @(7);
    }] ;
    SCXWaitForPromisesWithTimeout(100000000);
    XCTAssertEqual(p.value, @(7));
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
