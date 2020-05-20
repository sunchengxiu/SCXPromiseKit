//
//  SCXPromise+Any.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise<Value> (Any)

/// 如果都fullfill，那么返回集合，如果有成功有失败，那么也返回成功失败的集合，如果都是失败，那么以最后一个失败为准，只返回一次
/// @param promises 所有的promise
+ (SCXPromise<NSArray *> *)any:(NSArray *)promises;

+ (SCXPromise<NSArray *> *)onQueue:(dispatch_queue_t)queue
                               any:(NSArray *)promises;
@end

NS_ASSUME_NONNULL_END
