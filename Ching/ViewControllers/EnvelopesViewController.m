//
//  EnvelopesViewController.m
//  Ching
//
//  Created by Nate Armstrong on 8/2/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import ChingKit;

#import "EnvelopesViewController.h"
#import "EnvelopeViewController.h"
#import "TransactionsViewController.h"

@interface EnvelopesViewController ()
{
	bool collapseDetailViewController;
}

@end

@implementation EnvelopesViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	collapseDetailViewController = true;
	self.splitViewController.delegate = self;
}

- (void)setContext:(NSManagedObjectContext *)context
{
	_context = context;
	if (context)
	{
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[CHEnvelope entityName]];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
																  ascending:YES
																   selector:@selector(localizedCaseInsensitiveCompare:)]];
		request.predicate = nil; // all envelopes
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																			managedObjectContext:context
																			  sectionNameKeyPath:nil
																					   cacheName:nil];
	}
	else
	{
		self.fetchedResultsController = nil;
	}
}

- (IBAction)addEnvelopeButtonTapped:(id)sender
{
	[self performSegueWithIdentifier:@"newEnvelope" sender:sender];
}

- (IBAction)unwindFromEnvelopeForm:(UIStoryboardSegue *)segue
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"newEnvelope"] || [segue.identifier isEqualToString:@"showEnvelope:"])
	{
		NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		childContext.parentContext = self.context;
		CHEnvelope *envelope;
		if ([segue.identifier isEqualToString:@"newEnvelope"])
		{
    		envelope = [CHEnvelope insertNewObjectInContext:childContext];
    		EnvelopeViewController *envelopeViewController = (EnvelopeViewController *)[segue.destinationViewController topViewController];
    		envelopeViewController.envelope = envelope;
    		envelopeViewController.context = childContext;
    		envelopeViewController.title = @"New Envelope";
		}
		else if ([segue.identifier isEqualToString:@"showEnvelope:"] && [sender isKindOfClass:[NSIndexPath class]])
		{
			envelope = [self.fetchedResultsController objectAtIndexPath:(NSIndexPath *)sender];
			TransactionsViewController *transactions = (TransactionsViewController *)[segue.destinationViewController topViewController];
			transactions.envelope = envelope;
		}
	}
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Envelope"];
	CHEnvelope *envelope = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = envelope.name;
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	collapseDetailViewController = false;
	[self performSegueWithIdentifier:@"showEnvelope:" sender:indexPath];
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController
{
	return collapseDetailViewController;
}

@end
