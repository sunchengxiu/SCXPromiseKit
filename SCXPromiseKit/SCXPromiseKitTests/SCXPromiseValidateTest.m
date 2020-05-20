//
//  SCXPromiseValidateTest.m
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
@interface SCXPromiseValidateTest : XCTestCase

@end

@implementation SCXPromiseValidateTest
NSErrorDomain const SCXPromiseValidateTestErrorDomain = @"com.rongcloud.promise.validateTestError";

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)test{
    SCXPromise *promise = [[[[[[SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(2));
    }] validate:^BOOL(id  _Nullable value) {
        return ((NSNumber *)value).intValue == 2;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"---%@",value);
        return @(3);;
    }] validate:^BOOL(id  _Nullable value) {
        return ((NSNumber *)value).intValue == 2;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }] ;
    SCXWaitForPromisesWithTimeout(10);
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
