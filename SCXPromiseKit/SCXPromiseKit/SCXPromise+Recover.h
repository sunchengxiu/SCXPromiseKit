//
//  SCXPromise+Recover.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/28.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef id __nullable (^SCXPromiseRecoverWorkBlock)(NSError *error);
@interface SCXPromise<Value> (Recover)

/// 截获某个错误后，尝试恢复这个错误
/// @param recover 截获某错误
- (SCXPromise *)recover:(SCXPromiseRecoverWorkBlock)recover;
- (SCXPromise *)onQueue:(dispatch_queue_t)queue recover:(SCXPromiseRecoverWorkBlock)recover;
@end

NS_ASSUME_NONNULL_END
