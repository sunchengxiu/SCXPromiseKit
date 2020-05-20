//
//  SCXPromise+Any.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Any.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"

static NSArray *SCXPromiseCombineValuesAndErrors(NSArray<SCXPromise *> *promises) {
    NSMutableArray *combinedValuesAndErrors = [[NSMutableArray alloc] init];
    for (SCXPromise *promise in promises) {
        if (promise.state == SCXPromiseStateFulfilled) {
            [combinedValuesAndErrors addObject:promise.value ?: [NSNull null]];
            continue;
        }
        if (promise.state == SCXPromiseStateRejected) {
            [combinedValuesAndErrors addObject:promise.error];
            continue;
        }
    };
    return combinedValuesAndErrors;
}
@implementation SCXPromise (Any)
+ (SCXPromise<NSArray *> *)any:(NSArray *)promises{
    return [self onQueue:SCXPromise.dufaultDispatchQueue any:promises];;
}
+ (SCXPromise<NSArray *> *)onQueue:(dispatch_queue_t)queue any:(NSArray *)anyPromises{
    NSParameterAssert(queue);
    NSParameterAssert(anyPromises);
    
    if (anyPromises.count == 0) {
        return [SCXPromise resolvedWith:@[]];
    }
    NSMutableArray *promises = [anyPromises mutableCopy];
    return [SCXPromise onQueue:queue async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        for (NSUInteger i = 0; i < promises.count; ++i) {
            id promise = promises[i];
            if ([promise isKindOfClass:self]) {
                continue;
            } else {
                [promises replaceObjectAtIndex:i
                                    withObject:[SCXPromise resolvedWith:promise]];
            }
        }
        
        for (SCXPromise *promise in promises) {
            [promise observOnQueue:queue fullFill:^(id  _Nullable value) {
                for (SCXPromise *_p in promises) {
                    if (_p.state == SCXPromiseStatePending) {
                        return;
                    }
                }
                fulfill(SCXPromiseCombineValuesAndErrors(promises));
            } reject:^(NSError * _Nonnull error) {
                BOOL atLeastOneIsFulfilled = NO;
                for (SCXPromise *promise in promises) {
                    if (promise.state == SCXPromiseStatePending) {
                        return;
                    }
                    if (promise.state == SCXPromiseStateFulfilled) {
                        atLeastOneIsFulfilled = YES;
                    }
                }
                if (atLeastOneIsFulfilled) {
                    fulfill(SCXPromiseCombineValuesAndErrors(promises));
                } else {
                    reject(error);
                }
            }];
            
        }
    }];
}
@end
