//
//  SCXPromise+Async.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (Async)

typedef void (^SCXPromiseFulfillBlock)(Value __nullable value) ;
typedef void (^SCXPromiseRejectBlock)(NSError *error) ;
typedef void (^SCXPromiseAsyncWorkBlock)(SCXPromiseFulfillBlock fulfill,
                                         SCXPromiseRejectBlock reject) ;

+ (instancetype)async:(SCXPromiseAsyncWorkBlock)work;
+ (instancetype)onQueue:(dispatch_queue_t)queue
                  async:(SCXPromiseAsyncWorkBlock)work;
@end

NS_ASSUME_NONNULL_END
