//
//  GameBoard+Test.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameBoard.h"

@interface GameBoard (Test)
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *nextWaveData;
@end
