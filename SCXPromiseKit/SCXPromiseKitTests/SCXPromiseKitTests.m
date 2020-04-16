//
//  SCXPromiseKitTests.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/4/8.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCXPromise.h"
#import "SCXPromisePrivate.h"


NSErrorDomain const SCXPromiseErrorDomain = @"com.rongcloud.promise.Error";
@interface SCXPromiseKitTests : XCTestCase

@end

@implementation SCXPromiseKitTests

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
- (void)testResoution{
//    SCXPromise *promise = [];
}
- (void)testReturnPromise{
    SCXPromise *promise = [SCXPromise pendingPromise];
    SCXPromise *p1 = [promise chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        SCXPromise *promise1 = [SCXPromise pendingPromise];
        [promise1 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
            return @(8);
        } chainedReject:^id _Nullable(NSError * _Nonnull error) {
            return nil;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promise1 fulfill:@"9"];
        });
        return promise1;
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        return nil;
    }];
    SCXPromise *p2 = [p1 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        return @(5);
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        NSLog(@"error");
        return @(6);
    }];
    [promise fulfill:@(3)];
    SCXWaitForPromisesWithTimeout(10);
//    XCTAssertEqual(p2.value, @(6));
}
- (void)testCommonReject{
    SCXPromise *promise = [SCXPromise pendingPromise];
    SCXPromise *p1 = [promise chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        XCTFail();
        return nil;
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
        return [NSError errorWithDomain:SCXPromiseErrorDomain code:43 userInfo:nil];
    }];
    SCXPromise *p2 = [p1 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        XCTFail();
        return nil;
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 43);
        return @(6);
    }];
    SCXPromise *p3 = [p2 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        XCTAssertEqual(value, @(6));
        return @(7);
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        XCTFail();
        return nil;
    }];
    [promise reject:[NSError errorWithDomain:SCXPromiseErrorDomain code:42 userInfo:nil]];
    SCXWaitForPromisesWithTimeout(10);
    XCTAssertEqual(p3.value, @(7));
}
- (void)testCommonFullReject{
    SCXPromise *promise = [SCXPromise pendingPromise];
    SCXPromise *p1 = [promise chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        return [NSError errorWithDomain:SCXPromiseErrorDomain code:42 userInfo:nil];
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        return nil;
    }];
    SCXPromise *p2 = [p1 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        return @(5);
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        NSLog(@"error");
        return @(6);
    }];
    [promise fulfill:@(3)];
    SCXWaitForPromisesWithTimeout(10);
    XCTAssertEqual(p2.value, @(6));
}
- (void)testCommonFullFill{
    SCXPromise *promise = [SCXPromise pendingPromise];
    SCXPromise *p1 = [promise chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        return @(2);
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        return nil;
    }];
    SCXPromise *p2 = [p1 chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return @(3);
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        return nil;
    }];
    [promise fulfill:@(3)];
    SCXWaitForPromisesWithTimeout(10);
    XCTAssertEqual(p2.value, @(3));
}
- (void)testPromiseThenNoDeallocUntilFulfilled {
  SCXPromise *promise = [SCXPromise pendingPromise];
  SCXPromise __weak *weakExtendedPromise1;
  SCXPromise __weak *weakExtendedPromise2;
  @autoreleasepool {
    XCTAssertNil(weakExtendedPromise1);
    XCTAssertNil(weakExtendedPromise2);
      weakExtendedPromise1 = [promise  chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
          return @(6);
      } chainedReject:^id _Nullable(NSError * _Nonnull error) {
          return nil;
      }];
      weakExtendedPromise2 = [promise chainOnQueue:SCXPromise.dufaultDispatchQueue chainedFulfill:^id _Nullable(id  _Nullable value) {
          return @(5);
      } chainedReject:^id _Nullable(NSError * _Nonnull error) {
          return nil;
      }];
    XCTAssertNotNil(weakExtendedPromise1);
    XCTAssertNotNil(weakExtendedPromise2);
  }
  XCTAssertNotNil(weakExtendedPromise1);
  XCTAssertNotNil(weakExtendedPromise2);
  [promise fulfill:@42];
  XCTAssert(SCXWaitForPromisesWithTimeout(10));
  XCTAssertNil(weakExtendedPromise1);
  XCTAssertNil(weakExtendedPromise2);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
