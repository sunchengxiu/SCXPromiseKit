//
//  SCXPromise.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/8.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise.h"
static dispatch_queue_t SCXDefaultDispatchQueue;
typedef NS_ENUM(NSInteger, SCXPromiseState) {
  SCXPromiseStatePending = 0,
  SCXPromiseStateFulfilled,
  SCXPromiseStateRejected,
};
typedef void (^SCXPromiseObserver)(SCXPromiseState state, id __nullable resolution);
@implementation SCXPromise{
  SCXPromiseState _state;
  NSMutableSet *__nullable _pendingObjects;
  id __nullable _value;
  NSError *__nullable _error;
  NSMutableArray<SCXPromiseObserver> *_observers;
}
+(void)initialize{
    if (self == [SCXPromise class]) {
        SCXDefaultDispatchQueue = dispatch_get_main_queue();
    }
}
+(dispatch_queue_t)dufaultDispatchQueue{
    @synchronized (self) {
        return SCXDefaultDispatchQueue;
    }
}
+(void)setDufaultDispatchQueue:(dispatch_queue_t)dufaultDispatchQueue{
    @synchronized (self) {
        SCXDefaultDispatchQueue = dufaultDispatchQueue;
    }
}
+ (dispatch_group_t)dispatchGroup {
  static dispatch_group_t gDispatchGroup;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gDispatchGroup = dispatch_group_create();
  });
  return gDispatchGroup;
}
- (instancetype)initPending{
    if (self = [super init]) {
        dispatch_group_enter(SCXPromise.dispatchGroup);
    }
    return self;
}
+(instancetype)pendingPromise{
    return [[self alloc] initPending];
}

@end
