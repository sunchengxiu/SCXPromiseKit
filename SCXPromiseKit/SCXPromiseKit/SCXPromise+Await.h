//
//  SCXPromise+Await.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 等待 promise 执行完成会继续向下执行，会卡住当前的线程，如果当前方法在主线程调用那么就会卡住主线程，建议开辟新线程
/// @param promise 需要等待的promise
/// @param error 发生的错误
FOUNDATION_EXTERN id __nullable SCXPromiseAwait(SCXPromise *promise , NSError **error);


NS_ASSUME_NONNULL_END
