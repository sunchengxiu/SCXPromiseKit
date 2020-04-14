//
//  SCXPromise.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/8.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise.h"
#import "SCXPromisePrivate.h"
static dispatch_queue_t SCXDefaultDispatchQueue;

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
- (instancetype)initWithResolution:(nullable id )resulution{
    if (self = [super init]) {
        if ([resulution isKindOfClass:[NSError class]]) {
            _state = SCXPromiseStateRejected;
            _error = (NSError *)resulution;
        } else {
            _state = SCXPromiseStateFulfilled;
            _value = resulution;
        }
    }
    return self;
}
+(instancetype)pendingPromise{
    return [[self alloc] initPending];
}
+(instancetype)resolvedWith:(id)resolution{
    return [[self alloc] initWithResolution:resolution];
}
-(SCXPromiseState)state{
    @synchronized (self) {
        return _state;
    }
}
-(id)value{
    @synchronized (self) {
        return _value;
    }
}
-(NSError *)error{
    @synchronized (self) {
        return _error;
    }
}
-(void)dealloc{
    if (_state == SCXPromiseStatePending) {
        dispatch_group_leave(SCXPromise.dispatchGroup);
    }
}
- (void)reject:(NSError *)error{
    NSAssert([error isKindOfClass:[NSError class]], @"It must be the type \"NSerror\"");
    @synchronized (self) {
        if (_state == SCXPromiseStatePending) {
            _state = SCXPromiseStateRejected;
            _error = error;
            _pendingObjects = nil;
            for (SCXPromiseObserver obser in _observers) {
                obser(_state,error);
            }
            _observers = nil;
            dispatch_group_leave(SCXPromise.dispatchGroup);
        }
    }
}
-(void)fulfill:(id)value{
    if ([value isKindOfClass:[NSError class]]) {
        [self reject:(NSError *)value];
    } else {
        if (_state == SCXPromiseStatePending) {
            _state = SCXPromiseStateFulfilled;
            _value = value;
            _pendingObjects = nil;
            for (SCXPromiseObserver obser in _observers) {
                obser(_state,_value);
            }
            _observers = nil;
            dispatch_group_leave(SCXPromise.dispatchGroup);

        }
    }
}
- (void)observOnQueue:(dispatch_queue_t)queue
             fullFill:(SCXPromiseOnFulfillBlock)onFullFill
               reject:(SCXPromiseOnRejectBlock)onReject{
    @synchronized (self) {
        switch (_state) {
            case SCXPromiseStatePending:{
                if (!_observers) {
                    _observers = [NSMutableArray array];
                }
                SCXPromiseObserver obser = ^ (SCXPromiseState state, id __nullable resolution){
                    dispatch_group_async(SCXPromise.dispatchGroup, queue, ^{
                        switch (state) {
                            case SCXPromiseStatePending:
                                {
                                }
                                break;
                            case SCXPromiseStateFulfilled:{
                                onFullFill(resolution);

                            }
                                break;
                            case SCXPromiseStateRejected:{
                                onReject(resolution);
                            }
                                break;
                                
                            default:
                                break;
                        }
                    });
                };
                [_observers addObject:obser];
            }
                break;
            case SCXPromiseStateFulfilled:{
                dispatch_group_async(SCXPromise.dispatchGroup, queue, ^{
                    onFullFill(self->_value);
                });
            }
                break;
            case SCXPromiseStateRejected:{
                dispatch_group_async(SCXPromise.dispatchGroup, queue, ^{
                    onReject(self->_error);
                });
            }
                break;
                
            default:
                break;
        }
    }
}
- (SCXPromise *) chainOnQueue:(dispatch_queue_t)queue
               chainedFulfill:(SCXPromiseChainedFulfillBlock)chainedFulfill
                chainedReject:(SCXPromiseChainedRejectBlock)chainedReject{
    SCXPromise *promise = [SCXPromise pendingPromise];
    void (^resolve)(id value) = ^ (id __nullable value){
        if ([value isKindOfClass:[SCXPromise class]]) {
            [value observOnQueue:queue fullFill:^(id  _Nullable value) {
                
                [promise fulfill:value];
            } reject:^(NSError * _Nonnull error) {
                
                [promise reject:error];
            }];
        } else {
            [promise fulfill:value];
        }
    };
    [self observOnQueue:queue fullFill:^(id  _Nullable value) {
        value = chainedFulfill ? chainedFulfill(value) : value;
        resolve(value);
    } reject:^(NSError * _Nonnull error) {
        id value = chainedReject ? chainedReject(error) : error;
        resolve(value);
    }];
    return promise;
}
- (SCXPromise *) chainOnQueue:(dispatch_queue_t)queue
               chainedAsyncFulfill:(SCXPromiseWorkBlock)asyncFulfill
                chainedAsyncReject:(SCXPromiseChainedRejectBlock)chainedReject{
    SCXPromise *promise = [SCXPromise pendingPromise];
    void (^resolve)(id value) = ^ (id __nullable value){
        if ([value isKindOfClass:[SCXPromise class]]) {
            [value observOnQueue:queue fullFill:^(id  _Nullable value) {
                
                [promise fulfill:value];
            } reject:^(NSError * _Nonnull error) {
                
                [promise reject:error];
            }];
        } else {
            [promise fulfill:value];
        }
    };
    [self observOnQueue:queue fullFill:^(id  _Nullable value) {
        if (asyncFulfill) {
            asyncFulfill(value,^(id asyncValue){
                resolve(asyncValue);
            });
        } else {
            resolve(value);
        }
    } reject:^(NSError * _Nonnull error) {
        id value = chainedReject ? chainedReject(error) : error;
        resolve(value);
    }];
    return promise;
}
BOOL SCXWaitForPromisesWithTimeout(NSTimeInterval timeout) {
  BOOL isTimedOut = NO;
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
  static NSTimeInterval const minimalTimeout = 0.01;
  static int64_t const minimalTimeToWait = (int64_t)(minimalTimeout * NSEC_PER_SEC);
  dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, minimalTimeToWait);
  dispatch_group_t dispatchGroup = SCXPromise.dispatchGroup;
  NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
  while (dispatch_group_wait(dispatchGroup, waitTime)) {
    isTimedOut = timeoutDate.timeIntervalSinceNow < 0.0;
    if (isTimedOut) {
      break;
    }
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:minimalTimeout]];
  }
  return !isTimedOut;
}
@end
