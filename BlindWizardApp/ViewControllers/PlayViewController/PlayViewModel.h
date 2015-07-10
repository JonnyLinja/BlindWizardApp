//
//  PlayViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Game;
@class GridCalculator;
@class TopScores;

@interface PlayViewModel : NSObject
@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, strong) GridCalculator *calculator; //inject
@property (nonatomic, strong) TopScores *topScores; //inject
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, strong, readonly) NSString *score;
@property (nonatomic, assign, readonly) CGFloat boardVisibility;
- (void) callNextWave;
- (void) startGame;
@end
