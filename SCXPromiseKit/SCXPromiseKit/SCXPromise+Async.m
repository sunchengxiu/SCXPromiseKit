//
//  SCXPromise+Async.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Async.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (Async)
+(instancetype)async:(SCXPromiseAsyncWorkBlock)work{
    return [self onQueue:self.dufaultDispatchQueue async:work];
}
+(instancetype)onQueue:(dispatch_queue_t)queue async:(SCXPromiseAsyncWorkBlock)work{
    SCXPromise *promise = [SCXPromise pendingPromise];
    dispatch_group_async(SCXPromise.dispatchGroup , queue, ^{
        work( ^(id __nullable value){
            if ([value isKindOfClass:[SCXPromise class]]) {
                [(SCXPromise *)value observOnQueue:queue fullFill:^(id  _Nullable value) {
                    [promise fulfill:value];
                } reject:^(NSError * _Nonnull error) {
                    [promise reject:error];
                }];
            } else {
                [promise fulfill:value];
            }
        },
             ^ (NSError *err){
            
            [promise reject:err];
        });
    });
    return promise;
}
@end
