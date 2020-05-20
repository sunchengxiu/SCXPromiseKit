//
//  SCXPromise+Validate.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Validate.h"
#import "SCXPromisePrivate.h"

@implementation SCXPromise (Validate)
NSErrorDomain const SCXPromiseValidateErrorDomain = @"com.rongcloud.validate.error";
- (SCXPromise*)validate:(SCXPromiseValidateWorkBlock)predicate {
  return [self onQueue:SCXPromise.dufaultDispatchQueue validate:predicate];
}

- (SCXPromise*)onQueue:(dispatch_queue_t)queue validate:(SCXPromiseValidateWorkBlock)predicate {
  NSParameterAssert(queue);
  NSParameterAssert(predicate);

  SCXPromiseChainedFulfillBlock chainedFulfill = ^id(id value) {
    return predicate(value) ? value :
                              [[NSError alloc] initWithDomain:SCXPromiseValidateErrorDomain
                                                         code:2
                                                     userInfo:nil];
  };
  return [self chainOnQueue:queue chainedFulfill:chainedFulfill chainedReject:nil];
}
@end
