//
//  SCXPromise+Race.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Race.h"
#import "SCXPromisePrivate.h"
#import "SCXPromise+Async.h"
@implementation SCXPromise (Race)
+ (instancetype)race:(NSArray *)promises{
    return [self onQueue:SCXPromise.dufaultDispatchQueue race:promises];;
}
+ (instancetype)onQueue:(dispatch_queue_t)queue race:(NSArray *)racePromises{
    NSParameterAssert(queue);
    NSAssert(racePromises.count > 0, @"No promises to observe");
    NSArray *promises = [racePromises copy];
    return [SCXPromise onQueue:queue async:^(SCXPromiseFulfillBlock  _Nonnull fulfill, SCXPromiseRejectBlock  _Nonnull reject) {
        for (id pro in promises) {
            if (![pro isKindOfClass:[SCXPromise class]]) {
                fulfill(pro);
                return;;
            }
        }
        for (SCXPromise *p in promises) {
            [p observOnQueue:queue fullFill:fulfill reject:reject];
        }
    }];;
}
@end
