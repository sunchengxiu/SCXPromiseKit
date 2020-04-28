//
//  SCXPromise.h
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/4/8.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SCXPromiseState) {
  SCXPromiseStatePending = 0,
  SCXPromiseStateFulfilled,
  SCXPromiseStateRejected,
};
@interface SCXPromise<Value> : NSObject

/**
 value
 */
@property(nonatomic , strong , readonly)id value;

/**
 state
 */
@property(nonatomic , assign , readonly)SCXPromiseState state;

/**
 error
 */
@property(nonatomic , strong , readonly)NSError *error;


/**
 default dispatch queue
 */
@property(class)dispatch_queue_t dufaultDispatchQueue;

+ (instancetype)pendingPromise ;

+ (instancetype)resolvedWith:(nullable id)resolution ;

- (void)fulfill:(nullable Value)value NS_REFINED_FOR_SWIFT;

- (void)reject:(NSError *)error NS_REFINED_FOR_SWIFT;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
