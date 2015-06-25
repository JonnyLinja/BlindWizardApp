#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewController.h"

SpecBegin(BoardViewController)

describe(@"BoardViewController", ^{
    __block BoardViewController *sut;
    __block UIStoryboard *storyboard;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
        [sut view];
    });
    
    context(@"when loaded", ^{
        it(@"should ", ^{
            
        });
    });
});

SpecEnd