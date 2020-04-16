//
//  SCXPromise+Catch.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/16.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Catch.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (Catch)
-(SCXPromise *)catch:(SCXPromiseCatchWorkBlock)reject{
    return [self onQueue:SCXPromise.dufaultDispatchQueue catch:reject];
}
-(SCXPromise *)onQueue:(dispatch_queue_t)queue catch:(SCXPromiseCatchWorkBlock)reject{
    return [self chainOnQueue:queue chainedFulfill:nil chainedReject:^id _Nullable(NSError * _Nonnull error) {
        reject(error);
        return error;
    }];
}
@end
