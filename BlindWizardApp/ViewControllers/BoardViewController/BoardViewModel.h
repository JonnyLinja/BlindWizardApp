//
//  BoardViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Game;
@class GridCalculator;
@class GameFactory;

@interface BoardViewModel : NSObject

@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, strong) GridCalculator *gridCalculator; //inject
@property (nonatomic, strong) GameFactory *gameFactory; //inject

- (void) swipeLeftFromPoint:(CGPoint)point;
- (void) swipeRightFromPoint:(CGPoint)point;

//for testing only
@property (nonatomic, strong) NSMutableDictionary *enemies;
- (void) create:(NSNotification *)notification;
- (void) shiftLeft:(NSNotification *)notification;
@end
