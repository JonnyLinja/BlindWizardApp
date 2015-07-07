//
//  GameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GameDependencyFactory.h"

@protocol GameDependencyFactory;
@class GameBoard;

@protocol GameAction <NSObject>
@property (nonatomic, assign, readonly) CGFloat duration;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
