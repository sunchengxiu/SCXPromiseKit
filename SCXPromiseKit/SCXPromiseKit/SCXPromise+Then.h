//
//  SCXPromise+Then.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//


#import <SCXPromiseKit/SCXPromiseKit.h>
#import "SCXPromise.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (Then)
typedef id __nullable (^SCXPromiseThenWorkBlock)(Value __nullable value);

/// then
/// @param then then block
- (SCXPromise *)then:(SCXPromiseThenWorkBlock)then;

/// onqueue then
/// @param queue queue
/// @param then then block
- (SCXPromise *)onQueue:(dispatch_queue_t)queue
                   then:(SCXPromiseThenWorkBlock)then;

@end

NS_ASSUME_NONNULL_END
