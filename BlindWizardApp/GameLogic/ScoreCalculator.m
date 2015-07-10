//
//  ScoreCalculator.m
//  BlindWizardApp
//
//  Created by N A on 7/9/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ScoreCalculator.h"

@implementation ScoreCalculator

- (NSInteger) calculateScoreFromNumberOfEnemiesDestroyed:(NSInteger)count {
    return count * count;
}

@end
