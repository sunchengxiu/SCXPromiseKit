//
//  SCXPromise+Validate.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (Validate)

typedef BOOL (^SCXPromiseValidateWorkBlock)(Value __nullable value);

/// 检查fullfill的值是否合法
/// @param predicate 检查 block
- (SCXPromise *)validate:(SCXPromiseValidateWorkBlock)predicate ;
- (SCXPromise *)onQueue:(dispatch_queue_t)queue
               validate:(SCXPromiseValidateWorkBlock)predicate;
@end

NS_ASSUME_NONNULL_END
