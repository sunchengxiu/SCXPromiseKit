//
//  SCXPromise+Retry.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/19.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef id __nullable (^SCXPromiseRetryWorkBlock)(void);

typedef BOOL (^SCXPromiseRetryPredicateBlock)(NSInteger, NSError *);

@interface SCXPromise<Value> (Retry)

/// 尝试 retry
+ (SCXPromise *)retry:(SCXPromiseRetryWorkBlock)block;

+ (SCXPromise *)onQueue:(dispatch_queue_t)queue
                  retry:(SCXPromiseRetryWorkBlock)block;

+ (SCXPromise *)attempts:(NSUInteger)count
                   retry:(SCXPromiseRetryWorkBlock)block;

+ (SCXPromise *)onqueue:(dispatch_queue_t)queue
               attempts:(NSUInteger)count
                  retry:(SCXPromiseRetryWorkBlock)block;

+ (SCXPromise *)attempts:(NSInteger)count
                   delay:(NSTimeInterval)interval
               condition:(nullable SCXPromiseRetryPredicateBlock)predicate
                   retry:(SCXPromiseRetryWorkBlock)work ;

+ (SCXPromise *)onQueue:(dispatch_queue_t)queue
               attempts:(NSInteger)count
                  delay:(NSTimeInterval)interval
              condition:(nullable SCXPromiseRetryPredicateBlock)predicate
                  retry:(SCXPromiseRetryWorkBlock)work NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
