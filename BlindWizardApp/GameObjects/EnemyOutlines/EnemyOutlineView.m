//
//  EnemyOutlineView.m
//  BlindWizardApp
//
//  Created by N A on 8/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyOutlineView.h"
#import "EnemyOutlineViewModel.h"
#import "MTKObserving.h"

@interface EnemyOutlineView ()
@property (nonatomic, strong) EnemyOutlineViewModel *viewModel; //inject
@end

@implementation EnemyOutlineView

- (id) initWithViewModel:(EnemyOutlineViewModel *)viewModel {
    self = [super init];
    if(!self) return nil;
    
    //vm
    self.viewModel = viewModel;
    
    //view
    self.backgroundColor = [UIColor clearColor];
    
    //bind
    [self observeProperty:@keypath(self.viewModel.animationType) withSelector:@selector(runAnimation)];
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    //context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //color
    [self.viewModel.color setStroke];
    
    //line
    CGContextSetLineWidth(ctx, 1.0f);
    CGFloat dashPattern[] = {4, 2};
    CGContextSetLineDash(ctx, 0.0, dashPattern, 2);
    
    //path
    CGContextAddRect(ctx, self.bounds);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

- (void) runAnimation {
    switch (self.viewModel.animationType) {
        case CreateOutlineAnimation:
            break;
        case DestroyAndRemoveOutlineAnimation:
            [self removeFromSuperview];
            break;
        default:
            break;
    }
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
