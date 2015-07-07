//
//  GridCalculatorFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

@class GridCalculator;

@protocol GridCalculatorFactory <NSObject>
- (GridCalculator *) gridCalculatorWithSize:(CGSize)size;
@end