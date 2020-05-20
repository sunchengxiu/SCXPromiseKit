//
//  SCXPromise+Race.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise (Race)

/// 几个promise同时执行,只fullfill最先返回的那个
/// @param promises 需要赛跑的 promises
+ (instancetype)race:(NSArray *)promises;

+ (instancetype)onQueue:(dispatch_queue_t)queue race:(NSArray *)promises ;
@end

NS_ASSUME_NONNULL_END
