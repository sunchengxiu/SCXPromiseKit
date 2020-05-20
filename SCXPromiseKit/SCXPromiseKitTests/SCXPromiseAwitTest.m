//
//  SCXPromiseAwitTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/5/20.
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
#import "SCXPromise+Await.h"
@interface SCXPromiseAwitTest : XCTestCase

@end

@implementation SCXPromiseAwitTest
NSErrorDomain const SCXPromiseAwitErrorDomain = @"com.rongcloud.promise.awitError";

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void)test{
    __block NSError *err;
    SCXPromise *promise = [SCXPromise onQueue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        id value1 = SCXPromiseAwait([self async1], &err);
        XCTAssertEqualObjects(value1,@(1));
        id value2 = SCXPromiseAwait([self async2], &err);
        XCTAssertEqualObjects(value2,@"2");
        id value3 = SCXPromiseAwait([self async3], &err);
        XCTAssertEqual(((NSError *)value3).code,42);

    }];
   SCXWaitForPromisesWithTimeout(15.0);
}
- (SCXPromise *)async1{
    return [SCXPromise onQueue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(1, ^{
            fulfill(@(1));
        });
    }];;
}
- (SCXPromise *)async2{
    return [SCXPromise onQueue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(1, ^{
            fulfill(@"2");
        });
    }];;
}
- (SCXPromise *)async3{
    return [SCXPromise onQueue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.2, ^{
            reject([NSError errorWithDomain:SCXPromiseAwitErrorDomain code:42 userInfo:nil]);
        });
    }];;
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
