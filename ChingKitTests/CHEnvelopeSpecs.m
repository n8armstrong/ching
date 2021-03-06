//
//  CHEnvelopeSpecs.m
//  Ching
//
//  Created by Nate Armstrong on 8/3/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;
@import ChingKit;

SpecBegin(CHEnvelopeSpec)

describe(@"CHEnvelope", ^{
	__block NSManagedObjectContext *context;
	beforeAll(^{
		CHInMemoryPersistenceController *persistenceController = [[CHInMemoryPersistenceController alloc] init];
		context = persistenceController.managedObjectContext;
	});

	afterEach(^{
		[context reset];
	});

	it(@"can be inserted into a managed object context", ^{
		CHEnvelope *envelope = [CHEnvelope insertNewObjectInContext:context];
		expect(envelope).toNot.beNil();
	});

	it(@"can conveniently set budget with double", ^{
		CHEnvelope *envelope = [CHEnvelope insertNewObjectInContext:context];
		[envelope setBudgetWithDouble:100.0];
		expect(envelope.budget).to.equal(100);
	});
});

SpecEnd
