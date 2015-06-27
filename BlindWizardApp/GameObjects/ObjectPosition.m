//
//  ObjectPosition.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ObjectPosition.h"

@implementation ObjectPosition

- (id) initWithRow:(NSInteger)row andColumn:(NSInteger) column {
    self = [super init];
    if(!self) return nil;
    
    self.row = row;
    self.column = column;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if(copy) {
        [copy setRow:self.row];
        [copy setColumn:self.column];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return self.row == [other row] && self.column == [other column];
}

@end
