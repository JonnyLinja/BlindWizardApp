//
//  GridCalculator.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GridCalculator.h"

@interface GridCalculator ()
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) CGSize size;
@end

@implementation GridCalculator

- (void) calculateNumberOfRowsAndColumnsForSize:(CGSize)size {
    self.numRows = size.width / self.squareWidth;
    self.numColumns = size.height / self.squareHeight;
    self.size = size;
}

// roundf
- (NSInteger) calculateRowForYPos:(CGFloat)yPos {
    return yPos / self.squareHeight;
}

- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column {
    return CGPointZero;
}

@end
