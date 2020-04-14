//
//  SCXPromise+ThenAsync.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+ThenAsync.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (ThenAsync)
-(SCXPromise *)asyncThen:(SCXPromiseThenAsyncWorkBlock)then{
    return [self onQueue:SCXPromise.dufaultDispatchQueue asyncThen:then];
}
-(SCXPromise *)onQueue:(dispatch_queue_t)queue asyncThen:(SCXPromiseThenAsyncWorkBlock)then{
    return [self chainOnQueue:queue chainedAsyncFulfill:then chainedAsyncReject:nil];
}
@end
