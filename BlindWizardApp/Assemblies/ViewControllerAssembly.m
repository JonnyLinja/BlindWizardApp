//
//  ViewControllerAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ViewControllerAssembly.h"
#import "GameAssembly.h"
#import "GeneralAssembly.h"

#import "TitleViewController.h"
#import "LeaderboardViewController.h"
#import "PlayViewController.h"
#import "PlayViewModel.h"
#import "BoardViewController.h"
#import "BoardViewModel.h"

@implementation ViewControllerAssembly

- (TitleViewController *) titleViewController {
    return [TyphoonDefinition withClass:[TitleViewController class]];
}

- (LeaderboardViewController *) leaderboardViewController {
    return [TyphoonDefinition withClass:[LeaderboardViewController class]];
}

- (PlayViewController *) playViewController {
    return [TyphoonDefinition withClass:[PlayViewController class] configuration:^(TyphoonDefinition* definition) {
        [definition injectProperty:@selector(viewModel) with:[self playViewModel]];
    }];
}

- (PlayViewModel *) playViewModel {
    return [TyphoonDefinition withClass:[PlayViewModel class] configuration:^(TyphoonDefinition* definition) {
        [definition injectProperty:@selector(game) with:[self.gameAssembly game]];
        //GridCalculator needs to be manually injected by the VC
    }];
}

- (BoardViewController *) boardViewController {
    return [TyphoonDefinition withClass:[BoardViewController class] configuration:^(TyphoonDefinition* definition) {
        [definition injectProperty:@selector(viewModel) with:[self boardViewModel]];
    }];
}

- (BoardViewModel *) boardViewModel {
    return [TyphoonDefinition withClass:[PlayViewModel class] configuration:^(TyphoonDefinition* definition) {
        [definition injectProperty:@selector(game) with:[self.gameAssembly game]];
        [definition injectProperty:@selector(gridStorage) with:[self.generalAssembly gridStorage]];
        //GridCalculator needs to be manually injected by the VC
        //GameObjectFactory needs to be manually injected by the VC
    }];
}

@end