//
//  LeaderboardViewModel.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "LeaderboardViewModel.h"
#import "TopScores.h"
#import "MTKObserving.h"

@interface LeaderboardViewModel ()
@property (nonatomic, strong) NSString *listOfTopScores;
@end

@implementation LeaderboardViewModel

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    [self map:@keypath(self.topScores.scores) to:@keypath(self.listOfTopScores) transform:^NSString *(NSArray *value) {
        if(!value || value.count == 0) {
            return @"0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0";
        }
        
        NSString *convertedString = [value componentsJoinedByString:@"\n\n"];
        for(NSInteger i=value.count; i<10; i++) {
            convertedString = [convertedString stringByAppendingString:@"\n\n0"];
        }
        return convertedString;
    }];
    
    return self;
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
