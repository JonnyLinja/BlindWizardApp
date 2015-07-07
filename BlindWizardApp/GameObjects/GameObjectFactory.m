//
//  GameObjectFactory.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameObjectFactory.h"
#import "GameObjectDependencyFactory.h"
#import "EnemyView.h"
#import "EnemyViewModel.h"
#import "GridCalculator.h"

@interface GameObjectFactory ()
@property (nonatomic, strong) id<GameObjectDependencyFactory> factory; //inject
@property (nonatomic, strong) GridCalculator *calculator; //inject
@property (nonatomic, weak) UIView *view; //inject
@end

@implementation GameObjectFactory

- (id) initWithView:(UIView *)view calculator:(GridCalculator *)calculator dependencyFactory:(id<GameObjectDependencyFactory>)factory {
    self = [super init];
    if(!self) return nil;
    
    self.view = view;
    self.calculator = calculator;
    self.factory = factory;
    
    return self;
}

- (EnemyViewModel *) createEnemyWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column {
    //point
    CGPoint point = [self.calculator calculatePointForRow:row column:column];
    
    //config
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
    NSDictionary *gameConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    NSArray *enemies = [gameConfig objectForKey:@"Enemies"];
    NSDictionary *configuration = [enemies objectAtIndex:type-1];
    
    //evm
    EnemyViewModel *evm = [self.factory enemyViewModelWithType:@(type) configuration:configuration];
    
    //ev
    EnemyView *ev = [self.factory enemyViewWithViewModel:evm];
    ev.frame = CGRectMake(point.x, point.y, self.calculator.elementWidth, self.calculator.elementHeight);
    [self.view addSubview:ev];
    
    //return
    return evm;
}

@end
