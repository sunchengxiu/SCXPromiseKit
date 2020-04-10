//
//  SCXTestHelper.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static inline void SCXDelay(NSTimeInterval interval, void (^work)(void)) {
  int64_t const timeToWait = (int64_t)(interval * NSEC_PER_SEC);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeToWait),
                 dispatch_get_main_queue(), ^{
                   work();
                 });
}
NS_ASSUME_NONNULL_END
