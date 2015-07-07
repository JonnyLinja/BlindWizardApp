//
//  GameObjectFactoryFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

@class GameObjectFactory;
@class UIView;
@class GridCalculator;

@protocol GameObjectFactoryFactory <NSObject>
- (GameObjectFactory *) gameObjectFactoryWithView:(UIView *)view gridCalculator:(GridCalculator *)calculator;
@end
