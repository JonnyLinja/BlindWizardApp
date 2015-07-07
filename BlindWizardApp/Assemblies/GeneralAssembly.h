//
//  GeneralAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"

@class Queue;
@class RandomGenerator;
@class GridCalculator;
@class GridStorage;
@class GridStorageKeyGenerator;

@interface GeneralAssembly : TyphoonAssembly

- (Queue *) queue;
- (RandomGenerator *) randomGenerator;
- (GridStorage *) gridStorage;

@end
