//
//  ViewControllerAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"

@class GameAssembly;
@class GameObjectAssembly;
@class GeneralAssembly;
@class ModelAssembly;

@class TitleViewController;
@class LeaderboardViewController;
@class LeaderboardViewModel;
@class PlayViewController;
@class PlayViewModel;
@class BoardViewController;
@class BoardViewModel;

@interface ViewControllerAssembly : TyphoonAssembly
@property(nonatomic, strong, readonly) GameAssembly *gameAssembly;
@property(nonatomic, strong, readonly) GameObjectAssembly *gameObjectAssembly;
@property(nonatomic, strong, readonly) GeneralAssembly *generalAssembly;
@property(nonatomic, strong, readonly) ModelAssembly *modelAssembly;

- (TitleViewController *) titleViewController;
- (LeaderboardViewController *) leaderboardViewController;
- (LeaderboardViewModel *) leaderboardViewModel;
- (PlayViewController *) playViewController;
- (PlayViewModel *) playViewModel;
- (BoardViewController *) boardViewController;
- (BoardViewModel *) boardViewModel;

@end
