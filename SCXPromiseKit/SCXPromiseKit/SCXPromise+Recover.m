//
//  SCXPromise+Recover.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/28.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Recover.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (Recover)
-(SCXPromise *)recover:(SCXPromiseRecoverWorkBlock)recover{
    return [self onQueue:SCXPromise.dufaultDispatchQueue recover:recover];
}
-(SCXPromise *)onQueue:(dispatch_queue_t)queue recover:(SCXPromiseRecoverWorkBlock)recover{
    return [self chainOnQueue:queue chainedFulfill:nil chainedReject:^id _Nullable(NSError * _Nonnull error) {
        return recover(error);
    }];
}
@end
