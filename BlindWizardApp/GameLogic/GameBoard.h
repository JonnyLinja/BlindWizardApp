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
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, strong) NSMutableArray *data;
@end
