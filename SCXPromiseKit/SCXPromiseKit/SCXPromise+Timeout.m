//
//  SCXPromise+Timeout.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Timeout.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (Timeout)
NSErrorDomain const SCXPromiseTimeOutErrorDomain = @"com.rongcloud.timeout.domain";

-(SCXPromise *)timeout:(NSTimeInterval)interval{
    return [self onQueue:SCXPromise.dufaultDispatchQueue timeout:interval];;
}
-(SCXPromise *)onQueue:(dispatch_queue_t)queue timeout:(NSTimeInterval)interval{
    SCXPromise *promise = [SCXPromise pendingPromise];
    [self observOnQueue:queue fullFill:^(id  _Nullable value) {
        [promise fulfill:value];
    } reject:^(NSError * _Nonnull error) {
        [promise reject:error];
    }];
    __weak typeof(self)weakSelf = promise;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *timedOutError = [[NSError alloc] initWithDomain:SCXPromiseTimeOutErrorDomain
                                                            code:50001
                                                        userInfo:nil];
        [weakSelf reject:timedOutError];
    });
    return promise;;
}
@end
