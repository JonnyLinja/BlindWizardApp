//
//  LeaderboardViewModel.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "LeaderboardViewModel.h"

@interface LeaderboardViewModel ()
@property (nonatomic, strong) NSString *listOfTopScores;
@end

@implementation LeaderboardViewModel

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.listOfTopScores = @"foobar";
    
    return self;
}

@end
