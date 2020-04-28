//
//  SCXPromiseAllTest.m
//  SCXPromiseKitTests
//
//  Created by 孙承秀 on 2020/4/28.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCXPromise+All.h"
#import "SCXPromise+Catch.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
#import "SCXTestHelper.h"
#import "SCXPromise+ThenAsync.h"
#import "SCXPromise+ThenSync.h"
@interface SCXPromiseAllTest : XCTestCase

@end
NSErrorDomain const SCXPromiseAllErrorDomain = @"com.rongcloud.promise.Error";
@implementation SCXPromiseAllTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testAllWithReject{
    NSArray *arr = @[@(1),@"3"];
    SCXPromise *p = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(1));
    }];
    
    SCXPromise *p1 = [[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(2));
    }] asyncThen:^(id  _Nullable value, SCXPromiseAsyncThenFullFillBlock  _Nonnull fullFillBlock) {
        fullFillBlock(@"3");
    }];
    SCXPromise *p3 = [[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(4));
    }] asyncThen:^(id  _Nullable value, SCXPromiseAsyncThenFullFillBlock  _Nonnull fullFillBlock) {
        SCXPromise *promise = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
            SCXDelay(3, ^{
                reject([NSError errorWithDomain:SCXPromiseAllErrorDomain code:48 userInfo:nil]);
            });
        }];
        fullFillBlock(promise);
    }] ;
    SCXPromise *result = [[[SCXPromise all:@[p,p1,p3]] then:^id _Nullable(NSArray * _Nullable value) {
        NSLog(@"%@",value);
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }] ;
    SCXWaitForPromisesWithTimeout(1000000000000000000);
    NSLog(@"%@",result);
}
- (void)testAllSuccess{
    NSArray *arr = @[@(1),@"3"];
    SCXPromise *p = [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(1));
    }];
    
    SCXPromise *p1 = [[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(2));
    }] asyncThen:^(id  _Nullable value, SCXPromiseAsyncThenFullFillBlock  _Nonnull fullFillBlock) {
        fullFillBlock(@"3");
    }];
    
    SCXPromise *result = [[SCXPromise all:@[p,p1]] then:^id _Nullable(NSArray * _Nullable value) {
        NSLog(@"%@",value);
        return value;
    }];
    SCXWaitForPromisesWithTimeout(10);
    XCTAssertEqualObjects(result.value, arr);
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
