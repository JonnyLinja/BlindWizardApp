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
#import "EnemyOutlineView.h"
#import "EnemyOutlineViewModel.h"
#import "GridCalculator.h"

@interface GameObjectFactory ()
@property (nonatomic, strong) id<GameObjectDependencyFactory> factory; //inject
@property (nonatomic, strong) GridCalculator *calculator; //inject
@property (nonatomic, weak) UIView *view; //inject
@property (nonatomic, strong) NSArray *config; //inject
@property (nonatomic, assign) NSInteger count; //accessibility
@end

@implementation GameObjectFactory

- (id) initWithView:(UIView *)view calculator:(GridCalculator *)calculator dependencyFactory:(id<GameObjectDependencyFactory>)factory config:(NSArray *)config {
    self = [super init];
    if(!self) return nil;
    
    self.view = view;
    self.calculator = calculator;
    self.factory = factory;
    self.config = config;
    
    return self;
}

- (EnemyViewModel *) createEnemyWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column {
    //point
    CGPoint point = [self.calculator calculatePointForRow:row column:column];
    
    //config
    NSDictionary *configuration = [self.config objectAtIndex:type-1];
    
    //evm
    EnemyViewModel *evm = [self.factory enemyViewModelWithType:@(type) configuration:configuration];
    
    //ev
    EnemyView *ev = [self.factory enemyViewWithViewModel:evm];
    ev.frame = CGRectMake(point.x, point.y, self.calculator.elementWidth, self.calculator.elementHeight);
    ev.accessibilityIdentifier = [NSString stringWithFormat:@"Enemy%zd", self.count++];
    [self.view addSubview:ev];
    
    //return
    return evm;
}

- (EnemyOutlineViewModel *) createEnemyOutlineWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column {
    //point
    CGPoint point = [self.calculator calculatePointForRow:row column:column];
    
    //config
    NSDictionary *configuration = [self.config objectAtIndex:type-1];
    
    //eovm
    EnemyOutlineViewModel *eovm = [self.factory enemyOutlineViewModelWithType:@(type) configuration:configuration];
    
    //eov
    EnemyOutlineView *eov = [self.factory enemyOutlineViewWithViewModel:eovm];
    eov.frame = CGRectMake(point.x, point.y, self.calculator.elementWidth, self.calculator.elementHeight);
    eov.accessibilityIdentifier = [NSString stringWithFormat:@"EnemyOutline%zd", self.count++];
    [self.view addSubview:eov];
    
    //return
    return eovm;
}

@end
