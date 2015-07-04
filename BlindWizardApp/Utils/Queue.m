//
//  Queue.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Queue.h"

@interface Queue()
@property (nonatomic, assign) BOOL hasObject;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation Queue

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.array = [NSMutableArray new];
    
    return self;
}

- (void) updateHasObject {
    //because NSMutableArray isn't KVO compliant
    self.hasObject = self.array.count > 0;
}

- (id) pop {
    //valid check
    if(!self.hasObject) return nil;
    
    id object = [self.array lastObject];
    [self.array removeLastObject];
    [self updateHasObject];
    return object;
}

- (void) push:(id)object {
    if(object) {
        [self.array addObject:object];
        [self updateHasObject];
    }
}

- (void) add:(id)object {
    if(object) {
        [self.array insertObject:object atIndex:0];
        [self updateHasObject];
    }
}

@end
