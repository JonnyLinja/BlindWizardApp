//
//  GameBoard.m
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameBoard.h"

@interface GameBoard ()
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *nextWaveData;
@end

@implementation GameBoard

- (id) initWithRows:(NSInteger)numRows columns:(NSInteger)numColumns {
    self = [super init];
    if(!self) return nil;
    
    self.numRows = numRows;
    self.numColumns = numColumns;
    self.data = [NSMutableArray new];
    self.nextWaveData = [NSMutableArray new];
    self.isActive = YES;
    
    [self fillData];
    
    return self;
}

- (void) fillData {
    //fill data
    NSInteger count = self.numRows * self.numColumns;
    for(NSInteger i=0; i<count; i++) {
        [self.data setObject:@0 atIndexedSubscript:i];
    }
}

- (NSInteger) indexFromRow:(NSInteger)row column:(NSInteger)column {
    return (row * self.numColumns) + column;
}

@end
