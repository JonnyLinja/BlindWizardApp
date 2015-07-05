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
@property (nonatomic, assign) CGFloat verticalPadding;
@end

@implementation GridCalculator

- (void) calculateNumberOfRowsAndColumnsForSize:(CGSize)size {
    self.numRows = size.height / self.squareHeight;
    self.numColumns = size.width / self.squareWidth;
    self.size = size;
    
    CGFloat maxHeight = self.numRows * self.squareHeight;
    self.verticalPadding = size.height - maxHeight;
}

- (NSInteger) calculateRowForYPos:(CGFloat)yPos {
    return self.numRows - ((yPos-self.verticalPadding) / self.squareHeight);
}

// roundf
- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column {
    return CGPointZero;
}

@end
