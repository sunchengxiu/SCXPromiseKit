//
//  SCXPromise+Then.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/10.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+ThenSync.h"
#import "SCXPromisePrivate.h"
@implementation SCXPromise (Then)
-(SCXPromise *)then:(SCXPromiseThenWorkBlock)then{
    return [self onQueue:SCXPromise.dufaultDispatchQueue then:then];
}
-(SCXPromise *)onQueue:(dispatch_queue_t)queue then:(SCXPromiseThenWorkBlock)then{
    return [self chainOnQueue:queue chainedFulfill:then chainedReject:nil];
}
@end
