//
//  GeneralAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "GridCalculatorFactory.h"

@class Queue;
@class RandomGenerator;
@class GridCalculator;
@class GridStorage;
@class GridStorageKeyGenerator;

@interface GeneralAssembly : TyphoonAssembly

- (Queue *) queue;
- (RandomGenerator *) randomGenerator;
- (GridCalculator *) gridCalculatorWithSize:(CGSize)size;
- (GridStorage *) gridStorage;
- (GridStorageKeyGenerator *) gridStoryKeyGenerator;

@end
