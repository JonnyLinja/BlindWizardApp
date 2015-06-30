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
@class GridStorage;

@interface BoardViewModel : NSObject

@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, strong) GridCalculator *gridCalculator; //inject
@property (nonatomic, strong) GameFactory *gameFactory; //inject
@property (nonatomic, strong) GridStorage *gridStorage; //inject

- (void) swipeLeftFromPoint:(CGPoint)point;
- (void) swipeRightFromPoint:(CGPoint)point;

- (void) create:(NSNotification *)notification;
- (void) shiftLeft:(NSNotification *)notification;
- (void) shiftRight:(NSNotification *)notification;
- (void) moveToRowHead:(NSNotification *)notification;
- (void) moveToRowTail:(NSNotification *)notification;
- (void) drop:(NSNotification *)notification;
- (void) danger:(NSNotification *)notification;
- (void) pacify:(NSNotification *)notification;
- (void) destroy:(NSNotification *)notification;
@end
