//
//  NSString+GridPosition.m
//  BlindWizardApp
//
//  Created by N A on 6/29/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "NSString+GridPosition.h"

@implementation NSString (GridPosition)

+ (NSString *) stringFromRow:(NSInteger)row column:(NSInteger)column {
    return [NSString stringWithFormat:@"%li:%li", row, column];
}

@end
