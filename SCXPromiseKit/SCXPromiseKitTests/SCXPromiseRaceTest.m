//
//  SCXPromiseRaceTest.m
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
#import "SCXPromise+Validate.h"
#import "SCXPromise+Race.h"
@interface SCXPromiseRaceTest : XCTestCase

@end

@implementation SCXPromiseRaceTest
NSErrorDomain const SCXPromiseRaceTestErrorDomain = @"com.rongcloud.promise.raceTestError";

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)test{
    SCXPromise *p1 = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.1, ^{
            fulfill(@(1));
        });
    }];
    SCXPromise *p2 = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(2, ^{
            reject([NSError errorWithDomain:SCXPromiseRaceTestErrorDomain code:42 userInfo:nil]);
        });
    }];
    SCXPromise *p = [[[SCXPromise race:@[p2,p1]] then:^id _Nullable(id  _Nullable value) {
        XCTAssertEqualObjects(value, @1);

    }] catch:^(NSError * _Nonnull error) {
        XCTFail();
    }] ;
    SCXWaitForPromisesWithTimeout(15);
}
- (void)test1{
    SCXPromise *p1 = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(1, ^{
            fulfill(@(1));
        });
    }];
    SCXPromise *p2 = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        SCXDelay(0.1, ^{
            reject([NSError errorWithDomain:SCXPromiseRaceTestErrorDomain code:42 userInfo:nil]);
        });
    }];
    SCXPromise *p = [[[SCXPromise race:@[p2,p1]] then:^id _Nullable(id  _Nullable value) {
        XCTFail();
        return value;;
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
    }] ;
    SCXWaitForPromisesWithTimeout(15);
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
