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
@property (nonatomic, readonly) NSInteger numColumns;
@property (nonatomic, readonly) CGFloat squareWidth;
@property (nonatomic, readonly) CGFloat squareHeight;
- (NSInteger) calculateRowForYPos:(CGFloat)yPos;
- (CGPoint) calculatePointForRow:(NSInteger)row column:(NSInteger)column;
@end
