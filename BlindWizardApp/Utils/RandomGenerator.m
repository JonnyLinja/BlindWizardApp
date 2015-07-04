//
//  RandomGenerator.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "RandomGenerator.h"

@implementation RandomGenerator

- (NSInteger) generate {
    uint32_t difference = (uint32_t)(self.maximum-self.minimum);
    return arc4random_uniform(difference)+self.minimum;
}

@end
