//
//  GridCalculatorFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

@class GridCalculator;

@protocol GridCalculatorFactory <NSObject>
- (GridCalculator *) gridCalculatorWithWidth:(NSNumber *)width height:(NSNumber *)height;
@end