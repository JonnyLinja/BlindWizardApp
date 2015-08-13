//
//  DelayGameAction.m
//  BlindWizardApp
//
//  Created by N A on 8/11/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DelayGameAction.h"

@interface DelayGameAction ()
@property (nonatomic, assign) CGFloat duration;
@end

@implementation DelayGameAction

- (id) initWithDuration:(CGFloat)duration {
    self = [super init];
    if(!self) return nil;
    
    self.duration = duration;
    
    return self;
}

- (void) execute {
    
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return nil;
}

@end
