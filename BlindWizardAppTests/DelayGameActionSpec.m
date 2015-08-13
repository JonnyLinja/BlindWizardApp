#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "DelayGameAction.h"

SpecBegin(DelayGameAction)

describe(@"DelayGameAction", ^{
    context(@"when checking is Valid", ^{
        it(@"should return YES", ^{
            //context
            DelayGameAction *sut = [[DelayGameAction alloc] initWithDuration:0];
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when checking duration", ^{
        it(@"should return the duration sent in the constructor", ^{
            //context
            CGFloat duration = 5;
            
            //because
            DelayGameAction *sut = [[DelayGameAction alloc] initWithDuration:duration];
            
            //expect
            expect(sut.duration).to.equal(duration);
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should return nil", ^{
            //context
            DelayGameAction *sut = [[DelayGameAction alloc] initWithDuration:0];
            
            //because
            id value = [sut generateNextGameActions];
            
            //expect
            expect(value).to.beNil();
        });
    });
});

SpecEnd