//
//  ModelAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ModelAssembly.h"
#import "TopScores.h"

@implementation ModelAssembly

- (TopScores *) topScores {
    return [TyphoonDefinition withClass:[TopScores class]];
}

@end
