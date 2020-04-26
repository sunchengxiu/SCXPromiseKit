//
//  SCXPromise+All.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/24.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (All)

/// 全部执行成功
/// @param promises 要全部执行成功的 promis
+ (SCXPromise<NSArray *> *)all:(NSArray *)promises;

/// 指定队列执行
/// @param queue 指定队列
/// @param promises 需要全部执行成功的 promise 
+ (SCXPromise<NSArray *> *)onQueue:(dispatch_queue_t)queue
                               all:(NSArray *)promises ;
@end

NS_ASSUME_NONNULL_END
