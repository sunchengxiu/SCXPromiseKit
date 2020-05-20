//
//  SCXPromise+Timeout.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <SCXPromiseKit/SCXPromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCXPromise (Timeout)
- (SCXPromise *)timeout:(NSTimeInterval)interval;
- (SCXPromise *)onQueue:(dispatch_queue_t)queue
                timeout:(NSTimeInterval)interval;
@end

NS_ASSUME_NONNULL_END
