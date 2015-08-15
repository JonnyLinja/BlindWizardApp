//
//  GameBoard.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBoard : NSObject
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger numRows;
@property (nonatomic, assign, readonly) NSInteger numColumns;
@property (nonatomic, strong, readonly) NSMutableArray *data;
@property (nonatomic, strong, readonly) NSMutableArray *nextWaveData;
@property (nonatomic, assign) BOOL isActive;
- (id) initWithRows:(NSInteger)numRows columns:(NSInteger)numColumns;
- (NSInteger) indexFromRow:(NSInteger)row column:(NSInteger)column;
@end
