//
//  SCXPromise+ThenAsync.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SCXPromiseAsyncThenFullFillBlock)(id __nullable asyncValue);

@interface SCXPromise<Value> (ThenAsync)
typedef void (^SCXPromiseThenAsyncWorkBlock)(Value __nullable value ,SCXPromiseAsyncThenFullFillBlock fullFillBlock);

/// then
/// @param then then block
- (SCXPromise *)asyncThen:(SCXPromiseThenAsyncWorkBlock)then;

/// onqueue then
/// @param queue queue
/// @param then then block
- (SCXPromise *)onQueue:(dispatch_queue_t)queue
                   asyncThen:(SCXPromiseThenAsyncWorkBlock)then;
@end

NS_ASSUME_NONNULL_END
