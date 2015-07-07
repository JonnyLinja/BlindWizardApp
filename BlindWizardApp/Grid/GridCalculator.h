//
//  GridCalculator.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GridCalculator : NSObject
@property (nonatomic, assign, readonly) NSInteger numRows;
@property (nonatomic, assign, readonly) NSInteger numColumns;
@property (nonatomic, assign, readonly) CGFloat elementWidth;
@property (nonatomic, assign, readonly) CGFloat elementHeight;
- (id) initWithWidth:(CGFloat)width height:(CGFloat)height elementWidth:(CGFloat)elementWidth elementHeight:(CGFloat)elementHeight;
- (NSInteger) calculateRowForYPos:(CGFloat)yPos;
- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column;
@end
