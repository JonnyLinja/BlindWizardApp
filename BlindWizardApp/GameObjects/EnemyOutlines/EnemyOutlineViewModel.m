//
//  EnemyOutlineViewModel.m
//  BlindWizardApp
//
//  Created by N A on 8/5/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyOutlineViewModel.h"
#import <UIKit/UIKit.h>

@interface EnemyOutlineViewModel ()
@property (nonatomic, strong) UIColor *color;
@end

@implementation EnemyOutlineViewModel

- (id) initWithType:(NSInteger)enemyType animationDurations:(NSDictionary *)animationDurations configuration:(NSDictionary *)configuration {
    self = [super init];
    if(!self) return nil;
    
    NSString *hexColor = [configuration objectForKey:@"Color"];
    self.color = [self colorFromHexString:hexColor];
    
    return self;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void) runCreateAnimation {
    self.animationType = CreateOutlineAnimation;
}

- (void) runDestroyAnimation {
    self.animationType = DestroyAndRemoveOutlineAnimation;
}

@end
