//
//  EnemyViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

//TODO: I am trying for MVVM but EnemyViewModel seems completely worthless
//Would be much cleaner if it was just EnemyView right now
//Considering making Enemy a protocol and passing that around to the ViewModels
//It would be cleaner that way, though not MVVM

#import "EnemyViewModel.h"

@interface EnemyViewModel()
@property (nonatomic, assign) EnemyAnimationType animationType;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, assign) CGPoint snapPoint;
@end

@implementation EnemyViewModel

- (void) runCreateAnimation {
    self.animationType = CreateAnimation;
}

- (void) animateMoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAnimation;
}

- (void) animateMoveToCGPoint:(CGPoint)movePoint thenSnapToCGPoint:(CGPoint)snapPoint {
    self.movePoint = movePoint;
    self.snapPoint = snapPoint;
    self.animationType = MoveAndSnapAnimation;
}

- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAndRemoveAnimation;
}

- (void) runDangerAnimation {
    
}

- (void) stopDangerAnimation {
    
}

- (void) runDestroyAnimation {
    self.animationType = DestroyAndRemoveAnimation;
}

@end
