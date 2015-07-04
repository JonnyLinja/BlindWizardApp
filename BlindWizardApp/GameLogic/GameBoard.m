//
//  GameBoard.m
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (NSInteger) indexFromRow:(NSInteger)row column:(NSInteger)column {
    return (row * self.numColumns) + column;
}

@end
