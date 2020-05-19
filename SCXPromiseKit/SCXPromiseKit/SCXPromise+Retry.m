//
//  SCXPromise+Retry.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/19.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Retry.h"
#import "SCXPromisePrivate.h"
NSInteger const SCXPromiseRetryDefaultAttemptsCount = 1;
NSTimeInterval const SCXPromiseRetryDefaultDelayInterval = 1.0;
static void SCXPromisAtteptsRetry(SCXPromise *promise ,
                                  dispatch_queue_t queue ,
                                  NSUInteger count ,
                                  NSTimeInterval time ,
                                  SCXPromiseRetryPredicateBlock predicateBlock ,
                                  SCXPromiseRetryWorkBlock workBlock){
    __auto_type retrier = ^ (id __nullable value){
        if ([value isKindOfClass:[NSError class]]) {
            if (count <= 0 || (predicateBlock && !predicateBlock(count , value))) {
                [promise reject:value];
            } else {
                dispatch_after(dispatch_time(0, (int64_t)(time * NSEC_PER_SEC)), queue, ^{
                    SCXPromisAtteptsRetry(promise, queue, count - 1, time, predicateBlock, workBlock);
                });
            }
        } else {
            [promise fulfill:value];
        }
    };
    
    id value = workBlock();
    if ([value isKindOfClass:[SCXPromise class]]) {
        [(SCXPromise *)value observOnQueue:queue fullFill:retrier reject:retrier];
    } else {
        retrier(value);
    }
}
@implementation SCXPromise (Retry)
+ (SCXPromise *)retry:(SCXPromiseRetryWorkBlock)block{
    return [self onQueue:SCXPromise.dufaultDispatchQueue retry:block];
}
+ (SCXPromise *)onQueue:(dispatch_queue_t)queue retry:(SCXPromiseRetryWorkBlock)block{
    return [self onqueue:queue attempts:SCXPromiseRetryDefaultAttemptsCount retry:block];;
}
+ (SCXPromise *)onqueue:(dispatch_queue_t)queue attempts:(NSUInteger)count retry:(SCXPromiseRetryWorkBlock)block{
    return [self onQueue:queue attempts:count delay:SCXPromiseRetryDefaultDelayInterval condition:nil retry:block];;
}
+ (SCXPromise *)attempts:(NSUInteger)count retry:(SCXPromiseRetryWorkBlock)block{
    return [self onqueue:SCXPromise.dufaultDispatchQueue attempts:count retry:block];
}
+ (SCXPromise *)attempts:(NSInteger)count delay:(NSTimeInterval)interval condition:(SCXPromiseRetryPredicateBlock)predicate retry:(SCXPromiseRetryWorkBlock)work{
    return [self onQueue:SCXPromise.dufaultDispatchQueue attempts:count delay:interval condition:predicate retry:work];;
}
+ (SCXPromise *)onQueue:(dispatch_queue_t)queue attempts:(NSInteger)count delay:(NSTimeInterval)interval condition:(SCXPromiseRetryPredicateBlock)predicate retry:(SCXPromiseRetryWorkBlock)work{
    SCXPromise *promise = [SCXPromise pendingPromise];
    SCXPromisAtteptsRetry(promise, queue, count, interval, predicate, work);
    return promise;;
}
@end
