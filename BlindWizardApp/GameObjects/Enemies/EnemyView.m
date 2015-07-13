//
//  EnemyView.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyView.h"
#import "EnemyViewModel.h"
#import "MTKObserving.h"

@interface EnemyView ()
@property (nonatomic, strong) EnemyViewModel *viewModel; //inject
@property (nonatomic, weak) UIView *bg;
@end

@implementation EnemyView

- (id) initWithViewModel:(EnemyViewModel *)viewModel {
    self = [super init];
    if(!self) return nil;
    
    //vm
    self.viewModel = viewModel;
    
    //background
    UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
    bg.backgroundColor = [self.viewModel color];
    bg.alpha = 0.2;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:bg];
    self.bg = bg;
    
    //bind
    [self removeAllObservations];
    [self observeProperty:@keypath(self.viewModel.animationType) withSelector:@selector(runAnimation)];
    [self map:@keypath(self.viewModel.face) to:@keypath(self.text) null:@""];
    [self observeProperty:@keypath(self.viewModel.shouldFlicker) withBlock:^(__weak typeof(self) self, NSNumber *old, NSNumber *newVal) {
        if([newVal boolValue]) {
            //flicker
            [UIView animateKeyframesWithDuration:self.viewModel.dangerAnimationDuration delay:0.0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
                    self.bg.alpha = 0.4;
                }];
                [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.5 animations:^{
                    self.bg.alpha = 0.2;
                }];
            } completion:nil];
        }else {
            //stop
            [self.bg.layer removeAllAnimations];
        }
    }];
    
    //view
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [self.viewModel color].CGColor;
    self.layer.borderWidth = 3;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.textColor = self.viewModel.color;
    self.font = [UIFont systemFontOfSize:20];
    self.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

- (void) runAnimation {
    //run
    switch (self.viewModel.animationType) {
        case CreateAnimation:
            [self runCreateAnimation];
            break;
        case DropAnimation:
            [self runDropAnimation];
            break;
        case MoveAnimation:
            [self runMoveAnimation];
            break;
        case SnapAndMoveAnimation:
            [self runSnapAndMoveAnimation];
            break;
        case MoveAndRemoveAnimation:
            [self runMoveAndRemoveAnimation];
            break;
        case DestroyAndRemoveAnimation:
            [self destroyAndRemoveAnimation];
            break;
        default:
            break;
    }
}

- (void) runCreateAnimation {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [UIView animateWithDuration:self.viewModel.createAnimationDuration animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void) runDropAnimation {
    [UIView animateWithDuration:self.viewModel.dropAnimationDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        [self.viewModel runNeutralAnimation];
    }];
}

- (void) runMoveAnimation {
    [UIView animateWithDuration:self.viewModel.shiftAnimationDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        [self.viewModel runNeutralAnimation];
    }];
}

- (void) runSnapAndMoveAnimation {
    self.frame = CGRectMake(self.viewModel.snapPoint.x, self.viewModel.snapPoint.y, self.bounds.size.width, self.bounds.size.height);
    [UIView animateWithDuration:self.viewModel.shiftAnimationDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        [self.viewModel runNeutralAnimation];
    }];
}

- (void) runMoveAndRemoveAnimation {
    [UIView animateWithDuration:self.viewModel.shiftAnimationDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) destroyAndRemoveAnimation {
    self.clipsToBounds = YES;
    self.font = [UIFont systemFontOfSize:30];
    [self.superview sendSubviewToBack:self];
    
    //animate shrink
    [UIView animateWithDuration:self.viewModel.destroyAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(0.05, 0.05);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    //animate corner radius
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    radiusAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    radiusAnimation.toValue = [NSNumber numberWithFloat:0.7*self.bounds.size.width];
    radiusAnimation.duration = self.viewModel.destroyAnimationDuration;
    self.layer.cornerRadius = 0.7*self.bounds.size.width;
    [self.layer addAnimation:radiusAnimation forKey:@"cornerRadius"];
    
    //animate border width
    CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    borderAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    borderAnimation.fromValue = [NSNumber numberWithFloat:3];
    borderAnimation.toValue = [NSNumber numberWithFloat:0];
    borderAnimation.duration = self.viewModel.destroyAnimationDuration;
    self.layer.cornerRadius = 0;
    [self.layer addAnimation:borderAnimation forKey:@"borderWidth"];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
