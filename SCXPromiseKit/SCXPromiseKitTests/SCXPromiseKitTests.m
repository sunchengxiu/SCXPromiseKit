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
BOOL SCXWaitForPromisesWithTimeout(NSTimeInterval timeout) {
  BOOL isTimedOut = NO;
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
  static NSTimeInterval const minimalTimeout = 0.01;
  static int64_t const minimalTimeToWait = (int64_t)(minimalTimeout * NSEC_PER_SEC);
  dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, minimalTimeToWait);
  dispatch_group_t dispatchGroup = SCXPromise.dispatchGroup;
  NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
  while (dispatch_group_wait(dispatchGroup, waitTime)) {
    isTimedOut = timeoutDate.timeIntervalSinceNow < 0.0;
    if (isTimedOut) {
      break;
    }
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:minimalTimeout]];
  }
  return !isTimedOut;
}
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
- (void)testPromiseThenNoDeallocUntilFulfilled {
  // Arrange.
  SCXPromise *promise = [SCXPromise pendingPromise];
  SCXPromise __weak *weakExtendedPromise1;
  SCXPromise __weak *weakExtendedPromise2;

  // Act.
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

  // Assert.
  XCTAssertNotNil(weakExtendedPromise1);
  XCTAssertNotNil(weakExtendedPromise2);

  [promise fulfill:@42];
  XCTAssert(SCXWaitForPromisesWithTimeout(10));

  XCTAssertNil(weakExtendedPromise1);
  XCTAssertNil(weakExtendedPromise2);
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
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
