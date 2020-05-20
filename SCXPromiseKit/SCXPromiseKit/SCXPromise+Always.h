//
//  SCXPromise+Always.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (Always)

typedef void (^SCXPromiseAlwaysWorkBlock)(void) ;

/// 无论成功还是失败都 always 回调
/// @param work 回调
- (SCXPromise *)always:(SCXPromiseAlwaysWorkBlock)work ;

- (SCXPromise *)onQueue:(dispatch_queue_t)queue
                 always:(SCXPromiseAlwaysWorkBlock)work ;
@end

NS_ASSUME_NONNULL_END
