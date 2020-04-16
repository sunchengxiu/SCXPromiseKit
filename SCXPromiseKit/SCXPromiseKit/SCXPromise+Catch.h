//
//  SCXPromise+Catch.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/16.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SCXPromiseCatchWorkBlock)(NSError *error);

@interface SCXPromise<Value> (Catch)

- (SCXPromise *)catch:(SCXPromiseCatchWorkBlock)reject;

- (SCXPromise *)onQueue:(dispatch_queue_t)queue
                  catch:(SCXPromiseCatchWorkBlock)reject;
@end

NS_ASSUME_NONNULL_END
