//
//  ViewControllerAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"

@class GameAssembly;
@class GeneralAssembly;

@class TitleViewController;
@class LeaderboardViewController;
@class PlayViewController;
@class PlayViewModel;
@class BoardViewController;
@class BoardViewModel;

@interface ViewControllerAssembly : TyphoonAssembly
@property(nonatomic, strong, readonly) GameAssembly *gameAssembly;
@property(nonatomic, strong, readonly) GeneralAssembly *generalAssembly;

- (TitleViewController *) titleViewController;
- (LeaderboardViewController *) leaderboardViewController;
- (PlayViewController *) playViewController;
- (PlayViewModel *) playViewModel;
- (BoardViewController *) boardViewController;
- (BoardViewModel *) boardViewModel;

@end
