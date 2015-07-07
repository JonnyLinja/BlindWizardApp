//
//  NSObject+MTKTest.m
//  PentaShiftApp
//
//  Created by N A on 6/21/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "NSObject+MTKTest.h"
#import "MTKObserving.h"

@interface NSObject(MTKHack)
- (MTKObserver *)mtk_observerForKeyPath:(NSString *)keyPath owner:(id)owner;
@end

@implementation NSObject (MTKTest)

- (void) notifyKeyPath:(NSString *)keyPath change:(NSDictionary *)change {
    MTKObserver *observer = [self mtk_observerForKeyPath:keyPath owner:self];
    [observer observeValueForKeyPath:keyPath
                            ofObject:self
                              change:change
                             context:nil];
}

- (void) notifyKeyPath:(NSString *)keyPath setTo:(id)to {
    [self notifyKeyPath:keyPath
                 change:@{
                          NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
                          NSKeyValueChangeNewKey: to,
                          }];
}

- (void) notifyKeyPath:(NSString *)keyPath setFrom:(id)from to:(id)to {
    [self notifyKeyPath:keyPath
                 change:@{
                          NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
                          NSKeyValueChangeNewKey: to,
                          NSKeyValueChangeOldKey: from,
                          }];
}

@end
