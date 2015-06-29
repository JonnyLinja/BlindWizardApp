//
//  EnemyViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface EnemyViewModel : NSObject
- (void) runCreateAnimation;
- (void) animateMoveToCGPoint:(CGPoint)point;
@end
