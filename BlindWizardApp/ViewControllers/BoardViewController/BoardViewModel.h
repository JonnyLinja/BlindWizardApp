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

@interface BoardViewModel : NSObject
@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, strong) GridCalculator *gridCalculator; //inject
- (void) swipeLeftFromPoint:(CGPoint)point;
- (void) swipeRightFromPoint:(CGPoint)point;
@end
