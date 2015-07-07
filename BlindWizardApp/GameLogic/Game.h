//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameDependencyFactory;
@class GameFlow;

@interface Game : NSObject
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, assign, readonly) NSInteger score;

- (id) initWithDependencyFactory:(id<GameDependencyFactory>)factory;

- (void) commandStartGameWithRows:(NSInteger)rows columns:(NSInteger)columns;
- (void) commandCallNextWave;
- (void) commandSwipeLeftOnRow:(NSInteger)row;
- (void) commandSwipeRightOnRow:(NSInteger)row;

@end
