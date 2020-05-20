//
//  SCXPromise+Await.m
//  SCXPromiseKit
//
//  Created by 孙承秀 on 2020/5/20.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "SCXPromise+Await.h"
#import "SCXPromisePrivate.h"

id __nullable SCXPromiseAwait(SCXPromise *promise , NSError **error){
    assert(promise);
    static dispatch_once_t onceToken;
    static dispatch_queue_t queue;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.rongcloud.cn.awit", DISPATCH_QUEUE_CONCURRENT);
    });
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block id res;
    __block NSError *rejectErr;
    [promise chainOnQueue:queue chainedFulfill:^id _Nullable(id  _Nullable value) {
        res = value;
        dispatch_semaphore_signal(sem);
        return value;
    } chainedReject:^id _Nullable(NSError * _Nonnull error) {
        rejectErr = error;
        dispatch_semaphore_signal(sem);
        return error;
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    if (rejectErr) {
        *error = rejectErr;
    }
    if (res == nil && rejectErr != nil) {
        res = rejectErr;
    }
    return res;
}
