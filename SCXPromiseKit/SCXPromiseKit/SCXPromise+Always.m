//
//  SCXPromise+Always.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Always.h"
#import "SCXPromisePrivate.h"

@implementation SCXPromise (Always)
- (SCXPromise *)always:(SCXPromiseAlwaysWorkBlock)work {
  return [self onQueue:SCXPromise.dufaultDispatchQueue always:work];
}

- (SCXPromise *)onQueue:(dispatch_queue_t)queue always:(SCXPromiseAlwaysWorkBlock)work {
  NSParameterAssert(queue);
  NSParameterAssert(work);
    return [self chainOnQueue:queue chainedFulfill:^id _Nullable(id  _Nullable value) {
        work();
        return value;
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        work();
        return error;
    }];;
}

@end
