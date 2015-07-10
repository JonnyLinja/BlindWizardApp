//
//  TopScores.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TopScores.h"

@interface TopScores ()
@property (nonatomic, strong) NSArray *scores;
@end

@implementation TopScores

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.scores = [[NSUserDefaults standardUserDefaults] objectForKey:@"scores"];
    
    return self;
}

- (void) addScore:(NSInteger)score {
    if(score <= 0) return;

    if(self.scores.count < 10) {
        //create array
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.scores];
        
        //add it
        [array addObject:@(score)];
        
        //sort it
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [array sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        //store it
        self.scores = [array copy];
        
        //save it
        [[NSUserDefaults standardUserDefaults] setObject:self.scores forKey:@"scores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if(score > [[self.scores lastObject] integerValue]) {
        //create array
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.scores];
        
        //remove last
        [array removeLastObject];
        
        //add it
        [array addObject:@(score)];
        
        //sort it
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [array sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        //store it
        self.scores = [array copy];
        
        //save it
        [[NSUserDefaults standardUserDefaults] setObject:self.scores forKey:@"scores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
