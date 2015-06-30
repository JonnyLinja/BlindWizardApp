//
//  NSString+GridPosition.h
//  BlindWizardApp
//
//  Created by N A on 6/29/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//
//  Category is a hack helper method for NSDictionary purposes
//  Trying to make an actual object implemented NSCopying and isEqual resulted in inconsistent behavior
//  So going with a string instead
//

#import <Foundation/Foundation.h>

@interface NSString (GridPosition)
+ (NSString *) stringFromRow:(NSInteger)row column:(NSInteger)column;
@end
