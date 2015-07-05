//
//  GridCalculator.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GridCalculator.h"
#import <tgmath.h>

@interface GridCalculator ()
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;
@end

@implementation GridCalculator

- (void) calculateNumberOfRowsAndColumnsForSize:(CGSize)size {
    self.numRows = size.height / self.squareHeight;
    self.numColumns = size.width / self.squareWidth;
    self.size = size;
    
    CGFloat maxHeight = self.numRows * self.squareHeight;
    self.verticalPadding = size.height - maxHeight;
    
    CGFloat maxWidth = self.numColumns * self.squareWidth;
    CGFloat maxHorizontalPadding = size.width - maxWidth;
    self.horizontalPadding = maxHorizontalPadding / (self.numColumns-1);
}

- (NSInteger) calculateRowForYPos:(CGFloat)yPos {
    return self.numRows - ((yPos-self.verticalPadding) / self.squareHeight);
}

// round
- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column {
    //x
    CGFloat x;
    if(column == 0) {
        //first
        x = 0;
    }else if(column == self.numColumns-1) {
        //last
        x = self.size.width - self.squareWidth;
    }else {
        //middle
        x = (column * self.squareWidth);
        x = -1;
    }
    
    //y
    CGFloat y = self.size.height - ((row+1) * self.squareHeight);
    
    return CGPointMake(x, y);
}

@end
