#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridStorage.h"
#import "GridStorageKeyGenerator.h"

@interface GridStorage (Test)
@property (nonatomic, strong, readonly) NSMutableDictionary *objects;
@property (nonatomic, strong, readonly) NSMutableDictionary *objectsToAdd;
@property (nonatomic, strong, readonly) NSMutableArray *keysToRemove;
@end

SpecBegin(GridStorage)

describe(@"GridStorage", ^{
    __block GridStorage *sut;
    __block id gridStorageKeyGeneratorMock;
    
    beforeEach(^{
        gridStorageKeyGeneratorMock = OCMClassMock([GridStorageKeyGenerator class]);
        sut = [[GridStorage alloc] initWithKeyGenerator:gridStorageKeyGeneratorMock];
    });
    
    context(@"when retrieving an object at a row and column", ^{
        it(@"should return the object", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            NSObject *obj = [[NSObject alloc] init];
            id dictionaryMock = OCMPartialMock(sut.objects);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);
            OCMStub([dictionaryMock objectForKey:key]).andReturn(obj);
            
            //because
            id returnedObject = [sut objectForRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect(returnedObject).to.equal(obj);
            
            //cleanup
            [dictionaryMock stopMocking];
        });
    });
    
    context(@"when promising to set an object at a row and column", ^{
        it(@"should queue the object to be removed from its old position and added to its new position", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            NSObject *obj = [[NSObject alloc] init];
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);

            //because
            [sut promiseSetObject:obj forRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect([sut.objectsToAdd objectForKey:key]).to.equal(obj);
            expect(sut.keysToRemove).to.contain(key);
        });
    });
    
    context(@"when promising to remove an object at a row and column", ^{
        it(@"should queue the object to be removed from its original position", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);
            
            //because
            [sut promiseRemoveObjectForRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect(sut.keysToRemove).to.contain(key);
        });
    });

    context(@"when fulfilling promises", ^{
        it(@"should remove all objects promised, add objects promised, and reset both queues", ^{
            //context
            NSObject *obj1 = [NSObject new];
            NSObject *obj2 = [NSObject new];
            NSObject *obj3 = [NSObject new];
            NSString *key1 = @"1:1";
            NSString *key2 = @"1:2";
            NSString *key3 = @"1:3";
            NSString *key4 = @"1:4";
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:1]).andReturn(key1);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:2]).andReturn(key2);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:3]).andReturn(key3);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:4]).andReturn(key4);
            [sut promiseSetObject:obj1 forRow:1 column:2];
            [sut promiseSetObject:obj2 forRow:1 column:3];
            [sut promiseSetObject:obj3 forRow:1 column:1];

            //because
            [sut fulfillPromises];
            
            //expect - skipping OCMVerify to make my life easier, testing more classicist style here
            expect([sut.objects objectForKey:key1]).to.equal(obj3);
            expect([sut.objects objectForKey:key2]).to.equal(obj1);
            expect([sut.objects objectForKey:key3]).to.equal(obj2);
            expect([sut.objects objectForKey:key4]).to.beNil();
            expect(sut.objectsToAdd).to.beEmpty();
            expect(sut.keysToRemove).to.beEmpty();
        });
    });
    
    context(@"when removing all objects", ^{
        it(@"should have empty data", ^{
            //context
            [sut.objects setObject:[NSObject new] forKey:@"foobar"];
            [sut.objectsToAdd setObject:[NSObject new] forKey:@"foobar"];
            [sut.keysToRemove addObject:[NSObject new]];
            
           //because
            [sut removeAllObjects];
            
            //expect
            expect(sut.objects).to.beEmpty();
            expect(sut.objectsToAdd).to.beEmpty();
            expect(sut.keysToRemove).to.beEmpty();
        });
    });
    
    afterEach(^{
        [gridStorageKeyGeneratorMock stopMocking];
    });
});

SpecEnd