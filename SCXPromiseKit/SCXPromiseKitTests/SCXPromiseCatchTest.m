//
//  SCXPromiseCatchTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/4/16.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCXPromise+ThenSync.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
#import "SCXTestHelper.h"
#import "SCXPromise+ThenAsync.h"
#import "SCXPromise+Catch.h"
@interface SCXPromiseCatchTest : XCTestCase

@end

NSErrorDomain const SCXPromiseCatchErrorDomain = @"com.rongcloud.promise.Error";
@implementation SCXPromiseCatchTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testCatch{
    [[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.1, ^{
            fulfill(@(1));
        });
    }] then:^id _Nullable(id  _Nullable value) {
        return [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
            reject([NSError errorWithDomain:SCXPromiseCatchErrorDomain code:40 userInfo:nil]);
        }];
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 40);
    }] ;
    SCXWaitForPromisesWithTimeout(10);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
