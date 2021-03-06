//
//  SCXPromisePrivate.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/9.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCXPromise.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value>()


typedef id __nullable (^ __nullable SCXPromiseChainedFulfillBlock)(Value __nullable value);
typedef id __nullable (^__nullable SCXPromiseChainedRejectBlock)(NSError *error);
typedef void (^SCXPromiseOnFulfillBlock)(Value __nullable value) ;
typedef void (^SCXPromiseOnRejectBlock)(NSError *error);
typedef void (^SCXPromiseAsyncFullFillBlock)(id __nullable asyncValue);
typedef void (^SCXPromiseWorkBlock)(Value __nullable value ,SCXPromiseAsyncFullFillBlock fullFillBlock);


+ (dispatch_group_t)dispatchGroup;
- (SCXPromise *) chainOnQueue:(dispatch_queue_t)queue
chainedFulfill:(SCXPromiseChainedFulfillBlock)chainedFulfill
                chainedReject:(SCXPromiseChainedRejectBlock)chainedReject;
- (SCXPromise *) chainOnQueue:(dispatch_queue_t)queue
chainedAsyncFulfill:(SCXPromiseWorkBlock)chainedFulfill
           chainedAsyncReject:(SCXPromiseChainedRejectBlock)chainedReject;
- (void)observOnQueue:(dispatch_queue_t)queue
fullFill:(SCXPromiseOnFulfillBlock)onFullFill
               reject:(SCXPromiseOnRejectBlock)onReject;
BOOL SCXWaitForPromisesWithTimeout(NSTimeInterval timeout);
@end


NS_ASSUME_NONNULL_END
