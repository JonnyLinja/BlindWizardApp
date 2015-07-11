//
//  RandomGenerator.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "RandomGenerator.h"

@interface RandomGenerator ()
@property (nonatomic, assign) NSInteger minimum;
@property (nonatomic, assign) NSInteger maximum;
@end

@implementation RandomGenerator

- (id) initWithMinimum:(NSInteger)minimum maximum:(NSInteger)maximum {
    self = [super init];
    if(!self) return nil;
    
    self.minimum = minimum;
    self.maximum = maximum;
    
    return self;
}

- (NSInteger) generate {
    uint32_t difference = (uint32_t)(self.maximum-self.minimum+1);
    return arc4random_uniform(difference)+self.minimum;
}

@end
