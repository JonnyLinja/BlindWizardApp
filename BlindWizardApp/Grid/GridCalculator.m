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
@property (nonatomic, assign) CGFloat elementWidth;
@property (nonatomic, assign) CGFloat elementHeight;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;
@end

@implementation GridCalculator

- (id) initWithWidth:(CGFloat)width height:(CGFloat)height elementWidth:(CGFloat)elementWidth elementHeight:(CGFloat)elementHeight {
    self = [super init];
    if(!self) return nil;
    
    self.size = CGSizeMake(width, height);
    self.elementWidth = elementWidth;
    self.elementHeight = elementHeight;
    
    [self calculateNumberOfRowsAndColumnsForSize:self.size];
    
    return self;
}

- (void) calculateNumberOfRowsAndColumnsForSize:(CGSize)size {
    self.numRows = 1 + (size.height / self.elementHeight);
    self.numColumns = size.width / self.elementWidth;
    
    CGFloat maxHeight = self.numRows * self.elementHeight;
    self.verticalPadding = size.height - maxHeight;
    
    CGFloat maxWidth = self.numColumns * self.elementWidth;
    CGFloat maxHorizontalPadding = size.width - maxWidth;
    self.horizontalPadding = maxHorizontalPadding / (self.numColumns-1);
}

- (NSInteger) calculateRowForYPos:(CGFloat)yPos {
    return self.numRows - ((yPos-self.verticalPadding) / self.elementHeight);
}

- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column {
    //x
    CGFloat x;
    if(column == 0) {
        //first
        x = 0;
    }else if(column == self.numColumns-1) {
        //last
        x = self.size.width - self.elementWidth;
    }else {
        //middle
        x = round(column * (self.elementWidth + self.horizontalPadding));
    }
    
    //y
    CGFloat y = self.size.height - ((row+1) * self.elementHeight);
    
    //return
    return CGPointMake(x, y);
}

@end
