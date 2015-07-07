//
//  RandomGenerator.h
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGenerator : NSObject
- (id) initWithMinimum:(NSInteger)minimum maximum:(NSInteger)maximum;
- (NSInteger) generate;
@end
