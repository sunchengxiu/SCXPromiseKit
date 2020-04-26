//
//  SCXPromise+All.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/24.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+All.h"
#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (All)
+(SCXPromise<NSArray *> *)all:(NSArray *)promises{
    return [SCXPromise onQueue:self.dufaultDispatchQueue all:promises];
}
+(SCXPromise<NSArray *> *)onQueue:(dispatch_queue_t)queue all:(NSArray *)promises{
    NSParameterAssert(queue);
     NSParameterAssert(promises);

     if (promises.count == 0) {
         
         return [SCXPromise resolvedWith:@[]];
     }
     NSMutableArray *promisesCopy = [promises mutableCopy];
    return [SCXPromise async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        for (int i = 0 ; i < promisesCopy.count; i ++) {
            id promise = promisesCopy[i];
            if ([promise isKindOfClass:[self class]]) {
                continue;
            } else if ([promise isKindOfClass:[NSError class]]){
                reject((NSError *)promise);
                return ;
            } else {
                [promisesCopy replaceObjectAtIndex:i withObject:[SCXPromise resolvedWith:promise]];
            }
        }
        
        for (SCXPromise *promise in promisesCopy) {
            [promise observOnQueue:queue fullFill:^(id  _Nullable value) {
                for (SCXPromise *_p in promisesCopy) {
                    if (_p.state != SCXPromiseStateFulfilled) {
                        return ;
                    }
                }
                fulfill([promisesCopy valueForKey:NSStringFromSelector(@selector(value))]);
            } reject:^(NSError * _Nonnull error) {
                reject(error);
            }];
        }
    }];
}
@end
