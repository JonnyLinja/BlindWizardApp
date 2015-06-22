//
//  NSObject+MTKTest.h
//  PentaShiftApp
//
//  Created by N A on 6/21/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MTKTest)
- (void) notifyKeyPath:(NSString *)keyPath change:(NSDictionary *)change;
- (void) notifyKeyPath:(NSString *)keyPath setTo:(id)to;
- (void) notifyKeyPath:(NSString *)keyPath setFrom:(id)from to:(id)to;
@end
